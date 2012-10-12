#!/bin/bash

MAR_PATH=$1
if [[ ! -n "$MAR_PATH" ]]; then
  echo "Usage: $0 [update.mar]"
  exit 1
fi
shift

ADB=${ADB:-adb}
BUSYBOX=/data/local/bin/busybox
SERVER_ROOT=/data/local/b2g-updates

if [ -z "$B2G_DIR" ]; then
  echo "Error: B2G_DIR must be set in the environment"
  exit 1
fi

if [ -z "$($ADB shell ls /data/local/bin/busybox)" ]; then
  echo "Pushing busybox"
  $ADB shell mkdir -p /data/local/bin
  $ADB push $B2G_DIR/gaia/build/busybox-armv6l $BUSYBOX
  $ADB shell chmod 755 $BUSYBOX
fi

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

echo "Pushing update site"
$ADB push $STAGE_PATH $SERVER_ROOT

BUSYBOX_PID=$($ADB shell 'toolbox ps busybox | (read header; read user pid rest; echo -n $pid)')
if [ -z "$BUSYBOX_PID" ]; then
  echo "Starting busybox-httpd"
  $ADB shell $BUSYBOX httpd -h $SERVER_ROOT
fi

echo "Done."
