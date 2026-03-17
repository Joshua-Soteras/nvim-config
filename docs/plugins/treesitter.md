# Treesitter

**File:** `lua/plugins/treesitter.lua`
**Plugin:** [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

Treesitter is a **parsing framework** that gives Neovim a deep, structured understanding of your code. Instead of using regex-based syntax highlighting (which is fragile and dumb), Treesitter builds an actual **syntax tree** from your source code — the same kind of representation that compilers use internally.

---

## What It Does

- **Syntax highlighting** — Accurate, context-aware colorization. It knows that `if` inside a string isn't a keyword, or that a variable named `end` in Python isn't a block terminator.
- **Indentation** — Smart, language-aware indentation via `indentexpr`.
- **Text objects** — Other plugins (like mini.ai) use the Treesitter tree to define text objects like "select this function", "select this block", etc.
- **Code folding, structural navigation** — Available through additional Treesitter modules.

---

## Configuration

```lua
config = function()
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)
```

This installs **parsers** for the listed languages. Each parser is a compiled binary that understands one language's grammar. Parsers are downloaded and built on first use.

**Currently installed parsers:**

| Parser | Language |
|--------|----------|
| `bash` | Shell scripts |
| `c` | C |
| `diff` | Git diff output |
| `html` | HTML |
| `lua` | Lua (used for this config itself) |
| `luadoc` | Lua documentation comments |
| `markdown` | Markdown (block-level) |
| `markdown_inline` | Markdown inline elements |
| `query` | Treesitter query files (`.scm`) |
| `vim` | Vimscript |
| `vimdoc` | Neovim help files |

To add more languages (e.g. Python, TypeScript), just add their names to this list. Treesitter will install the parser automatically.

---

## Auto-Start on FileType

```lua
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
```

Every time you open a file, this autocmd fires:

1. **Detects the language** from the filetype (`lua`, `python`, etc.)
2. **Checks if a parser exists** for that language — if not, skips gracefully
3. **Starts Treesitter** on the buffer, enabling syntax highlighting
4. **Sets `indentexpr`** to use Treesitter's indentation logic instead of Neovim's built-in (which is regex-based)

This approach activates Treesitter automatically for any language you have a parser for — no manual setup needed per language.

---

## Build Step

```lua
build = ':TSUpdate',
```

When the plugin is installed or updated, this command runs automatically to update all installed parsers to match the current Treesitter API version. Parsers are compiled binaries and must be compatible with the version of the Treesitter library in use.

---

## `lazy = false`

```lua
lazy = false,
```

Loads immediately on startup. Syntax highlighting needs to be available from the moment a file opens, so lazy loading isn't appropriate here.
