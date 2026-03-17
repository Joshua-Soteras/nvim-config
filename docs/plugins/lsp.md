# LSP (Language Server Protocol)

**File:** `lua/plugins/lsp.lua`
**Plugin:** [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

LSP is the system that gives your editor "intelligence" about code — things like go-to-definition, find references, rename symbol, type checking, inline errors, and autocompletion data. It works by running a separate **language server** process in the background that understands a specific language, and Neovim communicates with it.

---

## How It Works

1. You open a file (e.g. `main.py`)
2. Neovim detects the filetype and starts the appropriate language server (e.g. `basedpyright`)
3. The server analyzes the file and sends back diagnostics, symbol info, etc.
4. Neovim renders those results as underlines, virtual text, hover docs, etc.
5. The `LspAttach` autocmd fires and registers buffer-local keymaps so you can interact with the server

---

## Dependency Stack

```lua
dependencies = {
  { 'mason-org/mason.nvim', opts = {} },
  'mason-org/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  { 'j-hui/fidget.nvim', opts = {} },
},
```

| Plugin | Role |
|--------|------|
| **mason.nvim** | A package manager for LSP servers, formatters, and linters. Installs them into Neovim's data dir so you don't need to install them globally on your system |
| **mason-lspconfig.nvim** | Bridge between Mason and nvim-lspconfig — ensures the servers Mason installs are automatically configured |
| **mason-tool-installer.nvim** | Ensures a specific list of tools is always installed. Runs on startup and installs anything missing |
| **fidget.nvim** | Shows a small loading spinner in the bottom-right corner while LSP servers are starting up or indexing |

---

## Keymaps (Buffer-Local)

These keymaps are only active inside buffers where an LSP server is attached. They're set up inside the `LspAttach` autocmd so they don't pollute other filetypes.

```lua
map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
```

| Keys | Action | Description |
|------|--------|-------------|
| `grn` | Rename symbol | Renames the symbol under the cursor **everywhere it's used** across the project — not just a text replace, but a semantic rename that understands scope |
| `gra` | Code action | Opens a menu of context-aware fixes and refactors the LSP suggests (e.g. "Import missing module", "Extract to function", "Fix lint error") |
| `grD` | Go to declaration | Jumps to where the symbol is *declared* (e.g. the `extern` declaration in C). Different from definition — some languages distinguish the two |

**Telescope-powered LSP keymaps** (set in `lua/plugins/telescope.lua`):

| Keys | Action |
|------|--------|
| `grr` | Find all references to the symbol under the cursor |
| `gri` | Find all implementations of an interface or abstract method |
| `grd` | Go to the definition of the symbol (where it's implemented) |
| `gO` | List all symbols (functions, classes, variables) in the current file |
| `gW` | Search symbols across the entire workspace |
| `grt` | Go to the type definition of the symbol |

**Toggle inlay hints:**

```lua
map('<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
end, '[T]oggle Inlay [H]ints')
```

| Keys | Action |
|------|--------|
| `Space + t + h` | Toggle inlay hints on/off |

**Inlay hints** are subtle inline annotations the LSP inserts into your code — things like parameter names in function calls, return types, or inferred types. They appear as grayed-out text and don't modify the actual file.

---

## Document Highlights

```lua
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = vim.lsp.buf.document_highlight,
})
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  callback = vim.lsp.buf.clear_references,
})
```

When you leave the cursor on a symbol for `updatetime` milliseconds (250ms in this config), the LSP highlights all other occurrences of that symbol in the file. When you move the cursor, the highlights clear. This only activates if the server supports `textDocument/documentHighlight`.

---

## Configured Language Servers

### `lua_ls` — Lua

The Lua language server, configured specifically to understand Neovim's Lua API. The `on_init` callback sets up the correct runtime path and workspace library so `lua_ls` knows about Neovim's built-in globals like `vim`, `require`, etc.

### `basedpyright` — Python

A strict, community-maintained fork of Microsoft's Pyright. Configured with:

| Setting | Effect |
|---------|--------|
| `typeCheckingMode = 'strict'` | Maximum type checking — catches more bugs |
| `autoImportCompletions = true` | Suggests imports automatically when you autocomplete |
| `diagnosticMode = 'openFilesOnly'` | Only analyzes files currently open — avoids slowdown on large projects |
| `callArgumentNames = true` | Inlay hints for parameter names in function calls |
| `functionReturnTypes = true` | Inlay hints showing what each function returns |
| `genericTypes = true` | Inlay hints showing resolved generic types |

### `ruff` — Python linting/formatting

Ruff is an extremely fast Python linter (written in Rust). It runs alongside basedpyright and handles style/lint diagnostics separately from type checking.

### `stylua` — Lua formatting

StyLua is the Lua formatter used by conform.nvim. It's listed here so Mason installs it automatically alongside the LSP servers.

---

## Auto-Installation

```lua
require('mason-tool-installer').setup { ensure_installed = ensure_installed }
```

On startup, Mason checks whether each server in the `servers` table is installed. If any are missing, it installs them automatically. You never need to run `:MasonInstall` manually for servers listed here.
