DOTFILES_PRIVATE=$(cd "$DOTFILES"/../dotfiles-private; pwd)

if [[ -d "$DOTFILES_PRIVATE" ]]; then
    export DOTFILES_PRIVATE
    for config_file ($DOTFILES_PRIVATE/*/*.zsh) source $config_file
fi
