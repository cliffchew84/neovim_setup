return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    keywords = {
      NOTE = {
        icon = "󰍩",
        color = "hint",
      },
      IMPT = {
        icon = "",
        color = "warning",
      },
      TODO = {
        icon = "",
        color = "info",
      },
      WIP = {
        icon = "󰦖",
        color = "default",
      },
    },
  },
}
