local nvim_tree = require('nvim-tree')
local utils = require('utils')
local api = vim.api
local bufname = vim.fn.bufname
local cmd = vim.cmd
local exists = vim.fn.exists
local wincmd = vim.fn.wincmd
local winnr = vim.fn.winnr

local function open_nvim_tree(data)
  -- trying to replicate these legacy options:
  --
  -- ignore_buffer_on_setup = true,
  -- ignore_ft_on_setup = {
  --   'gitcommit'
  -- },
  -- open_on_setup = true,
  -- open_on_tab = true,

  local IGNORED_FT = {
    'gitcommit',
  }

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  if no_name then
    -- preserve startify for [No Name]
    require("nvim-tree.api").tree.toggle({ focus = false })
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
    require("nvim-tree.api").tree.open()
  elseif real_file then
    if vim.tbl_contains(IGNORED_FT, filetype) then
      return
    end
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
  end
end

nvim_tree.setup {
  diagnostics = {
    -- this re-enables icons for certain "special" files
    enable = true,
    icons = {
      error = '',
      warning  = '',
      info  = '',
      hint  = '',
    }
  },
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
          unstaged = "",  -- nf-fa-circle_o
          staged = "",  -- nf-fa-dot_circle_o
          unmerged = "",  -- nf-oct-git_pull_request
          renamed = "➜",  -- nf-fa-arrow_circle_right
          untracked = "",  -- nf-fa-eye
          deleted = "",  -- nf-fa-trash_o
          ignored = "◌"  -- nf-fa-info
        },
      }
    },
    special_files = {},

  },
  tab = {
    sync = { open = true },
  },
  update_focused_file = {
    enable = true,
    ignore_list = {
      'help',
    },
  },
  view = {
    width = 50
  }
}


api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.cmd('autocmd BufEnter * ++nested if winnr("$") == 1 && bufname() == "NvimTree_" . tabpagenr() | quit | endif')

utils.map('n', '<F2>', ':NvimTreeToggle<CR>', { silent = true })
utils.map('n', '<leader>r', ':NvimTreeFindFile<CR>', { silent = true })

local hi_groups = {
  FolderIcon = 'Number',
  RootFolder = 'Statement',
  ExecFile = 'Keyword',
}

for k, d in pairs(hi_groups) do
  api.nvim_command('hi clear NvimTree'..k)
  api.nvim_command('hi link NvimTree'..k..' '..d)
end
