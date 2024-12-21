#!/bin/bash

# Define the directory where wallpapers are stored
WALLPAPER_DIR="/home/jay/Pictures/Wallpaper/Dual/"

# Find a random .jpg file in the directory
WALLPAPER=$(find "$WALLPAPER_DIR" -type f -name "*.jpg" | shuf -n 1)

# Check if a wallpaper was found
if [ -z "$WALLPAPER" ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Split the wallpaper into left and right halves
LEFT_OUTPUT="/tmp/left_wallpaper.jpg"
RIGHT_OUTPUT="/tmp/right_wallpaper.jpg"

magick "$WALLPAPER" -crop 1920x1080+0+0 "$LEFT_OUTPUT"
magick "$WALLPAPER" -crop 1920x1080+1920+0 "$RIGHT_OUTPUT"

# Set the left half on the left monitor
swaybg -o HDMI-A-1 -i "$LEFT_OUTPUT" -m fill &

# Set the right half on the right monitor
swaybg -o HDMI-A-2 -i "$RIGHT_OUTPUT" -m fill &

echo "Wallpaper applied successfully!"
