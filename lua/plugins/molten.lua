---@module 'lazy'
---@type LazySpec
return {
  'benlubas/molten-nvim',
  version = '^1.0.0',
  build = ':UpdateRemotePlugins',
  init = function()
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
  end,
  keys = {
    { '<leader>mi', ':MoltenInit<CR>', desc = '[M]olten [I]nit kernel' },
    { '<leader>ml', ':MoltenEvaluateLine<CR>', desc = '[M]olten evaluate [L]ine' },
    { '<leader>mr', ':MoltenReevaluateCell<CR>', desc = '[M]olten [R]e-evaluate cell' },
    { '<leader>md', ':MoltenDelete<CR>', desc = '[M]olten [D]elete cell' },
    { '<leader>mo', ':MoltenShowOutput<CR>', desc = '[M]olten show [O]utput' },
    { '<leader>mc', ':MoltenHideOutput<CR>', desc = '[M]olten [C]lose output' },
    { '<leader>mk', ':MoltenInterrupt<CR>', desc = '[M]olten [K]ill/interrupt kernel' },
    { '<leader>mR', ':MoltenRestart!<CR>', desc = '[M]olten [R]estart kernel' },
    { '<leader>mv', ':<C-u>MoltenEvaluateVisual<CR>', mode = 'v', desc = '[M]olten evaluate [V]isual' },
  },
}
