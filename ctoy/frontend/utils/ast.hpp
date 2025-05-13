#pragma once

#include <string>
#include <ostream>
#include <iostream>

namespace frontend
{

    using position_t = std::size_t;
    using location_t = std::pair<std::size_t, std::size_t>;

    enum TokenType
    {
        KEYWORD,
        CONSTANT,
        STRING_LITERAL,
        IDENTIFIER,
        PUNCTUATOR
    };

    std::ostream &operator<<(std::ostream &os, const TokenType &type);

    class Node
    {
    private:
        std::string lexeme;
        location_t location;
        position_t position;
        TokenType token_type;

    public:
        Node(std::string lexeme, location_t location, position_t position, TokenType token_type)
            : lexeme(std::move(lexeme)), location(location), position(position), token_type(token_type) {}

        std::string get_lexeme() const { return lexeme; }
        location_t get_location() const { return location; }
        position_t get_position() const { return position; }
        TokenType get_token_type() const { return token_type; }
        void print(std::ostream &os = std::cout) const;
    };

    inline std::ostream &operator<<(std::ostream &os, const frontend::location_t &loc)
    {
        return os << "[" << loc.first << "-" << loc.second << "]";
    }
}
