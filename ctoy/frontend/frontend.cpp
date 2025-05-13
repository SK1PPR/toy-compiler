#include <frontend/frontend.hpp>

int parse_frontend()
{
    frontend::FrontendLexer lexer(std::cin, false);
    frontend::FrontendBisonParser parser(lexer, false);
    return parser();
}