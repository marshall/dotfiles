function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]

    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
       let [line_start, column_start, line_end, column_end] = [line_end, column_end, line_start, column_start]
    endif

    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif

    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! RgUnderCursor() range
    let query = GetVisualSelection()
    call RgFzf(query, 0)
endfunction

function! RgFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'

    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

let $BAT_STYLE='plain'

command! -bang -nargs=* Rg call RgFzf(<q-args>, <bang>0)

nnoremap <leader>s :Rg<cr>
xnoremap <leader>s :Rg<cr>
vnoremap <leader>s :call RgUnderCursor()<cr>
