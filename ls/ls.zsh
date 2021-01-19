dircolors_path=$(whence dircolors || whence gdircolors)

export CLICOLOR=1
eval `$dircolors_path "$DOTFILES/ls/dircolors"`
