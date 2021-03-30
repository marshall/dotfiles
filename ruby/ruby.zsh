 # Add RVM to PATH for scripting
PATH=$HOME/.rbenv/bin:$HOME/.rvm/bin:$PATH
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

if [[ -x "`which rbenv`" ]]; then
    eval "$(rbenv init -)"
fi
