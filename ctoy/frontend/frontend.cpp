#include <frontend/frontend.hpp>

int parse_frontend(std::ifstream &input)
{
    frontend::FrontendLexer lexer(input, false);
    frontend::FrontendBisonParser parser(lexer, false);
    return parser();
}