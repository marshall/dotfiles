#!/bin/bash
# Bootstrap a clean Git-bash (MINGW64) environment with dependencies
set -e

DOTFILES_DIR=$(cd `dirname "$0"`/..; pwd)
PACMAN_PACKAGES=(zsh tmux vim git curl mingw-w64-x86_64-ag ruby)

run_cmd() {
    printf "\033[0;1;37m-> \033[0;1;34m"
    echo $@
    printf "\033[0m"
    $@
}

run_cmd pacman -S --noconfirm ${PACMAN_PACKAGES[@]}

echo "export DOTFILES=$DOTFILES_DIR" > ~/.dotfiles-dir

# echo "updating default shell to zsh"
#run_cmd sudo usermod --shell /usr/bin/zsh $USER
#install_ack
