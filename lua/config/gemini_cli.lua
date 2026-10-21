-- lua/config/gemini_cli.lua

-- 1. CODE EXTRACTION LOGIC
local function extract_code_block(lines)
  local code = {}
  local inside_block = false
  local found_any_block = false

  for _, line in ipairs(lines) do
    if line:match("^%s*```") then
      if inside_block then
        inside_block = false
        break
      else
        inside_block = true
        found_any_block = true
        code = {}
      end
    elseif inside_block then
      table.insert(code, line)
    end
  end

  if found_any_block and #code > 0 then
    return code
  end
  return nil
end

vim.api.nvim_create_user_command("Gemini", function(opts)
  -- 2. CAPTURE ORIGINAL CONTEXT
  local original_buf = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- `'<`/`'>` are unset (line 0) when no visual selection has ever been made.
  -- Without this guard the command sends an empty snippet and then writes the
  -- result back over an invalid range, mangling the file.
  if start_pos[2] == 0 or end_pos[2] == 0 then
    vim.notify("Gemini: select some code first (visual mode, then :Gemini).", vim.log.levels.WARN)
    return
  end

  local start_line = start_pos[2] - 1
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(original_buf, start_line, end_line, false)
  local code_snippet = table.concat(lines, "\n")
  local filetype = vim.bo.filetype or "text"

  -- 3. CREATE SIDEBAR
  local sidebar_buf = vim.api.nvim_create_buf(false, true)

  vim.cmd("vsplit")
  vim.cmd("wincmd L")
  vim.cmd("vertical resize 45")

  local sidebar_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(sidebar_win, sidebar_buf)

  vim.bo[sidebar_buf].buftype = "nofile"
  vim.bo[sidebar_buf].bufhidden = "wipe"
  vim.bo[sidebar_buf].swapfile = false
  vim.bo[sidebar_buf].filetype = "markdown"
  vim.wo[sidebar_win].wrap = true

  vim.api.nvim_buf_set_lines(sidebar_buf, 0, -1, false, { "▋ Gemini is thinking...", "---" })

  -- 4. PREPARE PROMPT
  local tmp_file = os.tmpname()
  local f = io.open(tmp_file, "w")
  f:write(code_snippet)
  f:close()

  local user_prompt = opts.args
  local final_prompt = string.format(
    "%s. \nIMPORTANT INSTRUCTIONS:\n1. Explain your thinking step-by-step.\n2. Then provide the fixed code inside a markdown code block (```%s).\n3. Only the code inside the block will be automatically applied to the user's file.",
    user_prompt,
    filetype
  )

  -- Non-interactive mode is `-p/--prompt`, not a `prompt` subcommand (that now
  -- just becomes a query and drops into the interactive TUI, which would never
  -- return from a job).
  local cmd = string.format(
    "cat %s | env -u GEMINI_API_KEY gemini --skip-trust -p %s",
    vim.fn.shellescape(tmp_file),
    vim.fn.shellescape(final_prompt)
  )

  -- 5. RUN ASYNC JOB
  local output_lines = {}

  -- jobstart delivers chunks, and the first/last entry of a chunk can be a
  -- partial line. Stitch each stream back together so long lines (and the
  -- extracted code block) are not split in two.
  local function line_splitter()
    local pending = ""
    return {
      feed = function(data)
        if not data or #data == 0 then
          return {}
        end
        data[1] = pending .. data[1]
        pending = data[#data]
        return vim.list_slice(data, 1, #data - 1)
      end,
      flush = function()
        if pending == "" then
          return nil
        end
        local line = pending
        pending = ""
        return line
      end,
    }
  end

  local stdout = line_splitter()
  local stderr = line_splitter()

  local function add_to_sidebar(lines)
    if #lines == 0 or not vim.api.nvim_buf_is_valid(sidebar_buf) then
      return
    end
    local count = vim.api.nvim_buf_line_count(sidebar_buf)
    vim.api.nvim_buf_set_lines(sidebar_buf, count, -1, false, lines)
    pcall(vim.api.nvim_win_set_cursor, sidebar_win, { vim.api.nvim_buf_line_count(sidebar_buf), 0 })
  end

  local function is_noise(line)
    return line:match("Loaded cached credentials") ~= nil or line:match("%[STARTUP%]") ~= nil
  end

  local function append_stdout(data)
    local lines = stdout.feed(data)
    if #lines > 0 then
      vim.list_extend(output_lines, lines)
      add_to_sidebar(lines)
    end
  end

  local function append_stderr(data)
    local lines = {}
    for _, line in ipairs(stderr.feed(data)) do
      if line ~= "" and not is_noise(line) then
        lines[#lines + 1] = "> ⚠ ERROR: " .. line
      end
    end
    add_to_sidebar(lines)
  end

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      append_stdout(data)
    end,

    on_stderr = function(_, data)
      append_stderr(data)
    end,

    on_exit = function(_, exit_code)
      os.remove(tmp_file)

      -- flush a final line that arrived without a trailing newline
      local tail = stdout.flush()
      if tail then
        output_lines[#output_lines + 1] = tail
        add_to_sidebar({ tail })
      end
      local err_tail = stderr.flush()
      if err_tail and not is_noise(err_tail) then
        add_to_sidebar({ "> ⚠ ERROR: " .. err_tail })
      end

      if exit_code == 0 then
        local code_block = extract_code_block(output_lines)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(original_buf) then
            add_to_sidebar({ "", "⚠ Original buffer was closed; nothing applied." })
          elseif code_block then
            vim.api.nvim_buf_set_lines(original_buf, start_line, end_line, false, code_block)
            add_to_sidebar({ "", "✔ CODE APPLIED to original file." })
          else
            add_to_sidebar({ "", "⚠ NO CODE BLOCK found. Original file left unchanged." })
          end
        end)
      else
        vim.schedule(function()
          add_to_sidebar({ "", "✘ FAILED. See error details above." })
        end)
      end
    end,
  })
end, { range = true, nargs = "+" })
