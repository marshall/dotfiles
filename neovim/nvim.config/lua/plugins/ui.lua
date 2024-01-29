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
}
