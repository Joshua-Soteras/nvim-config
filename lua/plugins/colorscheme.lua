---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        transparent_background = false,
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  { 'rebelot/kanagawa.nvim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'EdenEast/nightfox.nvim' },
  { 'sainnhe/everforest' },
  { 'sainnhe/gruvbox-material' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly' },
  { 'projekt0n/github-nvim-theme' },
  { 'sainnhe/edge' },
  { 'rmehri01/onenord.nvim' },
  { 'mcchrish/zenbones.nvim' },
  { 'craftzdog/solarized-osaka.nvim' },
  { 'scottmckendry/cyberdream.nvim' },
  { 'valonmulolli/heap.nvim' },
}
