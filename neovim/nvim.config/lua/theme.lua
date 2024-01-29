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

-- this runs after lazyvim plugins are initialized
M.setup = function()
  for key, hi in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, key, hi)
  end
end

return M
