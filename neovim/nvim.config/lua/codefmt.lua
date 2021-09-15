local utils = require('utils')
local opt = utils.opt
local map = utils.map
local buffer = { vim.o, vim.bo }

local M = {}

function M.set_code_format(use_tabs, tab_width)
  opt('expandtab', use_tabs, buffer)
  opt('tabstop', tab_width, buffer)
  opt('softtabstop', tab_width, buffer)
  opt('shiftwidth', tab_width, buffer)
end

function M.four_space()
  M.set_code_format(false, 4)
end

function M.two_space()
  M.set_code_format(false, 2)
end

function M.tab()
  M.set_code_format(true, 4)
end

return M
