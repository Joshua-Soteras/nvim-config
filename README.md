# Neovim Config

A modern, modular Neovim setup built on [lazy.nvim](https://github.com/folke/lazy.nvim). Designed to feel like a lightweight IDE — fast startup, smart completions, LSP support, and a clean UI.

---

## Table of Contents

- [Setup & Prerequisites](docs/setup.md)
- [Editor Options](docs/options.md)
- [Keymaps & Autocmds](docs/keymaps.md)
- **Plugins**
  - [bufferline.nvim](docs/plugins/bufferline.md) — Buffer tabs at the top
  - [blink.cmp](docs/plugins/blink-cmp.md) — Autocompletion
  - [conform.nvim](docs/plugins/conform.md) — Code formatting
  - [gitsigns.nvim](docs/plugins/gitsigns.md) — Git indicators in the gutter
  - [guess-indent.nvim](docs/plugins/guess-indent.md) — Auto-detect indentation
  - [LSP](docs/plugins/lsp.md) — Language Server Protocol (code intelligence)
  - [mini.nvim](docs/plugins/mini.md) — Statusline, text objects, surround
  - [neo-tree.nvim](docs/plugins/neo-tree.md) — File explorer sidebar
  - [Telescope](docs/plugins/telescope.md) — Fuzzy finder
  - [todo-comments.nvim](docs/plugins/todo-comments.md) — Highlight TODOs
  - [tokyonight.nvim](docs/plugins/colorscheme.md) — Colorscheme
  - [Treesitter](docs/plugins/treesitter.md) — Syntax highlighting & parsing
  - [which-key.nvim](docs/plugins/which-key.md) — Keymap hint popup

---

## Directory Structure

```
nvim/
├── init.lua                  # Entry point — sets leader key, loads config modules, boots lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua       # Editor settings (line numbers, clipboard, etc.)
│   │   ├── keymaps.lua       # Global keybindings and diagnostic config
│   │   └── autocmds.lua      # Automatic behaviors triggered by Neovim events
│   └── plugins/              # One file per plugin — all auto-loaded by lazy.nvim
│       ├── bufferline.lua
│       ├── blink-cmp.lua
│       ├── colorscheme.lua
│       ├── conform.lua
│       ├── gitsigns.lua
│       ├── guess-indent.lua
│       ├── lsp.lua
│       ├── mini.lua
│       ├── neo-tree.lua
│       ├── telescope.lua
│       ├── todo-comments.lua
│       ├── treesitter.lua
│       └── which-key.lua
└── docs/                     # This documentation
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

## The Leader Key

Throughout this config you'll see `<leader>` in keymaps. The leader key is a **prefix key** — it does nothing on its own, but pressing it signals that a custom shortcut is coming.

In this config the leader is set to **Space**.

So `<leader>sf` means: press `Space`, then `s`, then `f`.

which-key will show you a popup of available shortcuts whenever you pause after pressing `<leader>`.
