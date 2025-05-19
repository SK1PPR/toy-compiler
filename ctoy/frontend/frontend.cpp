#include <frontend/frontend.hpp>
#include <sstream>
#include <filesystem>
#include <iomanip>

int parse_frontend(std::ifstream &input, const std::string &input_filename, bool lexer_output, bool ast_output)
{
    if (lexer_output)
    {
        // Create a new file with same name as input file but with .lex extension
        std::string output_path = input_filename + ".lex";
        auto *lexer_output_file = new std::ofstream(output_path);
        frontend::lexer_output = lexer_output_file;

        // Add table headers
        *lexer_output_file << "| " << std::setw(25) << std::left << "Lexeme"
                           << " | " << std::setw(9) << std::left << "Location"
                           << " | " << std::setw(15) << std::left << "Position"
                           << " | " << std::setw(15) << std::left << "Token Type"
                           << " |" << std::endl;
        *lexer_output_file << std::string(80, '-') << std::endl; // Add separator line
    }

    frontend::FrontendLexer lexer(input, false);
    frontend::FrontendBisonParser parser(lexer, false);
    return parser();
}