-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- toggle to absolute line numbers when in insert mode or the editor has lost focus

local function augroup(name)
  return vim.api.nvim_create_augroup("dotfiles_" .. name, { clear = false })
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  group = augroup("linenum_toggle"),
  callback = function()
    if vim.opt.nu and vim.fn.mode() ~= "i" then
      vim.opt.rnu = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  group = augroup("linenum_toggle"),
  callback = function()
    if vim.opt.nu then
      vim.opt.rnu = false
    end
  end,
})

vim.api.nvim_create_user_command("RestoreSession", function()
  require("persistence").load()
end, {})
