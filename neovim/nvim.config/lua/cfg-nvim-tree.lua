-- local tree_cb = require('nvim-tree.config').nvim_tree_callback
local nvim_tree = require('nvim-tree')
local utils = require('utils')
local api = vim.api
local bufname = vim.fn.bufname
local cmd = vim.cmd
local exists = vim.fn.exists
local wincmd = vim.fn.wincmd
local winnr = vim.fn.winnr

vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}

-- this re-enables icons for certain "special" files
vim.g.nvim_tree_special_files = {}

vim.g.nvim_tree_icons = {
  default = "",
}

nvim_tree.setup {
  diagnostics = {
    enable = true,
    icons = {
      error = '',
      warning  = '',
      info  = '',
      hint  = '',
    }
  },
  ignore_buffer_on_setup = true,
  ignore_ft_on_setup = {
    'gitcommit'
  },
  open_on_setup = true,
  open_on_tab = true,
  update_focused_file = {
    enable = true,
    ignore_list = {
      'help',
    },
  },
  view = {
    width = 50
  }
}

vim.cmd('autocmd BufEnter * ++nested if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif')

utils.map('n', '<F2>', ':NvimTreeToggle<CR>', { silent = true })
utils.map('n', '<leader>r', ':NvimTreeFindFile<CR>', { silent = true })

local hi_groups = {
  FolderIcon = 'Number',
  RootFolder = 'Statement',
  ExecFile = 'Keyword',
}

for k, d in pairs(hi_groups) do
  api.nvim_command('hi clear NvimTree'..k)
  api.nvim_command('hi link NvimTree'..k..' '..d)
end
