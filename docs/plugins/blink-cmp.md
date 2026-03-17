# blink.cmp

**File:** `lua/plugins/blink-cmp.lua`
**Plugin:** [saghen/blink.cmp](https://github.com/Saghen/blink.cmp)

blink.cmp is the **autocompletion engine**. As you type, it shows a popup menu of suggestions pulled from the LSP, file paths, and snippets. It's a modern, fast alternative to nvim-cmp, written with performance in mind.

---

## How Completion Works

1. You start typing in Insert mode
2. blink.cmp queries **sources** (LSP, filesystem paths, snippet library)
3. A popup menu appears with ranked suggestions
4. You use the configured keys to navigate and accept a suggestion

---

## Dependencies

```lua
dependencies = {
  {
    'L3MON4D3/LuaSnip',
    version = '2.*',
    build = (function()
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),
  },
},
```

**LuaSnip** is the snippet engine. Snippets are templates that expand into boilerplate — for example, typing `fn` + Tab might expand into a full function skeleton. The `make install_jsregexp` build step adds support for JavaScript-style regex in snippets (optional but recommended).

---

## Configuration

### Keymap Preset

```lua
keymap = { preset = 'default' },
```

Uses blink.cmp's built-in default keymaps for the completion menu:

| Key | Action |
|-----|--------|
| `Ctrl + n` | Select next item |
| `Ctrl + p` | Select previous item |
| `Ctrl + y` | Accept selected item |
| `Ctrl + e` | Close completion menu |
| `Tab` | Select next / accept (context-dependent) |

---

### Appearance

```lua
appearance = { nerd_font_variant = 'mono' },
```

Uses the monospaced variant of Nerd Font icons in the completion menu (e.g. the small icon that shows whether a suggestion is a function, variable, class, etc.). `'mono'` ensures icons are single-width, which prevents alignment issues in monospace terminals.

---

### Documentation

```lua
completion = {
  documentation = { auto_show = false, auto_show_delay_ms = 500 },
},
```

- `auto_show = false` — the documentation popup (showing the full description of a completion item) doesn't open automatically. You have to trigger it manually. This keeps the UI less cluttered while you're typing.
- `auto_show_delay_ms = 500` — if you were to enable `auto_show`, it would wait 500ms before popping up the docs.

---

### Sources

```lua
sources = {
  default = { 'lsp', 'path', 'snippets' },
},
```

Defines where completion suggestions come from:

| Source | What it provides |
|--------|-----------------|
| `lsp` | Suggestions from the language server — functions, methods, types, variables from the project and its dependencies |
| `path` | File system path completion — useful when typing strings like `'./src/components/...'` |
| `snippets` | Snippet completions from LuaSnip |

Buffer-based completion (suggesting words already in the current file) is intentionally excluded here, keeping suggestions more semantic and relevant.

---

### Snippets

```lua
snippets = { preset = 'luasnip' },
```

Tells blink.cmp to use **LuaSnip** as the snippet engine for expanding snippet completions.

---

### Fuzzy Matching

```lua
fuzzy = { implementation = 'lua' },
```

Uses a pure Lua implementation for fuzzy matching instead of a native binary. More portable across systems, slightly slower on very large completion lists (but not noticeably so in practice).

---

### Signature Help

```lua
signature = { enabled = true },
```

Shows the function signature (parameter names and types) in a floating window as you type inside a function call. For example, calling `string.format(` would show you all the parameters `format` accepts. This data comes from the LSP.

---

## `event = 'VimEnter'`

```lua
event = 'VimEnter',
```

Loads the plugin right after Neovim starts (on the `VimEnter` event) rather than immediately at startup. This is a lazy loading strategy that shaves a few milliseconds off startup time — completion isn't needed until you actually have a file open.
