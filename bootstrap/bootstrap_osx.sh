#!/bin/bash
# Bootstrap a clean environment with dependencies
set -e

BREW_PACKAGES=(zsh vim git-core ack grc)

install_brew() {
    ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
}

install_packages() {
    which brew 2>/dev/null || install_brew
    run_cmd brew install ${BREW_PACKAGES[@]}
}

install_packages
