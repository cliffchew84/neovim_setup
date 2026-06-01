require("neo-tree").setup({
  window = {
    number = true,
    relativenumber = false,
  },
  filesystem = {
    commands = {
      delete = function(state)
        local inputs = require("neo-tree.ui.inputs")
        local node = state.tree:get_node()
        local path = node.path
        inputs.confirm("Trash " .. node.name .. "?", function(confirmed)
          if not confirmed then return end
          vim.fn.system({ "osascript", "-e",
            'tell application "Finder" to delete POSIX file "' .. path .. '"'
          })
          require("neo-tree.sources.manager").refresh(state.source_name)
        end)
      end,
    },
    window = {
      mappings = {
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["gy"] = function(state)
          local node = state.tree:get_node()
          vim.fn.setreg("+", node.path)
          vim.notify("Copied: " .. node.path)
        end,
      },
    },
  },
  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function()
        -- reapply number settings
        vim.opt_local.number = true
        vim.opt_local.relativenumber = false

        -- reapply highlights
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#FFFFFF" }) -- main number line
        vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#228B22" }) -- green
        vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#87CEEB" }) -- sky blue
      end,
    },
  },
})
