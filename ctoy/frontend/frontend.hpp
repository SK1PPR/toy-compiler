#pragma once

#include <fstream>
#include <frontend/parser/frontendParser.tab.hh>
#include <frontend/lexer/frontend_lexer.hpp>

int parse_frontend(std::ifstream &input);