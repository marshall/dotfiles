alias reload!='. ~/.zshrc'
alias ack='nocorrect ack'
alias adb='nocorrect adb'
alias repo='nocorrect repo'
alias mux='nocorrect tmuxinator'

alias vi='vim'

if [ "$OS_NAME" = "Darwin" ]; then
    alias ls='ls -G'
    alias vim='mvim -v'
elif [ "$OS_NAME" = "Linux" ]; then
    alias ls='ls --color'

    alias xcopy='xclip -selection clipboard'
    alias xpaste='xclip -selection clipboard -o'
fi
