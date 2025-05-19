#include <frontend/frontend.hpp>
#include <sstream>
#include <filesystem>
#include <iomanip>

int parse_frontend(std::ifstream &input, const std::string &input_filename, bool lexer_output, bool ast_output)
{
    std::ofstream *lexer_output_file = nullptr;
    std::ofstream *ast_output_file = nullptr;

    if (lexer_output)
    {
        // Create a new file with same name as input file but with .lex extension
        std::string output_path = input_filename + ".lex";
        lexer_output_file = new std::ofstream(output_path);
        frontend::lexer_output = lexer_output_file;

        // Add table headers
        *lexer_output_file << "| " << std::setw(25) << std::left << "Lexeme"
                           << " | " << std::setw(9) << std::left << "Location"
                           << " | " << std::setw(15) << std::left << "Position"
                           << " | " << std::setw(15) << std::left << "Token Type"
                           << " |" << std::endl;
        *lexer_output_file << std::string(80, '-') << std::endl; // Add separator line
    }

    std::string temp_path = input_filename + ".dot";

    if (ast_output)
    {
        // Create a temporary file to run graphviz on
        ast_output_file = new std::ofstream(temp_path);
        frontend::ast_output = ast_output_file;

        // Write Graphviz header
        *ast_output_file << "digraph AST {" << std::endl;
        *ast_output_file << "    node [fontname=\"Arial\"];" << std::endl;
        *ast_output_file << "    edge [fontname=\"Arial\"];" << std::endl;
        *ast_output_file << "    rankdir=TB;" << std::endl;
    }

    // Create lexer and parser
    frontend::FrontendLexer lexer(input, false);
    frontend::FrontendBisonParser parser(lexer, false);

    // Parse the input
    int result = parser.parse();

    if (ast_output)
    {
        // Write Graphviz footer
        *ast_output_file << "}" << std::endl;
        ast_output_file->close();
        delete ast_output_file;

        // Run graphviz to generate the image
        std::string cmd = "dot -Tpng " + temp_path + " -o " + input_filename + ".png";
        system(cmd.c_str());
    }

    if (lexer_output)
    {
        lexer_output_file->close();
        delete lexer_output_file;
    }

    return result;
}