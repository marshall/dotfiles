require('treesitter-context').setup()
local colors = require('theme').colors

vim.api.nvim_command('hi TreesitterContextBottom gui=underline guisp='..colors.blue)
