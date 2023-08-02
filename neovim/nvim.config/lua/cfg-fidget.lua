require('fidget').setup {
  text = {
    spinner = 'dots_snake',
    commenced = 'began',
    completed = 'done',
  }
}

vim.api.nvim_command('hi link FidgetTitle String')

