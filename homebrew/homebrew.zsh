if ( which brew >/dev/null ); then
    eval $(brew shellenv)
elif [[ "$OS_NAME" = "Linux" ]]; then
    LINUX_BREW=/home/linuxbrew/.linuxbrew
    LINUX_BREW_USER=$HOME/.linuxbrew

    test -d $LINUX_BREW && eval $($LINUX_BREW/bin/brew shellenv)
    test -d $LINUX_BREW_USER && eval $($LINUX_BREW_USER/bin/brew shellenv)
elif [[ "$OS_NAME" = "Darwin" ]]; then
    test -d /opt/homebrew && eval $(/opt/homebrew/bin/brew shellenv)
fi
