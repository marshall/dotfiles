vim.cmd [[packadd packer.nvim]]

local fn = vim.fn

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use { 'airblade/vim-gitgutter', config = [[require('cfg-gitgutter')]] }
  use { 'christoomey/vim-tmux-navigator' }
  use { 'frankier/neovim-colors-solarized-truecolor-only', config = [[require('cfg-solarized')]] }
  use { 'junegunn/fzf', run = function() fn['fzf#install'](0) end}
  use { 'junegunn/fzf.vim', config = [[require('cfg-fzf')]] }
  use { 'kyazdani42/nvim-web-devicons', config=[[require('cfg-devicons')]] }
  use { 'kyazdani42/nvim-tree.lua', config = [[require('cfg-nvim-tree')]], after = 'nvim-web-devicons' }
  use { 'mhinz/vim-startify', config=[[require('cfg-startify')]] }
  use { 'neoclide/coc.nvim', branch = 'release', config=[[require('cfg-coc')]], after='nvim-tree.lua' }
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lualine/lualine.nvim', config = [[require('cfg-lualine')]] }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[require('cfg-treesitter')]] }
  use { 'preservim/tagbar', config = [[require('cfg-tagbar')]] }
  use { 'simrat39/rust-tools.nvim' }
  use { 'tpope/vim-fugitive' }
end)


