local transparent_group = vim.api.nvim_create_augroup('transparent-bg', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Clear background highlight groups for terminal transparency',
  group = transparent_group,
  callback = function()
    local groups = {
      'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder',
      'SignColumn', 'StatusLine', 'StatusLineNC',
      'TabLine', 'TabLineFill', 'TabLineSel',
      'EndOfBuffer', 'LineNr', 'CursorLineNr',
      'NeoTreeNormal', 'NeoTreeNormalNC', 'NeoTreeEndOfBuffer',
      'BufferLineFill', 'BufferLineBackground',
    }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
