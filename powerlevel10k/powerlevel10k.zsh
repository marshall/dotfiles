export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

P10K_THEME=$DOTFILES/powerlevel10k/powerlevel10k/powerlevel10k.zsh-theme

if [[ -f "$P10K_THEME" ]]; then
    source "$P10K_THEME"
fi
