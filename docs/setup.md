# Setup & Prerequisites

This config is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and targets the latest **stable** Neovim release.

---

## 1. Install Neovim

You need Neovim **0.10 or later**. Check your version with:

```sh
nvim --version
```

### macOS

```sh
brew install neovim
```

### Ubuntu / Debian

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim
```

### Arch Linux

```sh
sudo pacman -S neovim
```

### Windows (WSL recommended)

```sh
wsl --install
# then inside WSL:
sudo apt install neovim
```

---

## 2. Install External Dependencies

These tools are required by plugins (Telescope for searching, Treesitter for parsing, etc.):

| Tool | What it's for |
|------|--------------|
| `git` | Plugin manager downloads plugins via git |
| `make` + `gcc` | Building native extensions (e.g. telescope-fzf-native) |
| `ripgrep` (`rg`) | Fast text search used by Telescope's live grep |
| `fd` | Fast file finder used by Telescope |
| `tree-sitter` CLI | Compiling Treesitter parsers |
| clipboard tool | Syncing Neovim's clipboard with the system clipboard |

### macOS

```sh
brew install ripgrep fd tree-sitter gcc make
```

### Ubuntu / Debian

```sh
sudo apt install make gcc ripgrep fd-find tree-sitter-cli unzip git xclip
```

### Arch

```sh
sudo pacman -S ripgrep fd tree-sitter gcc make git
```

---

## 3. Install a Nerd Font (Required)

This config has `vim.g.have_nerd_font = true` set, which means Nerd Font icons are expected to render correctly throughout the UI (bufferline tabs, statusline, file explorer, etc.).

A **Nerd Font** is a regular programming font patched with thousands of icons and glyphs. Without one, you'll see broken squares or question marks instead of icons.

**Recommended fonts:**
- [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
- [FiraCode Nerd Font](https://www.nerdfonts.com/font-downloads)
- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)

After downloading, install the font and **set it in your terminal emulator's settings**. Neovim itself doesn't control the font — your terminal does.

> If you ever switch to a terminal without a Nerd Font, set `vim.g.have_nerd_font = false` in `init.lua` to fall back to text-only icons.

---

## 4. Clone the Config

```sh
git clone <your-repo-url> ~/.config/nvim
```

---

## 5. First Launch

Open Neovim:

```sh
nvim
```

On first launch, **lazy.nvim** (the plugin manager) will automatically install itself and then install all plugins. This may take 30–60 seconds. You'll see a progress UI.

Once it's done, restart Neovim and everything will be ready.

---

## 6. Verify Everything Works

| Check | Command |
|-------|---------|
| Plugin status | `:Lazy` |
| LSP server status | `:Mason` |
| Treesitter parsers | `:TSInstallInfo` |
| Health check | `:checkhealth` |

`:checkhealth` is especially useful — it will warn you about missing dependencies like `ripgrep`, `fd`, or `node`.

---

## Adding New Languages

To add LSP support for a new language:

1. Open `:Mason` and find the language server (e.g. `typescript-language-server`)
2. Press `i` to install it
3. Or add it to the `servers` table in `lua/plugins/lsp.lua` so it installs automatically

To add a new Treesitter parser:

Add the language name to the `parsers` list in `lua/plugins/treesitter.lua`:

```lua
local parsers = { 'bash', 'c', 'lua', 'python', 'typescript', ... }
```
