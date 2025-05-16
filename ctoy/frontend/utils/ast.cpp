#include <frontend/utils/ast.hpp>

namespace frontend
{

    void Node::print(std::ostream &os) const
    {
        os << "Node(" << lexeme << ", " << location << ", " << position
           << ", node_type=" << node_type
           << ", children=" << children.size() << ")" << std::endl;
    }

    bool Node::is_terminal() const
    {
        return children.empty() && (node_type == NodeType::IDENTIFIER ||
                                    node_type == NodeType::CONSTANT ||
                                    node_type == NodeType::STRING_LITERAL ||
                                    node_type == NodeType::KEYWORD ||
                                    node_type == NodeType::PUNCTUATOR);
    }

    Node *create_nterm(std::string name, NodeType type, std::vector<std::shared_ptr<Node>> children)
    {
        return new Node(std::move(name), location_t(0, 0), 0, type, std::move(children));
    }

    std::ostream &operator<<(std::ostream &os, const NodeType &type)
    {
        switch (type)
        {
        case NodeType::IDENTIFIER:
            return os << "IDENTIFIER";
        case NodeType::CONSTANT:
            return os << "CONSTANT";
        case NodeType::STRING_LITERAL:
            return os << "STRING_LITERAL";
        case NodeType::KEYWORD:
            return os << "KEYWORD";
        case NodeType::PUNCTUATOR:
            return os << "PUNCTUATOR";
        case NodeType::ERROR:
            return os << "ERROR";
        case NodeType::EMPTY:
            return os << "EMPTY";
        default:
            return os << "UNKNOWN";
        }
    }
}
