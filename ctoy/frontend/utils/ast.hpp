#pragma once

#include <string>
#include <ostream>
#include <iostream>
#include <memory>
#include <vector>

namespace frontend
{

    using position_t = std::size_t;
    using location_t = std::pair<std::size_t, std::size_t>;

    // Base class for AST nodes
    class Node
    {
    protected:
        std::string lexeme;
        std::vector<std::unique_ptr<Node>> children;

    public:
        Node(std::string lexeme) : lexeme(std::move(lexeme)) {}
        void add_child(std::unique_ptr<Node> child)
        {
            children.push_back(std::move(child));
        }

        virtual void print(std::ostream &os = std::cout) const
        {
            os << lexeme << std::endl;
            for (const auto &child : children)
            {
                child->print(os);
            }
        }

        virtual ~Node() = default;
    };

    // Derived class for non-terminal nodes
    class NonTerminal : public Node
    {
    public:
        NonTerminal(std::string lexeme) : Node(std::move(lexeme)) {}
        void print(std::ostream &os = std::cout) const override
        {
            os << "NonTerminal: " << lexeme << std::endl;
            for (const auto &child : children)
            {
                child->print(os);
            }
        }
    };

    enum TokenType
    {
        KEYWORD,
        CONSTANT,
        STRING_LITERAL,
        IDENTIFIER,
        PUNCTUATOR
    };

    std::ostream &operator<<(std::ostream &os, const TokenType &type);

    class Terminal : public Node
    {
    protected:
        location_t location;
        position_t position;
        TokenType token_type;

    public:
        Terminal(std::string lexeme, location_t location, position_t position, TokenType token_type)
            : Node(std::move(lexeme)), location(location), position(position), token_type(token_type) {}

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
