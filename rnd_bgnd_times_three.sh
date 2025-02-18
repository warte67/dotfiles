#!/bin/bash

# Directories
raw_dir="/home/jay/Pictures/Wallpaper/Custom-Size/raw"
working_dir="/home/jay/Pictures/Wallpaper/Custom-Size"

# Final image dimensions
total_width=7040
height=2560

# Select a random .jpg file from the raw directory
input_image=$(find "$raw_dir" -type f -name "*.jpg" | shuf -n 1)

# Exit if no image is found
if [ -z "$input_image" ]; then
  echo "No .jpg files found in $raw_dir."
  exit 1
fi

# Extract base filename (without extension)
base_filename=$(basename "$input_image" .jpg)

# Output image filenames
left_output="$working_dir/$base_filename-L.jpg"
middle_output="$working_dir/$base_filename-M.jpg"
right_output="$working_dir/$base_filename-R.jpg"

# Resize the input image to the final size (7040x2560)
magick "$input_image" -resize ${total_width}x${height}^ "$working_dir/$base_filename-resized.jpg"

# Split the image into three parts
# Crop left section (2346x2560 from the left)
magick "$working_dir/$base_filename-resized.jpg" -crop 2346x2560+0+0 "$left_output"

# Crop middle section (2348x2560 from the center)
magick "$working_dir/$base_filename-resized.jpg" -crop 2348x2560+2346+0 "$middle_output"

# Crop right section (2346x2560 from the right)
magick "$working_dir/$base_filename-resized.jpg" -crop 2346x2560+4694+0 "$right_output"

# Clean up the resized image
rm "$working_dir/$base_filename-resized.jpg"

# Define monitor output names
monitor_left="HDMI-A-1"
monitor_middle="DP-1"
monitor_right="DP-2"

# Set wallpapers for each monitor using swaybg
swaybg -o "$monitor_left" -i "$left_output" -m fill &
swaybg -o "$monitor_middle" -i "$middle_output" -m fill &
swaybg -o "$monitor_right" -i "$right_output" -m fill &

echo "Wallpapers set:"
echo "Left monitor: $left_output"
echo "Middle monitor: $middle_output"
echo "Right monitor: $right_output"
