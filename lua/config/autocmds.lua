-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Markdown renders without conceal (options.lua already sets conceallevel=0
-- globally; this also covers files opened before VeryLazy, e.g. `nvim foo.md`).
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  command = "setlocal conceallevel=0",
})
