#include <cstdlib>  // for std::system()
#include <iostream>
#include <ctime>

int main()
{
    std::srand(std::time(nullptr)); // use current time as seed for random generator

    std::string ref_str = "ABCDEF";
    int i = std::rand() % ref_str.length();
    std::cout << "letter: " << ref_str.at(i) << std::endl;

    std::string S1 = "swaybg -o HDMI-A-1 -i /home/jay/.config/hypr/bgnd/";
    S1 = S1 + ref_str.at(i) + "1.jpg &";
    std::string S2 = "swaybg -o HDMI-A-2 -i /home/jay/.config/hypr/bgnd/";
    S2 = S2 + ref_str.at(i) + "2.jpg &";

    std::cout << S1 << std::endl;
    std::cout << S2 << std::endl;
    std::system(S1.c_str());
    std::system(S2.c_str());

    return 0;
}


/****

swaybg -o HDMI-A-1 -i /home/jay/.config/hypr/bgnd/A1.jpg
swaybg -o HDMI-A-2 -i /home/jay/.config/hypr/bgnd/A2.jpg

*****/