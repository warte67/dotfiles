#!/bin/bash

# Lock file to ensure only one instance runs at a time
LOCK_FILE="/tmp/swaybg_rnd.lock"
SCRIPT="/home/jay/Documents/GitHub/dotfiles/dual_bgnd.sh"

# Check if the lock file exists
if [ -f "$LOCK_FILE" ]; then
    notify-send "Error" "Wallpaper loop is already running!"
    exit 1
fi

# Create the lock file and ensure it is removed on script exit
touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Check if the script exists
if [ ! -f "$SCRIPT" ]; then
    notify-send "Error" "Script not found: $SCRIPT"
    exit 1
fi

# Infinite loop to update wallpaper
while true; do
    # Exit if lock file is missing (manual termination)
    if [ ! -f "$LOCK_FILE" ]; then
        exit 0
    fi

    # Execute the dual_bgnd.sh script
    /bin/bash "$SCRIPT"

    # Wait for 300 seconds (5 minutes)
    sleep 300
done
