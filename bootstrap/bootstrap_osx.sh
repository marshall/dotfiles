#!/bin/bash
# Bootstrap a clean environment with dependencies
set -e
PATH=/opt/homebrew/bin:$PATH

BREW_PACKAGES=(zsh vim macvim git ack grc check the_silver_searcher node tmux lastpass-cli \
               coreutils tmuxinator romkatv/powerlevel10k/powerlevel10k ripgrep fzf nvm bat)

install_brew() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_packages() {
    which brew 2>/dev/null || install_brew
    run_cmd brew install ${BREW_PACKAGES[@]}
}

install_packages

# fix compaudit permissions in newer installations
compaudit 2>/dev/null 1>/dev/null || ( compaudit | xargs chmod g-w )
