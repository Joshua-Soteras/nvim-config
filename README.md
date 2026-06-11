# Neovim Config

A modern, modular Neovim setup built on [lazy.nvim](https://github.com/folke/lazy.nvim). Designed to feel like a lightweight IDE — fast startup, smart completions, LSP support, and a clean UI. Everything is written in Lua. Plugins install themselves on first launch — no manual steps required beyond the prerequisites below.

---

## Table of Contents

- [What Is Neovim?](#what-is-neovim)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Important: Python Path](#important-python-path)
- [Directory Structure](#directory-structure)
- [How the Config Loads](#how-the-config-loads)
- [How Neovim Modes Work](#how-neovim-modes-work)
- [The Leader Key](#the-leader-key)
- [Plugin Overview](#plugin-overview)
- [Global Keymaps](#global-keymaps)
- [Saving and Quitting](#saving-and-quitting)
- [Useful Commands](#useful-commands)
- [Troubleshooting](#troubleshooting)
- [Further Reading](#further-reading)

---

## What Is Neovim?

Neovim is a terminal-based text editor. It is keyboard-driven, meaning you navigate and edit without touching the mouse. It has a steep learning curve at first, but once it clicks it is extremely fast. This config makes it feel closer to a modern IDE while keeping that speed.

---

## Prerequisites

Install these before cloning.

### 1. Neovim (v0.10 or later)

Check your version with:
```bash
nvim --version
```

**macOS:**
```bash
brew install neovim
```

**Ubuntu / Debian:**
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim
```

**Arch Linux:**
```bash
sudo pacman -S neovim
```

**Windows (WSL recommended):**
```bash
wsl --install
# then inside WSL:
sudo apt install neovim
```

### 2. External Tools

These are required by various plugins (Telescope for searching, Treesitter for parsing, etc.):

| Tool | What it's for |
|---|---|
| `git` | Plugin manager downloads plugins via git |
| `make` + `gcc` | Building native extensions (e.g. telescope-fzf-native) |
| `ripgrep` (`rg`) | Fast text search used by Telescope's live grep |
| `fd` | Fast file finder used by Telescope |
| clipboard tool | Syncing Neovim's clipboard with the system clipboard |

**macOS:**
```bash
brew install ripgrep fd gcc make
```

**Ubuntu / Debian:**
```bash
sudo apt install make gcc ripgrep fd-find unzip git xclip
```

**Arch:**
```bash
sudo pacman -S ripgrep fd gcc make git
```

### 3. A Nerd Font (Required)

Nerd Fonts add icons used throughout the UI (file tree icons, git signs, status bar, etc.). Without one you will see broken boxes or question marks instead of icons.

This config has `vim.g.have_nerd_font = true` set, so icons are expected everywhere.

**Recommended fonts:**
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
- [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)

After downloading, install the font and set it in your terminal emulator's settings. Neovim itself doesn't control the font — your terminal does.

> If you ever switch to a terminal without a Nerd Font, set `vim.g.have_nerd_font = false` in `init.lua` to fall back to text-only icons.

### 4. Node.js (for Markdown browser preview)

```bash
# macOS
brew install node

# Ubuntu/Debian
sudo apt install nodejs npm
```

---

## Installation

```bash
# Back up any existing Neovim config first (skip if you have none)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone the repo
git clone https://github.com/Joshua-Soteras/kickstart.nvim.git ~/.config/nvim
```

Then open Neovim:
```bash
nvim
```

On first launch, lazy.nvim will automatically install all plugins. This takes about 30–60 seconds depending on your connection. You will see a progress window. When it finishes, restart Neovim.

> **Note:** You may see a few errors on the very first launch before plugins finish installing. This is normal — restart and they will be gone.

### Verify Everything Works

| Check | Command |
|---|---|
| Plugin status | `:Lazy` |
| LSP server status | `:Mason` |
| Treesitter parsers | `:TSInstallInfo` |
| Health check | `:checkhealth` |

`:checkhealth` is especially useful — it will warn you about missing dependencies like `ripgrep`, `fd`, or `node`.

---

## Important: Python Path

`lua/config/options.lua` currently points to a specific Python virtual environment on the original machine. **You must edit this before using Python features, or Neovim will throw errors.**

Open `~/.config/nvim/lua/config/options.lua` and remove or update these three lines at the top:

```lua
-- Remove or change this to point to your own Python venv
local thesis_venv = vim.fn.expand('~/Documents/1_Projects/Thesis/...')
vim.g.python3_host_prog = thesis_venv .. '/bin/python'
vim.env.PATH = thesis_venv .. '/bin:' .. vim.env.PATH
```

If you are not using Python, delete all three lines. If you have your own venv, update the path to point to it.

---

## Directory Structure

```
nvim/
├── init.lua                      # Entry point — sets leader key, loads config modules, boots lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua           # Editor settings (line numbers, clipboard, etc.)
│   │   ├── keymaps.lua           # Global keybindings and diagnostic config
│   │   └── autocmds.lua          # Automatic behaviors triggered by Neovim events
│   └── plugins/                  # One file per plugin — all auto-loaded by lazy.nvim
│       ├── blink-cmp.lua         # Autocompletion
│       ├── bufferline.lua        # Buffer tabs at the top
│       ├── colorscheme.lua       # Colorschemes (Catppuccin active + extras)
│       ├── conform.lua           # Code formatting on save
│       ├── gitsigns.lua          # Git indicators in the gutter
│       ├── guess-indent.lua      # Auto-detect indentation style
│       ├── indent-blankline.lua  # Indent guide lines
│       ├── jupytext.lua          # Jupyter notebook → Python conversion
│       ├── lsp.lua               # Language Server Protocol (code intelligence)
│       ├── markdown-preview.lua  # Live markdown preview in browser
│       ├── mini.lua              # Statusline, text objects, surround
│       ├── molten.lua            # Jupyter kernel runner inline
│       ├── neo-tree.lua          # File explorer sidebar
│       ├── render-markdown.lua   # Markdown rendering inside Neovim
│       ├── telescope.lua         # Fuzzy finder
│       ├── todo-comments.lua     # Highlight TODO/FIXME comments
│       ├── treesitter.lua        # Syntax highlighting & parsing
│       └── which-key.lua         # Keymap hint popup
└── docs/                         # Detailed documentation (see Further Reading)
```

---

## How the Config Loads

`init.lua` is the first file Neovim reads. It:

1. Sets `<Space>` as the **leader key** (used as a prefix in most custom shortcuts)
2. Loads `config/options.lua`, `config/keymaps.lua`, `config/autocmds.lua`
3. Downloads and installs **lazy.nvim** (the plugin manager) if it isn't already present
4. Calls `lazy.setup({ import = 'plugins' })` — this scans `lua/plugins/` and loads every file automatically

You never need to manually register plugins anywhere. Drop a `.lua` file in `lua/plugins/` and it gets picked up on the next Neovim start.

---

## How Neovim Modes Work

Neovim is **modal** — it has different modes for different actions.

| Mode | How to enter | What it does |
|---|---|---|
| **Normal** | `Esc` or `jk` | Navigate, run commands — the default mode |
| **Insert** | `i` | Type text like a normal editor |
| **Visual** | `v` | Select text |
| **Command** | `:` | Run editor commands (`:w` to save, `:q` to quit) |
| **Terminal** | `:terminal` | A real shell inside Neovim |

When you open Neovim you are in Normal mode. Press `i` to start typing, then `jk` or `Esc` to return to Normal.

---

## The Leader Key

Throughout this config you'll see `<leader>` in keymaps. The leader key is a **prefix key** — it does nothing on its own, but pressing it signals that a custom shortcut is coming.

In this config the leader is set to **Space**.

So `<leader>sf` means: press `Space`, then `s`, then `f`.

which-key will show you a popup of available shortcuts whenever you pause after pressing `<leader>`. You do not need to memorize keymaps upfront — just press Space and browse.

---

## Plugin Overview

### Plugin Manager — lazy.nvim

[lazy.nvim](https://github.com/folke/lazy.nvim) manages all plugins. It installs, updates, and loads them. Most plugins load only when needed so startup stays fast.

- Open the plugin manager UI: `:Lazy`
- Update all plugins: `:Lazy update`

---

### Colorscheme — Catppuccin (+ extras)

**Active theme:** [Catppuccin](https://github.com/catppuccin/nvim) — a warm, pastel dark theme.

Several other themes are also installed and ready to switch to at any time:

| Theme | Vibe |
|---|---|
| `tokyonight` | Cool blue/purple |
| `kanagawa` | Inspired by Japanese art |
| `rose-pine` | Muted, earthy |
| `gruvbox` / `gruvbox-material` | Retro warm |
| `nightfly` | Dark blue |
| `everforest` | Green/nature |
| `cyberdream` | Neon/sci-fi |
| `edge`, `onenord`, `nightfox`, and more | Various |

Switch themes temporarily: `:colorscheme <name>` (e.g. `:colorscheme tokyonight`)

---

### File Explorer — Neo-tree

[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) gives you a sidebar file tree, like VS Code's Explorer panel.

| Key | Action |
|---|---|
| `\` | Toggle the file tree open/close |
| `\` (while inside the tree) | Close the tree |

Inside the tree, navigate with arrow keys or `hjkl`, press `Enter` to open a file.

---

### Fuzzy Finder — Telescope

[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) is a powerful search tool — think VS Code's `Ctrl+P` command palette, but for everything: files, text, keymaps, help docs, LSP symbols.

| Key | Action |
|---|---|
| `<leader>sf` | Find files in the project |
| `<leader>sg` | Search text across all files (live grep) |
| `<leader>sw` | Search the word under your cursor |
| `<leader><leader>` | Switch between open buffers (open files) |
| `<leader>sh` | Search Neovim help docs |
| `<leader>sk` | Browse all keymaps |
| `<leader>sd` | Show LSP diagnostics (errors/warnings) |
| `<leader>sr` | Resume the last search |
| `<leader>s.` | Recent files |
| `<leader>sn` | Browse this Neovim config's files |
| `<leader>/` | Fuzzy search inside the current file |
| `<leader>s/` | Grep only in currently open files |
| `<leader>sD` | Pick a directory to create a new file in |

---

### Syntax Highlighting — Treesitter

[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) parses your code for accurate, context-aware highlighting. Much more precise than regex-based highlighting.

Pre-installed parsers: `bash`, `c`, `diff`, `html`, `lua`, `markdown`, `vim`, and more. Additional parsers are auto-installed when you open a new file type.

Update parsers: `:TSUpdate`

To add a language, add it to the `parsers` list in `lua/plugins/treesitter.lua`:
```lua
local parsers = { 'bash', 'c', 'lua', 'python', 'typescript', ... }
```

---

### LSP (Language Server Protocol)

[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) connects Neovim to language servers — programs that understand your code and provide:

- Go to definition
- Find all references
- Inline error/warning diagnostics
- Rename symbols across files
- Code actions (quick fixes)

**Installed language servers:**

| Server | Language |
|---|---|
| `lua_ls` | Lua (for editing this config itself) |
| `basedpyright` | Python — strict type checking |
| `ruff` | Python — linting and import sorting |

[Mason](https://github.com/mason-org/mason.nvim) auto-installs these servers. To manage them manually: `:Mason`

To add LSP support for a new language:
1. Open `:Mason` and find the language server (e.g. `typescript-language-server`)
2. Press `i` to install it
3. Or add it to the `servers` table in `lua/plugins/lsp.lua` so it installs automatically

**LSP keymaps** (active when a supported file is open):

| Key | Action |
|---|---|
| `grd` | Go to definition |
| `grr` | Find all references |
| `gri` | Go to implementation |
| `grn` | Rename symbol |
| `gra` | Code actions (quick fixes) |
| `grD` | Go to declaration |
| `gO` | Document symbols (outline) |
| `gW` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |

A small spinner ([fidget.nvim](https://github.com/j-hui/fidget.nvim)) appears in the bottom right while the LSP is loading.

---

### Autocompletion — blink.cmp + LuaSnip

[blink.cmp](https://github.com/saghen/blink.cmp) is the autocomplete engine. It shows suggestions as you type from the LSP, file paths, and snippets.

[LuaSnip](https://github.com/L3MON4D3/LuaSnip) handles code snippets — short abbreviations that expand into full code templates.

| Key | Action |
|---|---|
| `Tab` | Select next suggestion |
| `Shift+Tab` | Select previous suggestion |
| `Enter` | Confirm selection |

---

### Formatting — conform.nvim

[conform.nvim](https://github.com/stevearc/conform.nvim) auto-formats your code every time you save.

| Language | Formatter |
|---|---|
| Lua | `stylua` |
| Python | `ruff_format` + `ruff_fix` |

Manual format: `<leader>f`

Debug formatter issues: `:ConformInfo`

---

### Git Signs — gitsigns.nvim

[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) shows git diff indicators in the left margin so you can see what changed since your last commit without leaving the editor.

| Sign | Meaning |
|---|---|
| `+` | New line added |
| `~` | Line modified |
| `_` | Line deleted |

---

### Buffer Tabs — bufferline.nvim

[bufferline.nvim](https://github.com/akinsho/bufferline.nvim) shows open files as tabs at the top of the screen, similar to browser tabs or VS Code tabs. Each tab shows LSP error/warning counts.

| Key | Action |
|---|---|
| `Tab` | Next buffer/tab |
| `Shift+Tab` | Previous buffer/tab |
| `<leader>bd` | Close current buffer/tab |

---

### Keymap Helper — which-key.nvim

[which-key.nvim](https://github.com/folke/which-key.nvim) shows a popup listing available keymaps when you pause mid-sequence. Press `Space` and wait — a menu appears showing all options. This is especially useful while learning.

---

### Statusline — mini.statusline

Part of [mini.nvim](https://github.com/echasnovski/mini.nvim). Adds a status bar at the bottom showing: current mode, file name, file type, and cursor position.

Two other mini modules are also active:

- **mini.ai** — smarter text objects. For example `diq` deletes inside quotes, `da(` deletes around parentheses.
- **mini.surround** — add/change/delete surrounding characters. `sa"` surrounds a word with quotes, `sd"` removes them, `sr"'` replaces double quotes with single quotes.

---

### Indent Guides — indent-blankline.nvim

[indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) draws vertical lines at each indentation level so nested code is easier to follow visually.

---

### Indent Detection — guess-indent.nvim

[guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) automatically detects whether a file uses tabs or spaces and configures the editor to match. You never have to worry about mixing indent styles.

---

### TODO Highlights — todo-comments.nvim

[todo-comments.nvim](https://github.com/folke/todo-comments.nvim) highlights special comment keywords with colors:

```lua
-- TODO: something to do
-- FIXME: broken, needs fixing
-- NOTE: important note
-- HACK: workaround
-- WARN: be careful
```

Search all TODOs in the project: `:TodoTelescope`

---

### Markdown Rendering — render-markdown.nvim

[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) renders Markdown files visually inside Neovim: styled headings, checkboxes, code blocks, and bullet icons — without leaving the editor.

Activates automatically when you open a `.md` file. Toggle it: `:RenderMarkdown toggle`

---

### Markdown Browser Preview — markdown-preview.nvim

[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) opens your Markdown file in a browser with live preview that updates as you type. Requires Node.js.

| Key | Action |
|---|---|
| `<leader>mp` | Toggle browser preview (in a `.md` file) |

---

### Jupyter Notebooks — molten-nvim + jupytext.nvim

These two work together to let you edit Jupyter notebooks (`.ipynb` files) inside Neovim.

[jupytext.nvim](https://github.com/GCBallesteros/jupytext.nvim) converts notebooks to clean Python files so you can edit them as regular code.

[molten-nvim](https://github.com/benlubas/molten-nvim) connects to a live Jupyter kernel so you can run cells and see output inline.

> Requires a Python environment with `jupyter` and `pynvim` installed.

| Key | Action |
|---|---|
| `<leader>mi` | Initialize/connect a kernel |
| `<leader>ml` | Run current line |
| `<leader>mv` | Run visual selection |
| `<leader>mr` | Re-run current cell |
| `<leader>mo` | Show cell output |
| `<leader>mc` | Hide output |
| `<leader>md` | Delete cell |
| `<leader>mk` | Kill/interrupt kernel |
| `<leader>mR` | Restart kernel |

---

## Global Keymaps

| Key | Action |
|---|---|
| `jk` | Exit insert mode (same as `Esc`) |
| `Esc` (normal mode) | Clear search highlights |
| `<leader>st` | Open terminal in a bottom split |
| `Esc Esc` (in terminal) | Exit terminal mode back to Normal |
| `Ctrl+h / j / k / l` | Move focus between split windows |
| `<leader>q` | Open diagnostic quickfix list |
| `<leader>f` | Format current file |

---

## Saving and Quitting

| Command | Action |
|---|---|
| `:w` | Save file |
| `:q` | Quit (asks if unsaved — won't lose work) |
| `:wq` | Save and quit |
| `:qa` | Quit all windows |

---

## Useful Commands

| Command | Purpose |
|---|---|
| `:Lazy` | Open plugin manager |
| `:Lazy update` | Update all plugins |
| `:Mason` | Manage LSP servers and formatters |
| `:ConformInfo` | Debug formatter for current file |
| `:TSUpdate` | Update Treesitter language parsers |
| `:checkhealth` | Diagnose missing dependencies |
| `:RenderMarkdown toggle` | Toggle Markdown rendering |
| `:TodoTelescope` | Search all TODO/FIXME comments |

---

## Troubleshooting

**Icons look like boxes or `?`** — your terminal font is not a Nerd Font. Install one and set it in your terminal settings.

**Errors on first launch** — normal. Restart Neovim after plugins finish installing.

**LSP not working** — run `:Mason` and check if the language server is installed. Run `:checkhealth` for a full diagnostic.

**Formatting not running** — run `:ConformInfo` to see what formatter is configured and whether it is installed.

**Python errors on startup** — edit `~/.config/nvim/lua/config/options.lua` and remove the three hardcoded venv lines at the top of the file (see the [Python Path section](#important-python-path) above).

---

## Further Reading

Detailed documentation lives in the `docs/` folder:

- [Setup & Prerequisites](docs/setup.md) — full install guide including Windows/Arch
- [Editor Options](docs/options.md) — every setting in `options.lua` explained line by line
- [Keymaps & Autocmds](docs/keymaps.md) — how keymaps work, diagnostic config, autocmds explained
- [Jupyter Notebooks](docs/jupyter-notebooks.md) — full guide for molten + jupytext workflow
- **Plugin deep-dives:**
  - [bufferline.nvim](docs/plugins/bufferline.md)
  - [blink.cmp](docs/plugins/blink-cmp.md)
  - [conform.nvim](docs/plugins/conform.md)
  - [gitsigns.nvim](docs/plugins/gitsigns.md)
  - [LSP](docs/plugins/lsp.md)
  - [mini.nvim](docs/plugins/mini.md)
  - [neo-tree.nvim](docs/plugins/neo-tree.md)
  - [Telescope](docs/plugins/telescope.md)
  - [Colorschemes](docs/plugins/colorscheme.md)
  - [Treesitter](docs/plugins/treesitter.md)
  - [which-key.nvim](docs/plugins/which-key.md)
