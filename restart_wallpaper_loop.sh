#!/bin/bash

# Path to the wallpaper loop script
WALLPAPER_LOOP_SCRIPT="/home/jay/Documents/GitHub/dotfiles/wallpaper_loop.sh"

# Stop any running instance of the wallpaper loop
LOCK_FILE="/tmp/swaybg_rnd.lock"
if [ -f "$LOCK_FILE" ]; then
    rm -f "$LOCK_FILE"
    sleep 1  # Brief pause to ensure the previous loop terminates
fi

# Start a new instance of the wallpaper loop
/bin/bash "$WALLPAPER_LOOP_SCRIPT" &
#notify-send "Success" "Wallpaper loop restarted."
