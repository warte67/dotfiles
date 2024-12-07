#!/bin/bash
#
# This script will convert all images in the raw folder into three parts:
# left, middle, and right for multi-monitor backgrounds.
#
# It assumes the images in the 'raw' folder are suitable for resizing to 7040x2560 and cropping.
#

# Define directories
raw_dir="/home/jay/Pictures/Wallpaper/Custom Size/raw"
working_dir="/home/jay/Pictures/Wallpaper/Custom Size"

# Final image dimensions
total_width=7040
height=2560

# Iterate over each image in the raw directory
for input_image in "$raw_dir"/*.jpg; do
  # Extract base filename (without extension)
  base_filename=$(basename "$input_image" .jpg)

  # Output image filenames
  left_output="$working_dir/$base_filename-left.jpg"
  middle_output="$working_dir/$base_filename-middle.jpg"
  right_output="$working_dir/$base_filename-right.jpg"

  # Resize the input image to the final size (7040x2560) using 'magick' instead of 'convert'
  magick "$input_image" -resize ${total_width}x${height}^ "$working_dir/$base_filename-resized.jpg"

  # Crop left section (1440x2560) from the resized image
  magick "$working_dir/$base_filename-resized.jpg" -crop 1440x2560+0+0 "$left_output"

  # Crop middle section (3072x1728) from the resized image
  magick "$working_dir/$base_filename-resized.jpg" -crop 3072x1728+1440+460 "$middle_output"

  # Crop right section (2560x1440) from the resized image
  magick "$working_dir/$base_filename-resized.jpg" -crop 2560x1440+4512+700 "$right_output"

  # Clean up the resized image
  rm "$working_dir/$base_filename-resized.jpg"

  echo "Processed image: $input_image"
  echo "Saved: $left_output, $middle_output, $right_output"
done
