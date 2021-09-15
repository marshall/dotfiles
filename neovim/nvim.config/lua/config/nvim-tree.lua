local tree_cb = require('nvim-tree.config').nvim_tree_callback
local utils = require('utils')

vim.g.nvim_tree_width = 50
utils.map('n', '<F2>', ':NvimTreeToggle<CR>')
utils.map('n', '<leader>r', ':NvimTreeFindFile<CR>')
