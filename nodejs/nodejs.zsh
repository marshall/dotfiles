# load the first found installation of nvm
for dir in "$HOMEBREW_PREFIX/opt/nvm" "$HOME/.nvm"; do
    [ -s "$dir/nvm.sh" ] && . "$dir/nvm.sh"  # This loads nvm
    [ -s "$dir/etc/bash_completion.d/nvm" ] && . "$dir/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    [ -s "$dir/nvm.sh" ] && break
done

autoload -U add-zsh-hook
load-nvmrc() {
    if ( which nvm >/dev/null ); then
        local node_version="$(nvm version)"
        local nvmrc_path="$(nvm_find_nvmrc)"

        if [ -n "$nvmrc_path" ]; then
            local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

            if [ "$nvmrc_node_version" = "N/A" ]; then
            nvm install
            elif [ "$nvmrc_node_version" != "$node_version" ]; then
            nvm use
            fi
        elif [ "$node_version" != "$(nvm version default)" ]; then
            echo "Reverting to nvm default version"
            nvm use default
        fi
    fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

if ( which brew >/dev/null ); then
  # NODE_PATH for npm / node installed via brew
  DEFAULT_NODE_PATH=$(nvm which current | sed "s/bin\/node/lib\/node_modules/")
  export NODE_PATH=$(/usr/bin/env npm root -g 2>/dev/null || echo "$DEFAULT_NODE_PATH")
fi
