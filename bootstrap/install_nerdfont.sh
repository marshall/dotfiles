#!/bin/bash

FONT_NAME="Meslo LG M DZ Regular Nerd Font Complete"
FONT_PATH="Meslo/M-DZ/Regular/complete/$FONT_NAME.ttf"

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

curl -fLo "$FONT_NAME.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/$FONT_URL"
