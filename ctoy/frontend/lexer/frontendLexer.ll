%{
    #include <frontend/lexer/FrontendLexer.hh>
    #include <frontend/parser/frontendParser.tab.hh>
    #include <frontend/util/ast.hpp>
    
    using namespace frontend;
    
    #undef  YY_DECL
    #define YY_DECL int FrontendLexer::yylex(semantic_type *const lval, location_type *const lloc)
    
    #define YY_USER_INIT yylval = lval; yylloc = lloc;
    
    #define YY_USER_ACTION \
        lloc->first = currentColumn; \
        currentColumn += yyleng; \
        lloc->second = currentColumn;
%}

%option c++ noyywrap debug

%option yyclass="FrontendLexer"
%option prefix="yy_frontend_"

%%

%{
    using Token = FrontendBisonParser::token;
%}

\n { 
    ++currentLine; 
    currentColumn = 1;
}

[[:space:]] { }

Hello { 
    *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD);
    return Token::HELLO; 
}

[[:alpha:]]+ { 
    *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::IDENTIFIER);
    return Token::WORLD; 
}

. { return yytext[0]; }

%%