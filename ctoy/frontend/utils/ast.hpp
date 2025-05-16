#pragma once

#include <string>
#include <ostream>
#include <iostream>
#include <vector>
#include <memory>
#include "node_types.hpp"

namespace frontend
{

    using position_t = std::size_t;
    using location_t = std::pair<std::size_t, std::size_t>;

    enum class NodeType
    {
        TYPEDEF_NAME,
        IDENTIFIER,
        CONSTANT,
        STRING_LITERAL,
        KEYWORD,
        PUNCTUATOR,
        EMPTY,
        ERROR,
    };

    class Node : public std::enable_shared_from_this<Node>
    {
    public:
        std::string lexeme; // Make these public for easier access
        location_t location;
        position_t position;
        NodeType node_type;
        std::vector<std::shared_ptr<Node>> children;
        std::weak_ptr<Node> parent;

        Node(std::string lexeme,
             location_t location,
             position_t position,
             NodeType node_type = NodeType::EMPTY,
             std::vector<std::shared_ptr<Node>> children = {})
            : lexeme(std::move(lexeme)),
              location(location),
              position(position),
              node_type(node_type),
              children(std::move(children)) {}

        // Getters
        const std::string &get_lexeme() const { return lexeme; }
        location_t get_location() const { return location; }
        position_t get_position() const { return position; }
        NodeType get_node_type() const { return node_type; }
        const std::vector<std::shared_ptr<Node>> &get_children() const { return children; }
        std::shared_ptr<Node> get_parent() const { return parent.lock(); }

        // Modifiers
        void add_child(std::shared_ptr<Node> child)
        {
            if (!child)
                return; // Guard against null pointers
            children.push_back(child);
            try
            {
                child->parent = shared_from_this();
            }
            catch (const std::bad_weak_ptr &)
            {
                // Handle the case where shared_from_this() is called before any shared_ptr exists
                std::cerr << "Warning: shared_from_this() called before shared_ptr exists\n";
            }
        }
        void set_node_type(NodeType type) { node_type = type; }

        // Utility
        void print(std::ostream &os = std::cout) const;
        bool is_terminal() const;
        size_t child_count() const { return children.size(); }
    };

    Node *create_nterm(std::string name, NodeType type = NodeType::EMPTY, std::vector<std::shared_ptr<Node>> children = {});

    std::ostream &operator<<(std::ostream &os, const NodeType &type);

    inline std::ostream &operator<<(std::ostream &os, const frontend::location_t &loc)
    {
        return os << "[" << loc.first << "-" << loc.second << "]";
    }
}
