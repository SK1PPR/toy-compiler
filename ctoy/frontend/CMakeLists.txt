cmake_minimum_required(VERSION 3.10)

# Find required packages
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# Find all source files recursively
file(GLOB_RECURSE FRONTEND_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp"
)

# Set output directories for generated files
set(PARSER_OUTPUT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/parser)

# Generate parser files
BISON_TARGET(
    FrontendParser
    ${CMAKE_CURRENT_SOURCE_DIR}/parser/parser.yy
    ${CMAKE_CURRENT_BINARY_DIR}/frontendParser.tab.cc
    DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/frontendParser.tab.hh
    COMPILE_FLAGS "-Wcounterexamples"
)

# Generate lexer files
FLEX_TARGET(
    FrontendLexer
    ${CMAKE_CURRENT_SOURCE_DIR}/lexer/lexer.ll
    ${CMAKE_CURRENT_BINARY_DIR}/lex.yy_frontend_.cc
)

# Add dependencies between flex and bison
ADD_FLEX_BISON_DEPENDENCY(FrontendLexer FrontendParser)

# Copy generated parser files to source directory
add_custom_command(
    OUTPUT 
        ${PARSER_OUTPUT_DIR}/frontendParser.tab.cc
        ${PARSER_OUTPUT_DIR}/frontendParser.tab.hh
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_BINARY_DIR}/frontendParser.tab.cc
            ${PARSER_OUTPUT_DIR}/frontendParser.tab.cc
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_CURRENT_BINARY_DIR}/frontendParser.tab.hh
            ${PARSER_OUTPUT_DIR}/frontendParser.tab.hh
    DEPENDS ${BISON_FrontendParser_OUTPUTS}
    COMMENT "Copying generated parser files to source directory"
)

# Add custom target for the copy operation
add_custom_target(copy_parser_files ALL
    DEPENDS 
        ${PARSER_OUTPUT_DIR}/frontendParser.tab.cc
        ${PARSER_OUTPUT_DIR}/frontendParser.tab.hh
)

# Create a library for the frontend components
add_library(frontend
    ${FRONTEND_SOURCES}
    ${PARSER_OUTPUT_DIR}/frontendParser.tab.cc
    ${FLEX_FrontendLexer_OUTPUTS}
)

# Make sure files are copied before building the library
add_dependencies(frontend copy_parser_files)

# Add include directories
target_include_directories(frontend
    SYSTEM PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/..  # For <frontend/...> includes
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/lexer
        ${CMAKE_CURRENT_SOURCE_DIR}/parser
)

# Set C++ standard and compiler flags
set_target_properties(frontend PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

# Add compile definitions to avoid flex/bison warnings
target_compile_definitions(frontend PRIVATE
    YY_NO_UNISTD_H
    YY_NO_INPUT
) 