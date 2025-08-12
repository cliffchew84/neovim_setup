return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night",
    on_highlights = function(hl, colors)
      hl.Comment = { fg = "#FF5555", italic = true } -- red comments
    end,
  },
}
