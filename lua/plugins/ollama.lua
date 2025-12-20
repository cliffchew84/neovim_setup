return {
  "nomnivore/ollama.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "Ollama" },
  keys = {
    -- Flow 1: Display in a split for review
    {
      "<leader>md",
      ":<c-u>lua require('ollama').prompt('DeepSeekDisplay')<cr>",
      desc = "Ask DeepSeek and display output in split",
      mode = { "n", "v" },
    },
    -- Flow 2: Insert directly into buffer
    {
      "<leader>mi",
      ":<c-u>lua require('ollama').prompt('DeepSeekInsert')<cr>",
      desc = "Ask DeepSeek and insert output under cursor",
      mode = { "n", "v" },
    },
    -- Flow 3: Review existing code
    {
      "<leader>mr",
      ":<c-u>lua require('ollama').prompt('DeepSeekReview')<cr>",
      desc = "Review selected code with DeepSeek",
      mode = { "v" }, -- typically VISUAL select the code to review
    },
  },

  opts = {
    model = "deepseek-coder:6.7b-instruct",
    prompts = {
      -- Display flow
      DeepSeekDisplay = {
        prompt = "$input\n" .. vim.fn.getline("."),
        input_label = "> ",
        model = "deepseek-coder:6.7b-instruct",
        action = "display", -- show in split
      },
      -- Insert flow
      DeepSeekInsert = {
        prompt = "$input\n" .. vim.fn.getline("."),
        input_label = "> ",
        model = "deepseek-coder:6.7b-instruct",
        action = "insert", -- insert directly
      },
      -- New review flow
      DeepSeekReview = {
        prompt = "Please review the following code for readability, bugs, and improvements:\n$input"
          .. vim.fn.getline("."),
        input_label = "> ",
        model = "deepseek-coder:6.7b-instruct",
        action = "display", -- we usually review before inserting
      },
    },
  },
}
