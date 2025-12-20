return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  opts = {
    provider = "gemini",

    -- 1. MODEL OPTIMIZATION
    providers = {
      gemini = {
        -- "flash-lite" is the correct choice for lowest cost/latency
        model = "gemini-2.5-flash-lite",
        temperature = 0,
        max_tokens = 4096,
      },
    },

    -- 2. BEHAVIOUR OPTIMIZATION (Stops constant background checking)
    behaviour = {
      auto_suggestions = false, -- DISABLES "Ghost text" as you type (saves huge RPM/TPM)
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },

    -- 3. CONTEXT OPTIMIZATION (The biggest token saver)
    rag_service = {
      enabled = false, -- DISABLES "Read entire codebase". Prevents it from indexing all your files.
    },

    -- 4. DISABLE WEB SEARCH (Prevents extra API calls for searching online)
    web_search_engine = {
      provider = nil,
    },
  },

  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
