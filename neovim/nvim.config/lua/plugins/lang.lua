return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters.shfmt = {
        -- 4 space indent
        prepend_args = { "-i", 4 },
      }
      return opts
    end,
  },
  {
    "NoahTheDuke/vim-just",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "cue",
      },
    },
  },
  {
    "jjo/vim-cue",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                telemetry = { enable = false },
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/love2d/library",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "cstrahan/vim-capnp",
  },
}
