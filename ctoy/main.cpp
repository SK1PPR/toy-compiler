#include <iostream>
#include <fstream>
#include <frontend/frontend.hpp>

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        std::cerr << "Usage: " << argv[0] << " [-l] [-s] <input_file>" << std::endl;
        std::cerr << "  -l: Enable lexer output" << std::endl;
        std::cerr << "  -s: Enable syntax tree output" << std::endl;
        return 1;
    }

    bool lexer_output = false;
    bool syntax_output = false;
    std::string input_file;

    // Parse command line arguments
    for (int i = 1; i < argc; i++)
    {
        std::string arg = argv[i];
        if (arg == "-l")
        {
            lexer_output = true;
        }
        else if (arg == "-s")
        {
            syntax_output = true;
        }
        else
        {
            input_file = arg;
        }
    }

    if (input_file.empty())
    {
        std::cerr << "Error: No input file specified" << std::endl;
        return 1;
    }

    std::ifstream input(input_file);
    if (!input.is_open())
    {
        std::cerr << "Error: Could not open file '" << input_file << "'" << std::endl;
        return 1;
    }

    return parse_frontend(input, input_file, lexer_output, syntax_output);
}