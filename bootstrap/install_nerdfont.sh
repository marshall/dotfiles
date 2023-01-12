#!/bin/bash

FONT_FAMILY="Meslo"
FONT_NAME="$FONT_FAMILY LG M DZ Regular Nerd Font Complete"
FONT_PATH="$FONT_FAMILY/M-DZ/Regular/complete/$FONT_NAME.ttf"

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/$FONT_FAMILY.zip" -o $FONT_FAMILY.zip
unzip $FONT_FAMILY.zip "$FONT_NAME.ttf"
rm $FONT_FAMILY.zip

fc-cache -f -v
