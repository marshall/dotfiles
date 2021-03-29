function! FindRustfmt()
    let cmd = 'rustup which --toolchain nightly rustfmt'
    let output = system(cmd)
    if v:shell_error
        let cmd = 'rustup which rustfmt'
        let output = system(cmd)
        if v:shell_error
            let cmd = 'which rustfmt'
            let output = system(cmd)
            if v:shell_error
                return 'oops'
            endif
        endif
    endif

    let rustfmt = split(output, '\n')[0]
    return rustfmt
endfunction

let g:rustfmt_command = FindRustfmt()
