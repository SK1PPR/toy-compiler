%require "3.2"
%language "c++"

%code requires {
    #include <string>
    #include "../utils/ast.hpp"
    #include "../lexer/frontend_lexer.hpp"
	#include <frontend/utils/types.hpp>
}

%define api.namespace {frontend}
%define api.parser.class {FrontendBisonParser}
%define api.value.type {Terminal*}
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

/* Declare non-terminals */
%nterm program
%nterm translation_unit
%nterm external_declaration
%nterm function_definition
%nterm declaration_list
%nterm declaration
%nterm declaration_specifiers
%nterm storage_class_specifier
%nterm type_specifier
%nterm struct_or_union_specifier
%nterm struct_or_union
%nterm struct_declaration_list
%nterm struct_declaration
%nterm specifier_qualifier_list
%nterm struct_declarator_list
%nterm struct_declarator
%nterm enum_specifier
%nterm enumerator_list
%nterm enumerator
%nterm type_qualifier
%nterm declarator
%nterm direct_declarator
%nterm pointer
%nterm type_qualifier_list
%nterm parameter_type_list
%nterm parameter_list
%nterm parameter_declaration
%nterm identifier_list
%nterm init_declarator_list
%nterm init_declarator
%nterm initializer
%nterm initializer_list
/* %nterm typedef_name */
%nterm compound_statement
%nterm statement_list
%nterm statement
%nterm labeled_statement
%nterm expression_statement
%nterm selection_statement
%nterm iteration_statement
%nterm jump_statement
%nterm expression
%nterm constant_expression
%nterm conditional_expression
%nterm logical_or_expression
%nterm logical_and_expression
%nterm inclusive_or_expression
%nterm exclusive_or_expression
%nterm and_expression
%nterm equality_expression
%nterm relational_expression
%nterm shift_expression
%nterm additive_expression
%nterm multiplicative_expression
%nterm cast_expression
%nterm unary_expression
%nterm postfix_expression
%nterm primary_expression
%nterm argument_expression_list
%nterm unary_operator
%nterm type_name
%nterm abstract_declarator
%nterm direct_abstract_declarator
%nterm assignment_expression
%nterm assignment_operator

/* Token declarations */
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER
%token RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token ALIGNAS ALIGNOF ATOMIC BOOL COMPLEX GENERIC IMAGINARY NORETURN STATIC_ASSERT THREAD_LOCAL
%token IDENTIFIER CONSTANT STRING_LITERAL

/* Operator precedence and associativity */
%right ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%right QUESTION COLON
%left OR_OP
%left AND_OP
%left PIPE
%left CARET
%left AMPERSAND
%left EQ_OP NE_OP
%left LESS_THAN GREATER_THAN LE_OP GE_OP
%left LEFT_OP RIGHT_OP
%left PLUS MINUS
%left ASTERISK SLASH PERCENT
%right SIZEOF UNARY
%right TILDE EXCLAMATION
%left INC_OP DEC_OP
%left DOT PTR_OP LEFT_BRACKET LEFT_PAREN

/* Punctuators */
%token ELLIPSIS
%token SEMICOLON LEFT_BRACE RIGHT_BRACE COMMA RIGHT_PAREN RIGHT_BRACKET

/* Resolve dangling else */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%expect 0

%%

primary_expression
	: IDENTIFIER
	| CONSTANT
	| STRING_LITERAL
	| LEFT_PAREN expression RIGHT_PAREN
	;

postfix_expression
	: primary_expression
	| postfix_expression LEFT_BRACKET expression RIGHT_BRACKET
	| postfix_expression LEFT_PAREN RIGHT_PAREN
	| postfix_expression LEFT_PAREN argument_expression_list RIGHT_PAREN
	| postfix_expression DOT IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list COMMA assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	| SIZEOF unary_expression
	| SIZEOF LEFT_PAREN type_name RIGHT_PAREN
	;

unary_operator
	: AMPERSAND
	| ASTERISK
	| PLUS
	| MINUS
	| TILDE
	| EXCLAMATION
	;

