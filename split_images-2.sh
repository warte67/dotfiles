#!/bin/bash
#
# source images: 8192 x 1728
#
set -euo pipefail

raw_dir="/home/jay/Pictures/Wallpaper/Custom-Size/raw"
working_dir="/home/jay/Pictures/Wallpaper/Custom-Size"

# --- Segment sizes ---
left_w=2560;  left_h=1440
mid_w=3072;   mid_h=1728
right_w=2560; right_h=1440

# --- Derived canvas size ---
total_width=$((left_w + mid_w + right_w))
height=$(( left_h > mid_h ? (left_h > right_h ? left_h : right_h) : (mid_h > right_h ? mid_h : right_h) ))

# --- X offsets ---
x_left=0
x_mid=$left_w
x_right=$((left_w + mid_w))

# --- Y offsets (BOTTOM ALIGN within the canvas) ---
y_left=$((height - left_h))
y_mid=$((height - mid_h))
y_right=$((height - right_h))

mkdir -p "$working_dir"

shopt -s nullglob
for input_image in "$raw_dir"/*.jpg "$raw_dir"/*.jpeg "$raw_dir"/*.png; do
  base_filename="$(basename "$input_image")"
  base_filename="${base_filename%.*}"

  left_output="$working_dir/$base_filename-left.jpg"
  middle_output="$working_dir/$base_filename-middle.jpg"
  right_output="$working_dir/$base_filename-right.jpg"
  resized="$working_dir/$base_filename-resized.jpg"

  # 1) Resize to cover, then 2) force EXACT canvas size, bottom-anchored
  magick "$input_image" \
    -resize "${total_width}x${height}^" \
    -gravity south \
    -extent "${total_width}x${height}" \
    "$resized"

  # Now crops are guaranteed to come from the bottom-aligned canvas
  magick "$resized" -crop "${left_w}x${left_h}+${x_left}+${y_left}"  +repage "$left_output"
  magick "$resized" -crop "${mid_w}x${mid_h}+${x_mid}+${y_mid}"     +repage "$middle_output"
  magick "$resized" -crop "${right_w}x${right_h}+${x_right}+${y_right}" +repage "$right_output"

  rm -f "$resized"

  echo "Processed: $input_image"
done
