# which-key.nvim

**File:** `lua/plugins/which-key.lua`
**Plugin:** [folke/which-key.nvim](https://github.com/folke/which-key.nvim)

which-key shows a **popup hint panel** when you pause mid-keymap. For example, if you press `Space` and wait, it shows a list of all available `<leader>` shortcuts with their descriptions. It's essentially a live, searchable cheat sheet built from your actual config.

---

## How It Works

1. You start pressing a multi-key sequence (e.g. `Space`)
2. After a short delay (configurable), a floating window pops up
3. It shows all keymaps that start with the keys you've pressed so far
4. As you press more keys, the list narrows
5. If you press a key that completes a mapping, it executes and the popup closes
6. Press `<Esc>` to dismiss without executing anything

---

## Configuration

```lua
opts = {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch',   mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr',        group = 'LSP Actions', mode = { 'n' } },
  },
},
```

### `delay = 0`

How long to wait before showing the popup after you pause. `0` means the popup opens immediately with no delay. The popup only appears when you stop pressing keys — it doesn't interrupt your typing if you're pressing keys quickly.

### `icons.mappings`

When `vim.g.have_nerd_font` is `true`, which-key shows Nerd Font icons next to each keymap entry (e.g. a magnifying glass for search, a wrench for settings). When false, it uses text-only labels.

### `spec` — Group Labels

The `spec` table assigns **friendly group names** to keymap prefixes. Without this, which-key would just show raw key letters — with it, you see labeled sections.

```lua
{ '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
```

| Field | Meaning |
|-------|---------|
| `'<leader>s'` | The keymap prefix this label applies to |
| `group = '[S]earch'` | The label shown in the popup for this group. The `[S]` bracket notation highlights the mnemonic letter |
| `mode = { 'n', 'v' }` | The modes this group is active in (Normal and Visual) |

**Defined groups:**

| Prefix | Group Name | Modes |
|--------|-----------|-------|
| `<leader>s` | `[S]earch` | Normal, Visual |
| `<leader>t` | `[T]oggle` | Normal |
| `<leader>h` | `Git [H]unk` | Normal, Visual |
| `gr` | `LSP Actions` | Normal |

When you press `Space + s`, the popup shows "Search" as the section heading, and lists all `<leader>s*` keymaps underneath. This makes it much easier to remember what `<leader>sg` vs `<leader>sf` do.

---

## `event = 'VimEnter'`

```lua
event = 'VimEnter',
```

Loads the plugin right after Neovim finishes starting. This ensures which-key is ready before you press any keys, without adding to raw startup time.
