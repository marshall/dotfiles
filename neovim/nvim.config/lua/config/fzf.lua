local utils = require('utils')
local map = utils.map
local cmd = vim.cmd

map('n', '<leader>f', ':Files<CR>')
map('n', '<leader>b', ':Buffers<CR>')
map({'n', 'x'}, '<leader>s', ':Rg<CR>')

vim.g.fzf_buffers_jump = 1
vim.g.fzf_colors = {
  gutter =  {'bg', 'LineNr'},
  ['bg+'] = {'bg', 'IncSearch'},
  ['fg+'] = {'fg', 'IncSearch'}
}

cmd [[command! -bang -nargs=* Rg lua require('fzf-rg').fzf_rg(<q-args>, <bang>0)]]
