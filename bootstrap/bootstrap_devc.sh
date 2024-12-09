#!/bin/bash
# Bootstrap a clean devcontainer with a more minimal environment

set -e

APT_PACKAGES=(
    bat
    fzf
    ripgrep
)

sudo apt update
sudo apt install -y ${APT_PACKAGES[@]}

install_nvim() {
    if ! type nvim >/dev/null 2>&1; then
        wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -O nvim-linux64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        sudo mv /opt/nvim-linux64 /opt/nvim
        rm -f nvim-linux64.tar.gz
    fi
}

install_nodejs() {
    if ! type npm >/dev/null 2>&1; then
        curl -fsSL https://deb.nodesource.com/setup_21.x >setup_21.x
        sudo bash setup_21.x
        sudo apt-get install -y nodejs
        rm -f setup_21.x
    fi
}

install_nvim
install_nodejs

DOTFILES=$(
    cd "$(dirname $0)/.."
    pwd
)

install_link() {
    src=$1
    dst=$2

    if [[ -e "$dst" ]]; then
        echo "backing up original $dst to $dst.bak"
        if ! mv "$dst" "$dst.bak" 2>&1 >/dev/null; then
            echo "couldn't backup, probably on a volume mount"
            return 0
        fi
    fi

    ln -s "$src" "$dst"
}

for symlink in $DOTFILES/**/*.symlink; do
    ## leave out some special cases that are typically mounted as volumes
    if [[ "$symlink" = *gitconfig.symlink ]] || [[ "$symlink" = *zshrc.symlink ]]; then
        continue
    fi

    filename=$(basename "$symlink" | sed "s/.symlink//")
    install_link "$symlink" "$HOME/.$filename"
done

mkdir -p ~/.config || echo

for dotconfig in $DOTFILES/**/*.config; do
    filename=$(basename "$dotconfig" | sed "s/.config//")
    install_link "$dotconfig" "$HOME/.config/$filename"
done

if [[ -d "$DOTFILES-private" ]]; then
    for priv_symlink in $DOTFILES-private/**/*.symlink; do
        filename=$(basename "$priv_symlink" | sed "s/.symlink//")
        install_link "$priv_symlink" "$HOME/.$filename"
    done
fi
