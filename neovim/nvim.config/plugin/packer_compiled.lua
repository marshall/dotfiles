-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/marshall/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/marshall/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/marshall/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/marshall/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/marshall/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["copilot.vim"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["fidget.nvim"] = {
    config = { "require('cfg-fidget')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  fzf = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    config = { "require('cfg-fzf')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["lualine.nvim"] = {
    config = { "require('cfg-lualine')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["neovim-colors-solarized-truecolor-only"] = {
    config = { "require('cfg-solarized')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/neovim-colors-solarized-truecolor-only",
    url = "https://github.com/frankier/neovim-colors-solarized-truecolor-only"
  },
  ["nvim-cmp"] = {
    config = { "require('cfg-nvim-cmp')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "require('cfg-nvim-tree')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "require('cfg-treesitter')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { "require('cfg-treesitter-context')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    after = { "nvim-tree.lua" },
    config = { "require('cfg-devicons')" },
    loaded = true,
    only_config = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["pgsql.vim"] = {
    config = { "require('cfg-pgsql')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/pgsql.vim",
    url = "https://github.com/lifepillar/pgsql.vim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["plenary.vim"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/plenary.vim",
    url = "https://github.com/nvim-lua/plenary.vim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "require('cfg-rust-tools')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  tagbar = {
    config = { "require('cfg-tagbar')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/tagbar",
    url = "https://github.com/preservim/tagbar"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    config = { "require('cfg-telescope')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["vim-cue"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/vim-cue",
    url = "https://github.com/jjo/vim-cue"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gitgutter"] = {
    config = { "require('cfg-gitgutter')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/vim-gitgutter",
    url = "https://github.com/airblade/vim-gitgutter"
  },
  ["vim-startify"] = {
    config = { "require('cfg-startify')" },
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/vim-startify",
    url = "https://github.com/mhinz/vim-startify"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator",
    url = "https://github.com/christoomey/vim-tmux-navigator"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/marshall/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: vim-gitgutter
time([[Config for vim-gitgutter]], true)
require('cfg-gitgutter')
time([[Config for vim-gitgutter]], false)
-- Config for: tagbar
time([[Config for tagbar]], true)
require('cfg-tagbar')
time([[Config for tagbar]], false)
-- Config for: pgsql.vim
time([[Config for pgsql.vim]], true)
require('cfg-pgsql')
time([[Config for pgsql.vim]], false)
-- Config for: neovim-colors-solarized-truecolor-only
time([[Config for neovim-colors-solarized-truecolor-only]], true)
require('cfg-solarized')
time([[Config for neovim-colors-solarized-truecolor-only]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
require('cfg-treesitter-context')
time([[Config for nvim-treesitter-context]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
require('cfg-devicons')
time([[Config for nvim-web-devicons]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require('cfg-nvim-cmp')
time([[Config for nvim-cmp]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require('cfg-telescope')
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require('cfg-treesitter')
time([[Config for nvim-treesitter]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require('cfg-lualine')
time([[Config for lualine.nvim]], false)
-- Config for: vim-startify
time([[Config for vim-startify]], true)
require('cfg-startify')
time([[Config for vim-startify]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
require('cfg-fidget')
time([[Config for fidget.nvim]], false)
-- Config for: fzf.vim
time([[Config for fzf.vim]], true)
require('cfg-fzf')
time([[Config for fzf.vim]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
require('cfg-rust-tools')
time([[Config for rust-tools.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-tree.lua ]]

-- Config for: nvim-tree.lua
require('cfg-nvim-tree')

time([[Sequenced loading]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
