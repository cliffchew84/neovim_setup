# LazyVim Config

Personal [LazyVim](https://lazyvim.github.io/installation) setup with additional plugins and custom config.

---

## Plugins Added

### Editor Behavior
| Plugin | Purpose | Key bindings |
|--------|---------|--------------|
| `folke/flash.nvim` | Jump navigation with labels | `s` jump, `S` treesitter, `r` remote, `R` treesitter search, `<C-s>` toggle |
| `m4xshen/hardtime.nvim` | Enforces good Vim habits | — (auto-active) |
| `numToStr/Comment.nvim` | Comment toggling | `gcc` line, `gbc` block, `gc`/`gb` operator |
| `folke/todo-comments.nvim` | Highlight keywords | Custom: `NOTE`, `IMPT`, `TODO`, `WIP` |

### Git
| Plugin | Purpose | Key bindings |
|--------|---------|--------------|
| `kdheepak/lazygit.nvim` | Full LazyGit TUI | `<leader>lg` |
| `sindrets/diffview.nvim` | Git diff/history viewer | `<leader>gv` open, `<leader>gV` close, `<leader>gH` file history |

### File Types & Viewing
| Plugin | Purpose | Key bindings |
|--------|---------|--------------|
| `hat0uma/csvview.nvim` | Aligned CSV/TSV viewer | `<leader>ct` toggle |
| `toppair/peek.nvim` | Live Markdown preview (light theme) | `<leader>po` open, `<leader>pc` close |

### Python / Data Science
| Plugin | Purpose |
|--------|---------|
| `geg2102/nvim-jupyter-client` | Edit `.ipynb` natively; cell ops via `<leader>j*` |
| `quarto-dev/quarto-nvim` + `otter.nvim` | Quarto/RMarkdown with LSP for Python, R, SQL |

### UI
| Plugin | Purpose |
|--------|---------|
| `folke/tokyonight.nvim` | Theme: `night` style, red italic comments |
| `nvim-lualine/lualine.nvim` | Custom statusline: mode, branch, diff, diagnostics, filename, filetype |

### Formatting & Linting
- **Linters**: `yamllint` (YAML), `markdownlint-cli2` (Markdown; auto-discovers a project `.markdownlint-cli2.*` config)
- **Formatters via conform.nvim**:
  - Python → `ruff_format` + `ruff_organize_imports`
  - YAML → `prettier`
  - Markdown → `prettier` (`--prose-wrap always --print-width 120`)
- **Mason auto-installs** (added by this config): `markdownlint`, `prettier`, `ruff`, `yamllint`

---

## Custom Config

### Neo-tree Sidebar
- Delete sends to **macOS Trash** (via `osascript`) instead of permanent delete
- `x` = cut, `p` = paste in tree
- Line numbers shown in sidebar

### Gemini CLI Integration
- `:Gemini <prompt>` command (works on visual selection)
- Streams output to a right sidebar
- Auto-extracts first code block and applies it back to the original file

### Terminal
- `<leader>tt` opens a terminal **below the code panel** (not below the sidebar), in the current directory; pressing it again reuses the same one
- `<leader>th` **hides/shows** it — the shell and anything running in it keep going, and `<leader>th` brings it straight back
- `<leader>tq` **quits** it — kills the shell and whatever it started, then forgets it (next `<leader>tt` is fresh); typing `exit` in the shell does the same
- `Esc` `Esc` leaves terminal mode (press the two `Esc` quickly — a slow pair lets the first one reach the shell) — while in terminal mode every key goes to the shell, so this step is what lets `<C-h/j/k/l>` move between sidebar, code and terminal, and what makes `<leader>th` / `<leader>tq` (normal-mode keys) reachable again when the terminal has focus; press `i` to type again
- With no file open the code panel shows the LazyVim dashboard, so `<leader>tt` never leaves a blank `[No Name]` above the terminal (see `lua/config/empty_slot.lua`)

### Keymaps
| Key | Mode | Action |
|-----|------|--------|
| `J` / `K` | Visual | Move selected lines down/up |
| `<C-d>` / `<C-u>` | Normal | Half-page scroll, cursor centered |
| `n` / `N` | Normal | Search next/prev, cursor centered |
| `` ` `` | Normal/Visual | Go to line start (`0`) |
| `0` | Normal/Visual | Go to line end (`$`) |
| `<leader>p` | Visual | Paste without overwriting register |
| `<leader>y` / `Y` | Normal/Visual | Yank to system clipboard |
| `<leader>o` | Normal | Close other windows |
| `<leader>tt` | Normal | Open terminal below the code panel (current dir) |
| `<leader>th` | Normal | Hide/show terminal (shell keeps running) |
| `<leader>tq` | Normal | Quit terminal and kill its process |
| `Esc` `Esc` | Terminal | Leave terminal mode |

### Editor Options
- Relative line numbers (above = sky blue, below = green)
- Tab = 4 spaces, `expandtab`
- `colorcolumn` + `textwidth` = 120
- `scrolloff` = 8
- No swapfile/backup; persistent undo at `~/.vim/undodir`
- `conceallevel=0` globally for Markdown

---

## Manual Setup Required

### CLI Tools
| Tool | Why | Install |
|------|-----|---------|
| `lazygit` | `lazygit.nvim` backend | `brew install lazygit` |
| `deno` | `peek.nvim` build step | `brew install deno` |
| `gemini` CLI | Gemini integration | Install from Google |

### Python Packages
| Package | Why |
|---------|-----|
| `jupyter` / `ipykernel` | `nvim-jupyter-client` kernel execution |

### Config Files & Directories
| Path | Why |
|------|-----|
| `~/.vim/undodir/` | Persistent undo — create with `mkdir -p ~/.vim/undodir` |

### macOS Only
- `osascript` (built-in) used for Trash deletion in neo-tree — not portable to Linux
