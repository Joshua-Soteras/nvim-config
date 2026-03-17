# mini.nvim

**File:** `lua/plugins/mini.lua`
**Plugin:** [nvim-mini/mini.nvim](https://github.com/echasnovski/mini.nvim)

mini.nvim is a collection of small, focused Neovim plugins that each do one thing well. This config uses three of its modules: `mini.ai`, `mini.surround`, and `mini.statusline`.

---

## mini.ai — Extended Text Objects

```lua
require('mini.ai').setup { n_lines = 500 }
```

**Text objects** are selections in Neovim like `iw` (inside word), `ap` (around paragraph), `i"` (inside quotes). mini.ai extends the built-in set with more powerful, Treesitter-aware text objects.

`n_lines = 500` tells mini.ai to look up to 500 lines away when searching for the boundaries of a text object. This ensures it works correctly in large files.

### What it adds

You can use these with any operator (`d` delete, `c` change, `y` yank, `v` select, etc.):

| Object | What it selects |
|--------|----------------|
| `af` / `if` | Around/inside a **function** (body + signature vs just body) |
| `ac` / `ic` | Around/inside a **class** |
| `aa` / `ia` | Around/inside a **argument** in a function call |
| `a(` / `i(` | Around/inside **parentheses** (enhanced from built-in) |
| `a"` / `i"` | Around/inside **double quotes** |
| `a'` / `i'` | Around/inside **single quotes** |
| `a`` / `i`` | Around/inside **backticks** |

**Examples:**
- `daf` — delete the entire function the cursor is in
- `cic` — change the contents of the class body
- `yia` — yank the argument the cursor is on

---

## mini.surround — Surround Operations

```lua
require('mini.surround').setup()
```

Adds keymaps for adding, deleting, and changing surrounding characters like brackets, quotes, and tags.

### Default Keymaps

| Keys | Action | Example |
|------|--------|---------|
| `sa` + motion + char | **Add** surrounding | `sa iw "` → surround word with `"` |
| `sd` + char | **Delete** surrounding | cursor inside `"foo"`, `sd"` → `foo` |
| `sr` + old + new | **Replace** surrounding | cursor inside `"foo"`, `sr"'` → `'foo'` |
| `sf` + char | **Find** surrounding | move cursor to the next surrounding char |
| `sh` + char | **Highlight** surrounding | flash-highlight the surrounding pair |

**Examples:**
- You have `foo` and want `"foo"`: put cursor on `foo`, type `saiw"` (surround around inner word with `"`)
- You have `"foo"` and want `'foo'`: cursor inside quotes, type `sr"'`
- You have `"foo"` and want `foo`: cursor inside quotes, type `sd"`

---

## mini.statusline — Status Bar

```lua
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

statusline.section_location = function()
  return '%2l:%-2v'
end
```

Replaces Neovim's plain default statusline (the bar at the bottom of each window) with a clean, informative one.

**What it shows (left to right):**
- Current mode (NORMAL, INSERT, VISUAL, etc.)
- Git branch name
- Diagnostics count (errors/warnings)
- Filename and modified flag
- File info (type, encoding)
- Cursor position

### Custom Location Format

```lua
statusline.section_location = function()
  return '%2l:%-2v'
end
```

Overrides the cursor position display format:
- `%2l` — line number, minimum 2 characters wide (so it doesn't shift when going from line 9 to 10)
- `%-2v` — virtual column number, left-aligned, minimum 2 characters wide

This makes the position indicator compact and stable: `12:5` instead of a longer format.

`use_icons = vim.g.have_nerd_font` enables Nerd Font icons in the statusline when available.
