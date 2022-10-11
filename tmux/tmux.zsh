[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

if [[ "$OS_NAME" = "Darwin" ]]; then
    alias tmux-osx-copy='tmux save-buffer - | pbcopy'
    alias tmux-osx-paste='tmux set-buffer "$(pbpaste)"'
fi

tmux_get_option() {
  tmux show-option -gqv "$1"
}

