return {
  "geg2102/nvim-jupyter-client",
  ft = { "ipynb", "python", "lua", "vim", "json" },
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

    -- Keybindings for cell operations
    local map = vim.keymap.set
    map("n", "<leader>ja", "<cmd>JupyterAddCellBelow<CR>", { desc = "Add Jupyter cell below" })
    map("n", "<leader>jA", "<cmd>JupyterAddCellAbove<CR>", { desc = "Add Jupyter cell above" })
    map("n", "<leader>jd", "<cmd>JupyterRemoveCell<CR>", { desc = "Remove current Jupyter cell" })
    map("n", "<leader>jm", "<cmd>JupyterMergeCellAbove<CR>", { desc = "Merge with cell above" })
    map("n", "<leader>jM", "<cmd>JupyterMergeCellBelow<CR>", { desc = "Merge with cell below" })
    map("n", "<leader>jt", "<cmd>JupyterConvertCellType<CR>", { desc = "Toggle cell type (code/markdown)" })
    map("v", "<leader>jm", "<cmd>JupyterMergeVisual<CR>", { desc = "Merge selected cells" })
    map("n", "<leader>jD", "<cmd>JupyterDeleteCell<CR>", { desc = "Delete current cell" })
  end,
}
