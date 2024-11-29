#include <iostream>
#include <time.h>
#include <string>


int main()
{
    srand(time(NULL));

    int n = (rand() % 6)+1;

    // std::string ret = "swaylock --image /home/jay/Pictures/Lock/lock-" + std::to_string(n) + ".jpg";
    std::string ret = "swaylock --image /home/jay/.config/hypr/lock/lock-" + std::to_string(n) + ".jpg";
    std::cout << ret << std::endl;

    // std::cout << ret << std::endl;
    system(ret.c_str());
    

    return 0;
}