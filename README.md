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
| `sindrets/diffview.nvim` | Git diff/history viewer | `<leader>gd` open, `<leader>gD` close, `<leader>gh` file history |

### File Types & Viewing
| Plugin | Purpose | Key bindings |
|--------|---------|--------------|
| `hat0uma/csvview.nvim` | Aligned CSV/TSV viewer | `<leader>ct` toggle |
| `toppair/peek.nvim` | Live Markdown preview (light theme) | `<leader>po` open, `<leader>pc` close |

### Python / Data Science
| Plugin | Purpose |
|--------|---------|
| `geg2102/nvim-jupyter-client` | Edit `.ipynb` natively; cell ops via `<leader>j*` |
| `goerz/jupytext.vim` | Sync notebooks as `py:percent` format |
| `quarto-dev/quarto-nvim` + `otter.nvim` | Quarto/RMarkdown with LSP for Python, R, SQL |

### UI
| Plugin | Purpose |
|--------|---------|
| `folke/tokyonight.nvim` | Theme: `night` style, red italic comments |
| `nvim-lualine/lualine.nvim` | Custom statusline: mode, branch, diff, diagnostics, filename, filetype |

### Formatting & Linting
- **Linters**: `yamllint` (YAML), `markdownlint-cli2` (Markdown, reads `~/.markdownlint-cli2.yaml`)
- **Formatters via conform.nvim**:
  - Python → `ruff_format` + `ruff_organize_imports`
  - SQL → `sqlfluff`
  - YAML → `prettier`
  - Markdown → `prettier` (`--prose-wrap always --print-width 120`)
- **Mason auto-installs**: `markdownlint`, `markdownlint-cli2`, `prettier`, `ruff`, `sqlfluff`, `yamllint`

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
| `<leader>w` / `q` | Normal | Save / quit |
| `<leader>c` / `o` | Normal | Close window / close other windows |

### Editor Options
- Relative line numbers (above = sky blue, below = green)
- Tab = 4 spaces, `expandtab`
- `colorcolumn` + `textwidth` = 80
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
| `jupytext` | `jupytext.vim` converts notebooks |
| `jupyter` / `ipykernel` | `nvim-jupyter-client` kernel execution |

### Config Files & Directories
| Path | Why |
|------|-----|
| `~/.markdownlint-cli2.yaml` | markdownlint-cli2 rule config |
| `~/.vim/undodir/` | Persistent undo — create with `mkdir -p ~/.vim/undodir` |

### macOS Only
- `osascript` (built-in) used for Trash deletion in neo-tree — not portable to Linux
