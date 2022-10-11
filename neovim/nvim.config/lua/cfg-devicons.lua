local devicons = require('nvim-web-devicons')
local icons = devicons.get_icons()
local colors = require('theme').colors

local icon_color = colors.cyan
local icon_cterm_color = '11'

local default_icon = {
  icon = '',
  color = icon_color,
  cterm_color = icon_cterm_color,
  -- this is renamed to workaround a nvimtree bug that removes the highlight group from a default icon
  name = 'NvimTreeDefault',
}

icons.Rakefile = icons.rakefile
icons.Gemfile = icons['Gemfile$']
icons['Gemfile.lock'] = icons['Gemfile$']
icons['go.mod'] = icons.go
icons['go.sum'] = icons.go
icons['Makefile'] = icons.makefile
icons['mk'] = icons.makefile
icons.default_icon = default_icon

for _, icon_data in pairs(icons) do
  -- solarized cyan
  icon_data.color = icon_color
  icon_data.cterm_color = icon_cterm_color
end

devicons.setup {
  override = icons,
  default = true
}
