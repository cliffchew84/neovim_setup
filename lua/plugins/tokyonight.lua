return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night",
    on_highlights = function(hl, colors)
      hl.Comment = { fg = "#FF5555", italic = true } -- red comments
      -- LazyVim applies tokyonight via require("tokyonight").load(), which skips
      -- the ColorScheme event, so set the custom line-number colours here as
      -- well (keep in sync with config/options.lua).
      hl.LineNrAbove = { fg = "#87CEEB" }
      hl.LineNrBelow = { fg = "#228B22" }
    end,
  },
}
