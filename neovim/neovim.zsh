# lazy init packer.nvim repo
if [[ ! -d " $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim \
         ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
