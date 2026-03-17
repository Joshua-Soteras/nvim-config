# gitsigns.nvim

**File:** `lua/plugins/gitsigns.lua`
**Plugin:** [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)

gitsigns adds **git status indicators** to the sign column (the narrow strip to the left of line numbers). At a glance you can see which lines have been added, modified, or deleted since the last git commit.

---

## What It Shows

The sign column shows a character next to each changed line:

```lua
signs = {
  add          = { text = '+' },
  change       = { text = '~' },
  delete       = { text = '_' },
  topdelete    = { text = '‾' },
  changedelete = { text = '~' },
},
```

| Sign | Meaning |
|------|---------|
| `+` | This line was **added** (doesn't exist in the last commit) |
| `~` | This line was **changed** (different from the last commit) |
| `_` | Lines were **deleted** below this line |
| `‾` | Lines were **deleted** above this line (the top of a deleted block) |
| `~` | This line was **changed and then part of it deleted** |

These signs update in real time as you edit the file, giving you a live diff view without leaving Neovim.

---

## More Features

While this config uses gitsigns in its minimal form (just signs), the plugin also supports:

- **Hunk navigation** — jump between changed sections (`]h` / `[h` if configured)
- **Stage/unstage hunks** — stage individual changed sections without leaving Neovim
- **Preview hunks** — see a diff popup of a change before staging
- **Blame** — show who last changed each line inline
- **Git object text objects** — select/operate on whole diff hunks

These aren't configured here, but are available if you want to expand the setup later.

---

## Sign Column

The sign column (`vim.o.signcolumn = 'yes'` in `options.lua`) is always visible, so git signs appear and disappear without causing the text to shift left or right.
