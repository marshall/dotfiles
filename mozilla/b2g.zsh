B2G_IMAGE=$HOME/Documents/Boot2Gecko.dmg.sparseimage

if [[ ( "$OS_NAME" = "Darwin" ) && ( -f $B2G_IMAGE ) ]]; then
    # Mounts the case-sensitive Boot2Gecko volume if it isn't already mounted
    if [ ( ! -d "/Volumes/Boot2Gecko" ) ]; then
        hdiutil attach $B2G_IMAGE -mountpoint /Volumes/Boot2Gecko;
    fi
fi

# Some useful mozilla-central environment shortcuts
export MOZILLA_CENTRAL=$HOME/Code/mozilla-central
export B2G_DEV_DIR=$HOME/Code/B2G
export GAIA_DEV_DIR=$B2G_DEV_DIR/gaia

export MC_DOM=$MOZILLA_CENTRAL/dom
export MARIONETTE_CLIENT=$MOZILLA_CENTRAL/testing/marionette/client/marionette
export MARIONETTE_LOGCAT=$MARIONETTE_CLIENT/logcat

b2g_test_local_update() {
  MAR=$1
  B2G_DIR=$B2G_DEV_DIR b2g_test_aus_server.sh $MAR && \
  B2G_UPDATER_PREFS=$DOTFILES/mozilla/b2g_updater.prefs b2g_force_update_check.sh
}

b2g_push_busybox() {
  adb $@ remount
  adb $@ push $B2G_DEV_DIR/gaia/build/busybox-armv6l /system/bin/busybox

  adb $@ shell 'cd /system/bin; chmod 555 busybox; for x in `./busybox --list`; do ln -s ./busybox $x; done'
}

adb_busybox() {
  if [[ "$1" = "-d" || "$1" = "-e" ]]; then
    ADB_ARGS=$1
    shift
  elif [[ "$1" = "-s" && -n "$2" ]]; then
    ADB_ARGS="$1 $2"
    shift
    shift
  fi

  adb $ADB_ARGS shell /data/busybox/busybox-bin $@
}

b2g_restart() {
  adb $@ shell 'stop b2g; start b2g'
}

b2g_build_update_full() {
  ./build.sh GAIA_APP_SRCDIRS=apps gecko-update-full
}

b2g_push_update_full() {
  . load-config.sh
  b2g_push_update $GECKO_OBJDIR/dist/b2g-update/b2g-gecko-update.mar
}

b2g_push_update() {
  MAR_PATH=$1
  if [[ ! -n "$MAR_PATH" ]]; then
    echo "Usage: $0 [update.mar] (adb options)"
    return 1
  fi
  shift

  VERSION="99.0" # TODO make this changeable
  STAGE_PATH=/tmp/b2g-updates

  [[ -f "$STAGE_PATH" ]] && rm -rf $STAGE_PATH
  mkdir -p $STAGE_PATH

  cp $MAR_PATH $STAGE_PATH/b2g-gecko-update.mar
  SHA512=$(shasum -a 512 $MAR_PATH | sed 's/ .*//')
  BUILD_ID=$(date +%Y%m%d%H%M%S)
  eval $(stat -s $MAR_PATH)

  cat > $STAGE_PATH/update.xml <<UPDATE_TEMPLATE
<?xml version="1.0"?>
<updates>
  <update type="minor" appVersion="$VERSION" version="$VERSION" extensionVersion="$VERSION" buildID="$BUILD_ID" licenseURL="http://www.mozilla.com/test/sample-eula.html" detailsURL="http://www.mozilla.com/test/sample-details.html">
    <patch type="complete" URL="http://localhost/b2g-gecko-update.mar" hashFunction="SHA512" hashValue="$SHA512" size="$st_size"/>
  </update>
</updates>
UPDATE_TEMPLATE

  adb $@ push $STAGE_PATH /data/local/b2g-updates
}

b2g_start_update_httpd() {
  adb $@ shell /data/busybox/busybox-bin httpd -h /data/local/b2g-updates
}

b2g_build_filters() {
  awk -f $DOTFILES/mozilla/b2g_build_filters.awk
}

b2g_build() {
  ./build.sh $@ 2>&1 | b2g_build_filters | grcat conf.gcc
  return $pipestatus[1]
}

b2g_repo_sync_manifest() {
  if [[ ! -f ".repo/manifest.xml" ]]; then
    echo "You must be in a B2G directory to run this" 1>&2
    return 1
  fi

  . load-config.sh
  rm -rf .repo/manifest* &&
  ./repo init -u git://github.com/mozilla-b2g/b2g-manifest.git -b $DEVICE &&
  ./repo sync
}

gaia_unit_test() {
  make test-agent-test TEST_ARGS="$@"
}

gaia_marionette_test() {
  VERBOSE=1 TEST_FILES="$@" make test-integration
}

gaia_screenshots() {
  python $DOTFILES/mozilla/gaia_screenshots.py
}

moz_nserror() {
  # find an error name based on it's code, or vice-versa using xpcshell
  XULRUNNER_BIN=$B2G_DEV_DIR/gaia/xulrunner-sdk-33/xulrunner-sdk/bin
  if [[ "$OS_NAME" = "Darwin" ]]; then
    XPCSHELL=$XULRUNNER_BIN/XUL.framework/Versions/Current/xpcshell
  else
    XPCSHELL=$XULRUNNER_BIN/xpcshell
  fi

  if [[ -z $1 ]]; then
    echo "Error: required error code or name missing"
    return 1
  fi

  ERR=$1
  if [[ "$ERR" = NS_* ]]; then
    $XPCSHELL -e "print(\"$ERR = \" + Components.results.$ERR);"
  else
    $XPCSHELL -e "for (var err in Components.results) { var code = Components.results[err]; if (code === $ERR) { print(err + \" = \" + code); } }"
  fi
}

moz_compare_versions() {
  XPCSHELL=$B2G_DEV_DIR/gaia/xulrunner-sdk/bin/xpcshell
  $XPCSHELL $DOTFILES/mozilla/compare_versions.js $@
}
