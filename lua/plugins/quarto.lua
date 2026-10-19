return {
  {
    "quarto-dev/quarto-nvim",
    ft = { "quarto", "markdown" },
    dependencies = {
      "jmbuhr/otter.nvim",
    },
    opts = {
      lspFeatures = {
        languages = { "python", "r", "sql" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<leader>qp",
        "<cmd>QuartoPreview<cr>",
        desc = "Open Quarto Preview",
        ft = { "quarto", "markdown" },
      },
      {
        "<leader>qc",
        "<cmd>QuartoClosePreview<cr>",
        desc = "Close Quarto Preview",
        ft = { "quarto", "markdown" },
      },
    },
  },
}
