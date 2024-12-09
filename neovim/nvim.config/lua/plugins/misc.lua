return {
  {
    { import = "lazyvim.plugins.extras.coding.copilot" },
  },
  {
    "shumphrey/fugitive-gitlab.vim",
  },
  {
    "ojroques/nvim-osc52",
    config = function(_, opts)
      require("osc52").setup(opts)

      local function copy(lines, _)
        require("osc52").copy(table.concat(lines, "\n"))
      end

      local function paste()
        return { vim.fn.splite(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
      end

      vim.g.clipboard = {
        name = "osc52",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
      }

      vim.keymap.set("n", "<leader>c", '"+y')
      vim.keymap.set("n", "<leader>cc", '"+yy')
      vim.keymap.set("v", "<leader>c", require("osc52").copy_visual)
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
      }
    }
  },
  {
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
  },
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "tmux/nvim left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "tmux/nvim down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "tmux/nvim up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "tmux/nvim right" },
      { "<C-/>", "<cmd>TmuxNavigatePrevious<cr>", desc = "tmux prev" },
    },
    config = function(_, _)
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
}
