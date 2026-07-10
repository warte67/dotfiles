#!/bin/bash

# Directories
raw_dir="/home/jay/Pictures/Wallpaper/Custom-Size/raw"
working_dir="/home/jay/Pictures/Wallpaper/Custom-Size"

# Known reference image
input_image="$raw_dir/A.jpg"

# Verify it exists
if [ ! -f "$input_image" ]; then
    echo "Reference image not found:"
    echo "  $input_image"
    exit 1
fi

# Background dimensions
left_width=1440
left_height=2560

middle_base_width=3840
middle_base_height=2160
dpi_scaling_factor=0.8

middle_y_adjust=50
right_y_adjust=-25

middle_width=$(echo "$middle_base_width * $dpi_scaling_factor" | bc)
middle_height=$(echo "$middle_base_height * $dpi_scaling_factor" | bc)

right_width=2560
right_height=1440

total_width=$(echo "$left_width + $middle_width + $right_width" | bc)
height=$left_height

base_filename=$(basename "$input_image" .jpg)

left_output="$working_dir/$base_filename-L.jpg"
middle_output="$working_dir/$base_filename-M.jpg"
right_output="$working_dir/$base_filename-R.jpg"

# Resize to virtual canvas
magick "$input_image" \
    -resize ${total_width}x${height}^ \
    "$working_dir/$base_filename-resized.jpg"

# Left
magick "$working_dir/$base_filename-resized.jpg" \
    -crop ${left_width}x${left_height}+0+0 \
    "$left_output"

# Middle
middle_x_offset=$left_width
middle_y_offset=$(echo "(($height - $middle_height) / 2) + $middle_y_adjust" | bc)

magick "$working_dir/$base_filename-resized.jpg" \
    -crop ${middle_width}x${middle_height}+${middle_x_offset}+${middle_y_offset} \
    "$middle_output"

# Right
right_x_offset=$(echo "$left_width + $middle_width" | bc)
right_y_offset=$(echo "$middle_y_offset + $middle_height - $right_height + $right_y_adjust" | bc)

magick "$working_dir/$base_filename-resized.jpg" \
    -crop ${right_width}x${right_height}+${right_x_offset}+${right_y_offset} \
    "$right_output"

rm "$working_dir/$base_filename-resized.jpg"

# Monitor names
monitor_left="HDMI-A-1"
monitor_middle="DP-1"
monitor_right="HDMI-A-2"

# Kill any previous swaybg instances
pkill swaybg 2>/dev/null

# Set wallpapers
swaybg -o "$monitor_left" -i "$left_output" -m fill &
swaybg -o "$monitor_middle" -i "$middle_output" -m fill &
swaybg -o "$monitor_right" -i "$right_output" -m fill &

# Tell DMS
dms ipc call wallpaper setFor "$monitor_left" "$left_output"
dms ipc call wallpaper setFor "$monitor_middle" "$middle_output"
dms ipc call wallpaper setFor "$monitor_right" "$right_output"

echo "Reference wallpaper applied."
