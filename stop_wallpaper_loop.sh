#!/bin/bash

# Lock file path
LOCK_FILE="/tmp/swaybg_rnd.lock"

# Check if the lock file exists
if [ -f "$LOCK_FILE" ]; then
    # Remove the lock file to stop the loop
    rm -f "$LOCK_FILE"
    notify-send "Success" "Wallpaper loop stopped."
else
    notify-send "Info" "Wallpaper loop is not running."
fi
