%{
    #include <frontend/lexer/FrontendLexer.hh>
    #include <frontend/parser/frontendParser.tab.hh>
    
    using namespace frontend;
    
    #undef  YY_DECL
    #define YY_DECL int FrontendLexer::yylex(FrontendBisonParser::semantic_type *const lval, FrontendBisonParser::location_type *const lloc)
    
    #define YY_USER_INIT yylval = lval; yylloc = lloc;
    
    #define YY_USER_ACTION copyLocation();
%}

%option c++ noyywrap debug

%option yyclass="FrontendLexer"
%option prefix="yy_frontend_"

%%

%{
    using Token = FrontendBisonParser::token;
%}

\n { ++currentLine; }
[[:space:]] ;
Hello { return Token::HELLO; }
[[:alpha:]]+ { 
    yylval = new std::string(yytext);
    return Token::WORLD; 
}
. { return yytext[0]; }

%%