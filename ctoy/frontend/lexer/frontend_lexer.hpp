#pragma once

#include <string>
#if !defined(yyFlexLexerOnce)
#define yyFlexLexer yy_frontend_FlexLexer
#include <FlexLexer.h>
#undef yyFlexLexer
#endif

#include <frontend/utils/ast.hpp>

namespace frontend
{
    // Forward declarations
    class FrontendBisonParser;
    using semantic_type = Node *;
    using location_type = location_t;

    class FrontendLexer : public yy_frontend_FlexLexer
    {
        std::size_t currentLine = 1;
        std::size_t currentColumn = 1;

        semantic_type *yylval = nullptr;
        location_type *yylloc = nullptr;

        void copyValue(const std::size_t leftTrim = 0, const std::size_t rightTrim = 0, const bool trimCr = false);
        void copyLocation() { *yylloc = location_t(currentLine, currentLine); }

    public:
        FrontendLexer(std::istream &in, const bool debug) : yy_frontend_FlexLexer(&in) { yy_frontend_FlexLexer::set_debug(debug); }

        int yylex(semantic_type *const lval, location_type *const lloc);
    };

    inline void FrontendLexer::copyValue(const std::size_t leftTrim, const std::size_t rightTrim, const bool trimCr)
    {
        std::size_t endPos = yyleng - rightTrim;
        if (trimCr && endPos != 0 && yytext[endPos - 1] == '\r')
            --endPos;
        *yylval = new Node(std::string(yytext + leftTrim, yytext + endPos), location_t(currentLine, currentLine), 0, TokenType::IDENTIFIER);
    }
}