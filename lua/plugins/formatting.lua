-- markdownlint-cli2 only auto-discovers config from the linted file's directory
-- tree (for nvim-lint's stdin input it uses the cwd). Files in a project without
-- their own config therefore fall back to markdownlint's defaults (e.g. MD013 at
-- 80 columns). Always pass the nearest config explicitly, falling back to this
-- repo's config, so every markdown file is linted the same way.
local function markdownlint_config(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local start = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
  local found = vim.fs.find({
    ".markdownlint-cli2.jsonc",
    ".markdownlint-cli2.yaml",
    ".markdownlint-cli2.yml",
    ".markdownlint-cli2.cjs",
    ".markdownlint-cli2.mjs",
    ".markdownlint.jsonc",
    ".markdownlint.yaml",
    ".markdownlint.yml",
    ".markdownlint.json",
    ".markdownlintrc",
  }, { path = start, upward = true, type = "file" })[1]
  return found or (vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml")
end

return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        yaml = { "yamllint" },
      })

      local linter = require("lint").linters["markdownlint-cli2"]
      if linter then
        linter.args = {
          "--config",
          function()
            return markdownlint_config(vim.api.nvim_get_current_buf())
          end,
          "-",
        }
      end
    end,
  },

  -- Add formatter/linter tools to mason so they're always available
  -- (markdownlint-cli2 is ensured by LazyVim's markdown extra; the old
  -- `markdownlint` CLI is not used by nvim-lint or conform).
  -- mason's spec declares opts_extend = { "ensure_installed" }, so this merges with LazyVim's list
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "prettier", "ruff", "yamllint" },
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
        ["markdownlint-cli2"] = {
          -- Lint/fix with the same config nvim-lint uses (see above).
          prepend_args = function(_, ctx)
            return { "--config", markdownlint_config(ctx.buf) }
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
