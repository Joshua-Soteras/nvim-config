# tokyonight.nvim

**File:** `lua/plugins/colorscheme.lua`
**Plugin:** [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)

The colorscheme — controls all the colors in Neovim's UI. tokyonight is a clean, dark theme with vibrant but not overwhelming colors. It's widely supported by other plugins, meaning things like the statusline, bufferline, and Telescope all automatically pick up matching colors.

---

## Configuration

```lua
require('tokyonight').setup {
  styles = {
    comments = { italic = false },
  },
}
vim.cmd.colorscheme 'tokyonight-night'
```

### `styles.comments = { italic = false }`

By default, tokyonight renders comments in italic. This disables that. Italics in terminals can sometimes look off depending on the font, and some people find them distracting. All other syntax elements keep their default styling.

### `vim.cmd.colorscheme 'tokyonight-night'`

Activates the **night** variant of tokyonight. tokyonight comes in four variants:

| Variant | Feel |
|---------|------|
| `tokyonight-night` | Darkest — deep navy/black background |
| `tokyonight-storm` | Slightly lighter dark |
| `tokyonight-moon` | Softer, muted dark with warmer tones |
| `tokyonight-day` | Light theme |

To switch variants, change the string in `vim.cmd.colorscheme`.

---

## `priority = 1000`

```lua
priority = 1000,
```

lazy.nvim loads plugins in parallel by default. If another plugin loads before the colorscheme and tries to set highlight colors, you'd get a flash of the wrong colors at startup.

`priority = 1000` tells lazy.nvim to load this plugin **first**, before anything else. The default priority is 50. Setting it high ensures colors are set before any UI elements render.
