#!/bin/bash
#
# Left    1440x2560 (no scaling, top and bottom aligned)
# Middle  3840x2160 (scaled by DPI difference, vertically centered)
# Right   2560x1440 (no scaling, bottom aligned with middle)
# -----------------
# input   7244x2560 (size in pixels of the reference image)

# Directories
raw_dir="/home/jay/Pictures/Wallpaper/Custom-Size/raw"
working_dir="/home/jay/Pictures/Wallpaper/Custom-Size"

# Background dimensions
left_width=1440
left_height=2560

middle_base_width=3840
middle_base_height=2160
dpi_scaling_factor=0.847

# Calculate the scaled dimensions for the middle monitor
middle_width=$(echo "$middle_base_width * $dpi_scaling_factor" | bc)
middle_height=$(echo "$middle_base_height * $dpi_scaling_factor" | bc)

right_width=2560
right_height=1440

# Total image dimensions (reference image size)
total_width=$(echo "$left_width + $middle_width + $right_width" | bc)
height=$left_height  # The height is constant for all monitors

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

# Resize the input image to the final size (total width and height)
magick "$input_image" -resize ${total_width}x${height}^ "$working_dir/$base_filename-resized.jpg"

# Crop left section (1440x2560)
magick "$working_dir/$base_filename-resized.jpg" -crop ${left_width}x${left_height}+0+0 "$left_output"

# Crop and scale middle section (scaled by DPI factor)
middle_x_offset=$left_width  # Middle section starts right after the left monitor
middle_y_offset=$(echo "($height - $middle_height) / 2" | bc)  # Vertically centered
magick "$working_dir/$base_filename-resized.jpg" -crop ${middle_width}x${middle_height}+$middle_x_offset+$middle_y_offset "$middle_output"

# Crop right section (2560x1440)
right_x_offset=$(echo "$left_width + $middle_width" | bc)  # Right section starts after the middle monitor
right_y_offset=$(echo "$middle_y_offset + $middle_height - $right_height" | bc)  # Bottom-aligned with middle
magick "$working_dir/$base_filename-resized.jpg" -crop ${right_width}x${right_height}+$right_x_offset+$right_y_offset "$right_output"

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
