function! s:MozBrowse(browser)
  let path = shellescape(expand("%:p"))
  let dir = shellescape(expand("%:p:h"))
  let lineno = shellescape(line("."))
  let result = system("cd " . dir . "; mxr -b " . shellescape(a:browser) . " -l " . lineno . " " . path)
endfunction

if !exists(":MozBrowse")
  command MozBrowse :call s:MozBrowse("mxr")
  command MozBrowseMXR :call s:MozBrowse("mxr")
  command MozBrowseDXR :call s:MozBrowse("dxr")
  command MozBrowseGithub :call s:MozBrowse("github")
endif
