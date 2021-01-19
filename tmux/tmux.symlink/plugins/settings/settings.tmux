#!/bin/bash

this_dir=$(cd "`dirname "$0"`"; pwd)
source "$this_dir/common.sh"

# Add custom widgets to dracula

# hostname_bg=$([ "$P9K_SSH" = "1" ] && echo $orange || echo $light_purple)
BG=$yellow FG=$dark_gray \
    right_section "$this_dir/host.sh"
