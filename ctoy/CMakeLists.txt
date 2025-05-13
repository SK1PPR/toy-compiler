cmake_minimum_required(VERSION 3.10)
project(ctoy CXX)

# Add the frontend subdirectory first
add_subdirectory(frontend)

# Create the main executable
add_executable(ctoy main.cpp)

# Set up include directories
target_include_directories(ctoy SYSTEM PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Link the executable with the frontend library
target_link_libraries(ctoy PRIVATE frontend)