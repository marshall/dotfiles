return {
  {
    'telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
  },
  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'tmux/nvim left' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'tmux/nvim down' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'tmux/nvim up' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'tmux/nvim right' },
      { '<C-/>', '<cmd>TmuxNavigatePrevious<cr>', desc = 'tmux prev' },
    },
    config = function(_, opts)
      vim.g.tmux_navigator_no_mappings = 1
    end
  },
  { 'tpope/vim-fugitive' },
}
