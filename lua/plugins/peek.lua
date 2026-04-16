return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  build = "deno task --quiet build:fast",
  config = function()
    local peek = require("peek")

    peek.setup({
      theme = "light",
    })
    vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
    vim.api.nvim_create_user_command("PeekClose", peek.close, {})

    vim.keymap.set("n", "<leader>po", peek.open, { desc = "Peek Open Markdown Preview" })
    vim.keymap.set("n", "<leader>pc", peek.close, { desc = "Peek Close Markdown Preview" })
  end,
}
