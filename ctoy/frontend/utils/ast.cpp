#include <frontend/utils/ast.hpp>

namespace frontend
{

    void Terminal::print(std::ostream &os) const
    {
        os << "| " << lexeme << ", " << location << ", " << position << ", " << token_type << " |" << std::endl;
    }

    std::ostream &operator<<(std::ostream &os, const TokenType &type)
    {
        switch (type)
        {
        case KEYWORD:
            return os << "KEYWORD";
        case CONSTANT:
            return os << "CONSTANT";
        case STRING_LITERAL:
            return os << "STRING_LITERAL";
        case IDENTIFIER:
            return os << "IDENTIFIER";
        case PUNCTUATOR:
            return os << "PUNCTUATOR";
        default:
            return os << "UNKNOWN";
        }
    }
}
