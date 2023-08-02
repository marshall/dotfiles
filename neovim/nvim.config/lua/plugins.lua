vim.cmd [[packadd packer.nvim]]

local fn = vim.fn

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use { 'airblade/vim-gitgutter', config = [[require('cfg-gitgutter')]] }
  use { 'christoomey/vim-tmux-navigator' }
  use { 'frankier/neovim-colors-solarized-truecolor-only', config = [[require('cfg-solarized')]] }
  use { 'github/copilot.vim' }
  use { 'hrsh7th/nvim-cmp', config=[[require('cfg-nvim-cmp')]] }
  use {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    after = 'hrsh7th/nvim-cmp',
    requires = 'hrsh7th/nvim-cmp'
  }
  use { 'hrsh7th/vim-vsnip' }
  use { 'jjo/vim-cue' }
  use { 'junegunn/fzf', run = function() fn['fzf#install'](0) end}
  use { 'junegunn/fzf.vim', config = [[require('cfg-fzf')]] }
  use { 'j-hui/fidget.nvim', tag = 'legacy', config = [[require('cfg-fidget')]] }
  use { 'kyazdani42/nvim-web-devicons', config=[[require('cfg-devicons')]] }
  use { 'kyazdani42/nvim-tree.lua', config = [[require('cfg-nvim-tree')]], after = 'nvim-web-devicons' }
  use { 'lifepillar/pgsql.vim', config = [[require('cfg-pgsql')]] }
  use { 'mhinz/vim-startify', config=[[require('cfg-startify')]] }
  --use { 'neoclide/coc.nvim', branch = 'release', config=[[require('cfg-coc')]], after='nvim-tree.lua' }
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-lua/popup.nvim' }
  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-lualine/lualine.nvim', config = [[require('cfg-lualine')]] }
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.2', requires = 'nvim-lua/plenary.vim', config = [[require('cfg-telescope')]] }
  use { 'nvim-telescope/telescope-project.nvim' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[require('cfg-treesitter')]] }
  use { 'nvim-treesitter/nvim-treesitter-context', config = [[require('cfg-treesitter-context')]] }
  use { 'preservim/tagbar', config = [[require('cfg-tagbar')]] }
  use { 'simrat39/rust-tools.nvim', config = [[require('cfg-rust-tools')]]}
  use { 'tpope/vim-fugitive' }
end)


