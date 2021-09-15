local M = {}

function M.fzf_rg(query, fullscreen)
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

	vim.fn['fzf#vim#grep'](initial_command, 1, vim.fn['fzf#vim#with_preview'](spec), fullscreen)
end

return M
