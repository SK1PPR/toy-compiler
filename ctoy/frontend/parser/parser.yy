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

        void handleTypedefDeclaration(FrontendLexer &lexer, Node* declarator) {
            if (declarator->get_node_type() == NodeType::IDENTIFIER) {
                lexer.addTypedefName(declarator->get_lexeme());
            }
        }
    }
    
    #define YYLLOC_DEFAULT(Cur, Rhs, N) calcLocation(Cur, Rhs, N)
    #define yylex lexer.yylex
}

/* Declare start symbol */
%start program

/* Make all tokens use the node type */
%type<Node*> primary_expression postfix_expression argument_expression_list
%type<Node*> unary_expression cast_expression multiplicative_expression 
%type<Node*> additive_expression shift_expression relational_expression
%type<Node*> equality_expression and_expression exclusive_or_expression
%type<Node*> inclusive_or_expression logical_and_expression logical_or_expression
%type<Node*> conditional_expression assignment_expression assignment_operator
%type<Node*> expression constant_expression declaration declaration_specifiers
%type<Node*> init_declarator_list init_declarator storage_class_specifier
%type<Node*> type_specifier struct_or_union_specifier struct_or_union
%type<Node*> struct_declaration_list struct_declaration specifier_qualifier_list
%type<Node*> struct_declarator_list struct_declarator enum_specifier
%type<Node*> enumerator_list enumerator type_qualifier declarator
%type<Node*> direct_declarator pointer type_qualifier_list parameter_type_list
%type<Node*> parameter_list parameter_declaration identifier_list type_name
%type<Node*> abstract_declarator direct_abstract_declarator initializer
%type<Node*> initializer_list statement labeled_statement compound_statement
%type<Node*> declaration_list statement_list expression_statement
%type<Node*> selection_statement iteration_statement jump_statement
%type<Node*> unary_operator program translation_unit external_declaration function_definition

/* Token declarations */
%token<Node*> AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INT LONG REGISTER
%token<Node*> RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE
%token<Node*> ALIGNAS ALIGNOF ATOMIC BOOL COMPLEX GENERIC IMAGINARY NORETURN STATIC_ASSERT THREAD_LOCAL
%token<Node*> IDENTIFIER CONSTANT STRING_LITERAL TYPEDEF_NAME

/* Operators and punctuators */
%token<Node*> ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token<Node*> QUESTION COLON
%token<Node*> OR_OP AND_OP
%token<Node*> PIPE CARET AMPERSAND
%token<Node*> EQ_OP NE_OP
%token<Node*> LESS_THAN GREATER_THAN LE_OP GE_OP
%token<Node*> LEFT_OP RIGHT_OP
%token<Node*> PLUS MINUS
%token<Node*> ASTERISK SLASH PERCENT
%token<Node*> TILDE EXCLAMATION
%token<Node*> INC_OP DEC_OP
%token<Node*> DOT PTR_OP
%token<Node*> ELLIPSIS SEMICOLON LEFT_BRACE RIGHT_BRACE COMMA LEFT_PAREN RIGHT_PAREN LEFT_BRACKET RIGHT_BRACKET

/* Resolve dangling else */
%precedence THEN
%precedence ELSE

%expect 0

%%

primary_expression
	: IDENTIFIER { 
		$$ = create_nterm("identifier"); 
		$$->add_child($1);
	}
	| CONSTANT { 
		$$ = create_nterm("constant"); 
		$$->add_child($1);
	}
	| STRING_LITERAL { 
		$$ = create_nterm("string_literal"); 
		$$->add_child($1);
	}
	| LEFT_PAREN expression RIGHT_PAREN { 
		$$ = $2; 
	}
	;

postfix_expression
	: primary_expression { $$ = $1; }
	| postfix_expression LEFT_BRACKET expression RIGHT_BRACKET {
		$$ = create_nterm("array_access");
		$$->add_child($1);
		$$->add_child($3);
	}
	| postfix_expression LEFT_PAREN RIGHT_PAREN {
		$$ = create_nterm("function_call");
		$$->add_child($1);
	}
	| postfix_expression LEFT_PAREN argument_expression_list RIGHT_PAREN {
		$$ = create_nterm("function_call");
		$$->add_child($1);
		$$->add_child($3);
	}
	| postfix_expression DOT IDENTIFIER {
		$$ = create_nterm("member_access");
		$$->add_child($1);
		$$->add_child($3);
	}
	| postfix_expression PTR_OP IDENTIFIER {
		$$ = create_nterm("pointer_member_access");
		$$->add_child($1);
		$$->add_child($3);
	}
	| postfix_expression INC_OP {
		$$ = create_nterm("post_increment");
		$$->add_child($1);
	}
	| postfix_expression DEC_OP {
		$$ = create_nterm("post_decrement");
		$$->add_child($1);
	}
	;

