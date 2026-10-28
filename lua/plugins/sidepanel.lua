-- neo-tree opts. Previously this lived in `lua/config/sidepanel.lua` and was
-- applied with an eager `require("neo-tree").setup(...)` in init.lua, which
-- clobbered every option LazyVim sets (file watcher, follow_current_file,
-- window mappings, event handlers). Defining it as a normal plugin `opts`
-- table lets lazy.nvim deep-merge it with LazyVim's spec instead.

-- Neo-tree's default macOS trash chain starts with `trash --`. The
-- /usr/bin/trash on this machine rejects the `--` separator, and neo-tree
-- stops at the first available command, so it never reaches its own osascript
-- fallback. Supply the osascript commands directly. Neo-tree's built-in trash
-- command then handles the confirmation, clears the buffer of each deleted
-- file and fires FILE_DELETED.
local function trash_command(paths)
  local commands = {}
  for i, path in ipairs(paths) do
    local escaped = path:gsub("\\", "\\\\"):gsub('"', '\\"')
    commands[i] = {
      "osascript",
      "-e",
      'tell application "Finder" to delete POSIX file "' .. escaped .. '"',
    }
  end
  return commands
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    trash = {
      command = trash_command,
    },
    window = {
      number = true,
      relativenumber = false,
    },
    filesystem = {
      window = {
        mappings = {
          -- `d` trashes instead of deleting permanently. Neo-tree resolves the
          -- visual variant (trash_visual) from this same mapping, so it covers
          -- a single node and a visual selection.
          ["d"] = "trash",
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
          vim.opt_local.number = true
          vim.opt_local.relativenumber = false

          -- White line numbers, scoped to the sidebar window only. Defining the
          -- group here (rather than once at load) keeps it alive across
          -- `:colorscheme` changes; `winhl` stops it leaking into every other
          -- window the way a global `nvim_set_hl(0, "LineNr", ...)` did.
          -- `relativenumber` is off in the sidebar, so LineNrAbove/LineNrBelow
          -- are unused here and the global colours from config/options.lua apply.
          vim.api.nvim_set_hl(0, "NeoTreeLineNr", { fg = "#FFFFFF" })
          vim.wo.winhl = "LineNr:NeoTreeLineNr"
        end,
      },
    },
  },
}
