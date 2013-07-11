" Code formatting helpers
function! SetCodeFormat (usetabs, tabwidth)
    if a:usetabs
        set noexpandtab
    else
        set expandtab
    endif
    execute "set tabstop=" . a:tabwidth
    execute "set softtabstop=" . a:tabwidth
    execute "set shiftwidth=" . a:tabwidth
endfunction

" Indent with 4 spaces
function! FourSpaceCodeFormat ()
    call SetCodeFormat(0, 4)
endfunction

" Indent with 2 spaces
function! TwoSpaceCodeFormat ()
    call SetCodeFormat(0, 2)
endfunction

function! TabCodeFormat ()
    call SetCodeFormat(1, 4)
endfunction

" Default code format
call FourSpaceCodeFormat()

" Other mappings
map <leader>4s :call FourSpaceCodeFormat()<cr>
map <leader>2s :call TwoSpaceCodeFormat()<cr>
map <leader>tab :call TabCodeFormat()<cr>
