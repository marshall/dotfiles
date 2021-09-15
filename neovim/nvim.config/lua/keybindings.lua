local map = require('utils').map

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', '<leader>4s',  [[:lua require('codefmt').four_space()<CR>]], { noremap = true, silent = true })
map('n', '<leader>2s',  [[:lua require('codefmt').two_space()<CR>]], { noremap = true, silent = true })
map('n', '<leader>tab', [[:lua require('codefmt').tab()<CR>]], { noremap = true, silent = true })
