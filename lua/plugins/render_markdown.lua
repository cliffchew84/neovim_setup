return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        -- Keep the top/bottom ```{...}``` fence lines visible. The default
        -- conceals them, which makes Quarto/Python cells hard to track.
        conceal_delimiters = false,
      },
    },
  },
}
