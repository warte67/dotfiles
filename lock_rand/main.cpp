#include <iostream>
#include <time.h>
#include <string>


int main()
{
    srand(time(NULL));

    int n = (rand() % 6)+1;

    std::cout << rand() << std::endl;

    // std::cout << "swaylock --image /home/jay/Pictures/Lock/lock-" << n << ".jpg" << std::endl;

    std::string ret = "swaylock --image /home/jay/Pictures/Lock/lock-" + std::to_string(n) + ".jpg";

    // std::cout << ret << std::endl;
    system(ret.c_str());
    

    return 0;
}