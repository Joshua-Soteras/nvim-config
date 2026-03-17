# Keymaps & Autocmds

**Files:** `lua/config/keymaps.lua`, `lua/config/autocmds.lua`

---

## Understanding Keymaps

Before diving into the specific bindings, here's how to read them.

### vim.keymap.set

Every keymap in this config is set with:

```lua
vim.keymap.set(mode, keys, action, options)
```

| Argument | What it means |
|----------|--------------|
| `mode` | Which Neovim mode the keymap is active in |
| `keys` | The key sequence to press |
| `action` | What happens — a command string or a Lua function |
| `options` | A table of extra settings like `desc`, `buffer`, `silent` |

---

### Modes

| Symbol | Mode | When you're in it |
|--------|------|------------------|
| `'n'` | Normal | Default mode — navigating, not typing |
| `'i'` | Insert | Typing text into the buffer |
| `'v'` | Visual | Text is selected (includes Visual Line and Visual Block) |
| `'x'` | Visual only | Like `'v'` but excludes Select mode |
| `'t'` | Terminal | Inside a `:terminal` buffer |
| `''` | All modes | Active everywhere |
| `{ 'n', 'v' }` | Multiple | A Lua array of mode strings |

---

### Key Notation

| Notation | Key |
|----------|-----|
| `<leader>` | Space (set in `init.lua`) |
| `<CR>` | Enter / Return |
| `<Esc>` | Escape |
| `<Tab>` | Tab |
| `<S-Tab>` | Shift + Tab |
| `<C-h>` | Ctrl + h |
| `<C-\\>` | Ctrl + backslash |
| `<C-n>` | Ctrl + n |

---

### Options Table

| Option | What it does |
|--------|-------------|
| `desc` | A short description shown in which-key and `:map` output |
| `buffer` | Makes the keymap buffer-local — only active in the current file. Used by LSP so keys like `grr` only work in files where an LSP is attached |
| `silent = true` | Suppresses the command echo in the command line. Without this, pressing a key would flash the raw command string at the bottom of the screen |

---

## Global Keymaps

### Clear Search Highlights

```lua
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
```

After searching with `/`, Neovim highlights every match. Pressing `<Esc>` in Normal mode clears those highlights. The `<cmd>nohlsearch<CR>` part runs the `:nohlsearch` command.

---

### Diagnostic Quickfix List

```lua
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
```

- **Mode:** Normal
- **Keys:** `Space` + `q`
- **Action:** Collects all LSP diagnostics (errors, warnings, hints) for the current buffer into the **location list** — a built-in Neovim panel that lets you jump between issues. Open it with this key, navigate with `:lnext` / `:lprev`, close with `:lclose`.

---

### Exit Terminal Mode

```lua
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
```

- **Mode:** Terminal (`t`)
- **Keys:** `Esc` pressed twice
- **Action:** `<C-\\><C-n>` is the built-in key sequence to leave Terminal mode and return to Normal mode inside a `:terminal` buffer.

Why double `<Esc>`? Some terminal programs (like shells and TUIs) use single `<Esc>` internally, so a single press gets sent to the program rather than Neovim. Double `<Esc>` makes it unambiguous that you want to leave Terminal mode.

---

### Window Navigation

```lua
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
```

- **Mode:** Normal
- **Keys:** `Ctrl + h/j/k/l`
- **Action:** Moves focus between open windows (splits).

Neovim's native way to switch windows is `<C-w>` followed by a direction. These keymaps skip the `<C-w>` prefix so you can just use `Ctrl + h/j/k/l` directly — matching the same direction keys used for cursor movement (`h` = left, `j` = down, `k` = up, `l` = right).

---

## Diagnostic Configuration

```lua
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}
```

This controls how LSP errors and warnings are displayed.

| Setting | What it does |
|---------|-------------|
| `update_in_insert = false` | Diagnostics don't update while you're typing in Insert mode — avoids distracting flicker mid-keystroke |
| `severity_sort = true` | Errors are shown before warnings, warnings before hints |
| `float.border = 'rounded'` | Diagnostic popup windows have rounded corners |
| `float.source = 'if_many'` | If multiple LSP servers are running, each diagnostic shows which server reported it |
| `underline` | Only underlines diagnostics at Warning severity or higher (ignores hints/info) |
| `virtual_text = true` | Shows diagnostic messages inline at the end of the line |
| `virtual_lines = false` | Disables the alternative multi-line virtual text display |
| `jump.float = true` | When you jump to a diagnostic (`]d` / `[d`), a floating window automatically opens showing the full message |

---

## Autocmds

**File:** `lua/config/autocmds.lua`

Autocmds (auto-commands) are callbacks that fire automatically when specific Neovim events happen.

### Highlight on Yank

```lua
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
```

**Event:** `TextYankPost` — fires immediately after any yank (copy) operation.

**What it does:** Briefly flashes a highlight over the text you just yanked. This gives you visual confirmation of exactly what was copied, which is especially useful when yanking a whole line or a text object.

**`augroup`:** Autocmds are organized into groups. `vim.api.nvim_create_augroup` creates (or reuses) a named group. The `clear = true` flag removes any previously registered autocmds in that group before adding new ones — this prevents duplicate registrations if the config is reloaded mid-session.
