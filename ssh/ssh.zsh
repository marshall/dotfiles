# in minutes
export KEYCHAIN_TIMEOUT=120

ssh_identity_files() {
    config_file=$HOME/.ssh/config
    keys=()
    "$DOTFILES/ssh/identity_files.awk" "$config_file" | sort -u | while read key; do
        case "$key" in
            "~/"*) key="${HOME}/${key#"~/"}";;
        esac
        keys+=("$key")
    done
    echo "$keys[@]"
}

keychain_reload() {
    if ( which keychain >/dev/null ); then
        keys=($(ssh_identity_files))
        if [[ ! -f "$HOME/.keychain/$(uname -n)-sh" ]]; then
            echo "$fg[blue][keychain]$reset_color Spawning keychain ssh-agent"
        fi

        if ( keychain --list | grep "Error connecting" ) || ( keychain --list | grep "no identities" ); then
                echo -n "$fg[blue][keychain]$reset_color Adding $fg[green]$#keys$reset_color identity files"
                echo ", timeout $fg[green]$KEYCHAIN_TIMEOUT${reset_color} minutes."
        fi
        eval $(keychain --timeout $KEYCHAIN_TIMEOUT -q --eval "$keys[@]")
    fi
}

keychain_reload
