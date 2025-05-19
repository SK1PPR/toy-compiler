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
    extern std::ostream *ast_output;

    // Base class for AST nodes
    class Node
    {
    protected:
        std::string lexeme;
        static size_t node_counter; // Add static counter here

        // Helper function to escape quotes in labels
        std::string escape_quotes(const std::string &str) const
        {
            std::string result;
            for (char c : str)
            {
                if (c == '"')
                    result += "\\\"";
                else
                    result += c;
            }
            return result;
        }

    public:
        Node() = default;
        Node(std::string lexeme) : lexeme(std::move(lexeme)) {}

        virtual void print(std::ostream &os = std::cout) const
        {
            os << lexeme << std::endl;
        }

        virtual void dotify(std::ostream &os = *ast_output) const = 0;

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

        void dotify(std::ostream &os = *ast_output) const override
        {
            if (!ast_output)
                return; // Skip if ast_output is null

            // Create a unique ID for this node
            size_t current_id = node_counter++;

            // Output node definition
            os << "    node" << current_id << " [label=\"" << escape_quotes(lexeme) << "\", shape=box];" << std::endl;

            // Output edges to children
            for (const auto &child : children)
            {
                size_t child_id = node_counter;
                child->dotify(os);
                os << "    node" << current_id << " -> node" << child_id << ";" << std::endl;
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

        void dotify(std::ostream &os = *ast_output) const override
        {
            if (!ast_output)
                return; // Skip if ast_output is null

            // Create a unique ID for this node
            size_t current_id = node_counter++;

            // Output node definition with token type and lexeme
            os << "    node" << current_id << " [label=\"" << escape_quotes(lexeme) << "\\n"
               << token_type << "\", shape=ellipse];" << std::endl;
        }
    };

    inline std::ostream &operator<<(std::ostream &os, const frontend::location_t &loc)
    {
        return os << "[" << loc.first << "-" << loc.second << "]";
    }
}
