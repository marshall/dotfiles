autocmd FileType *.[ch]{,pp} call FoldPreprocessor()
autocmd FileType *.cc call FoldPreprocessor()
autocmd FileType *.cxx call FoldPreprocessor()

function! FoldPreprocessor()
    set foldmarker=#if,#endif
    set foldmethod=marker
endfunction
