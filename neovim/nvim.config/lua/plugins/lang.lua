return {
  { import = "lazyvim.plugins.extras.lang.clangd" },
  -- { import = "lazyvim.plugins.extras.lang.cmake" },
  -- { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.python" },
  -- { import = "lazyvim.plugins.extras.lang.ruby" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
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
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.clangd.cmd = {
        "./coruscant/scripts/run-clangd.sh",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      }
      return opts
    end,
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
      },
    },
  },
}
