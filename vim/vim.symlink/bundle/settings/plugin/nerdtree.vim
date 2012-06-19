" NERDTree custom functions

" Auto-open NERDTree when vim opens, but not for git commits
function! NERDTreeOpenOnVimEnter()
    if (bufname(winnr("$")) == ".git/COMMIT_EDITMSG")
        return
    endif

    NERDTree
    wincmd p
    wincmd =
endfunction

autocmd VimEnter * call NERDTreeOpenOnVimEnter()

" Close when NERDTree is the only thing left around
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Always make sure buffers have equal width / height when NERDTree is opened
" and there are more than 2 editor buffers open
function! NERDTreeEqualWhenOpen ()
    if (exists("t:NERDTreeBufName"))
      let l:NERDTreeBufNum = bufwinnr(t:NERDTreeBufName)
      let l:BufCount = bufwinnr("$") - 1 " exclude NERDTree from buf count
      if (winnr() == l:NERDTreeBufNum && l:BufCount > 2)
        wincmd =
      endif
    endif
endfunction

autocmd bufenter * call NERDTreeEqualWhenOpen()
