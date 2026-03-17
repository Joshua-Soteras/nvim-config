# bufferline.nvim

**File:** `lua/plugins/bufferline.lua`
**Plugin:** [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)

Renders your open buffers as tabs across the top of the screen, similar to browser tabs or VS Code's tab bar. Each tab shows the filename, and optionally icons and LSP diagnostic counts.

---

## What's a Buffer?

In Neovim, a **buffer** is any file you've opened. Unlike tabs in other editors, buffers aren't visually represented by default — they just exist in memory. bufferline.nvim gives them a visual tab-like UI at the top, making it easy to see what you have open and switch between files.

---

## Keymaps

```lua
keys = {
  { '<Tab>',   '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
  { '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
  { '<leader>bd', '<cmd>bdelete<CR>',          desc = 'Delete buffer' },
},
```

| Keys | Action |
|------|--------|
| `Tab` | Move to the next buffer (tab) to the right |
| `Shift + Tab` | Move to the previous buffer (tab) to the left |
| `Space + b + d` | Close (delete) the current buffer |

**How to read `<cmd>BufferLineCycleNext<CR>`:**
- `<cmd>` — opens the command-line without showing it
- `BufferLineCycleNext` — the Ex command provided by bufferline
- `<CR>` — submits/runs the command (Enter)

**`bdelete`** is a built-in Neovim command that removes the current buffer from memory. The buffer's tab disappears from bufferline. Note: this does not close the window, just the buffer.

---

## Options

```lua
opts = {
  options = {
    mode = "buffers",
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        text_align = "left",
        separator = true,
      },
    },
  },
},
```

### `mode = "buffers"`

Tells bufferline to display **buffers** (open files) as tabs. The alternative is `"tabs"` (Neovim's native tab pages), but buffer mode is almost always what you want since buffers are how most workflows manage open files.

### `diagnostics = "nvim_lsp"`

Shows LSP diagnostic counts directly on each tab. If a file has errors, you'll see a red indicator on its tab. If it has warnings, you'll see a yellow one. This means you can see at a glance which files have problems without having to open them.

Requires the built-in LSP client to be active (which it is via `lua/plugins/lsp.lua`).

### `separator_style = "slant"`

Controls the visual shape of the dividers between tabs. `"slant"` gives a diagonal / angled separator that looks like:

```
 file1.lua ╱ file2.py ╱ file3.js
```

Other options include `"thin"` (a simple vertical line), `"thick"`, `"slope"`, and `"padded_slant"`. Slant requires a **Nerd Font** to render correctly, which is why `vim.g.have_nerd_font = true` is set in `init.lua`.

### `offsets`

When neo-tree (the file explorer) is open, it creates a sidebar on the left. Without offsets, bufferline's tab bar would stretch across the full width of the screen — including over the neo-tree sidebar — which looks wrong.

The `offsets` setting tells bufferline to leave a gap on the left side when a window with `filetype = "neo-tree"` is open.

| Option | What it does |
|--------|-------------|
| `filetype = "neo-tree"` | Detects when the neo-tree sidebar is open |
| `text = "File Explorer"` | Shows this label in the offset area instead of leaving it blank |
| `text_align = "left"` | Aligns the label to the left of the offset area |
| `separator = true` | Draws a vertical separator line between the offset and the first tab |

---

## Dependencies

```lua
dependencies = { 'nvim-tree/nvim-web-devicons' }
```

**nvim-web-devicons** provides filetype icons — the small colored icons next to filenames (e.g. a Lua moon for `.lua` files, a Python snake for `.py` files). Requires a Nerd Font to render.

---

## `lazy = false`

```lua
lazy = false,
```

Loads the plugin immediately when Neovim starts. This is necessary because the tab bar needs to be rendered from the very beginning. If it loaded lazily (on first use), the top of the screen would be blank until you triggered it.
