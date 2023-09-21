local utils = require("utils")
local enable_auto_open = true

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-web-devicons",
  opts = {
    diagnostics = {
      -- this re-enables icons for certain "special" files
      enable = true,
      icons = {
        error = "",
        warning = "",
        info = "",
        hint = "",
      },
    },
    on_attach = function(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local nvim_tree_api = require("nvim-tree.api")
      -- default mappings
      nvim_tree_api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "<C-c>", function()
        nvim_tree_api.tree.change_root_to_node()
      end, opts("change the root node"))
    end,
    renderer = {
      add_trailing = true,
      highlight_git = true,
      icons = {
        show = {
          git = true,
          folder = true,
          file = true,
          folder_arrow = true,
        },
        glyphs = {
          default = "",
          git = {
            unstaged = "", -- nf-fa-circle_o
            staged = "", -- nf-fa-dot_circle_o
            unmerged = "", -- nf-oct-git_pull_request
            renamed = "➜", -- nf-fa-arrow_circle_right
            untracked = "", -- nf-fa-eye
            deleted = "", -- nf-fa-trash_o
            ignored = "◌", -- nf-fa-info
          },
        },
      },
      indent_markers = {
        enable = true,
      },
      root_folder_label = function(path)
        local relative_base = vim.env.RELATIVE_BASE
        if relative_base then
          local relto = vim.fn.system({
            "realpath",
            "--relative-base",
            relative_base,
            path,
          })
          return string.gsub(relto, "\n", "")
        else
          -- use ~/Code as the default "relative base"
          return vim.fn.fnamemodify(path, ":~:s?\\~/Code/??")
        end
      end,
      special_files = {},
    },
    tab = {
      sync = { open = true },
    },
    update_focused_file = {
      enable = true,
      ignore_list = {
        "help",
      },
    },
    view = {
      width = 50,
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = function(data)
        local nvim_tree_api = require("nvim-tree.api")
        local IGNORED_FT = {
          "gitcommit",
        }

        if not enable_auto_open then
          return
        end

        -- buffer is a [No Name]
        local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

        if no_name then
          -- preserve startify for [No Name]
          nvim_tree_api.tree.toggle({ focus = false })
          return
        end

        -- buffer is a directory
        local directory = vim.fn.isdirectory(data.file) == 1

        -- buffer is a real file on the disk
        local real_file = vim.fn.filereadable(data.file) == 1

        -- &ft
        local filetype = vim.bo[data.buf].ft

        if directory then
          vim.cmd.cd(data.file)
          nvim_tree_api.tree.open()
        elseif real_file then
          if vim.tbl_contains(IGNORED_FT, filetype) then
            return
          end
          nvim_tree_api.tree.toggle({ focus = false, find_file = true })
        end
      end,
    })
    -- for use in certain situations from CLI i.e. nvim +NoTree <file>
    vim.api.nvim_create_user_command("NoTree", function()
      enable_auto_open = false
    end, {})

    vim.cmd('autocmd BufEnter * ++nested if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif')

    utils.map("n", "<F2>", ":NvimTreeToggle<CR>", { silent = true })
    utils.map("n", "<leader>r", ":NvimTreeFindFile<CR>", { silent = true })
  end,
}
