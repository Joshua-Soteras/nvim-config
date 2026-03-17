# neo-tree.nvim

**File:** `lua/plugins/neo-tree.lua`
**Plugin:** [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)

neo-tree is a **file explorer sidebar** — a panel on the left side of the screen that shows your project's directory tree. You can navigate directories, open files, create/rename/delete files, and see git status per file.

---

## Keymaps

```lua
keys = {
  { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
},
```

| Keys | Action |
|------|--------|
| `\` (backslash) | Toggle the neo-tree sidebar open/closed, and reveal the current file |

**`:Neotree reveal`** — opens neo-tree and scrolls the tree to highlight the file you currently have open. This is different from just opening the tree — it also points to where you are in the project structure.

**`silent = true`** — suppresses the command text from flashing in the command line when the key is pressed.

---

## Closing the Sidebar

```lua
opts = {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
},
```

Inside the neo-tree window, pressing `\` again closes it. This makes `\` a toggle — press once to open, press again (while focused on neo-tree) to close.

This is set under `filesystem.window.mappings` because neo-tree has several "sources" (filesystem, git status, buffers) each with their own window config. `filesystem` is the default source.

---

## Built-in Neo-tree Keymaps

Once the neo-tree window is open and focused, these keys work inside it (defaults, not customized here):

| Key | Action |
|-----|--------|
| `Enter` or `l` | Open file or expand directory |
| `h` | Collapse directory |
| `a` | Create new file/directory |
| `d` | Delete file |
| `r` | Rename file |
| `y` | Copy file |
| `x` | Cut file |
| `p` | Paste file |
| `R` | Refresh the tree |
| `?` | Show help |
| `q` | Close neo-tree |
| `H` | Toggle hidden files |

---

## Dependencies

| Plugin | Purpose |
|--------|---------|
| **plenary.nvim** | Lua utilities (async operations, path handling) |
| **nvim-web-devicons** | File icons in the tree |
| **nui.nvim** | UI component library used by neo-tree for rendering |

---

## `lazy = false`

```lua
lazy = false,
```

Loads at startup. Since neo-tree manages the sidebar layout, it needs to be available immediately — especially because bufferline.nvim has an offset configured for neo-tree's sidebar, so the two need to coordinate from the start.
