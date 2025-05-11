#!/bin/bash

# Directory where wallpapers are stored
WALLPAPER_DIR="/home/jay/Pictures/Wallpaper/Dual/"

# Resolution of each monitor
RESOLUTION="1920x1080"

# Output paths for split wallpapers
LEFT_OUTPUT="/tmp/left_wallpaper.jpg"
RIGHT_OUTPUT="/tmp/right_wallpaper.jpg"

# Monitor identifiers (adjust as per your setup)
LEFT_MONITOR="DP-3"
RIGHT_MONITOR="HDMI-A-1"

# Find a random .jpg file in the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f -name "*.jpg" | shuf -n 1)

# Check if a wallpaper was found
if [ -z "$WALLPAPER" ]; then
  notify-send "Error" "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Split the wallpaper into left and right halves
magick "$WALLPAPER" -crop "${RESOLUTION}+0+0" "$LEFT_OUTPUT"
if [ $? -ne 0 ]; then
  notify-send "Error" "Failed to create left wallpaper from $WALLPAPER"
  exit 1
fi

magick "$WALLPAPER" -crop "${RESOLUTION}+1920+0" "$RIGHT_OUTPUT"
if [ $? -ne 0 ]; then
  notify-send "Error" "Failed to create right wallpaper from $WALLPAPER"
  exit 1
fi

# Set wallpapers on respective monitors
swaybg -o "$LEFT_MONITOR" -i "$LEFT_OUTPUT" -m fill &
LEFT_PID=$!

swaybg -o "$RIGHT_MONITOR" -i "$RIGHT_OUTPUT" -m fill &
RIGHT_PID=$!

# Wait briefly to ensure swaybg processes start
sleep 1

# Check if swaybg processes are running
if ! kill -0 $LEFT_PID 2>/dev/null || ! kill -0 $RIGHT_PID 2>/dev/null; then
  notify-send "Error" "Failed to apply wallpaper"
  exit 1
fi

notify-send "Success" "Wallpaper applied successfully!"
exit 0
