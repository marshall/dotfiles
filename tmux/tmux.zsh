[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

alias tmux-osx-copy='tmux save-buffer - | pbcopy'
alias tmux-osx-paste='tmux set-buffer "$(pbpaste)"'
