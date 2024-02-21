return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin",
    opts = function(_, o)
      o.integrations.nvimtree = true
      o.no_italic = true
      return o
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = "<F3>",
    },
  },
}
