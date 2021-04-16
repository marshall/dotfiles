 # Add RVM to PATH for scripting
_path_prepend "$HOME/.rbenv/bin" "$HOME/.rvm/bin"
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

if [[ -x "`which rbenv`" ]]; then
    eval "$(rbenv init -)"
fi
