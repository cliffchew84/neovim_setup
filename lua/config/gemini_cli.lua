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

  local safe_prompt = vim.fn.shellescape(final_prompt)
  local cmd = string.format("cat %s | env -u GEMINI_API_KEY gemini prompt %s", tmp_file, safe_prompt)

  -- 5. RUN ASYNC JOB
  local output_lines = {}

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(output_lines, line)
        end
        local current_lines = vim.api.nvim_buf_line_count(sidebar_buf)
        vim.api.nvim_buf_set_lines(sidebar_buf, current_lines, -1, false, data)
        pcall(vim.api.nvim_win_set_cursor, sidebar_win, { vim.api.nvim_buf_line_count(sidebar_buf), 0 })
      end
    end,

    -- THE FIX: Filter out noisy logs
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            -- Check if this line is just a debug log
            local is_noise = line:match("Loaded cached credentials") or line:match("%[STARTUP%]")

            if not is_noise then
              local count = vim.api.nvim_buf_line_count(sidebar_buf)
              vim.api.nvim_buf_set_lines(sidebar_buf, count, -1, false, { "> ⚠ ERROR: " .. line })
            end
          end
        end
      end
    end,

    on_exit = function(_, exit_code)
      os.remove(tmp_file)

      if exit_code == 0 then
        local code_block = extract_code_block(output_lines)
        vim.schedule(function()
          if code_block then
            vim.api.nvim_buf_set_lines(original_buf, start_line, end_line, false, code_block)
            vim.api.nvim_buf_set_lines(sidebar_buf, -1, -1, false, { "", "✔ CODE APPLIED to original file." })
          else
            vim.api.nvim_buf_set_lines(
              sidebar_buf,
              -1,
              -1,
              false,
              { "", "⚠ NO CODE BLOCK found. Original file left unchanged." }
            )
          end
        end)
      else
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(sidebar_buf, -1, -1, false, { "", "✘ FAILED. See error details above." })
        end)
      end
    end,
  })
end, { range = true, nargs = 1 })
