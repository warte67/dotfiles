#!/bin/bash
#
# Input jpg image will be resized to 7040x2560. To minimize distortion
# start with an image as close as posible to this size.
#
#

# Check if input image parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_image>"
  exit 1
fi

# Input image file
input_image="$1"

# Output image file names
left_output="left.jpg"
middle_output="middle.jpg"
right_output="right.jpg"

# Final image dimensions
total_width=7040
height=2560

# Resize the input image to the final size (7040x2560)
convert "$input_image" -resize ${total_width}x${height}^ "$input_image_resized.jpg"

# Crop left section (1440x2560) from the resized image
convert "$input_image_resized.jpg" -crop 1440x2560+0+0 "$left_output"

# Crop middle section (3072x1728) from the resized image
convert "$input_image_resized.jpg" -crop 3072x1728+1440+460 "$middle_output"

# Crop right section (2560x1440) from the resized image
convert "$input_image_resized.jpg" -crop 2560x1440+4512+700 "$right_output"

# Clean up the resized image
rm "$input_image_resized.jpg"

echo "Images saved: $left_output, $middle_output, $right_output"
