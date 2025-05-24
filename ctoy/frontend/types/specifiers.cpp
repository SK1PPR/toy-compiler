#include <frontend/types/specifiers.hpp>

namespace frontend
{
    Specifiers::Specifiers(Terminal *lexeme)
        : Terminal(lexeme), is_terminal(true) {}

    Specifiers::Specifiers(NonTerminal *lexeme)
        : NonTerminal(lexeme), is_terminal(false) {}

    bool Specifiers::get_specifier(EnumSpecifier specifier) const
    {
        return specifiers[(int)specifier];
    }
    
    
}