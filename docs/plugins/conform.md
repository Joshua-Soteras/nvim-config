# conform.nvim

**File:** `lua/plugins/conform.lua`
**Plugin:** [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)

conform.nvim handles **code formatting** — automatically running tools like `stylua` or `ruff` on your files to enforce consistent style. It's a thin, fast wrapper around external formatters.

---

## Keymaps

```lua
keys = {
  {
    '<leader>f',
    function()
      require('conform').format { async = true, lsp_format = 'fallback' }
    end,
    mode = '',
    desc = '[F]ormat buffer',
  },
},
```

| Keys | Action |
|------|--------|
| `Space + f` | Format the current buffer |

**`mode = ''`** means this keymap works in **all modes** — Normal, Insert, Visual, etc. Useful if you want to format while in a selection.

**`async = true`** — formatting runs asynchronously (in the background) so Neovim doesn't freeze while a slow formatter runs.

**`lsp_format = 'fallback'`** — if a dedicated formatter is configured for the current filetype, use it. If no formatter is configured, fall back to the LSP's built-in formatting capability (if the server supports it). This is a smart default that covers more situations.

---

## Lazy Loading

```lua
event = { 'BufWritePre' },
cmd = { 'ConformInfo' },
```

- `event = 'BufWritePre'` — the plugin loads the first time you save a file. This is efficient because conform isn't needed until you write.
- `cmd = 'ConformInfo'` — also loads if you manually run `:ConformInfo` (a command that shows which formatters are active for the current buffer).

---

## Format on Save

```lua
format_on_save = function(bufnr)
  local disable_filetypes = { c = true, cpp = true }
  if disable_filetypes[vim.bo[bufnr].filetype] then
    return nil
  else
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end
end,
```

Automatically formats the file every time you save (`:w`).

- **`timeout_ms = 500`** — if the formatter takes longer than 500ms, it's cancelled so saves don't feel laggy.
- **`lsp_format = 'fallback'`** — same fallback logic as the manual format keymap.
- **C and C++ are excluded** (`disable_filetypes = { c = true, cpp = true }`) because their formatters (like `clang-format`) can have complex project-specific config and it's safer to run them manually.

Returning `nil` disables format-on-save for that buffer.

---

## Formatters by Filetype

```lua
formatters_by_ft = {
  lua = { 'stylua' },
  python = { 'ruff_format', 'ruff_fix' },
},
```

Maps filetypes to the formatters that should run on them.

| Filetype | Formatter(s) | Notes |
|----------|-------------|-------|
| `lua` | `stylua` | Opinionated Lua formatter. Installed automatically via Mason (listed in `lsp.lua`) |
| `python` | `ruff_format` then `ruff_fix` | `ruff_format` reformats style; `ruff_fix` applies auto-fixable lint fixes. Both run in sequence |

When multiple formatters are listed (like for Python), they run in order — the output of the first is piped into the second.

---

## `notify_on_error = false`

```lua
notify_on_error = false,
```

Suppresses error notifications if a formatter fails (e.g. the tool isn't installed, or the file has a syntax error that prevents formatting). Errors are still logged but don't pop up as intrusive notifications.
