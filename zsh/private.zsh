dotfiles_private_rel="$DOTFILES/../dotfiles-private"

if [[ -d "$dotfiles_private_rel" ]]; then
    export DOTFILES_PRIVATE=$(cd "$dotfiles_private_rel"; pwd)
    for config_file ($DOTFILES_PRIVATE/*/*.zsh) source $config_file
fi
