-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Needed for highlighting and shifting code up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Needed to combine text of two lines into a single lines
vim.keymap.set("n", "J", "mzJ`z")

-- Centres the half page movements
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Allows search term to always be in the centre
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Ensures when I paste over something, the original paste reminds in my copy register
vim.keymap.set("x", "<leader>p", '"_dp')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "`", "0")
vim.keymap.set("v", "`", "0")
vim.keymap.set("v", "0", "$")
vim.keymap.set("n", "0", "$")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.textwidth = 80
vim.opt.wrapmargin = 2
vim.wo.colorcolumn = "80"

local quarto = require("quarto")
quarto.setup()
vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, {
  silent = true,
  noremap = true,
  desc = "Open Quarto Preview",
})
vim.keymap.set("n", "<leader>qcp", quarto.quartoClosePreview, {
  silent = true,
  noremap = true,
  desc = "Close Quarto Preview",
})
