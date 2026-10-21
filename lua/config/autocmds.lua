-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- The editor slot (the panel holding your files, i.e. not the sidebar and not
-- the terminal) is left as a bare [No Name] placeholder when you start with a
-- folder, see lua/config/empty_slot.lua. Fill it with the dashboard instead.
--
-- This file is loaded after startup (on the VeryLazy event), so there is nothing
-- left to wait for -- except that with `nvim .` the explorer briefly occupies the
-- slot while it hijacks the directory. Give it a moment to settle, then paint.
local slot = require("config.empty_slot")

local deadline = vim.uv.now() + 2000
local function fill_slot()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if slot.fill(win) then
      return
    end
  end
  if vim.uv.now() < deadline then
    vim.defer_fn(fill_slot, 50)
  end
end

fill_slot()

-- Safety net for when snacks is unavailable (nothing to draw): drop a stranded
-- placeholder as soon as a real file is opened, so it never lingers. The buffer
-- goes away and the panel that held it collapses.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("UserDropStartupPlaceholder", { clear = true }),
  callback = function(ev)
    -- only when a real file was entered, never the placeholder itself
    if vim.bo[ev.buf].buftype ~= "" or vim.api.nvim_buf_get_name(ev.buf) == "" then
      return
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local shown = #vim.fn.win_findbuf(buf) > 0
      -- never strip the buffer out of the only remaining window
      if buf ~= ev.buf and slot.is_placeholder(buf) and (not shown or #vim.api.nvim_list_wins() > 1) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end,
})
