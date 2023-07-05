local colors = require('theme').colors
local nvim_command = vim.api.nvim_command

nvim_command('hi CursorLineNr gui=bold')
nvim_command('hi VertSplit guifg='..colors.blue..' guibg='..colors.base03)

-- popup menus + floating windows
nvim_command('hi clear Pmenu')
nvim_command('hi Pmenu ctermfg=11 guifg='..colors.base01..' guibg='..colors.base02)
