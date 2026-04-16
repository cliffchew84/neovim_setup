-- lua/plugins/jupytext.lua
return {
  {
    "goerz/jupytext.vim",
    ft = { "python", "ipynb" },
    config = function()
      vim.g.jupytext_fmt = "py:percent"
      vim.g.jupytext_no_default_key_mappings = 1
    end,
  },
}
