function! FugitiveToggle() abort
  try
    exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
  catch /E684/
    vertical Git
    vertical resize 80
  endtry
endfunction

nnoremap <leader>g :call FugitiveToggle()<CR>
nnoremap <F3> :call FugitiveToggle()<CR>
