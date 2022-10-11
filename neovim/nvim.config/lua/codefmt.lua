local utils = require('utils')
local buffer = { vim.o, vim.bo }
local cmd = vim.cmd

local formats = {
  four_space = { use_tabs = false, tab_width = 4 },
  two_space = { use_tabs = false, tab_width = 2 },
  tab = { use_tabs = true, tab_width = 4 },
}

local default_format = formats.two_space
local filetypes = {
  go = formats.tab,
  rust = formats.two_space,
}

local M = {}

function M.setup()
  M.set_code_format(default_format)
  for filetype, _ in pairs(filetypes) do
    cmd('au FileType '..filetype..' lua require("codefmt").set_from_filetype("'..filetype..'")')
  end
end

function M.set_code_format(fmt)
  utils.opt('expandtab', not fmt.use_tabs, buffer)
  utils.opt('tabstop', fmt.tab_width, buffer)
  utils.opt('softtabstop', fmt.tab_width, buffer)
  utils.opt('shiftwidth', fmt.tab_width, buffer)
end

function M.set_from_filetype(filetype)
  if not filetypes[filetype] then
    M.set_code_format(default_format)
    return
  end

  M.set_code_format(filetypes[filetype])
end

function M.four_space()
  M.set_code_format(formats.four_space)
end

function M.two_space()
  M.set_code_format(formats.two_space)
end

function M.tab()
  M.set_code_format(formats.tab)
end

return M
