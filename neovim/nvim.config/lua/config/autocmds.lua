-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- toggle to absolute line numbers when in insert mode or the editor has lost focus

local function augroup(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = false })
end

vim.api.nvim_create_user_command("RestoreSession", function()
  require("persistence").load()
end, {})
