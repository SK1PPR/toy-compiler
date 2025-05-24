#pragma once

#include <frontend/utils/ast.hpp>

namespace frontend
{
    enum class QualifierSpecifiers
    {
        NONE = 1,
        CONST = 2,
        VOLATILE = 4
    };

    class Qualifier : public virtual Terminal, public virtual NonTerminal
    {
    private:
        std::vector<QualifierSpecifiers> qualifiers;
        bool is_terminal;

    public:
        Qualifier() = default;
        // Constructor for Terminal case
        Qualifier(Terminal *lexeme, int qualifier);
        // Constructor for NonTerminal case
        Qualifier(NonTerminal *lexeme, int qualifier);
        std::vector<QualifierSpecifiers> get_qualifiers() const;
        Qualifier operator+(const Qualifier &other) const;

        Node *as_node() const;
    };
}