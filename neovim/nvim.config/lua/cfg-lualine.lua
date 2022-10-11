local lualine = require('lualine')
local custom_solarized = require('lualine.themes.solarized_dark')
local colors = require('theme').colors
local devicons = require('nvim-web-devicons')

local group = {
  bg = colors.base02,
  fg = colors.base01,
  gui = 'bold',
}
custom_solarized.normal.b = group
custom_solarized.normal.x = group
custom_solarized.normal.c.bg = colors.base03
custom_solarized.normal.c.gui = 'bold'
custom_solarized.visual.a.bg = colors.yellow

local config = lualine.get_config()

local function coc_current_function()
  current = vim.b.coc_current_function
  if not current or current == vim.NIL then
    return ''
  end
  return current
end

require('lualine').setup {
  options = {
    theme = custom_solarized,
    symbols = {
      error = '',
      warn  = '',
      info  = '',
      hint  = '',
    },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        diagnostics_color = {
          warn = { fg = colors.yellow },
          error = { fg = colors.red },
          info = { fg = group.fg },
          hint = { fg = colors.blue },
        },
      },
      coc_current_function,
      require('dirname'),
    },
    lualine_c = {
      'filename',
      'g:coc_status'
    },
    lualine_x = { },
    lualine_y = { 'encoding', 'filetype', 'progress' },
    lualine_z = { 'location' },
  },
  extensions = {
    'fugitive',
    'nvim-tree',
    'fzf',
    {
      sections = {
        lualine_a = { function() return ' Outline' end }
      },
      filetypes = { 'coctree' },
    }
  }
}
