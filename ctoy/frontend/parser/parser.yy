%require "3.2"
%language "c++"

%code requires {
    #include <string>
    #include "../utils/ast.hpp"
    #include "../lexer/frontend_lexer.hpp"
}

%define api.namespace {frontend}
%define api.parser.class {FrontendBisonParser}
%define api.value.type {Node*}
%define api.location.type {location_t}

%locations
%define parse.error detailed
%define parse.trace

%header
%verbose

%parse-param {FrontendLexer &lexer}
%parse-param {const bool debug}

%initial-action
{
    #if YYDEBUG != 0
        set_debug_level(debug);
    #endif
};

%code {
    namespace frontend
    {
        template<typename RHS>
        void calcLocation(location_t &current, const RHS &rhs, const std::size_t n);
    }
    
    #define YYLLOC_DEFAULT(Cur, Rhs, N) calcLocation(Cur, Rhs, N)
    #define yylex lexer.yylex
}

/* Declare start symbol */
%start program

/* Declare non-terminals without types */
%nterm program
%nterm statement_list
%nterm statement

%token HELLO
%token WORLD
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER
%token RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token ALIGNAS ALIGNOF ATOMIC BOOL COMPLEX GENERIC IMAGINARY NORETURN STATIC_ASSERT THREAD_LOCAL
%token IDENTIFIER CONSTANT STRING_LITERAL

/* Punctuators */
%token ELLIPSIS RIGHT_ASSIGN LEFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN
%token RIGHT_OP LEFT_OP INC_OP DEC_OP PTR_OP AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP
%token SEMICOLON LEFT_BRACE RIGHT_BRACE COMMA COLON ASSIGN LEFT_PAREN RIGHT_PAREN LEFT_BRACKET RIGHT_BRACKET DOT AMPERSAND EXCLAMATION
%token TILDE MINUS PLUS ASTERISK SLASH PERCENT LESS_THAN GREATER_THAN CARET PIPE QUESTION

%expect 0

%%

program
    : statement_list
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : HELLO { $1->print(); }
    | WORLD { $1->print(); }
    | AUTO { $1->print(); }
    | BREAK { $1->print(); }
    | CASE { $1->print(); }
    | CHAR { $1->print(); }
    | CONST { $1->print(); }
    | CONTINUE { $1->print(); }
    | DEFAULT { $1->print(); }
    | DO { $1->print(); }
    | DOUBLE { $1->print(); }
    | ELSE { $1->print(); }
    | ENUM { $1->print(); }
    | EXTERN { $1->print(); }
    | FLOAT { $1->print(); }
    | FOR { $1->print(); }
    | GOTO { $1->print(); }
    | IF { $1->print(); }
    | INT { $1->print(); }
    | LONG { $1->print(); }
    | REGISTER { $1->print(); }
    | RETURN { $1->print(); }
    | SHORT { $1->print(); }
    | SIGNED { $1->print(); }
    | SIZEOF { $1->print(); }
    | STATIC { $1->print(); }
    | STRUCT { $1->print(); }
    | SWITCH { $1->print(); }
    | TYPEDEF { $1->print(); }
    | UNION { $1->print(); }
    | UNSIGNED { $1->print(); }
    | VOID { $1->print(); }
    | VOLATILE { $1->print(); }
    | WHILE { $1->print(); }
    | ALIGNAS { $1->print(); }
    | ALIGNOF { $1->print(); }
    | ATOMIC { $1->print(); }
    | BOOL { $1->print(); }
    | COMPLEX { $1->print(); }
    | GENERIC { $1->print(); }
    | IMAGINARY { $1->print(); }
    | NORETURN { $1->print(); }
    | STATIC_ASSERT { $1->print(); }
    | THREAD_LOCAL { $1->print(); }
    | IDENTIFIER { $1->print(); }
    | CONSTANT { $1->print(); }
    | SEMICOLON { $1->print(); }
    | LEFT_BRACE { $1->print(); }
    | RIGHT_BRACE { $1->print(); }
    | COMMA { $1->print(); }
    | COLON { $1->print(); }
    | ASSIGN { $1->print(); }
    | LEFT_PAREN { $1->print(); }
    | RIGHT_PAREN { $1->print(); }
    | LEFT_BRACKET { $1->print(); }
    | RIGHT_BRACKET { $1->print(); }
    | DOT { $1->print(); }
    | AMPERSAND { $1->print(); }
    | EXCLAMATION { $1->print(); }
    | TILDE { $1->print(); }
    | MINUS { $1->print(); }
    | PLUS { $1->print(); }
    | ASTERISK { $1->print(); }
    | SLASH { $1->print(); }
    | PERCENT { $1->print(); }
    | LESS_THAN { $1->print(); }
    | GREATER_THAN { $1->print(); }
    | CARET { $1->print(); }
    | PIPE { $1->print(); }
    | QUESTION { $1->print(); }
    | ELLIPSIS { $1->print(); }
    | RIGHT_ASSIGN { $1->print(); }
    | LEFT_ASSIGN { $1->print(); }
    | ADD_ASSIGN { $1->print(); }
    | SUB_ASSIGN { $1->print(); }
    | MUL_ASSIGN { $1->print(); }
    | DIV_ASSIGN { $1->print(); }
    | MOD_ASSIGN { $1->print(); }
    | AND_ASSIGN { $1->print(); }
    | OR_ASSIGN { $1->print(); }
    | XOR_ASSIGN { $1->print(); }
    | RIGHT_OP { $1->print(); }
    | LEFT_OP { $1->print(); }
    | INC_OP { $1->print(); }
    | DEC_OP { $1->print(); }
    | PTR_OP { $1->print(); }
    | AND_OP { $1->print(); }
    | OR_OP { $1->print(); }
    | LE_OP { $1->print(); }
    | GE_OP { $1->print(); }
    | EQ_OP { $1->print(); }
    | NE_OP { $1->print(); }
    ;

%%

namespace frontend
{
    template<typename RHS>
    inline void calcLocation(location_t &current, const RHS &rhs, const std::size_t n)
    {
        current = location_t(YYRHSLOC(rhs, 1).first, YYRHSLOC(rhs, n).second);
    }
    
    void FrontendBisonParser::error(const location_t &location, const std::string &message)
    {
        std::cerr << "Error at lines " << location << ": " << message << std::endl;
    }
}