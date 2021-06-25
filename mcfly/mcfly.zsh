export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=true

if ( which mcfly >/dev/null ); then
    eval "$(mcfly init zsh)"
fi
