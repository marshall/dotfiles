 # Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin:/var/lib/gems/1.8/bin
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

if [[ -x "`which rbenv`" ]]; then
    eval "$(rbenv init -)"
fi
