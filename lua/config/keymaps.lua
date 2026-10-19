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

-- Save/quit use native `:w` / `:q` (same keystroke count as a leader map, and
-- `<leader>w`/`<leader>q` shadow LazyVim's windows / quit-session groups).
-- Close-window is LazyVim's `<leader>wd` (= <C-w>c); a `<leader>c` mapping here
-- only shadowed the `code` group label.
vim.keymap.set("n", "<leader>o", ":only<CR>", { desc = "Close other windows" })
