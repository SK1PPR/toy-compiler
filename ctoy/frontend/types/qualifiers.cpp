#include <frontend/types/qualifiers.hpp>

namespace frontend
{
    Qualifier::Qualifier(Terminal *lexeme, int qualifier)
        : Terminal(lexeme), is_terminal(true), qualifiers(std::vector<QualifierSpecifiers>{})
    {
        if (qualifier & (int)QualifierSpecifiers::NONE)
            qualifiers.push_back(QualifierSpecifiers::NONE);
        if (qualifier & (int)QualifierSpecifiers::CONST)
            qualifiers.push_back(QualifierSpecifiers::CONST);
        if (qualifier & (int)QualifierSpecifiers::VOLATILE)
            qualifiers.push_back(QualifierSpecifiers::VOLATILE);
    }

    Qualifier::Qualifier(NonTerminal *lexeme, int qualifier)
        : NonTerminal(lexeme), is_terminal(false), qualifiers(std::vector<QualifierSpecifiers>{})
    {
        if (qualifier & (int)QualifierSpecifiers::NONE)
            qualifiers.push_back(QualifierSpecifiers::NONE);
        if (qualifier & (int)QualifierSpecifiers::CONST)
            qualifiers.push_back(QualifierSpecifiers::CONST);
        if (qualifier & (int)QualifierSpecifiers::VOLATILE)
            qualifiers.push_back(QualifierSpecifiers::VOLATILE);
    }

    std::vector<QualifierSpecifiers> Qualifier::get_qualifiers() const
    {
        return qualifiers;
    }

    Qualifier Qualifier::operator+(const Qualifier &other) const
    {
        switch (qualifiers.size())
        {
        case 0:
            return other;
        case 1:
        {
            switch (qualifiers.front())
            {
            case QualifierSpecifiers::NONE:
                return other;
            case QualifierSpecifiers::CONST:
            {
                if (other.qualifiers.size() == 2)
                {
                    // Error because we cannot combine const with (const and volatile)
                    throw std::runtime_error("Invalid qualifier combination, cannot combine const with (const and volatile)");
                }

                if (other.qualifiers.size() == 0)
                {
                    return *this;
                }

                // Make sure other is either none or volatile
                if (other.qualifiers.front() == QualifierSpecifiers::NONE)
                {
                    return *this;
                }
                else if (other.qualifiers.front() == QualifierSpecifiers::VOLATILE)
                {
                    auto *nonterm = new NonTerminal("qualifiers");
                    Qualifier result(nonterm, (int)QualifierSpecifiers::CONST | (int)QualifierSpecifiers::VOLATILE);
                    return result;
                }
                else
                {
                    throw std::runtime_error("Invalid qualifier combination, const declared twice");
                }
            }
            case QualifierSpecifiers::VOLATILE:
            {
                if (other.qualifiers.size() == 2)
                {
                    // Error because we cannot combine const with (const and volatile)
                    throw std::runtime_error("Invalid qualifier combination, cannot combine volatile with (const and volatile)");
                }

                if (other.qualifiers.size() == 0)
                {
                    return *this;
                }

                // Make sure other is either none or volatile
                if (other.qualifiers.front() == QualifierSpecifiers::NONE)
                {
                    return *this;
                }
                else if (other.qualifiers.front() == QualifierSpecifiers::CONST)
                {
                    auto *nonterm = new NonTerminal("qualifiers");
                    Qualifier result(nonterm, (int)QualifierSpecifiers::CONST | (int)QualifierSpecifiers::VOLATILE);
                    return result;
                }
                else
                {
                    throw std::runtime_error("Invalid qualifier combination, volatile declared twice");
                }
            }
            }
        }
        case 2:
        {
            // Can only combine if other is empty or none
            if (other.qualifiers.size() == 0 || (other.qualifiers.size() == 1 && other.qualifiers.front() == QualifierSpecifiers::NONE))
            {
                return *this;
            }
            else
            {
                throw std::runtime_error("Invalid qualifier combination, already 2 qualifiers, cannot combine const and volatile");
            }
        }
        default:
        {
            throw std::runtime_error("Invalid qualifier combination, already 2 qualifiers, cannot combine const and volatile");
        }
        }
    }

    Node *Qualifier::as_node() const
    {
        return is_terminal ? dynamic_cast<Node *>(const_cast<Terminal *>(static_cast<const Terminal *>(this)))
                           : dynamic_cast<Node *>(const_cast<NonTerminal *>(static_cast<const NonTerminal *>(this)));
    }
}