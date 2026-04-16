require("neo-tree").setup({
  window = {
    number = true,
    relativenumber = false,
  },
  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function()
        -- reapply number settings
        vim.opt_local.number = true
        vim.opt_local.relativenumber = false

        -- reapply highlights
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#FFFFFF" }) -- main number line
        vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#228B22" }) -- green
        vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#87CEEB" }) -- sky blue
      end,
    },
  },
})
