%require "3.2"
%language "c++"

%code requires {
    #include <string>
    #include "../lexer/location_t.hh"
    #include "../lexer/FrontendLexer.hh"
}

%define api.namespace {frontend}
%define api.parser.class {FrontendBisonParser}
%define api.value.type {std::string}
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

%token HELLO
%token WORLD

%expect 0

%%

hello_world: HELLO WORLD '!' { std::cout << "Goodbye " << $WORLD << '!' << std::endl; }

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