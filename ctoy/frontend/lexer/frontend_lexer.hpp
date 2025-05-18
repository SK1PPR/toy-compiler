#pragma once

#include <string>
#include <memory>
#include <frontend/utils/ast.hpp>

#if !defined(yyFlexLexerOnce)
#define yyFlexLexer yy_frontend_FlexLexer
#include <FlexLexer.h>
#undef yyFlexLexer
#endif

namespace frontend
{
    // Forward declarations
    class FrontendBisonParser;

    // Define the semantic type as Node* since both Terminal and NonTerminal inherit from it
    using semantic_type = Node **;
    using location_type = location_t;

    class FrontendLexer : public yy_frontend_FlexLexer
    {
        std::size_t currentLine = 1;
        std::size_t currentColumn = 1;

        Node **yylval = nullptr;
        location_type *yylloc = nullptr;

        void copyValue(const std::size_t leftTrim = 0, const std::size_t rightTrim = 0, const bool trimCr = false);
        void copyLocation() { *yylloc = location_t(currentLine, currentLine); }

    public:
        FrontendLexer(std::istream &in, const bool debug) : yy_frontend_FlexLexer(&in) { yy_frontend_FlexLexer::set_debug(debug); }

        int yylex(Node **lval, location_type *const lloc);
    };

    inline void FrontendLexer::copyValue(const std::size_t leftTrim, const std::size_t rightTrim, const bool trimCr)
    {
        std::size_t endPos = yyleng - rightTrim;
        if (trimCr && endPos != 0 && yytext[endPos - 1] == '\r')
            --endPos;
        *yylval = new Terminal(std::string(yytext + leftTrim, yytext + endPos), location_t(currentLine, currentLine), 0, TokenType::IDENTIFIER);
    }
}