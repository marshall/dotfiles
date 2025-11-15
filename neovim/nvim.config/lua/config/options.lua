-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

local opts = {
  background = "dark",
  colorcolumn = "100",
  display = "msgsep",
  encoding = "UTF-8",
  fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  },
  foldenable = true,
  guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50",
  hidden = true,
  joinspaces = false,
  list = true,
  listchars = "tab:»·,trail:·",
  mouse = "nivh",
  number = true,
  previewheight = 5,
  rnu = false,
  scrolloff = 5,
  shada = [['20,<50,s10,h,/100]],
  showmatch = true,
  smartcase = true,
  splitright = true,
  splitbelow = true,
  synmaxcol = 500,
  termguicolors = true,
  textwidth = 0,
  title = false,
  undofile = true,
  whichwrap = "b,s,h,l",
  wrap = false,
}

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indentstringlen

for key, val in pairs(opts) do
  vim.opt[key] = val
end

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldexpr = "v:lua.require'lazyvim.util'.treesitter.foldexpr()"
  vim.opt.foldmethod = "expr"
  vim.opt.foldtext = ""
else
  vim.opt.foldmethod = "indent"
  vim.opt.foldtext = "v:lua.require'lazyvim.util'.treesitter.foldtext()"
end

require("codefmt").setup()
