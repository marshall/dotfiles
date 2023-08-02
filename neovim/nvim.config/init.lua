local utils = require('utils')
local cmd = vim.cmd
local bo = vim.bo

require('plugins')
require('keybindings')

local opts = {
  autoindent = true,
  background = 'dark',
  colorcolumn = '100',
  completeopt = 'menuone,noinsert,noselect',
  cursorline = true,
  display = 'msgsep',
  encoding = 'UTF-8',
  foldenable = true,
  guicursor = 'n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50',
  hidden = true,
  joinspaces = false,
  laststatus = 2,
  lazyredraw = true,
  list = true,
  listchars = 'tab:»·,trail:·',
  modeline = false,
  mouse = 'nivh',
  number = true,
  previewheight = 5,
  scrolloff = 5,
  shada = [['20,<50,s10,h,/100]],
  shortmess = vim.o.shortmess .. 'c',
  showmatch = true,
  showmode = true,
  signcolumn = 'auto:1',
  smartcase = true,
  splitright = true,
  splitbelow = true,
  synmaxcol = 500,
  termguicolors = true,
  textwidth = 0,
  title = false,
  undofile = true,
  updatetime = 100,
  whichwrap = 'b,s,h,l',
  wrap = false,
}

for key, val in pairs(opts) do
  vim.opt[key] = val
end

bo.undofile = true

-- setup code formats
require('codefmt').setup()
require('clipboard')

-- highlight on yank
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

-- don't show tab characters in Go or Cue files
cmd 'au FileType go set nolist'
cmd 'au Filetype cue set nolist'

-- Textmate/sublime theme
cmd 'au BufNewFile,BufRead *.tmTheme set filetype=xml'

cmd [[colorscheme solarized]]
