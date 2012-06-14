# Mounts the case-sensitive Boot2Gecko volume if it isn't already mounted
if [ ! -d "/Volumes/Boot2Gecko" ]; then
    hdiutil attach ~/Documents/Boot2Gecko.dmg.sparseimage -mountpoint /Volumes/Boot2Gecko;
fi
