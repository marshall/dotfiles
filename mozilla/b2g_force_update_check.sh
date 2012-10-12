#!/bin/bash

ADB=${ADB:-adb}
DEVICE_TIME=$(date -j -f "%a %b %d %T %Z %Y" "`$ADB shell date`" "+%s" 2>/dev/null)
PROFILE_PREFS=$($ADB shell cat '/data/b2g/mozilla/*.default/prefs.js')

PROFILE_DIR=$($ADB shell ls -l /data/b2g/mozilla | grep .default)
PROFILE_REGEX="([^ ]+\.default)"
if [[ "$PROFILE_DIR" =~ $PROFILE_REGEX ]]; then
  PROFILE_DIR=/data/b2g/mozilla/${BASH_REMATCH[1]}
else
  echo "Couldn't find Profile directory :("
  exit 1
fi

# change last update time to 2 days ago. expr doesn't like localtime
TWO_DAYS_AGO=`python -c "print $DEVICE_TIME - (60 * 60 * 24 * 2)"`

echo $TWO_DAYS_AGO

TIMER_PREF=app.update.lastUpdateTime.background-update-timer

$ADB shell cat "$PROFILE_DIR/prefs.js" | \
    sed -E "s/user_pref\(\"$TIMER_PREF\", [0-9]+\)\;/user_pref\(\"$TIMER_PREF\", $TWO_DAYS_AGO\)\;/" \
    > /tmp/force-update-prefs.js

cat >> /tmp/force-update-prefs.js <<TESTING_PREFS
user_pref("app.update.interval", 1); // shortest interval possible
user_pref("app.update.timerFirstInterval", 1); // force check update after 10s
user_pref("app.update.timerMinimumDelay", 1); // minimum delay
user_pref("app.update.log", true);
TESTING_PREFS

if [[ -n "$B2G_UPDATER_PREFS" ]]; then
  cat $B2G_UPDATER_PREFS >> /tmp/force-update-prefs.js
fi

# backup the old prefs
$ADB pull "$PROFILE_DIR/prefs.js" /tmp/prefs.js.bak
$ADB push /tmp/prefs.js.bak "$PROFILE_DIR/prefs.js.bak"

$ADB push /tmp/force-update-prefs.js $PROFILE_DIR/prefs.js
$ADB shell "stop b2g; start b2g"
