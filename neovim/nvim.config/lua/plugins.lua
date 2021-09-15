vim.cmd [[packadd packer.nvim]]

local fn = vim.fn

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use { 'junegunn/fzf', run = function() fn['fzf#install'](0) end}
  use { 'junegunn/fzf.vim', config = [[require('config/fzf')]] }
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'kyazdani42/nvim-tree.lua', config = [[require('config/nvim-tree')]] }
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'simrat39/rust-tools.nvim' }
  use { 'overcache/NeoSolarized' }
end)


