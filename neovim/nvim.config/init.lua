local utils = require('utils')
local cmd = vim.cmd
local opt = utils.opt

require('plugins')
require('keybindings')

local buffer = { vim.o, vim.bo }
local window = { vim.o, vim.wo }

opt('textwidth', 100, buffer)
opt('lazyredraw', true)
opt('showmatch', true)
opt('ignorecase', true)
opt('smartcase', true)
opt('number', true, window)
opt('smartindent', true, buffer)
opt('laststatus', 2)
opt('showmode', false)
opt('shada', [['20,<50,s10,h,/100]])
opt('hidden', true)
opt('shortmess', vim.o.shortmess .. 'c')
opt('completeopt', 'menuone,noselect')
opt('joinspaces', false)
opt('guicursor', [[n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]])
opt('updatetime', 500)
opt('conceallevel', 2, window)
opt('concealcursor', 'nc', window)
opt('previewheight', 5)
opt('undofile', true, buffer)
opt('synmaxcol', 500, buffer)
opt('display', 'msgsep')
opt('cursorline', true, window)
opt('modeline', false, buffer)
opt('mouse', 'nivh')
opt('signcolumn', 'yes:1', window)

-- ?
opt('completeopt', 'menuone,noselect')

-- default code format
local codefmt = require('codefmt')
codefmt.two_space()

-- color scheme config
opt('termguicolors', true, utils.ALL_SCOPES)
opt('background', 'dark', utils.ALL_SCOPES)

-- highlight on yank
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

cmd [[colorscheme NeoSolarized]]
