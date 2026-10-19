-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- (These live here rather than in keymaps.lua so overrides take effect at the
--  documented point; user options are applied after LazyVim's own defaults.)

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
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

-- Line number colours (global; the neo-tree sidebar overrides LineNr locally
-- in lua/plugins/sidepanel.lua)
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#87CEEB" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#228B22" })
