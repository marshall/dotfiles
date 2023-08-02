local map = require('utils').map
local win32yank = '/usr/local/bin/win32yank.exe'

if vim.loop.fs_stat(win32yank) then
  vim.g.clipboard = {
    name = 'wsl',
    copy = {
      ['+'] = win32yank .. ' -i --crlf',
      ['*'] = win32yank .. ' -i --crlf',
    },
    paste = {
      ['+'] = win32yank .. ' -o --lf',
      ['*'] = win32yank .. ' -o --lf',
    },
  }

  map('v', '<leader>y', '"+y')
  map('n', '<leader>p', '"+p')
end

if vim.fn.has('macunix') then
  vim.opt.clipboard = 'unnamedplus'
end
