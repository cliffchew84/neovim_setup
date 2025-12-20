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

vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>c", "<C-w>c", { desc = "Close current window" })
vim.keymap.set("n", "<leader>o", ":only<CR>", { desc = "Close other windows" })

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
vim.opt_local.conceallevel = 0

vim.opt.updatetime = 50
vim.opt.textwidth = 80
vim.wo.colorcolumn = "80"

-- Set the color of all line numbers (LineNr)
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#A0A0A0" }) -- Example: light grey

-- Set the color of the line number on the current line (CursorLineNr)
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFFFF", bold = true }) -- Example: white and bold

-- If using relative line numbers, set colors for LineNrAbove and LineNrBelow
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#87CEEB" }) -- Example: light orange
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#228B22" }) -- Example: pale green
