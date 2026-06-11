# Jupyter Notebook Support

## What Was Added and Why

### Python packages (installed into Thesis venv)

Path: `~/Documents/1_Projects/Thesis/0_Thesis_Unified_3D_Reconstruction/.venv`

| Package | Why |
|---|---|
| `pynvim` | Neovim's Python remote plugin host — required for molten-nvim to function at all |
| `jupyter_client` | Lets molten-nvim connect to and communicate with Jupyter kernels |
| `jupytext` | CLI tool that converts `.ipynb` ↔ text formats; called by jupytext.nvim on file open/save |

### `lua/plugins/jupytext.lua` (new file)

Plugin: `GCBallesteros/jupytext.nvim`

Intercepts `.ipynb` files on open, transparently converts them to Python using the `percent` format (`# %%` cell markers), and converts back to `.ipynb` on save. The `percent` format was chosen over `markdown` because it gives you a plain Python file — meaning basedpyright (LSP), ruff (formatting), and treesitter all work as normal on the buffer.

### `lua/plugins/molten.lua` (new file)

Plugin: `benlubas/molten-nvim`

Connects Neovim to a live Jupyter kernel so you can run cells and see output inline. Requires `:UpdateRemotePlugins` to be run once after install (handled automatically by the lazy.nvim `build` key).

Keymaps (all under `<leader>m`):

| Key | Action |
|---|---|
| `<leader>mi` | Init/pick a kernel |
| `<leader>ml` | Evaluate current line/cell |
| `<leader>mv` | Evaluate visual selection |
| `<leader>mr` | Re-evaluate current cell |
| `<leader>md` | Delete cell output |
| `<leader>mo` / `<leader>mc` | Show/hide output window |
| `<leader>mk` | Interrupt kernel |
| `<leader>mR` | Restart kernel |

### `lua/config/options.lua` (modified)

Three lines were prepended:

```lua
local thesis_venv = vim.fn.expand('~/Documents/1_Projects/Thesis/0_Thesis_Unified_3D_Reconstruction/.venv')
vim.g.python3_host_prog = thesis_venv .. '/bin/python'
vim.env.PATH = thesis_venv .. '/bin:' .. vim.env.PATH
```

- `python3_host_prog` — tells Neovim which Python binary to use as its remote plugin host. Without this, Neovim would use the system Homebrew Python, which doesn't have `pynvim` and would fail to load molten-nvim.
- `PATH` prepend — makes the venv's binaries (including the `jupytext` CLI) available to any shell command Neovim runs. Without this, jupytext.nvim would fail to find the `jupytext` executable.

---

## How to Revert Everything

### 1. Remove the plugin files

```bash
rm ~/.config/nvim/lua/plugins/jupytext.lua
rm ~/.config/nvim/lua/plugins/molten.lua
```

### 2. Remove the three lines from `options.lua`

Delete these lines from `lua/config/options.lua`:

```lua
local thesis_venv = vim.fn.expand('~/Documents/1_Projects/Thesis/0_Thesis_Unified_3D_Reconstruction/.venv')
vim.g.python3_host_prog = thesis_venv .. '/bin/python'
vim.env.PATH = thesis_venv .. '/bin:' .. vim.env.PATH
```

### 3. Uninstall the plugins inside Neovim

```
:Lazy sync
```

This will detect that jupytext.nvim and molten-nvim are no longer in your config and remove them.

### 4. (Optional) Remove the Python packages from the Thesis venv

```bash
uv pip uninstall --python ~/Documents/1_Projects/Thesis/0_Thesis_Unified_3D_Reconstruction/.venv/bin/python \
  pynvim jupyter_client jupytext
```

The other packages that were pulled in as dependencies (`pyzmq`, `jupyter-core`, `nbformat`, etc.) can be removed too, but check first — some may already have been in the venv for other reasons.
