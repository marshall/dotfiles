return {
  { import = "lazyvim.plugins.extras.lang.clangd" },
  { import = "lazyvim.plugins.extras.lang.cmake" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.ruby" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  {
    "NoahTheDuke/vim-just",
  },
  {
    "lspcontainers/lspcontainers.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.clangd.cmd = require("lspcontainers").command("clangd", {
        image = "coruscant-dev:1.17.0",
        workdir = vim.fn.getenv("HOME") .. "/Code",
        cmd_builder = function(runtime, workdir, image, network, _)
          local volume = "--volume=" .. workdir .. ":" .. workdir .. ":z"
          return {
            runtime,
            "container",
            "run",
            "--interactive",
            "--rm",
            "--network=" .. network,
            "--workdir=" .. workdir,
            volume,
            image,
            "clangd",
            "--background-index",
          }
        end,
      })
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
}
