%{
    #include <frontend/lexer/frontend_lexer.hpp>
    #include <frontend/parser/frontendParser.tab.hh>
    #include <frontend/utils/ast.hpp>
    #include <memory>
    
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

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS          (u|U|l|L|ll|LL|ul|uL|Ul|UL|lu|lU|Lu|LU|ull|uLL|Ull|ULL|llu|llU|LLu|LLU)

%%

%{
    using Token = FrontendBisonParser::token;
%}

"auto"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::AUTO; }
"break"     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::BREAK; }
"case"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::CASE; }
"char"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::CHAR; }
"const"     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::CONST; }
"continue"  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::CONTINUE; }
"default"   { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::DEFAULT; }
"do"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::DO; }
"double"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::DOUBLE; }
"else"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::ELSE; }
"enum"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::ENUM; }
"extern"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::EXTERN; }
"float"     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::FLOAT; }
"for"       { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::FOR; }
"goto"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::GOTO; }
"if"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::IF; }
"int"       { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::INT; }
"long"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::LONG; }
"register"  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::REGISTER; }
"return"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::RETURN; }
"short"     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::SHORT; }
"signed"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::SIGNED; }
"sizeof"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::SIZEOF; }
"static"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::STATIC; }
"struct"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::STRUCT; }
"switch"    { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::SWITCH; }
"typedef"   { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::TYPEDEF; }
"union"     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::UNION; }
"unsigned"  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::UNSIGNED; }
"void"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::VOID; }
"volatile"  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::VOLATILE; }
"while"     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::WHILE; }
"_Alignas"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::ALIGNAS; }
"_Alignof"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::ALIGNOF; }
"_Atomic"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::ATOMIC; }
"_Bool"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::BOOL; }
"_Complex"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::COMPLEX; }
"_Generic"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::GENERIC; }
"_Imaginary"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::IMAGINARY; }
"_Noreturn"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::NORETURN; }
"_Static_assert"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::STATIC_ASSERT; }
"_Thread_local"      { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::KEYWORD); return Token::THREAD_LOCAL; }

{L}({L}|{D})* { 
    *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::IDENTIFIER); 
    return Token::IDENTIFIER; 
}

0[xX]{H}+{IS}?                   { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }
0{D}+{IS}?                       { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }
{D}+{IS}?                        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }
L?'(\\.|[^\\'])+\'               { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }
{D}+{E}{FS}?                     { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }
{D}*"."{D}+({E})?{FS}?           { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }
{D}+"."{D}*({E})?{FS}?           { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::CONSTANT); return Token::CONSTANT; }

L?\"(\\.|[^\\"])*\"              { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::STRING_LITERAL); return Token::STRING_LITERAL; }

"..."       { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::ELLIPSIS; }
">>="       { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::RIGHT_ASSIGN; }
"<<="       { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LEFT_ASSIGN; }
"+="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::ADD_ASSIGN; }
"-="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::SUB_ASSIGN; }
"*="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::MUL_ASSIGN; }
"/="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::DIV_ASSIGN; }
"%="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::MOD_ASSIGN; }
"&="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::AND_ASSIGN; }
"^="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::XOR_ASSIGN; }
"|="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::OR_ASSIGN; }
">>"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::RIGHT_OP; }
"<<"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LEFT_OP; }
"++"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::INC_OP; }
"--"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::DEC_OP; }
"->"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::PTR_OP; }
"&&"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::AND_OP; }
"||"        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::OR_OP; }
"<="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LE_OP; }
">="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::GE_OP; }
"=="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::EQ_OP; }
"!="        { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::NE_OP; }
";"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::SEMICOLON; }
("{"|"<%")  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LEFT_BRACE; }
("}"|"%>")  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::RIGHT_BRACE; }
","         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::COMMA; }
":"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::COLON; }
"="         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::ASSIGN; }
"("         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LEFT_PAREN; }
")"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::RIGHT_PAREN; }
("["|"<:")  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LEFT_BRACKET; }
("]"|":>")  { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::RIGHT_BRACKET; }
"."         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::DOT; }
"&"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::AMPERSAND; }
"!"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::EXCLAMATION; }
"~"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::TILDE; }
"-"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::MINUS; }
"+"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::PLUS; }
"*"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::ASTERISK; }
"/"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::SLASH; }
"%"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::PERCENT; }
"<"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::LESS_THAN; }
">"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::GREATER_THAN; }
"^"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::CARET; }
"|"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::PIPE; }
"?"         { *yylval = std::make_shared<Node>(std::string(yytext), *yylloc, currentLine, NodeType::PUNCTUATOR); return Token::QUESTION; }

([\n]) {
    ++currentLine; 
    currentColumn = 1;
}

([ \t\v\f])* {
    // Ignore whitespace
}

. {}

%%