cast_expression
	: unary_expression
	| LEFT_PAREN type_name RIGHT_PAREN cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression ASTERISK cast_expression
	| multiplicative_expression SLASH cast_expression
	| multiplicative_expression PERCENT cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression PLUS multiplicative_expression
	| additive_expression MINUS multiplicative_expression
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression
	: shift_expression
	| relational_expression LESS_THAN shift_expression
	| relational_expression GREATER_THAN shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression
	: equality_expression
	| and_expression AMPERSAND equality_expression
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression CARET and_expression
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression PIPE exclusive_or_expression
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression QUESTION expression COLON conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: ASSIGN
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression COMMA assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers SEMICOLON
	| declaration_specifiers init_declarator_list SEMICOLON
	;

declaration_specifiers
	: storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list
	: init_declarator
	| init_declarator_list COMMA init_declarator
	;

init_declarator
	: declarator
	| declarator ASSIGN initializer
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| struct_or_union_specifier
	| enum_specifier
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE
	| struct_or_union LEFT_BRACE struct_declaration_list RIGHT_BRACE
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMICOLON
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list COMMA struct_declarator
	;

struct_declarator
	: declarator
	| COLON constant_expression
	| declarator COLON constant_expression
	;

enum_specifier
	: ENUM LEFT_BRACE enumerator_list RIGHT_BRACE
	| ENUM IDENTIFIER LEFT_BRACE enumerator_list RIGHT_BRACE
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list COMMA enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER ASSIGN constant_expression
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER
	| LEFT_PAREN declarator RIGHT_PAREN
	| direct_declarator LEFT_BRACKET constant_expression RIGHT_BRACKET
	| direct_declarator LEFT_BRACKET RIGHT_BRACKET
	| direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN
	| direct_declarator LEFT_PAREN identifier_list RIGHT_PAREN
	| direct_declarator LEFT_PAREN RIGHT_PAREN
	;

pointer
	: ASTERISK
	| ASTERISK type_qualifier_list
	| ASTERISK pointer
	| ASTERISK type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;

parameter_type_list
	: parameter_list
	| parameter_list COMMA ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list COMMA parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list COMMA IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: LEFT_PAREN abstract_declarator RIGHT_PAREN
	| LEFT_BRACKET RIGHT_BRACKET
	| LEFT_BRACKET constant_expression RIGHT_BRACKET
	| direct_abstract_declarator LEFT_BRACKET RIGHT_BRACKET
	| direct_abstract_declarator LEFT_BRACKET constant_expression RIGHT_BRACKET
	| LEFT_PAREN RIGHT_PAREN
	| LEFT_PAREN parameter_type_list RIGHT_PAREN
	| direct_abstract_declarator LEFT_PAREN RIGHT_PAREN
	| direct_abstract_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN
	;

initializer
	: assignment_expression
	| LEFT_BRACE initializer_list RIGHT_BRACE
	| LEFT_BRACE initializer_list COMMA RIGHT_BRACE
	;

initializer_list
	: initializer
	| initializer_list COMMA initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER COLON statement
	| CASE constant_expression COLON statement
	| DEFAULT COLON statement
	;

compound_statement
	: LEFT_BRACE RIGHT_BRACE
	| LEFT_BRACE statement_list RIGHT_BRACE
	| LEFT_BRACE declaration_list RIGHT_BRACE
	| LEFT_BRACE declaration_list statement_list RIGHT_BRACE
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: SEMICOLON
	| expression SEMICOLON
	;

selection_statement
	: IF LEFT_PAREN expression RIGHT_PAREN statement %prec LOWER_THAN_ELSE
	| IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement
	| SWITCH LEFT_PAREN expression RIGHT_PAREN statement
	;

iteration_statement
	: WHILE LEFT_PAREN expression RIGHT_PAREN statement
	| DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON
	| FOR LEFT_PAREN expression_statement expression_statement RIGHT_PAREN statement
	| FOR LEFT_PAREN expression_statement expression_statement expression RIGHT_PAREN statement
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON
	| CONTINUE SEMICOLON
	| BREAK SEMICOLON
	| RETURN SEMICOLON
	| RETURN expression SEMICOLON
	;

program
    : translation_unit
    ;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	| declarator declaration_list compound_statement
	| declarator compound_statement
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