argument_expression_list
	: assignment_expression { $$ = $1; }
	| argument_expression_list COMMA assignment_expression { $$ = $1; $$->add_child($3); } 
	;

unary_expression
	: postfix_expression { $$ = $1; }
	| INC_OP unary_expression { $$ = $2; $$->add_child($1); }
	| DEC_OP unary_expression { $$ = $2; $$->add_child($1); }
	| unary_operator cast_expression { $$ = create_nterm("unary_expression"); $$->add_child($1); $$->add_child($2); }
	| SIZEOF unary_expression { $$ = $2; $$->add_child($1); }
	| SIZEOF LEFT_PAREN type_name RIGHT_PAREN { $$ = $3; $$->add_child($1); }
	;

unary_operator
	: AMPERSAND { $$ = $1; }
	| ASTERISK { $$ = $1; }
	| PLUS { $$ = $1; }
	| MINUS { $$ = $1; }
	| TILDE { $$ = $1; }
	| EXCLAMATION { $$ = $1; }
	;

cast_expression
	: unary_expression { $$ = $1; }
	| LEFT_PAREN type_name RIGHT_PAREN cast_expression {
		$$ = create_nterm("cast_expression");
		$$->add_child($2);
		$$->add_child($4);
	}
	;

multiplicative_expression
	: cast_expression { $$ = $1; }
	| multiplicative_expression ASTERISK cast_expression {
		$$ = create_nterm("multiplicative_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| multiplicative_expression SLASH cast_expression {
		$$ = create_nterm("multiplicative_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| multiplicative_expression PERCENT cast_expression {
		$$ = create_nterm("multiplicative_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

additive_expression
	: multiplicative_expression { $$ = $1; }
	| additive_expression PLUS multiplicative_expression {
		$$ = create_nterm("additive_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| additive_expression MINUS multiplicative_expression {
		$$ = create_nterm("additive_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

shift_expression
	: additive_expression { $$ = $1; }
	| shift_expression LEFT_OP additive_expression {
		$$ = create_nterm("shift_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| shift_expression RIGHT_OP additive_expression {
		$$ = create_nterm("shift_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

relational_expression
	: shift_expression { $$ = $1; }
	| relational_expression LESS_THAN shift_expression {
		$$ = create_nterm("relational_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| relational_expression GREATER_THAN shift_expression {
		$$ = create_nterm("relational_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| relational_expression LE_OP shift_expression {
		$$ = create_nterm("relational_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| relational_expression GE_OP shift_expression {
		$$ = create_nterm("relational_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

equality_expression
	: relational_expression { $$ = $1; }
	| equality_expression EQ_OP relational_expression {
		$$ = create_nterm("equality_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| equality_expression NE_OP relational_expression {
		$$ = create_nterm("equality_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

and_expression
	: equality_expression { $$ = $1; }
	| and_expression AMPERSAND equality_expression {
		$$ = create_nterm("and_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

exclusive_or_expression
	: and_expression { $$ = $1; }
	| exclusive_or_expression CARET and_expression {
		$$ = create_nterm("exclusive_or_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

inclusive_or_expression
	: exclusive_or_expression { $$ = $1; }
	| inclusive_or_expression PIPE exclusive_or_expression {
		$$ = create_nterm("inclusive_or_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

logical_and_expression
	: inclusive_or_expression { $$ = $1; }
	| logical_and_expression AND_OP inclusive_or_expression {
		$$ = create_nterm("logical_and_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

logical_or_expression
	: logical_and_expression { $$ = $1; }
	| logical_or_expression OR_OP logical_and_expression {
		$$ = create_nterm("logical_or_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

conditional_expression
	: logical_or_expression { $$ = $1; }
	| logical_or_expression QUESTION expression COLON conditional_expression {
		$$ = create_nterm("conditional_expression");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
		$$->add_child($4);
		$$->add_child($5);
	}
	;

assignment_expression
	: conditional_expression { $$ = $1; }
	| unary_expression assignment_operator assignment_expression { $$ = $1; }
	;

assignment_operator
	: ASSIGN { $$ = $1; }
	| MUL_ASSIGN { $$ = $1; }
	| DIV_ASSIGN { $$ = $1; }
	| MOD_ASSIGN { $$ = $1; }
	| ADD_ASSIGN { $$ = $1; }
	| SUB_ASSIGN { $$ = $1; }
	| LEFT_ASSIGN { $$ = $1; }
	| RIGHT_ASSIGN { $$ = $1; }
	| AND_ASSIGN { $$ = $1; }
	| XOR_ASSIGN { $$ = $1; }
	| OR_ASSIGN { $$ = $1; }
	;

expression
	: assignment_expression { $$ = $1; }
	| expression COMMA assignment_expression {
		$$ = create_nterm("expression");
		$$->add_child($1);
		$$->add_child($3);
	}
	;

constant_expression
	: conditional_expression { $$ = $1; }
	;

declaration
	: declaration_specifiers SEMICOLON {
		$$ = create_nterm("declaration");
		$$->add_child($1);
	}
	| declaration_specifiers init_declarator_list SEMICOLON {
		$$ = create_nterm("declaration");
		$$->add_child($1);
		$$->add_child($2);
		// Check if this is a typedef declaration
		for (const auto& spec : $1->children) {
			if (spec->type == NodeType::STORAGE_CLASS_SPECIFIER && 
				spec->children.size() > 0 &&
				spec->children[0]->value == "typedef") {
				// For each declarator in the init_declarator_list
				for (const auto& init_decl : $2->children) {
					if (init_decl->children.size() > 0 && 
						init_decl->children[0]->type == NodeType::IDENTIFIER) {
						lexer.addTypedefName(init_decl->children[0]->value);
					}
				}
				break;
			}
		}
	}
	;

declaration_specifiers
	: storage_class_specifier {
		$$ = create_nterm("declaration_specifiers");
		$$->add_child($1);
	}
	| storage_class_specifier declaration_specifiers {
		$$ = $2;
		$$->add_child($1);
	}
	| type_specifier {
		$$ = create_nterm("declaration_specifiers");
		$$->add_child($1);
	}
	| type_specifier declaration_specifiers {
		$$ = $2;
		$$->add_child($1);
	}
	| type_qualifier {
		$$ = create_nterm("declaration_specifiers");
		$$->add_child($1);
	}
	| type_qualifier declaration_specifiers {
		$$ = $2;
		$$->add_child($1);
	}
	;

init_declarator_list
	: init_declarator { $$ = create_nterm("init_declarator_list"); $$->add_child($1); }
	| init_declarator_list COMMA init_declarator { $$ = $1; $$->add_child($3); }
	;

init_declarator
	: declarator { $$ = create_nterm("init_declarator"); $$->add_child($1); }
	| declarator ASSIGN initializer {
		$$ = create_nterm("init_declarator");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

storage_class_specifier
	: TYPEDEF { $$ = create_nterm("storage_class_specifier"); $$->add_child($1); }
	| EXTERN { $$ = create_nterm("storage_class_specifier"); $$->add_child($1); }
	| STATIC { $$ = create_nterm("storage_class_specifier"); $$->add_child($1); }
	| AUTO { $$ = create_nterm("storage_class_specifier"); $$->add_child($1); }
	| REGISTER { $$ = create_nterm("storage_class_specifier"); $$->add_child($1); }
	;

type_specifier
	: VOID { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| CHAR { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| SHORT { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| INT { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| LONG { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| FLOAT { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| DOUBLE { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| SIGNED { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| UNSIGNED { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| struct_or_union_specifier { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| enum_specifier { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	| TYPEDEF_NAME { $$ = create_nterm("type_specifier"); $$->add_child($1); }
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER LEFT_BRACE struct_declaration_list RIGHT_BRACE {
		$$ = create_nterm("struct_or_union_definition");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($4);
	}
	| struct_or_union LEFT_BRACE struct_declaration_list RIGHT_BRACE {
		$$ = create_nterm("struct_or_union_definition");
		$$->add_child($1);
		$$->add_child($3);
	}
	| struct_or_union IDENTIFIER {
		$$ = create_nterm("struct_or_union_declaration");
		$$->add_child($1);
		$$->add_child($2);
	}
	;

struct_or_union
	: STRUCT { $$ = create_nterm("struct"); $$->add_child($1); }
	| UNION { $$ = create_nterm("union"); $$->add_child($1); }
	;

struct_declaration_list
	: struct_declaration { $$ = create_nterm("struct_declaration_list"); $$->add_child($1); }
	| struct_declaration_list struct_declaration { $$ = $1; $$->add_child($2); }
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list SEMICOLON {
		$$ = create_nterm("struct_declaration");
		$$->add_child($1);
		$$->add_child($2);
	}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list {
		$$ = create_nterm("specifier_qualifier_list");
		$$->add_child($1);
		$$->add_child($2);
	}
	| type_specifier { $$ = create_nterm("specifier_qualifier_list"); $$->add_child($1); }
	| type_qualifier specifier_qualifier_list {
		$$ = create_nterm("specifier_qualifier_list");
		$$->add_child($1);
		$$->add_child($2);
	}
	| type_qualifier { $$ = create_nterm("specifier_qualifier_list"); $$->add_child($1); }
	;

struct_declarator_list
	: struct_declarator { $$ = create_nterm("struct_declarator_list"); $$->add_child($1); }
	| struct_declarator_list COMMA struct_declarator { $$ = $1; $$->add_child($3); }
	;

struct_declarator
	: declarator { $$ = create_nterm("struct_declarator"); $$->add_child($1); }
	| COLON constant_expression {
		$$ = create_nterm("struct_bit_field");
		$$->add_child($1);
		$$->add_child($2);
	}
	| declarator COLON constant_expression {
		$$ = create_nterm("struct_bit_field");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

enum_specifier
	: ENUM LEFT_BRACE enumerator_list RIGHT_BRACE {
		$$ = create_nterm("enum_definition");
		$$->add_child($1);
		$$->add_child($3);
	}
	| ENUM IDENTIFIER LEFT_BRACE enumerator_list RIGHT_BRACE {
		$$ = create_nterm("enum_definition");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($4);
	}
	| ENUM IDENTIFIER {
		$$ = create_nterm("enum_declaration");
		$$->add_child($1);
		$$->add_child($2);
	}
	;

enumerator_list
	: enumerator { $$ = create_nterm("enumerator_list"); $$->add_child($1); }
	| enumerator_list COMMA enumerator { $$ = $1; $$->add_child($3); }
	;

enumerator
	: IDENTIFIER { $$ = create_nterm("enumerator"); $$->add_child($1); }
	| IDENTIFIER ASSIGN constant_expression {
		$$ = create_nterm("enumerator_with_value");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

type_qualifier
	: CONST { $$ = $1; }
	| VOLATILE { $$ = $1; }
	;

declarator
	: pointer direct_declarator {
		$$ = create_nterm("pointer_declarator");
		$$->add_child($1);
		$$->add_child($2);
	}
	| direct_declarator { $$ = $1; }
	;

direct_declarator
	: IDENTIFIER { 
		$$ = create_nterm("direct_declarator"); 
		Node* id_node = create_nterm("identifier");
		id_node->add_child($1);
		$$->add_child(id_node);
	}
	| LEFT_PAREN declarator RIGHT_PAREN { 
		$$ = $2; 
	}
	| direct_declarator LEFT_BRACKET constant_expression RIGHT_BRACKET {
		$$ = create_nterm("array_declarator");
		$$->add_child($1);
		$$->add_child($3);
	}
	| direct_declarator LEFT_BRACKET RIGHT_BRACKET {
		$$ = create_nterm("array_declarator");
		$$->add_child($1);
	}
	| direct_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN {
		$$ = create_nterm("function_declarator");
		$$->add_child($1);
		$$->add_child($3);
	}
	| direct_declarator LEFT_PAREN identifier_list RIGHT_PAREN {
		$$ = create_nterm("function_declarator");
		$$->add_child($1);
		$$->add_child($3);
	}
	| direct_declarator LEFT_PAREN RIGHT_PAREN {
		$$ = create_nterm("function_declarator");
		$$->add_child($1);
	}
	;

pointer
	: ASTERISK { $$ = create_nterm("pointer"); $$->add_child($1); }
	| ASTERISK type_qualifier_list {
		$$ = create_nterm("pointer");
		$$->add_child($1);
		$$->add_child($2);
	}
	| ASTERISK pointer {
		$$ = create_nterm("pointer");
		$$->add_child($1);
		$$->add_child($2);
	}
	| ASTERISK type_qualifier_list pointer {
		$$ = create_nterm("pointer");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

type_qualifier_list
	: type_qualifier { $$ = create_nterm("type_qualifier_list"); $$->add_child($1); }
	| type_qualifier_list type_qualifier { $$ = $1; $$->add_child($2); }
	;

parameter_type_list
	: parameter_list { $$ = $1; }
	| parameter_list COMMA ELLIPSIS {
		$$ = create_nterm("parameter_type_list");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

parameter_list
	: parameter_declaration { $$ = create_nterm("parameter_list"); $$->add_child($1); }
	| parameter_list COMMA parameter_declaration { $$ = $1; $$->add_child($3); }
	;

parameter_declaration
	: declaration_specifiers declarator {
		$$ = create_nterm("parameter_declaration");
		$$->add_child($1);
		$$->add_child($2);
	}
	| declaration_specifiers abstract_declarator {
		$$ = create_nterm("parameter_declaration");
		$$->add_child($1);
		$$->add_child($2);
	}
	| declaration_specifiers {
		$$ = create_nterm("parameter_declaration");
		$$->add_child($1);
	}
	;

identifier_list
	: IDENTIFIER { 
		$$ = create_nterm("identifier_list"); 
		Node* id_node = create_nterm("identifier");
		id_node->add_child($1);
		$$->add_child(id_node); 
	}
	| identifier_list COMMA IDENTIFIER { 
		$$ = $1; 
		Node* id_node = create_nterm("identifier");
		id_node->add_child($3);
		$$->add_child(id_node); 
	}
	;

type_name
	: specifier_qualifier_list { $$ = create_nterm("type_name"); $$->add_child($1); }
	| specifier_qualifier_list abstract_declarator {
		$$ = create_nterm("type_name");
		$$->add_child($1);
		$$->add_child($2);
	}
	;

abstract_declarator
	: pointer { $$ = create_nterm("abstract_declarator"); $$->add_child($1); }
	| direct_abstract_declarator { $$ = create_nterm("abstract_declarator"); $$->add_child($1); }
	| pointer direct_abstract_declarator {
		$$ = create_nterm("abstract_declarator");
		$$->add_child($1);
		$$->add_child($2);
	}
	;

direct_abstract_declarator
	: LEFT_PAREN abstract_declarator RIGHT_PAREN { $$ = $2; }
	| LEFT_BRACKET RIGHT_BRACKET { $$ = create_nterm("array_abstract_declarator"); }
	| LEFT_BRACKET constant_expression RIGHT_BRACKET {
		$$ = create_nterm("array_abstract_declarator");
		$$->add_child($2);
	}
	| direct_abstract_declarator LEFT_BRACKET RIGHT_BRACKET {
		$$ = create_nterm("array_abstract_declarator");
		$$->add_child($1);
	}
	| direct_abstract_declarator LEFT_BRACKET constant_expression RIGHT_BRACKET {
		$$ = create_nterm("array_abstract_declarator");
		$$->add_child($1);
		$$->add_child($3);
	}
	| LEFT_PAREN RIGHT_PAREN { $$ = create_nterm("function_abstract_declarator"); }
	| LEFT_PAREN parameter_type_list RIGHT_PAREN {
		$$ = create_nterm("function_abstract_declarator");
		$$->add_child($2);
	}
	| direct_abstract_declarator LEFT_PAREN RIGHT_PAREN {
		$$ = create_nterm("function_abstract_declarator");
		$$->add_child($1);
	}
	| direct_abstract_declarator LEFT_PAREN parameter_type_list RIGHT_PAREN {
		$$ = create_nterm("function_abstract_declarator");
		$$->add_child($1);
		$$->add_child($3);
	}
	;

initializer
	: assignment_expression { $$ = create_nterm("initializer"); $$->add_child($1); }
	| LEFT_BRACE initializer_list RIGHT_BRACE {
		$$ = create_nterm("initializer_list");
		$$->add_child($2);
	}
	| LEFT_BRACE initializer_list COMMA RIGHT_BRACE {
		$$ = create_nterm("initializer_list");
		$$->add_child($2);
	}
	;

initializer_list
	: initializer { $$ = create_nterm("initializer_list"); $$->add_child($1); }
	| initializer_list COMMA initializer { $$ = $1; $$->add_child($3); }
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
	: IDENTIFIER COLON statement {
		$$ = create_nterm("labeled_statement");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| CASE constant_expression COLON statement {
		$$ = create_nterm("case_statement");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
		$$->add_child($4);
	}
	| DEFAULT COLON statement {
		$$ = create_nterm("default_statement");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	;

compound_statement
	: LEFT_BRACE RIGHT_BRACE {
		$$ = create_nterm("compound_statement");
	}
	| LEFT_BRACE statement_list RIGHT_BRACE {
		$$ = create_nterm("compound_statement");
		$$->add_child($2);
	}
	| LEFT_BRACE declaration_list RIGHT_BRACE {
		$$ = create_nterm("compound_statement");
		$$->add_child($2);
	}
	| LEFT_BRACE declaration_list statement_list RIGHT_BRACE {
		$$ = create_nterm("compound_statement");
		$$->add_child($2);
		$$->add_child($3);
	}
	;

declaration_list
	: declaration { $$ = create_nterm("declaration_list"); $$->add_child($1); }
	| declaration_list declaration { $$ = $1; $$->add_child($2); }
	;

statement_list
	: statement { $$ = create_nterm("statement_list"); $$->add_child($1); }
	| statement_list statement { $$ = $1; $$->add_child($2); }
	;

expression_statement
	: SEMICOLON { $$ = create_nterm("empty_statement"); }
	| expression SEMICOLON { $$ = create_nterm("expression_statement"); $$->add_child($1); }
	;

selection_statement
	: IF LEFT_PAREN expression RIGHT_PAREN statement %prec THEN {
		$$ = create_nterm("if_statement");
		$$->add_child($1);
		$$->add_child($3);
		$$->add_child($5);
	}
	| IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement {
		$$ = create_nterm("if_else_statement");
		$$->add_child($1);
		$$->add_child($3);
		$$->add_child($5);
		$$->add_child($6);
		$$->add_child($7);
	}
	| SWITCH LEFT_PAREN expression RIGHT_PAREN statement {
		$$ = create_nterm("switch_statement");
		$$->add_child($1);
		$$->add_child($3);
		$$->add_child($5);
	}
	;

iteration_statement
	: WHILE LEFT_PAREN expression RIGHT_PAREN statement {
		$$ = create_nterm("while_statement");
		$$->add_child($1);
		$$->add_child($3);
		$$->add_child($5);
	}
	| DO statement WHILE LEFT_PAREN expression RIGHT_PAREN SEMICOLON {
		$$ = create_nterm("do_while_statement");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
		$$->add_child($5);
	}
	| FOR LEFT_PAREN expression_statement expression_statement RIGHT_PAREN statement {
		$$ = create_nterm("for_statement");
		$$->add_child($1);
		$$->add_child($3);
		$$->add_child($4);
		$$->add_child($6);
	}
	| FOR LEFT_PAREN expression_statement expression_statement expression RIGHT_PAREN statement {
		$$ = create_nterm("for_statement");
		$$->add_child($1);
		$$->add_child($3);
		$$->add_child($4);
		$$->add_child($5);
		$$->add_child($7);
	}
	;

jump_statement
	: GOTO IDENTIFIER SEMICOLON { 
		$$ = create_nterm("goto_statement");
		$$->add_child($2);
	}
	| CONTINUE SEMICOLON {
		$$ = create_nterm("continue_statement");
	}
	| BREAK SEMICOLON {
		$$ = create_nterm("break_statement");
	}
	| RETURN SEMICOLON {
		$$ = create_nterm("return_statement");
	}
	| RETURN expression SEMICOLON {
		$$ = create_nterm("return_statement");
		$$->add_child($2);
	}
	;

program
    : translation_unit { $$ = create_nterm("program"); $$->add_child($1); }
    ;

translation_unit
	: external_declaration { $$ = create_nterm("translation_unit"); $$->add_child($1); }
	| translation_unit external_declaration { $$ = $1; $$->add_child($2); }
	;

external_declaration
	: function_definition { $$ = create_nterm("external_declaration"); $$->add_child($1); }
	| declaration { $$ = create_nterm("external_declaration"); $$->add_child($1); }
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement {
		$$ = create_nterm("function_definition");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
		$$->add_child($4);
	}
	| declaration_specifiers declarator compound_statement {
		$$ = create_nterm("function_definition");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| declarator declaration_list compound_statement {
		$$ = create_nterm("function_definition");
		$$->add_child($1);
		$$->add_child($2);
		$$->add_child($3);
	}
	| declarator compound_statement {
		$$ = create_nterm("function_definition");
		$$->add_child($1);
		$$->add_child($2);
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