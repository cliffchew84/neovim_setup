return {
  "geg2102/nvim-jupyter-client",
  -- Only load for notebooks. They are detected as `json`, and `ft = { "json" }`
  -- used to load this for every JSON file (package.json, lazy-lock.json, ...).
  -- BufReadPre fires before filetype detection and before the plugin's own
  -- BufReadPost/BufEnter handlers, so initialization still happens.
  event = { "BufReadPre *.ipynb", "BufNewFile *.ipynb" },
  config = function()
    require("nvim-jupyter-client").setup({
      -- Optional custom template for new notebooks
      template = {
        cells = {
          {
            cell_type = "code",
            execution_count = nil,
            metadata = {},
            outputs = {},
            source = { "# New cell\n" },
          },
        },
        metadata = {
          kernelspec = {
            display_name = "Python 3",
            language = "python",
            name = "python3",
          },
        },
        nbformat = 4,
        nbformat_minor = 5,
      },
      -- Highlight settings
      cell_highlight_group = "CurSearch",
      highlights = {
        cell_title = { fg = "#ffffff", bg = "#000000" },
      },
    })

    -- Cell keymaps, scoped to notebook buffers so they don't appear in every
    -- other file (they used to be global `<leader>j*` maps).
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*.ipynb",
      callback = function(args)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
        end
        map("n", "<leader>ja", "<cmd>JupyterAddCellBelow<CR>", "Add Jupyter cell below")
        map("n", "<leader>jA", "<cmd>JupyterAddCellAbove<CR>", "Add Jupyter cell above")
        map("n", "<leader>jd", "<cmd>JupyterRemoveCell<CR>", "Remove current Jupyter cell")
        map("n", "<leader>jm", "<cmd>JupyterMergeCellAbove<CR>", "Merge with cell above")
        map("n", "<leader>jM", "<cmd>JupyterMergeCellBelow<CR>", "Merge with cell below")
        map("n", "<leader>jt", "<cmd>JupyterConvertCellType<CR>", "Toggle cell type (code/markdown)")
        map("v", "<leader>jm", "<cmd>JupyterMergeVisual<CR>", "Merge selected cells")
        map("n", "<leader>jD", "<cmd>JupyterDeleteCell<CR>", "Delete current cell")
      end,
    })
  end,
}
