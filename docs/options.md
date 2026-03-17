# Editor Options

**File:** `lua/config/options.lua`

These are Neovim editor settings — things like line numbers, mouse support, indentation behavior, and visual aids. They're set using `vim.o` (options) or `vim.opt` (a more Lua-friendly API that supports list/set operations).

---

## Line Numbers

```lua
vim.o.number = true
-- vim.o.relativenumber = true
```

- `number = true` — shows the absolute line number in the gutter on the left side of the screen.
- `relativenumber` is commented out. When enabled, every line except the current one shows its *distance* from the cursor (e.g. "3 lines up"). This is popular for quickly jumping with `5k` or `3j`. Uncomment it if you'd like both at once (hybrid mode: current line shows absolute number, all others show relative distance).

---

## Mouse

```lua
vim.o.mouse = 'a'
```

Enables mouse support in **all** modes (`a` = all). This lets you click to move the cursor, scroll, resize splits, etc. If you're a purist and want keyboard-only, set this to `''` to disable it.

---

## Mode Display

```lua
vim.o.showmode = false
```

By default Neovim shows `-- INSERT --` or `-- VISUAL --` at the bottom of the screen when you change modes. This is disabled here because the statusline (mini.statusline) already shows the current mode, so the built-in message would be redundant.

---

## Clipboard

```lua
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
```

Syncs Neovim's yank/paste with the **system clipboard**. Without this, text you copy in Neovim stays inside Neovim and can't be pasted into other apps.

`'unnamedplus'` means the `+` register (the system clipboard) is used by default for all yank, delete, and paste operations.

It's wrapped in `vim.schedule()` to defer it until after startup — this avoids a small performance cost when Neovim is used as a git editor or other non-interactive tool.

---

## Indentation

```lua
vim.o.breakindent = true
```

When a long line wraps to the next visual line, `breakindent` preserves the indentation level. Without it, wrapped lines would start at column 1, making deeply indented code hard to read.

---

## Undo History

```lua
vim.o.undofile = true
```

Saves undo history to a file on disk. This means you can close a file, reopen it later, and still undo changes from the previous session. Undo files are stored in Neovim's data directory (`~/.local/share/nvim/undo/`).

---

## Search

```lua
vim.o.ignorecase = true
vim.o.smartcase = true
```

- `ignorecase` — searches are case-insensitive by default. Searching `/foo` matches `foo`, `Foo`, `FOO`.
- `smartcase` — overrides `ignorecase` if your search pattern contains any uppercase letter. So `/foo` is case-insensitive, but `/Foo` only matches `Foo`. This is the most practical combination for everyday searching.

---

## Sign Column

```lua
vim.o.signcolumn = 'yes'
```

The sign column is the narrow strip to the left of line numbers where icons appear — LSP diagnostic indicators (errors, warnings), git diff markers, breakpoints, etc.

Setting it to `'yes'` keeps it always visible. Without this, it would pop in and out as signs appear/disappear, causing the text to shift left and right, which is jarring.

---

## Update Time

```lua
vim.o.updatetime = 250
```

How long Neovim waits after you stop typing before writing the swap file and firing the `CursorHold` event. The `CursorHold` event is used by LSP to trigger document highlights (when you hover over a symbol, related symbols get highlighted). 250ms feels responsive without being too aggressive.

Default is 4000ms (4 seconds), which makes LSP features feel sluggish.

---

## Keymap Timeout

```lua
vim.o.timeoutlen = 300
```

How long Neovim waits for the next key in a multi-key sequence before giving up and executing what it has so far. For example, if you press `<leader>` and pause, after 300ms Neovim stops waiting and which-key pops up.

Lower values make the editor feel snappier. The default is 1000ms.

---

## Split Behavior

```lua
vim.o.splitright = true
vim.o.splitbelow = true
```

Controls where new splits open:
- `splitright` — vertical splits (`:vsplit`) open to the **right** of the current window instead of the left.
- `splitbelow` — horizontal splits (`:split`) open **below** the current window instead of above.

This matches the intuition of most editors where new panels appear to the right or below.

---

## Whitespace Characters

```lua
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
```

- `list = true` — enables rendering of invisible characters.
- `listchars` defines what those characters look like:
  - `tab = '» '` — tabs are shown as a `»` followed by a space, making them easy to distinguish from spaces
  - `trail = '·'` — trailing spaces (spaces at the end of a line) are shown as dots
  - `nbsp = '␣'` — non-breaking spaces (common source of subtle bugs) are shown as `␣`

This is incredibly useful for spotting accidental whitespace, mixed indentation, or copy-paste artifacts.

---

## Incremental Command Preview

```lua
vim.o.inccommand = 'split'
```

Shows a live preview of substitution commands as you type them. For example, `:%s/foo/bar` will highlight and preview every replacement in real time before you press Enter.

`'split'` means the preview opens in a split window at the bottom, showing off-screen matches too (not just the ones visible in the current window).

---

## Cursor Line

```lua
vim.o.cursorline = true
```

Highlights the entire line your cursor is on with a subtle background color. Makes it much easier to track where you are, especially in large files.

---

## Scroll Offset

```lua
vim.o.scrolloff = 10
```

Keeps at least 10 lines visible above and below the cursor when scrolling. This prevents the cursor from sitting right at the top or bottom edge of the screen, giving you context of what's around the current line.

---

## Confirm on Exit

```lua
vim.o.confirm = true
```

Instead of throwing an error when you try to close an unsaved file (`:q`), Neovim will ask you to confirm whether you want to save, discard, or cancel. Saves you from accidentally losing work.
