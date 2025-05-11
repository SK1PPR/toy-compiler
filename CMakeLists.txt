cmake_minimum_required(VERSION 3.14)
set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")
project(ctoy)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enable testing
enable_testing()

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)

# Add source files
add_subdirectory(ctoy)
add_subdirectory(tests)
# add_subdirectory(examples)