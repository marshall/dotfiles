dircolors_path=$(whence dircolors || whence gdircolors)

export CLICOLOR=1
export SHELL=${SHELL:-/usr/bin/zsh}
eval `$dircolors_path "$DOTFILES/ls/dircolors"`
