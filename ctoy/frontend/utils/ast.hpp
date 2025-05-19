#pragma once

#include <string>
#include <ostream>
#include <iostream>
#include <memory>
#include <vector>
#include <sstream>

namespace frontend
{

    using position_t = std::size_t;
    using location_t = std::pair<std::size_t, std::size_t>;

    extern std::ostream *lexer_output;

    // Base class for AST nodes
    class Node
    {
    protected:
        std::string lexeme;

    public:
        Node() = default;
        Node(std::string lexeme) : lexeme(std::move(lexeme)) {}

        virtual void print(std::ostream &os = std::cout) const
        {
            os << lexeme << std::endl;
        }

        virtual ~Node() = default;
    };

    // Derived class for non-terminal nodes
    class NonTerminal : public Node
    {
    private:
        std::vector<Node *> children; // Changed from unique_ptr to raw pointer since Bison manages memory

    public:
        NonTerminal() = default;
        NonTerminal(std::string lexeme) : Node(std::move(lexeme)) {}

        void add_child(Node *child) // Changed to accept raw pointer
        {
            children.push_back(child);
        }

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
        Terminal() = default;
        Terminal(std::string lexeme, location_t location, position_t position, TokenType token_type);

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
