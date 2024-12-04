#!/bin/bash

# Lock file to ensure only one instance runs at a time
LOCK_FILE="/tmp/swaybg_rnd.lock"

# Check if the lock file exists
if [ -f "$LOCK_FILE" ]; then
    # Notify the user that the script is already running
    notify-send "Error" "Script is already running!"
    exit 1
fi

# Create the lock file
touch "$LOCK_FILE"

# Check if the swaybg_rnd.sh script exists
SCRIPT="/home/jay/.config/hypr/swaybg_rnd.sh"
if [ ! -f "$SCRIPT" ]; then
    # Notify the user that the script is missing
    notify-send "Error" "$SCRIPT not found!"
    rm "$LOCK_FILE"  # Remove the lock file if the script is not found
    exit 1
fi

# Infinite loop
while true; do
    # Call the swaybg_rnd.sh script
    /bin/bash "$SCRIPT"
    
    # Wait for 60 seconds
    sleep 60
done
