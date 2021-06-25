dotfiles_private_rel="$DOTFILES/../dotfiles-private"

if [[ -d "$dotfiles_private_rel" ]]; then
    for config_file ($dotfiles_private_rel/*/*.zsh) source $config_file
fi
