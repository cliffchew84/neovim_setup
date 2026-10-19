return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diff view open" },
    { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diff view close" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
  },
}
