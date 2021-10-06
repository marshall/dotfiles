_lotus_network() {
    if [[ ! -x "$1" ]]; then
        echo "Usage: lotus_network /path/to/lotus"
        return 1
    fi

    "$1" --version | perl -n -e'/\+(.*net)\+/ && print $1'
}

# for use in terminal window titles
_lotus_network_suffix() {
    DEV_LOTUS=$HOME/Code/filecoin/lotus/lotus
    if [[ ! -x $DEV_LOTUS ]]; then
        return 0
    fi

    echo "-$(_lotus_network $DEV_LOTUS)"
}
