#include <iostream>
#include <fstream>
#include <frontend/frontend.hpp>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        std::cerr << "Usage: " << argv[0] << " <input_file>" << std::endl;
        return 1;
    }

    std::ifstream input(argv[1]);

    return parse_frontend(input, argv[1], true, false);
}