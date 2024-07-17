#!/bin/bash

FONT_FAMILY="Meslo"
FONT_VARIANT="LGMDZNerdFont"
NERD_FONTS_VERSION=3.2.1

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

curl -fL "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_FONTS_VERSION/$FONT_FAMILY.zip" -o $FONT_FAMILY.zip
unzip $FONT_FAMILY.zip \
    "$FONT_FAMILY$FONT_VARIANT-Regular.ttf" \
    "$FONT_FAMILY$FONT_VARIANT-Bold.ttf" \
    "$FONT_FAMILY$FONT_VARIANT-Italic.ttf" \
    "$FONT_FAMILY$FONT_VARIANT-BoldItalic.ttf"

rm $FONT_FAMILY.zip

fc-cache -f -v
