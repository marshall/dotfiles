return {
  {
    "https://gitlab.com/HiPhish/resolarized.nvim",
    name = "resolarized",
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-dark",
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("ColorSchemePre", {
        pattern = "solarized-dark",
        callback = require("theme").init,
      })

      require("lazyvim").setup(opts)
      require("theme").setup()
    end,
  },
}
