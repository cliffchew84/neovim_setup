-- neo-tree opts. Previously this lived in `lua/config/sidepanel.lua` and was
-- applied with an eager `require("neo-tree").setup(...)` in init.lua, which
-- clobbered every option LazyVim sets (file watcher, follow_current_file,
-- window mappings, event handlers). Defining it as a normal plugin `opts`
-- table lets lazy.nvim deep-merge it with LazyVim's spec instead.

-- Moves each path to the Trash via Finder, one at a time.
-- NOTE: neo-tree's built-in trash command does not work on this machine:
-- /usr/bin/trash rejects the `--` separator neo-tree passes, so the command
-- reports failure even though it removes the file.
local function trash(paths, on_done)
  local function step(i)
    if i > #paths then
      if on_done then
        on_done()
      end
      return
    end
    local escaped = paths[i]:gsub('"', '\\"')
    vim.system(
      { "osascript", "-e", 'tell application "Finder" to delete POSIX file "' .. escaped .. '"' },
      { text = true },
      function()
        step(i + 1)
      end
    )
  end
  step(1)
end

local function confirm_and_trash(state, nodes)
  local inputs = require("neo-tree.ui.inputs")
  local label = #nodes == 1 and ("Trash " .. nodes[1].name .. "?") or ("Trash " .. #nodes .. " items?")
  inputs.confirm(label, function(confirmed)
    if not confirmed then
      return
    end
    local paths = {}
    for _, node in ipairs(nodes) do
      paths[#paths + 1] = node.path
    end
    trash(paths, function()
      require("neo-tree.sources.manager").refresh(state.source_name)
    end)
  end)
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      number = true,
      relativenumber = false,
    },
    filesystem = {
      commands = {
        -- `d` on a single node
        delete = function(state)
          confirm_and_trash(state, { state.tree:get_node() })
        end,
        -- `d` on a visual selection. Without this override neo-tree falls back
        -- to its built-in delete_visual, which permanently removes files.
        delete_visual = function(state, selected_nodes)
          confirm_and_trash(state, selected_nodes)
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
