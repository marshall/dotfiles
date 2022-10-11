local colors = require('theme').colors

vim.api.nvim_command('hi CursorLineNr gui=bold')
vim.api.nvim_command('hi VertSplit guifg='..colors.blue..' guibg='..colors.base03)
