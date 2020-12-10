BRAVE_RAMDISK_ENABLED=0
BRAVE_RAMDISK_SIZE_GB=256
BRAVE_RAMDISK_VOLUME_NAME=RamDisk
BRAVE_RAMDISK=/Volumes/$BRAVE_RAMDISK_VOLUME_NAME

export SCCACHE_CACHE_SIZE=100G
export SCCACHE_DIR=$HOME/sccache

if [[ "$OS_NAME" = "Darwin" ]]; then
    BRAVE_RAMDISK_ENABLED=$((`hostinfo | grep 'Primary memory available' | sed 's/[a-zA-Z ]*: //' | sed 's/ gigabytes//'` > 128))
    export BRAVE_NIGHTLY="/Applications/Brave Browser Nightly.app/Contents/MacOS/Brave Browser Nightly"
    if [[ $BRAVE_RAMDISK_ENABLED ]]; then
        export SCCACHE_DIR=$BRAVE_RAMDISK/sccache
    fi
fi

brave_dev() {
    npm start "$@"
}

brave_dev_clean() {
    tmpdir=$(mktemp -d "/tmp/brave.XXXXXXX")

    brave_dev -- --user-data-dir="$tmpdir" "$@"
    if [[ -d "$tmpdir" ]]; then
        rm -rf "$tmpdir"
    fi
}

brave_nightly() {
    "$BRAVE_NIGHTLY" "$@"
}

brave_nightly_clean() {
    tmpdir=$(mktemp -d "/tmp/brave.XXXXXXX")

    brave_nightly --user-data-dir="$tmpdir" "$@"
    if [[ -d "$tmpdir" ]]; then
        rm -rf "$tmpdir"
    fi
}

brave_nightly_dev_wallet() {
    if [[ ! -d dist/brave ]]; then
        echo "No unpacked extension found in $PWD/dist/brave, did you run yarn dev:brave?"
        return 1
    fi

    brave_nightly_clean --load-extension=dist/brave brave://wallet
}

brave_ramdisk_create() {
    if [[ "$OS_NAME" != "Darwin" ]]; then
        echo "Brave RAM disk only supported in macOS"
        return
    fi

    if [[ ! -d $BRAVE_RAMDISK ]]; then
        diskutil erasevolume HFS+ $BRAVE_RAMDISK_VOLUME_NAME \
            `hdiutil attach -nobrowse -nomount ram://$(($BRAVE_RAMDISK_SIZE_GB * 1024 * 2048))`
    fi
}

brave_ramdisk_init() {
    brave_ramdisk_create
    rsync -a --info=progress2 $HOME/Code/brave/brave-browser $BRAVE_RAMDISK
}
