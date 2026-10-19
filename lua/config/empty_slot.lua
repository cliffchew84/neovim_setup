-- The "editor slot" is the panel that holds your files -- everything that is
-- not the neo-tree sidebar and not the terminal.
--
-- Neovim boots with a single empty, unnamed buffer. Normally snacks paints its
-- dashboard over it, but snacks deliberately skips the dashboard when Neovim was
-- given an argument (`argc > 0`). So when you launch with a folder (`nvim .`),
-- the explorer claims the folder and the slot is left showing a bare [No Name]
-- placeholder -- which then shows up as a blank tab, and stays there when you
-- split the terminal under it with `<leader>tt`.
--
-- This module draws the dashboard into the slot instead, so the empty slot looks
-- deliberate. If snacks is unavailable it simply does nothing, and the placeholder
-- is cleaned up later by the safety net in autocmds.lua.

local M = {}

-- An empty, unnamed, unmodified, listed scratch buffer: Neovim's startup buffer.
function M.is_placeholder(buf)
  return vim.api.nvim_buf_is_loaded(buf)
    and vim.bo[buf].buflisted
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) == ""
    and not vim.bo[buf].modified
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
end

-- Draw the dashboard into `win` when it is showing the placeholder.
-- Returns true only if the dashboard was actually drawn.
function M.fill(win)
  win = win or vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  if not M.is_placeholder(buf) then
    return false
  end
  local ok, snacks = pcall(require, "snacks")
  if not ok or not snacks.dashboard then
    return false
  end
  -- Reuses the placeholder buffer itself, so no extra buffer (and no blank tab)
  -- is created: the slot buffer simply becomes the dashboard.
  return pcall(snacks.dashboard.open, { buf = buf, win = win })
end

return M
