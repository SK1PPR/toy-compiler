%{
    #include <frontend/lexer/frontend_lexer.hpp>
    #include <frontend/parser/frontendParser.tab.hh>
    #include <frontend/utils/ast.hpp>
    
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

"auto"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::AUTO; }
"break"     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::BREAK; }
"case"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::CASE; }
"char"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::CHAR; }
"const"     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::CONST; }
"continue"  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::CONTINUE; }
"default"   { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::DEFAULT; }
"do"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::DO; }
"double"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::DOUBLE; }
"else"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::ELSE; }
"enum"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::ENUM; }
"extern"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::EXTERN; }
"float"     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::FLOAT; }
"for"       { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::FOR; }
"goto"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::GOTO; }
"if"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::IF; }
"int"       { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::INT; }
"long"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::LONG; }
"register"  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::REGISTER; }
"return"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::RETURN; }
"short"     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::SHORT; }
"signed"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::SIGNED; }
"sizeof"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::SIZEOF; }
"static"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::STATIC; }
"struct"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::STRUCT; }
"switch"    { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::SWITCH; }
"typedef"   { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::TYPEDEF; }
"union"     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::UNION; }
"unsigned"  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::UNSIGNED; }
"void"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::VOID; }
"volatile"  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::VOLATILE; }
"while"     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::WHILE; }
"_Alignas"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::ALIGNAS; }
"_Alignof"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::ALIGNOF; }
"_Atomic"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::ATOMIC; }
"_Bool"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::BOOL; }
"_Complex"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::COMPLEX; }
"_Generic"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::GENERIC; }
"_Imaginary"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::IMAGINARY; }
"_Noreturn"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::NORETURN; }
"_Static_assert"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::STATIC_ASSERT; }
"_Thread_local"      { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::KEYWORD); return Token::THREAD_LOCAL; }

{L}({L}|{D})* { 
    *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::IDENTIFIER); 
    return Token::IDENTIFIER; 
}

0[xX]{H}+{IS}?                   { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }
0{D}+{IS}?                       { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }
{D}+{IS}?                        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }
L?'(\\.|[^\\'])+\'               { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }
{D}+{E}{FS}?                     { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }
{D}*"."{D}+({E})?{FS}?           { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }
{D}+"."{D}*({E})?{FS}?           { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::CONSTANT); return Token::CONSTANT; }

L?\"(\\.|[^\\"])*\"              { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::STRING_LITERAL); return Token::STRING_LITERAL; }

"..."       { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::ELLIPSIS; }
">>="       { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::RIGHT_ASSIGN; }
"<<="       { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LEFT_ASSIGN; }
"+="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::ADD_ASSIGN; }
"-="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::SUB_ASSIGN; }
"*="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::MUL_ASSIGN; }
"/="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::DIV_ASSIGN; }
"%="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::MOD_ASSIGN; }
"&="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::AND_ASSIGN; }
"^="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::XOR_ASSIGN; }
"|="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::OR_ASSIGN; }
">>"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::RIGHT_OP; }
"<<"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LEFT_OP; }
"++"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::INC_OP; }
"--"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::DEC_OP; }
"->"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::PTR_OP; }
"&&"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::AND_OP; }
"||"        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::OR_OP; }
"<="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LE_OP; }
">="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::GE_OP; }
"=="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::EQ_OP; }
"!="        { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::NE_OP; }
";"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::SEMICOLON; }
("{"|"<%")  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LEFT_BRACE; }
("}"|"%>")  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::RIGHT_BRACE; }
","         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::COMMA; }
":"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::COLON; }
"="         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::ASSIGN; }
"("         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LEFT_PAREN; }
")"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::RIGHT_PAREN; }
("["|"<:")  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LEFT_BRACKET; }
("]"|":>")  { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::RIGHT_BRACKET; }
"."         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::DOT; }
"&"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::AMPERSAND; }
"!"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::EXCLAMATION; }
"~"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::TILDE; }
"-"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::MINUS; }
"+"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::PLUS; }
"*"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::ASTERISK; }
"/"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::SLASH; }
"%"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::PERCENT; }
"<"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::LESS_THAN; }
">"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::GREATER_THAN; }
"^"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::CARET; }
"|"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::PIPE; }
"?"         { *yylval = new Node(std::string(yytext), *yylloc, currentLine, TokenType::PUNCTUATOR); return Token::QUESTION; }

([\n]) {
    ++currentLine; 
    currentColumn = 1;
}

([ \t\v\f])* {
    // Ignore whitespace
}

. {}


%%