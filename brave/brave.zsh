BRAVE_RAMDISK_ENABLED=0
BRAVE_RAMDISK_SIZE_GB=256
BRAVE_RAMDISK_VOLUME_NAME=RamDisk
BRAVE_RAMDISK=/Volumes/$BRAVE_RAMDISK_VOLUME_NAME

export SCCACHE_CACHE_SIZE=100G
export SCCACHE_DIR=$HOME/sccache

if [[ "$OS_NAME" = "Darwin" ]]; then
    BRAVE_RAMDISK_ENABLED=$((`hostinfo | grep 'Primary memory available' | sed 's/[a-zA-Z ]*: //' | sed 's/ gigabytes//'` > 128))
    export BRAVE_NIGHTLY="/Applications/Brave Browser Nightly.app/Contents/MacOS/Brave Browser Nightly"
    if [[ "$BRAVE_RAMDISK_ENABLED" = "1" ]]; then
        export SCCACHE_DIR=$BRAVE_RAMDISK/sccache
    fi
fi

brave_profile() {
    brave_bin=$1
    shift

    if [ ! -x "$brave_bin" ]; then
        echo "Invalid Brave binary: $brave_bin"
        return 1
    fi

    profile=$1
    shift

    if [ -z "$profile" ]; then
        echo "Missing profile dir"
        return 1
    fi

    "$brave_bin" --user-data-dir="$profile" "$@"
}

brave_tmp_profile() {
    brave_bin=$1
    shift

    if [ ! -x "$brave_bin" ]; then
        echo "Invalid Brave binary: $brave_bin"
        return 1
    fi

    tmpdir=$(mktemp -d "/tmp/brave.XXXXXXX")
    brave_profile "$brave_bin" "$tmpdir" "$@"

    if [[ -d "$tmpdir" ]]; then
        rm -rf "$tmpdir"
    fi
}

brave_dev() {
    npm start "$@"
}

brave_dev_clean() {
    brave_tmp_profile brave_dev
}

brave_dev_dev_wallet() {
    brave_bin="$PWD/src/out/Component/Brave Browser Development.app/Contents/MacOS/Brave Browser Development"
    if [[ ! -x "$brave_bin" ]]; then
        echo "No build of brave found at $brave_bin"
        return 1
    fi

    wallet=${1:-$HOME/Code/brave/ethereum-remote-client}
    profile=${2:-$HOME/Test/profiles/dev-wallet}
    if [[ ! -d "$wallet/dist/brave" ]]; then
        echo "No unpacked extension found in $wallet/dist/brave, did you run yarn dev:brave?"
        return 1
    fi

    brave_profile "$brave_bin" "$profile" --load-extension="$wallet/dist/brave" -- chrome://extensions chrome://wallet
}

brave_nightly() {
    "$BRAVE_NIGHTLY" "$@"
}

brave_nightly_clean() {
    brave_tmp_profile "$BRAVE_NIGHTLY"
}

brave_nightly_dev_wallet() {
    profile=${1:-$HOME/Test/profiles/dev-wallet}
    if [[ ! -d dist/brave ]]; then
        echo "No unpacked extension found in $PWD/dist/brave, did you run yarn dev:brave?"
        return 1
    fi

    brave_profile "$BRAVE_NIGHTLY" "$profile" --load-extension=dist/brave -- chrome://extensions chrome://wallet
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
