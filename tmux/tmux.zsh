[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

alias tmux-copy='tmux save-buffer - | reattach-to-user-namespace pbcopy'
alias tmux-paste='tmux set-buffer "$(reattach-to-user-namespace pbpaste)"'
