return {
  -- markdownlint-cli2 auto-discovers `.markdownlint-cli2.yaml` from the buffer's
  -- directory (and works over stdin), so no explicit --config is needed.
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
    },
  },

  -- Add markdownlint to mason so it's always available
  -- mason's spec declares opts_extend = { "ensure_installed" }, so this merges with LazyVim's list
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "markdownlint", "prettier", "ruff", "yamllint" },
    },
  },

  -- Configure conform to use appropriate fixers/formatters on save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          prepend_args = function(self, ctx)
            if vim.bo[ctx.buf].filetype == "markdown" then
              return { "--prose-wrap", "always", "--print-width", "120" }
            end
            return {}
          end,
        },
      },
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        yaml = { "prettier" },
      },
    },
  },
}
