#include <frontend/utils/ast.hpp>
#include <iomanip>

namespace frontend
{

    std::ostream *lexer_output = nullptr;
    std::ostream *ast_output = nullptr;

    // Initialize the static counter
    size_t Node::node_counter = 0;

    Terminal::Terminal(std::string _lexeme, location_t location, position_t position, TokenType token_type)
        : Node(std::move(_lexeme)), location(location), position(position), token_type(token_type)
    {
        // If output stream is set, print the terminal
        if (lexer_output)
        {
            *lexer_output << "| " << std::setw(25) << std::left << lexeme
                          << " | [" << std::setw(3) << std::right << location.first
                          << "-" << std::setw(3) << std::left << location.second << "]"
                          << " | " << std::setw(15) << std::left << position
                          << " | " << std::setw(15) << std::left << token_type
                          << " |" << std::endl;
        }
    }

    void Terminal::print(std::ostream &os) const
    {
        os << "| " << std::setw(25) << std::left << lexeme
           << " | [" << std::setw(3) << std::right << location.first
           << "-" << std::setw(3) << std::left << location.second << "]"
           << " | " << std::setw(15) << std::left << position
           << " | " << std::setw(15) << std::left << token_type
           << " |" << std::endl;
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
