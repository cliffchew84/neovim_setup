-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- (These live here rather than in keymaps.lua so overrides take effect at the
--  documented point; user options are applied after LazyVim's own defaults.)

-- Indentation (2 spaces, matching stylua/prettier/yaml/Vim runtime defaults;
-- Python files get shiftwidth=4 from the runtime python ftplugin)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.textwidth = 120
vim.opt.colorcolumn = "120"
vim.opt.conceallevel = 0

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.isfname:append("@-@")

-- Line number colours. Colorschemes reset these groups, and this file runs
-- before the colorscheme is applied. The tokyonight spec also sets them in
-- on_highlights (LazyVim loads tokyonight without firing ColorScheme); these
-- hooks cover other colorschemes and later scheme switches.
local function line_nr_colors()
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#87CEEB" })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#228B22" })
end

line_nr_colors()
-- LazyVim loads the colorscheme via `require("tokyonight").load()`, which does
-- not fire ColorScheme, so also apply once startup is finished. ColorScheme
-- keeps the colours in sync when you switch schemes later.
vim.api.nvim_create_autocmd("ColorScheme", { callback = line_nr_colors })
vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", callback = line_nr_colors })
