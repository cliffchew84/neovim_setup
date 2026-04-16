return {
  -- disable sqls formatting so conform handles it instead
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        sqls = function(_, opts)
          opts.on_attach = function(client, _)
            client.server_capabilities.documentFormattingProvider = false
          end
          require("lspconfig").sqls.setup(opts)
          return true
        end,
      },
    },
  },

}
