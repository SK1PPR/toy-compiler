#pragma once

#include <string>
#include <memory>
#include <unordered_set>
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
    using semantic_type = std::shared_ptr<Node>;
    using location_type = location_t;

    class FrontendLexer : public yy_frontend_FlexLexer
    {
        std::size_t currentLine = 1;
        std::size_t currentColumn = 1;

        semantic_type *yylval = nullptr;
        location_type *yylloc = nullptr;
        std::unordered_set<std::string> typedefNames;

        void copyValue(const std::size_t leftTrim = 0, const std::size_t rightTrim = 0, const bool trimCr = false);
        void copyLocation() { *yylloc = location_t(currentLine, currentLine); }

    public:
        FrontendLexer(std::istream &in, const bool debug) : yy_frontend_FlexLexer(&in) { yy_frontend_FlexLexer::set_debug(debug); }

        int yylex(semantic_type *const lval, location_type *const lloc);
        void addTypedefName(const std::string &name) { typedefNames.insert(name); }
        bool isTypedefName(const std::string &name) const { return typedefNames.count(name) > 0; }
    };

    inline void FrontendLexer::copyValue(const std::size_t leftTrim, const std::size_t rightTrim, const bool trimCr)
    {
        std::size_t endPos = yyleng - rightTrim;
        if (trimCr && endPos != 0 && yytext[endPos - 1] == '\r')
            --endPos;
        std::string text(yytext + leftTrim, yytext + endPos);
        NodeType type = isTypedefName(text) ? NodeType::TYPEDEF_NAME : NodeType::IDENTIFIER;
        *yylval = std::make_shared<Node>(text, location_t(currentLine, currentLine), 0, type);
    }
}