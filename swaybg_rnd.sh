#!/bin/bash

# Define the wallpaper folder
WALLPAPER_FOLDER="/home/jay/Pictures/Wallpaper/Dual/split"

# Select a random base image name (without the -L or -R suffix)
BASE_IMAGE=$(find "$WALLPAPER_FOLDER" -type f -name "*-L.jpg" | shuf -n 1 | sed 's/-L.jpg//')

# Set the left and right monitor wallpapers using the corresponding paired images
LEFT_WALLPAPER="${BASE_IMAGE}-L.jpg"
RIGHT_WALLPAPER="${BASE_IMAGE}-R.jpg"

# Set the left monitor wallpaper using swaybg
swaybg -o DP-4 -i "$LEFT_WALLPAPER" &

# Set the right monitor wallpaper using swaybg
swaybg -o HDMI-A-4 -i "$RIGHT_WALLPAPER" &

echo "Left monitor set to: $LEFT_WALLPAPER"
echo "Right monitor set to: $RIGHT_WALLPAPER"

