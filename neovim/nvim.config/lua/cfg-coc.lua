-- local isdirectory = vim.fn.isdirectory
-- local filereadable = vim.fn.filereadable
-- 
-- local extensions = {'coc-tsdetect'}
-- 
-- if isdirectory('./node_modules') then
--   if isdirectory('./node_modules/prettier') then
--     extensions = table.insert(extensions, 'coc-prettier')
--   end
-- 
--   if isdirectory('./node_modules/eslint') then
--     extensions = table.insert(extensions, 'coc-eslint')
--   end
-- end
-- 
-- if filereadable('./Cargo.toml') then
--   extensions = table.insert(extensions, 'coc-rust-analyzer')
-- end
-- 
-- vim.g.coc_global_extensions = extensions

vim.api.nvim_exec('source '..vim.fn.stdpath('config')..'/coc.vim', false)

local nvim_tree = require('nvim-tree')
local utils = require('utils')
local colors = require('theme').colors
local outline_height = 20

local M = {}

function M.toggle_outline()
  for w=1,vim.fn.winnr('$') do
    win_id = vim.fn.win_getid(w)
    s, view_id = pcall(function()
      return vim.api.nvim_win_get_var(win_id, 'cocViewId')
    end)
    if s and view_id == 'OUTLINE' then
      vim.api.nvim_win_close(win_id, true)
      return
    end
  end
  vim.api.nvim_exec('CocOutline', false)
end

utils.map('n', '<F4>', [[:lua require'cfg-coc'.toggle_outline()<CR>]], { silent = true })

vim.api.nvim_command('hi CocHintSign guifg='..colors.base01)

-- Highlight the symbol and its references when holding the cursor.
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

return M
