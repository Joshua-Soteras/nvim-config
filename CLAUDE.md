# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A modular Neovim config built on [lazy.nvim](https://github.com/folke/lazy.nvim). Lua is the only language used. There are no build steps, test suites, or package managers — changes take effect on the next Neovim launch (or `:Lazy reload <plugin>`).

## Key Commands (run inside Neovim)

| Command | Purpose |
|---|---|
| `:Lazy sync` | Install/update/clean plugins after editing plugin files |
| `:Lazy reload <plugin>` | Hot-reload a single plugin without restarting |
| `:Mason` | Manage LSP servers, formatters, and linters |
| `:ConformInfo` | Debug formatter setup for the current buffer |
| `:RenderMarkdown toggle` | Toggle markdown live preview on/off |
| `:TSUpdate` | Update Treesitter parsers |
| `:checkhealth` | Diagnose missing dependencies |

Formatting runs automatically on save via conform.nvim. Manual format: `<leader>f`.

## Architecture

**Entry point:** `init.lua` sets leader keys, loads `lua/config/*`, then boots lazy.nvim pointing at `lua/plugins/`.

**`lua/config/`** — editor-level settings, no plugin logic:
- `options.lua` — vim options (no relative numbers, `timeoutlen = 300`, transparency-friendly settings)
- `keymaps.lua` — global maps + diagnostic config (`jk` → Esc, `<C-hjkl>` window nav, `<leader>st` terminal split)
- `autocmds.lua` — two autogroups: terminal transparency (clears `bg` on every `ColorScheme` event) and yank highlight

**`lua/plugins/`** — one file per plugin, all lazy-loaded by convention. lazy.nvim scans this directory automatically via `{ import = 'plugins' }` in `init.lua`. To add a plugin, create a new file here returning a lazy spec table.

**`lua/custom/plugins/init.lua`** — empty extension point for local overrides (not tracked meaningfully).

## LSP & Formatting

LSP servers are declared in `lua/plugins/lsp.lua` in the `servers` table and auto-installed by mason-tool-installer. Currently configured: `lua_ls`, `basedpyright` (strict mode), `ruff`, `stylua`.

Formatting is handled by conform.nvim (`lua/plugins/conform.lua`):
- Lua → `stylua`
- Python → `ruff_format` then `ruff_fix`
- Format-on-save is enabled for all filetypes except `c`/`cpp`

## Active Colorscheme

Catppuccin with `transparent_background = true` is the active scheme (loaded with `priority = 1000`). The `autocmds.lua` transparency autogroup re-clears background highlights on every colorscheme change to maintain terminal transparency — this must be preserved when adding new plugins that introduce highlight groups (e.g., add their group names to the list in `autocmds.lua`).

## Adding a Plugin

1. Create `lua/plugins/<name>.lua` returning a lazy spec (`---@type LazySpec`)
2. Run `:Lazy sync` in Neovim
3. If the plugin adds highlight groups that break transparency, add them to the `groups` list in `lua/config/autocmds.lua`

## Keymaps Convention

All plugin keymaps live in their respective plugin file. Global keymaps live in `lua/config/keymaps.lua`. The `desc` field is always set — which-key surfaces these automatically. Leader is `<Space>`.
