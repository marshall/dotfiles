# Mounts the case-sensitive Boot2Gecko volume if it isn't already mounted
if [ ! -d "/Volumes/Boot2Gecko" ]; then
    hdiutil attach ~/Documents/Boot2Gecko.dmg.sparseimage -mountpoint /Volumes/Boot2Gecko;
fi

# Some useful mozilla-central environment shortcuts
export MOZILLA_CENTRAL=~/Code/mozilla-central
export MC_DOM=$MOZILLA_CENTRAL/dom
export TEST_MOBILE_NETWORKS=$MC_DOM/network/tests/marionette/test_mobile_networks.js
