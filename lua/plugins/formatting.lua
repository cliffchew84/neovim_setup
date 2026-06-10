return {
  -- Pass config explicitly since nvim-lint runs markdownlint-cli2 via stdin (no filesystem access)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~/.markdownlint-cli2.yaml"), "-" },
        },
      },
    },
  },

  -- Add markdownlint to mason so it's always available
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "markdownlint", "markdownlint-cli2", "prettier", "ruff", "sqlfluff", "yamllint" })
    end,
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
        sql = { "sqlfluff" },
        yaml = { "prettier" },
      },
    },
  },
}
