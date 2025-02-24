return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      --- fork of "helix" preset that is centered instead of right-aligned
      win = {
        width = { min = 30, max = 80 },
        height = { min = 4, max = 0.75 },
        padding = { 0, 1 },
        col = 0.5,
        row = -1,
        border = "rounded",
        title = true,
        title_pos = "center",
      },
      layout = {
        width = { min = 30 },
      },
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
  {
    "akinsho/bufferline.nvim",
  },
}
