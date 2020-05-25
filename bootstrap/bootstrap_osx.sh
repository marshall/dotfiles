#!/bin/bash
# Bootstrap a clean environment with dependencies
set -e

BREW_PACKAGES=(zsh vim macvim git ack grc check the_silver_searcher node tmux)

install_brew() {
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_packages() {
    which brew 2>/dev/null || install_brew
    run_cmd brew install ${BREW_PACKAGES[@]}
    run_cmd brew install lastpass-cli --with-pinentry --with-doc
}

install_packages