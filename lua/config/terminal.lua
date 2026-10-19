-- Bottom terminal for the code panel.
--
--   <leader>tt  open it  (creates it the first time, reuses it afterwards)
--   <leader>th  hide / show it  (the shell and anything running in it keep going)
--   <leader>tq  quit it  (kills the shell and its children, then forgets it)
--   <Esc><Esc>  leave terminal mode, so normal keys / <C-hjkl> work again
--
-- It is always opened *below the code panel*, never below the neo-tree
-- sidebar, no matter which panel has focus when it is invoked. Only one
-- terminal is kept: hiding it keeps the process alive, and showing it again
-- brings back the very same buffer.

local M = {}

local function win_by(pred)
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if pred(vim.api.nvim_win_get_buf(w)) then
      return w
    end
  end
end

local function is_term(b)
  return vim.bo[b].buftype == "terminal"
end
local function is_side(b)
  return vim.bo[b].filetype == "neo-tree"
end
-- The editor slot: the panel that holds your files. It is neither the sidebar
-- nor the terminal -- and when nothing is open it holds the dashboard
-- (buftype=nofile), not a normal buffer, so that counts as a slot as well.
local function is_main(b)
  return not is_side(b)
    and vim.bo[b].buftype ~= "terminal"
    and (vim.bo[b].buftype == "" or vim.bo[b].filetype == "snacks_dashboard")
end

-- true once the shell inside a terminal has ended (`exit`, Ctrl-D, crash)
local function job_dead(b)
  local ok, jid = pcall(vim.api.nvim_buf_get_var, b, "terminal_job_id")
  return not ok or vim.fn.jobwait({ jid }, 0)[1] ~= -1
end

-- any live terminal buffer, whether currently shown or hidden
local function term_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buftype == "terminal" and not job_dead(b) then
      return b
    end
  end
end

-- Show the terminal (creating it if needed) below the code panel.
function M.open()
  local w = win_by(is_term)
  if w then -- already visible: just go there
    vim.api.nvim_set_current_win(w)
    vim.cmd("startinsert")
    return
  end
  local b = term_buf() -- hidden earlier: bring the same one back
  local mw = win_by(is_main) -- never split the sidebar
  if mw then
    vim.api.nvim_set_current_win(mw)
    -- An empty slot (e.g. right after `nvim .`) would leave a bare [No Name]
    -- sitting above the terminal; show the dashboard there instead.
    require("config.empty_slot").fill(mw)
  end
  vim.cmd("belowright split")
  if b then
    vim.api.nvim_win_set_buf(0, b)
    vim.cmd("normal! G")
  else
    vim.cmd("terminal") -- starts in the current directory
    vim.bo.bufhidden = "hide"
  end
  vim.cmd("resize 12")
  vim.cmd("startinsert")
end

-- Hide the terminal without killing its process.
function M.hide()
  local w = win_by(is_term)
  if w and #vim.api.nvim_list_wins() > 1 then
    vim.api.nvim_win_close(w, false) -- keeps the buffer (and its process) alive
  end
end

-- Hide it if it is on screen, otherwise show it (creating one if needed).
function M.toggle()
  if win_by(is_term) then
    M.hide()
  else
    M.open()
  end
end

-- End the terminal for real: kill the shell (and anything it started) and
-- drop the buffer, so the next open gives a fresh one.
function M.close()
  local w = win_by(is_term)
  local b = w and vim.api.nvim_win_get_buf(w) or term_buf()
  if not b then
    return
  end
  if w and #vim.api.nvim_list_wins() > 1 then
    vim.api.nvim_win_close(w, false)
  end
  if vim.api.nvim_buf_is_valid(b) then
    vim.api.nvim_buf_delete(b, { force = true })
  end
end

return M
