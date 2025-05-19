%require "3.2"
%language "c++"

%code requires {
    #include <string>
    #include <memory>
    #include <frontend/utils/ast.hpp>
    #include <frontend/lexer/frontend_lexer.hpp>
	#include <frontend/utils/types.hpp>
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

/* Token declarations */
%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER
%token RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token ALIGNAS ALIGNOF ATOMIC BOOL COMPLEX GENERIC IMAGINARY NORETURN STATIC_ASSERT THREAD_LOCAL
%token IDENTIFIER CONSTANT STRING_LITERAL

/* Operator precedence and associativity */
%token ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token QUESTION COLON
%token OR_OP
%token AND_OP
%token PIPE
%token CARET
%token AMPERSAND
%token EQ_OP NE_OP
%token LESS_THAN GREATER_THAN LE_OP GE_OP
%token LEFT_OP RIGHT_OP
%token PLUS MINUS
%token ASTERISK SLASH PERCENT
%token TILDE EXCLAMATION
%token INC_OP DEC_OP
%token DOT PTR_OP LEFT_BRACKET LEFT_PAREN

/* Punctuators */
%token ELLIPSIS
%token SEMICOLON LEFT_BRACE RIGHT_BRACE COMMA RIGHT_PAREN RIGHT_BRACKET

/* Declare types for values */
%type <Terminal*> IDENTIFIER CONSTANT STRING_LITERAL
%type <Terminal*> AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER
%type <Terminal*> RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%type <Terminal*> ALIGNAS ALIGNOF ATOMIC BOOL COMPLEX GENERIC IMAGINARY NORETURN STATIC_ASSERT THREAD_LOCAL
%type <Terminal*> ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%type <Terminal*> QUESTION COLON OR_OP AND_OP PIPE CARET AMPERSAND EQ_OP NE_OP
%type <Terminal*> LESS_THAN GREATER_THAN LE_OP GE_OP LEFT_OP RIGHT_OP PLUS MINUS ASTERISK SLASH PERCENT
%type <Terminal*> TILDE EXCLAMATION INC_OP DEC_OP DOT PTR_OP LEFT_BRACKET LEFT_PAREN
%type <Terminal*> ELLIPSIS SEMICOLON LEFT_BRACE RIGHT_BRACE COMMA RIGHT_PAREN RIGHT_BRACKET

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
%nterm type_name
%nterm abstract_declarator
%nterm direct_abstract_declarator
%nterm assignment_expression
%nterm assignment_operator

/* Resolve dangling else */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%expect 0

%%

primary_expression
	: IDENTIFIER {
		auto nt = new NonTerminal("primary_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| CONSTANT {
		auto nt = new NonTerminal("primary_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| STRING_LITERAL {
		auto nt = new NonTerminal("primary_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_PAREN expression RIGHT_PAREN {
		auto nt = new NonTerminal("primary_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

postfix_expression
	: primary_expression {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression LEFT_BRACKET expression RIGHT_BRACKET {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression LEFT_PAREN RIGHT_PAREN {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression LEFT_PAREN argument_expression_list RIGHT_PAREN {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression DOT IDENTIFIER {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression PTR_OP IDENTIFIER {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression INC_OP {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| postfix_expression DEC_OP {
		auto nt = new NonTerminal("postfix_expression");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

argument_expression_list
	: assignment_expression {
		auto nt = new NonTerminal("argument_expression_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| argument_expression_list COMMA assignment_expression {
		auto nt = new NonTerminal("argument_expression_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

unary_expression
	: postfix_expression {
		auto nt = new NonTerminal("unary_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| INC_OP unary_expression {
		auto nt = new NonTerminal("unary_expression");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| DEC_OP unary_expression {
		auto nt = new NonTerminal("unary_expression");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| unary_operator cast_expression {
		auto nt = new NonTerminal("unary_expression");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| SIZEOF unary_expression {
		auto nt = new NonTerminal("unary_expression");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| SIZEOF LEFT_PAREN type_name RIGHT_PAREN {
		auto nt = new NonTerminal("unary_expression");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

unary_operator
	: AMPERSAND { 
		auto nt = new NonTerminal("unary_operator"); 
		nt->add_child(yystack_[0].value); 
		yylhs.value = nt;
	}
	| ASTERISK { 
		auto nt = new NonTerminal("unary_operator"); 
		nt->add_child(yystack_[0].value); 
		yylhs.value = nt;
	}
	| PLUS { 
		auto nt = new NonTerminal("unary_operator"); 
		nt->add_child(yystack_[0].value); 
		yylhs.value = nt;
	}
	| MINUS { 
		auto nt = new NonTerminal("unary_operator"); 
		nt->add_child(yystack_[0].value); 
		yylhs.value = nt;
	}
	| TILDE { 
		auto nt = new NonTerminal("unary_operator"); 
		nt->add_child(yystack_[0].value); 
		yylhs.value = nt;
	}
	| EXCLAMATION { 
		auto nt = new NonTerminal("unary_operator"); 
		nt->add_child(yystack_[0].value); 
		yylhs.value = nt;
	}
	;

cast_expression
	: unary_expression {
		auto nt = new NonTerminal("cast_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_PAREN type_name RIGHT_PAREN cast_expression {
		auto nt = new NonTerminal("cast_expression");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

multiplicative_expression
	: cast_expression {
		auto nt = new NonTerminal("multiplicative_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| multiplicative_expression ASTERISK cast_expression {
		auto nt = new NonTerminal("multiplicative_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| multiplicative_expression SLASH cast_expression {
		auto nt = new NonTerminal("multiplicative_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| multiplicative_expression PERCENT cast_expression {
		auto nt = new NonTerminal("multiplicative_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

additive_expression
	: multiplicative_expression {
		auto nt = new NonTerminal("additive_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| additive_expression PLUS multiplicative_expression {
		auto nt = new NonTerminal("additive_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| additive_expression MINUS multiplicative_expression {
		auto nt = new NonTerminal("additive_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

shift_expression
	: additive_expression {
		auto nt = new NonTerminal("shift_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| shift_expression LEFT_OP additive_expression {
		auto nt = new NonTerminal("shift_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| shift_expression RIGHT_OP additive_expression {
		auto nt = new NonTerminal("shift_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

relational_expression
	: shift_expression {
		auto nt = new NonTerminal("relational_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| relational_expression LESS_THAN shift_expression {
		auto nt = new NonTerminal("relational_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| relational_expression GREATER_THAN shift_expression {
		auto nt = new NonTerminal("relational_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| relational_expression LE_OP shift_expression {
		auto nt = new NonTerminal("relational_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| relational_expression GE_OP shift_expression {
		auto nt = new NonTerminal("relational_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

equality_expression
	: relational_expression {
		auto nt = new NonTerminal("equality_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| equality_expression EQ_OP relational_expression {
		auto nt = new NonTerminal("equality_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| equality_expression NE_OP relational_expression {
		auto nt = new NonTerminal("equality_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

and_expression
	: equality_expression {
		auto nt = new NonTerminal("and_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| and_expression AMPERSAND equality_expression {
		auto nt = new NonTerminal("and_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

exclusive_or_expression
	: and_expression {
		auto nt = new NonTerminal("exclusive_or_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| exclusive_or_expression CARET and_expression {
		auto nt = new NonTerminal("exclusive_or_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

inclusive_or_expression
	: exclusive_or_expression {
		auto nt = new NonTerminal("inclusive_or_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| inclusive_or_expression PIPE exclusive_or_expression {
		auto nt = new NonTerminal("inclusive_or_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

logical_and_expression
	: inclusive_or_expression {
		auto nt = new NonTerminal("logical_and_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| logical_and_expression AND_OP inclusive_or_expression {
		auto nt = new NonTerminal("logical_and_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

logical_or_expression
	: logical_and_expression {
		auto nt = new NonTerminal("logical_or_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| logical_or_expression OR_OP logical_and_expression {
		auto nt = new NonTerminal("logical_or_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

conditional_expression
	: logical_or_expression {
		auto nt = new NonTerminal("conditional_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| logical_or_expression QUESTION expression COLON conditional_expression {
		auto nt = new NonTerminal("conditional_expression");
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

assignment_expression
	: conditional_expression {
		auto nt = new NonTerminal("assignment_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| unary_expression assignment_operator assignment_expression {
		auto nt = new NonTerminal("assignment_expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

assignment_operator
	: ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| MUL_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| DIV_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| MOD_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| ADD_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| SUB_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| RIGHT_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| AND_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| XOR_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| OR_ASSIGN {
		auto nt = new NonTerminal("assignment_operator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

expression
	: assignment_expression {
		auto nt = new NonTerminal("expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| expression COMMA assignment_expression {
		auto nt = new NonTerminal("expression");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

constant_expression
	: conditional_expression {
		auto nt = new NonTerminal("constant_expression");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

declaration
	: declaration_specifiers SEMICOLON {
		auto nt = new NonTerminal("declaration");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declaration_specifiers init_declarator_list SEMICOLON {
		auto nt = new NonTerminal("declaration");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

declaration_specifiers
	: storage_class_specifier {
		auto nt = new NonTerminal("declaration_specifiers");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| storage_class_specifier declaration_specifiers {
		auto nt = new NonTerminal("declaration_specifiers");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_specifier {
		auto nt = new NonTerminal("declaration_specifiers");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_specifier declaration_specifiers {
		auto nt = new NonTerminal("declaration_specifiers");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_qualifier {
		auto nt = new NonTerminal("declaration_specifiers");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_qualifier declaration_specifiers {
		auto nt = new NonTerminal("declaration_specifiers");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

init_declarator_list
	: init_declarator {
		auto nt = new NonTerminal("init_declarator_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| init_declarator_list COMMA init_declarator {
		auto nt = new NonTerminal("init_declarator_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

init_declarator
	: declarator {
		auto nt = new NonTerminal("init_declarator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declarator ASSIGN initializer {
		auto nt = new NonTerminal("init_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

storage_class_specifier
	: TYPEDEF {
		auto nt = new NonTerminal("storage_class_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| EXTERN {
		auto nt = new NonTerminal("storage_class_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| STATIC {
		auto nt = new NonTerminal("storage_class_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| AUTO {
		auto nt = new NonTerminal("storage_class_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| REGISTER {
		auto nt = new NonTerminal("storage_class_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

type_specifier
	: VOID {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| CHAR {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| SHORT {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| INT {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LONG {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| FLOAT {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| DOUBLE {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| SIGNED {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| UNSIGNED {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| struct_or_union_specifier {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| enum_specifier {
		auto nt = new NonTerminal("type_specifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE {
		auto nt = new NonTerminal("struct_or_union_specifier");
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| struct_or_union LEFT_BRACE struct_declaration_list RIGHT_BRACE {
		auto nt = new NonTerminal("struct_or_union_specifier");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| struct_or_union IDENTIFIER {
		auto nt = new NonTerminal("struct_or_union_specifier");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

struct_or_union
	: STRUCT {
		auto nt = new NonTerminal("struct_or_union");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| UNION {
		auto nt = new NonTerminal("struct_or_union");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

struct_declaration_list
	: struct_declaration {
		auto nt = new NonTerminal("struct_declaration_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| struct_declaration_list struct_declaration {
		auto nt = new NonTerminal("struct_declaration_list");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMICOLON {
		auto nt = new NonTerminal("struct_declaration");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {
		auto nt = new NonTerminal("specifier_qualifier_list");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_specifier {
		auto nt = new NonTerminal("specifier_qualifier_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_qualifier specifier_qualifier_list {
		auto nt = new NonTerminal("specifier_qualifier_list");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_qualifier {
		auto nt = new NonTerminal("specifier_qualifier_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

struct_declarator_list
	: struct_declarator {
		auto nt = new NonTerminal("struct_declarator_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| struct_declarator_list COMMA struct_declarator {
		auto nt = new NonTerminal("struct_declarator_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

struct_declarator
	: declarator {
		auto nt = new NonTerminal("struct_declarator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| COLON constant_expression {
		auto nt = new NonTerminal("struct_declarator");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declarator COLON constant_expression {
		auto nt = new NonTerminal("struct_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

enum_specifier
	: ENUM LEFT_BRACE enumerator_list RIGHT_BRACE {
		auto nt = new NonTerminal("enum_specifier");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| ENUM IDENTIFIER LEFT_BRACE enumerator_list RIGHT_BRACE {
		auto nt = new NonTerminal("enum_specifier");
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| ENUM IDENTIFIER {
		auto nt = new NonTerminal("enum_specifier");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

enumerator_list
	: enumerator {
		auto nt = new NonTerminal("enumerator_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| enumerator_list COMMA enumerator {
		auto nt = new NonTerminal("enumerator_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

enumerator
	: IDENTIFIER {
		auto nt = new NonTerminal("enumerator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| IDENTIFIER ASSIGN constant_expression {
		auto nt = new NonTerminal("enumerator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

type_qualifier
	: CONST {
		auto nt = new NonTerminal("type_qualifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| VOLATILE {
		auto nt = new NonTerminal("type_qualifier");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

declarator
	: pointer direct_declarator {
		auto nt = new NonTerminal("declarator");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_declarator {
		auto nt = new NonTerminal("declarator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

direct_declarator
	: IDENTIFIER {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_PAREN declarator RIGHT_PAREN {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_declarator LEFT_BRACKET constant_expression RIGHT_BRACKET {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_declarator LEFT_BRACKET RIGHT_BRACKET {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_declarator LEFT_PAREN identifier_list RIGHT_PAREN {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_declarator LEFT_PAREN RIGHT_PAREN {
		auto nt = new NonTerminal("direct_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

pointer
	: ASTERISK {
		auto nt = new NonTerminal("pointer");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| ASTERISK type_qualifier_list {
		auto nt = new NonTerminal("pointer");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| ASTERISK pointer {
		auto nt = new NonTerminal("pointer");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| ASTERISK type_qualifier_list pointer {
		auto nt = new NonTerminal("pointer");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

type_qualifier_list
	: type_qualifier {
		auto nt = new NonTerminal("type_qualifier_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| type_qualifier_list type_qualifier {
		auto nt = new NonTerminal("type_qualifier_list");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

parameter_type_list
	: parameter_list {
		auto nt = new NonTerminal("parameter_type_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| parameter_list COMMA ELLIPSIS {
		auto nt = new NonTerminal("parameter_type_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

parameter_list
	: parameter_declaration {
		auto nt = new NonTerminal("parameter_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| parameter_list COMMA parameter_declaration {
		auto nt = new NonTerminal("parameter_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

parameter_declaration
	: declaration_specifiers declarator {
		auto nt = new NonTerminal("parameter_declaration");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declaration_specifiers abstract_declarator {
		auto nt = new NonTerminal("parameter_declaration");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declaration_specifiers {
		auto nt = new NonTerminal("parameter_declaration");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

identifier_list
	: IDENTIFIER {
		auto nt = new NonTerminal("identifier_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| identifier_list COMMA IDENTIFIER {
		auto nt = new NonTerminal("identifier_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

type_name
	: specifier_qualifier_list {
		auto nt = new NonTerminal("type_name");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| specifier_qualifier_list abstract_declarator {
		auto nt = new NonTerminal("type_name");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

abstract_declarator
	: pointer {
		auto nt = new NonTerminal("abstract_declarator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_abstract_declarator {
		auto nt = new NonTerminal("abstract_declarator");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| pointer direct_abstract_declarator {
		auto nt = new NonTerminal("abstract_declarator");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

direct_abstract_declarator
	: LEFT_PAREN abstract_declarator RIGHT_PAREN {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACKET RIGHT_BRACKET {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACKET constant_expression RIGHT_BRACKET {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_abstract_declarator LEFT_BRACKET RIGHT_BRACKET {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_abstract_declarator LEFT_BRACKET constant_expression RIGHT_BRACKET {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_PAREN RIGHT_PAREN {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_PAREN parameter_type_list RIGHT_PAREN {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_abstract_declarator LEFT_PAREN RIGHT_PAREN {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| direct_abstract_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN {
		auto nt = new NonTerminal("direct_abstract_declarator");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

initializer
	: assignment_expression {
		auto nt = new NonTerminal("initializer");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACE initializer_list RIGHT_BRACE {
		auto nt = new NonTerminal("initializer");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACE initializer_list COMMA RIGHT_BRACE {
		auto nt = new NonTerminal("initializer");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

initializer_list
	: initializer {
		auto nt = new NonTerminal("initializer_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| initializer_list COMMA initializer {
		auto nt = new NonTerminal("initializer_list");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

statement
	: labeled_statement {
		auto nt = new NonTerminal("statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| compound_statement {
		auto nt = new NonTerminal("statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| expression_statement {
		auto nt = new NonTerminal("statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| selection_statement {
		auto nt = new NonTerminal("statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| iteration_statement {
		auto nt = new NonTerminal("statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| jump_statement {
		auto nt = new NonTerminal("statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

labeled_statement
	: IDENTIFIER COLON statement {
		auto nt = new NonTerminal("labeled_statement");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| CASE constant_expression COLON statement {
		auto nt = new NonTerminal("labeled_statement");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| DEFAULT COLON statement {
		auto nt = new NonTerminal("labeled_statement");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

compound_statement
	: LEFT_BRACE RIGHT_BRACE {
		auto nt = new NonTerminal("compound_statement");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACE statement_list RIGHT_BRACE {
		auto nt = new NonTerminal("compound_statement");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACE declaration_list RIGHT_BRACE {
		auto nt = new NonTerminal("compound_statement");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| LEFT_BRACE declaration_list statement_list RIGHT_BRACE {
		auto nt = new NonTerminal("compound_statement");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

declaration_list
	: declaration {
		auto nt = new NonTerminal("declaration_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declaration_list declaration {
		auto nt = new NonTerminal("declaration_list");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

statement_list
	: statement {
		auto nt = new NonTerminal("statement_list");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| statement_list statement {
		auto nt = new NonTerminal("statement_list");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

expression_statement
	: SEMICOLON {
		auto nt = new NonTerminal("expression_statement");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| expression SEMICOLON {
		auto nt = new NonTerminal("expression_statement");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

selection_statement
	: IF LEFT_PAREN expression RIGHT_PAREN statement %prec LOWER_THAN_ELSE {
		auto nt = new NonTerminal("selection_statement");
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement {
		auto nt = new NonTerminal("selection_statement");
		nt->add_child(yystack_[6].value);
		nt->add_child(yystack_[5].value);
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| SWITCH LEFT_PAREN expression RIGHT_PAREN statement {
		auto nt = new NonTerminal("selection_statement");
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

iteration_statement
	: WHILE LEFT_PAREN expression RIGHT_PAREN statement {
		auto nt = new NonTerminal("iteration_statement");
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON {
		auto nt = new NonTerminal("iteration_statement");
		nt->add_child(yystack_[6].value);
		nt->add_child(yystack_[5].value);
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| FOR LEFT_PAREN expression_statement expression_statement RIGHT_PAREN statement {
		auto nt = new NonTerminal("iteration_statement");
		nt->add_child(yystack_[5].value);
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| FOR LEFT_PAREN expression_statement expression_statement expression RIGHT_PAREN statement {
		auto nt = new NonTerminal("iteration_statement");
		nt->add_child(yystack_[6].value);
		nt->add_child(yystack_[5].value);
		nt->add_child(yystack_[4].value);
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON {
		auto nt = new NonTerminal("jump_statement");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| CONTINUE SEMICOLON {
		auto nt = new NonTerminal("jump_statement");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| BREAK SEMICOLON {
		auto nt = new NonTerminal("jump_statement");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| RETURN SEMICOLON {
		auto nt = new NonTerminal("jump_statement");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| RETURN expression SEMICOLON {
		auto nt = new NonTerminal("jump_statement");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

program
    : translation_unit {
		auto nt = new NonTerminal("program");
		nt->add_child(yystack_[0].value);
		nt->dotify();
		yylhs.value = nt;
	}
    ;

translation_unit
	: external_declaration {
		auto nt = new NonTerminal("translation_unit");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| translation_unit external_declaration {
		auto nt = new NonTerminal("translation_unit");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

external_declaration
	: function_definition {
		auto nt = new NonTerminal("external_declaration");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declaration {
		auto nt = new NonTerminal("external_declaration");
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement {
		auto nt = new NonTerminal("function_definition");
		nt->add_child(yystack_[3].value);
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declaration_specifiers declarator compound_statement {
		auto nt = new NonTerminal("function_definition");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declarator declaration_list compound_statement {
		auto nt = new NonTerminal("function_definition");
		nt->add_child(yystack_[2].value);
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
	| declarator compound_statement {
		auto nt = new NonTerminal("function_definition");
		nt->add_child(yystack_[1].value);
		nt->add_child(yystack_[0].value);
		yylhs.value = nt;
	}
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