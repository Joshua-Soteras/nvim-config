# Telescope

**File:** `lua/plugins/telescope.lua`
**Plugin:** [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

Telescope is a fuzzy finder — a floating search UI that lets you interactively search through files, text, LSP symbols, keymaps, command history, and much more. It's one of the most-used plugins in the Neovim ecosystem.

---

## How It Works

When you trigger a Telescope picker, a floating window opens with three panes:
- **Prompt** — where you type your search query
- **Results** — a live-filtered list of matches
- **Preview** — a preview of the selected result (file content, definition, etc.)

As you type, results filter in real time. Press `Enter` to open the selection, `Esc` to close.

---

## Dependencies

| Plugin | Purpose |
|--------|---------|
| **plenary.nvim** | Lua utilities used by many Neovim plugins (async, file path handling, etc.) |
| **telescope-fzf-native.nvim** | A native C extension that makes fuzzy matching significantly faster. Built with `make` — only loaded if `make` is available on the system |
| **telescope-ui-select.nvim** | Replaces Neovim's built-in `vim.ui.select` with a Telescope picker. This means things like LSP code actions open in a Telescope dropdown instead of the default ugly menu |
| **nvim-web-devicons** | File icons in the results list. Only loaded when Nerd Font is enabled |

---

## Keymaps

All Telescope keymaps are in the `<leader>s` group (`s` for **S**earch), organized by what they search.

### File & Text Search

| Keys | Action | Notes |
|------|--------|-------|
| `Space + s + f` | Search files | Fuzzy find any file in the project by filename |
| `Space + s + g` | Search by grep | Live grep — search file *contents* across the whole project |
| `Space + s + w` | Search current word | Greps for the word under the cursor. Works in Normal and Visual mode |
| `Space + s + /` | Search in open files | Live grep but only across currently open buffers |
| `Space + s + .` | Recent files | Shows files you've opened recently |
| `Space + s + D` | Create file in directory | Opens a picker to choose a directory, then prompts for a new filename |
| `Space + Space` | Find open buffers | Lists all currently open buffers — quick way to switch between files |

### Neovim Meta

| Keys | Action | Notes |
|------|--------|-------|
| `Space + s + h` | Search help | Search Neovim's built-in help documentation |
| `Space + s + k` | Search keymaps | Browse all active keymaps with their descriptions |
| `Space + s + s` | Search Telescope pickers | Opens a picker listing all available Telescope pickers |
| `Space + s + c` | Search commands | Browse all available Ex commands |
| `Space + s + d` | Search diagnostics | Lists LSP diagnostics across all open buffers |
| `Space + s + r` | Resume last search | Re-opens the last Telescope picker with the same query |
| `Space + s + n` | Search Neovim config files | Opens a file picker scoped to `~/.config/nvim/` |

### In-Buffer Search

```lua
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
```

| Keys | Action |
|------|--------|
| `Space + /` | Fuzzy search within the current file |

This uses the `dropdown` theme (a compact centered picker) with `winblend = 10` (slight transparency) and no preview pane since you're already looking at the file.

### LSP Keymaps (from `lua/plugins/telescope.lua`)

These are set inside a `LspAttach` autocmd so they're only active when an LSP server is running:

| Keys | Action |
|------|--------|
| `grr` | Find references to the symbol under the cursor |
| `gri` | Find implementations of the symbol |
| `grd` | Go to definition |
| `gO` | List document symbols (functions, classes, etc.) |
| `gW` | Search workspace symbols |
| `grt` | Go to type definition |

---

## Extensions

```lua
require('telescope').setup {
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
```

`pcall` is Lua's protected call — it runs a function and catches any errors instead of crashing. This is used here because the extensions may not be installed yet on first launch, and we don't want an error to prevent Neovim from starting.

---

## Custom Picker: Create File in Directory

```lua
vim.keymap.set('n', '<leader>sD', function() ... end, { desc = '[S]earch [D]irectory to create file' })
```

`Space + s + D` opens a custom picker that:
1. Lists all directories in the project (using `fd --type d`)
2. You select a directory
3. A prompt appears asking for the new filename
4. Neovim opens the new file for editing

This is a hand-rolled Telescope picker built using the Telescope API: `pickers.new`, `finders.new_oneshot_job`, and `actions`.
