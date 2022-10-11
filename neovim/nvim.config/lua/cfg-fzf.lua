local utils = require('utils')
local map = utils.map
local cmd = vim.cmd

map('n', '<leader>f', ':Files<CR>', { silent = true })
map('n', '<leader>b', ':Buffers<CR>', { silent = true })
map({'n', 'x'}, '<leader>s', ':Rg<CR>', { silent = true })
map('v', '<leader>s', [[:lua require'cfg-fzf'.rg_under_cursor()<CR>]], { silent = true, noremap = true })

vim.g.fzf_buffers_jump = 1
vim.g.fzf_colors = {
  ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
  border = {'fg', 'LineNr' },
  fg = {'fg', 'Normal'},
  ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
  gutter =  {'bg', 'LineNr'},
  header = {'fg', 'Comment'},
  hl = {'fg', 'Search'},
  ['hl+'] = {'fg', 'Search'},
  info = {'fg', 'LineNr'},
  marker = {'fg', 'Keyword'},
  pointer = {'fg', 'Type'},
  prompt = {'fg', 'Function'},
}

local M = {}

local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos "'<")
  local _, cerow, cecol, _ = unpack(vim.fn.getpos "'>")

  local start_row, start_col, end_row, end_col

  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    start_row = csrow
    start_col = cscol
    end_row = cerow
    end_col = cecol
  else
    start_row = cerow
    start_col = cecol
    end_row = csrow
    end_col = cscol
  end

  return start_row, start_col, end_row, end_col
end

local function visual_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col = visual_selection_range()

  if start_row ~= end_row then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false)
    lines[1] = string.sub(lines[1], start_col)
    print(vim.inspect(lines), #lines, end_row, start_row)
    -- end_row might be just after the last line. In this case the last line is not truncated.
    if #lines - 1 == end_row - start_row then
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    return lines
  else
    local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    -- If line is nil then the line is empty
    return line and { string.sub(line, start_col, end_col) } or {}
  end
end

function M.rg_under_cursor()
  local query = table.concat(visual_selection(), '\n')
  M.fzf_rg(query, 0)
end

function M.fzf_rg(query, fullscreen)
  query = query or ''
  local command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  local initial_cmd = string.format(command_fmt, vim.fn.shellescape(query))
  local reload_cmd = string.format(command_fmt, '{q}')
  local binding = string.format('change:reload:%s', reload_cmd)

  local spec = {
    options = {
      '--phony',
      '--query',
      query,
      '--bind',
      binding
    }
  }
  print(spec)

  vim.fn['fzf#vim#grep'](initial_cmd, 1, vim.fn['fzf#vim#with_preview'](spec), fullscreen)
end

cmd [[command! -bang -nargs=* Rg lua require'cfg-fzf'.fzf_rg(<q-args>, <bang>0)]]

return M
