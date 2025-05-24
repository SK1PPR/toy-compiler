#pragma once

#include <frontend/utils/ast.hpp>

const int SpecifierCount = 7;

namespace frontend
{
    enum class EnumSpecifier
    {
        CONST,
        VOLATILE,
        STATIC,
        EXTERN,
        AUTO,
        TYPEDEF,
        REGISTER
    };

    class Specifiers : public virtual Terminal, public virtual NonTerminal
    {
    private:
        bool specifiers[SpecifierCount];
        bool is_terminal;

    public:
        Specifiers() = default;
        Specifiers(Terminal *lexeme);
        Specifiers(NonTerminal *lexeme);
        bool get_specifier(EnumSpecifier specifier) const;
        void set_specifier(EnumSpecifier specifier, bool value = true);

        Specifiers operator+(const Specifiers &other) const;

        Node *as_node() const;
    };
}