-- solarized palette colors and highlights
local M = {}

M.highlights = {
  TelescopeSelection = {
    link = "CursorLine",
  },
  TelescopeMatching = {
    link = "Search",
  },
  NvimTreeFolderIcon = {
    link = "Number",
  },
  NvimTreeRootFolder = {
    link = "Statement",
  },
  NvimTreeExecFile = {
    link = "Keyword",
  },
}

-- this runs before the color scheme is set
M.init = function()
  local resolarized = require("resolarized")
  local palette = resolarized.palette.solarized.dark
  local scheme = resolarized.scheme.solarized

  -- builtin colorscheme tweaks
  local hl = scheme.hlgroups
  hl.ColorColumn.bg = hl.CursorLineNr.bg
  for _, diff in ipairs({ "Add", "Change", "Delete", "Text" }) do
    hl["Diff" .. diff].bg = hl.LineNr.bg
  end
end

-- this runs after lazyvim plugins are initialized
M.setup = function()
  for key, hi in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, key, hi)
  end
end

return M
