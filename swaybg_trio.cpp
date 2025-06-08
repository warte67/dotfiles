#include <iostream>
#include <filesystem>
#include <cstdlib>
#include <random>
#include <string>

namespace fs = std::filesystem;

// Constants

// Monitor Definitions
#define LEFT_MONITOR "HDMI-A-1"
#define MIDDLE_MONITOR "DP-2"
#define RIGHT_MONITOR "DP-1"

const int LEFT_WIDTH = 1440;
const int LEFT_HEIGHT = 2560;
const int MIDDLE_BASE_WIDTH = 3840;
const int MIDDLE_BASE_HEIGHT = 2160;
const float DPI_SCALING_FACTOR = 0.8; // 1/1.25
const int RIGHT_WIDTH = 2560;
const int RIGHT_HEIGHT = 1440;
const int HEIGHT = LEFT_HEIGHT;  // Consistent height for all monitors
const int TOTAL_WIDTH = LEFT_WIDTH + (MIDDLE_BASE_WIDTH * DPI_SCALING_FACTOR) + RIGHT_WIDTH; // Total width of the reference image

const int MIDDLE_Y_OFFSET = 40;

// Function to get a random file from a directory
std::string get_random_file(const std::string& dir) {
    std::vector<std::string> files;
    for (const auto& entry : fs::directory_iterator(dir)) {
        if (entry.is_regular_file() && entry.path().extension() == ".jpg") {
            files.push_back(entry.path().string());
        }
    }

    if (files.empty()) {
        std::cerr << "No .jpg files found in " << dir << std::endl;
        exit(1);
    }

    // Generate a random index
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, files.size() - 1);
    return files[dis(gen)];
}

int main() {
    // Directories
    const std::string raw_dir = "/home/jay/Pictures/Wallpaper/Custom-Size/raw";
    const std::string working_dir = "/home/jay/Pictures/Wallpaper/Custom-Size";

    // Select a random .jpg file from the raw directory
    std::string input_image = get_random_file(raw_dir);

    // Extract base filename (without extension)
    std::string base_filename = fs::path(input_image).stem();

    // Output image filenames
    std::string left_output = working_dir + "/" + base_filename + "-L.jpg";
    std::string middle_output = working_dir + "/" + base_filename + "-M.jpg";
    std::string right_output = working_dir + "/" + base_filename + "-R.jpg";

    // Resize the input image to the total reference size (7244x2560)
    std::string resize_command = "magick convert \"" + input_image + "\" -resize " + std::to_string(TOTAL_WIDTH) + "x" + std::to_string(HEIGHT) + "^ \"" + working_dir + "/" + base_filename + "-resized.jpg\"";
    std::system(resize_command.c_str());

    // Crop the left section (1440x2560)
    std::string left_crop_command = "magick convert \"" + working_dir + "/" + base_filename + "-resized.jpg\" -crop " + std::to_string(LEFT_WIDTH) + "x" + std::to_string(LEFT_HEIGHT) + "+0+0 \"" + left_output + "\"";
    std::system(left_crop_command.c_str());

    // Scale the middle section (scaled by DPI factor)
    int middle_width = MIDDLE_BASE_WIDTH * DPI_SCALING_FACTOR;
    int middle_height = MIDDLE_BASE_HEIGHT * DPI_SCALING_FACTOR;

    // Middle section is vertically centered
    int middle_x_offset = LEFT_WIDTH;
    int middle_y_offset = (HEIGHT - middle_height) / 2;

    std::string middle_crop_command = "magick convert \"" + working_dir + "/" + base_filename + "-resized.jpg\" -crop " + std::to_string(middle_width) + "x" + std::to_string(middle_height) + "+" + std::to_string(middle_x_offset) + "+" + std::to_string(middle_y_offset+MIDDLE_Y_OFFSET) + " \"" + middle_output + "\"";
    std::system(middle_crop_command.c_str());

    // Crop the right section (2560x1440)
    int right_x_offset = LEFT_WIDTH + middle_width;
    int right_y_offset = middle_y_offset + middle_height - RIGHT_HEIGHT;

    std::string right_crop_command = "magick convert \"" + working_dir + "/" + base_filename + "-resized.jpg\" -crop " + std::to_string(RIGHT_WIDTH) + "x" + std::to_string(RIGHT_HEIGHT) + "+" + std::to_string(right_x_offset) + "+" + std::to_string(right_y_offset) + " \"" + right_output + "\"";
    std::system(right_crop_command.c_str());

    // Clean up the resized image
    std::string cleanup_command = "rm \"" + working_dir + "/" + base_filename + "-resized.jpg\"";
    std::system(cleanup_command.c_str());

    // // Set wallpapers using swaybg (assuming swaybg is installed)
    // std::string set_left_wallpaper = "swaybg -o HDMI-A-1 -i \"" + left_output + "\" -m fill &";
    // std::string set_middle_wallpaper = "swaybg -o DP-2 -i \"" + middle_output + "\" -m fill &";
    // std::string set_right_wallpaper = "swaybg -o DP-1 -i \"" + right_output + "\" -m fill &";

    // Set wallpapers using swaybg
    std::string set_left_wallpaper = "swaybg -o " + std::string(LEFT_MONITOR) + " -i \"" + left_output + "\" -m fill &";
    std::string set_middle_wallpaper = "swaybg -o " + std::string(MIDDLE_MONITOR) + " -i \"" + middle_output + "\" -m fill &";
    std::string set_right_wallpaper = "swaybg -o " + std::string(RIGHT_MONITOR) + " -i \"" + right_output + "\" -m fill &";

    std::system(set_left_wallpaper.c_str());
    std::system(set_middle_wallpaper.c_str());
    std::system(set_right_wallpaper.c_str());

    // Output the result
    std::cout << "Wallpapers set:" << std::endl;
    std::cout << "Left monitor: " << left_output << std::endl;
    std::cout << "Middle monitor: " << middle_output << std::endl;
    std::cout << "Right monitor: " << right_output << std::endl;

    return 0;
}
