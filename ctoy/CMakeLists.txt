# Create a library for the compiler components
file(GLOB_RECURSE CTOY_SOURCE_FILES_ALL
    *.cpp
    *.hpp
)

# Filter out test files
list(FILTER CTOY_SOURCE_FILES_ALL EXCLUDE REGEX ".*\.test\.cpp$")
list(FILTER CTOY_SOURCE_FILES_ALL EXCLUDE REGEX "main\.cpp$")
set(CTOY_SOURCE_FILES ${CTOY_SOURCE_FILES_ALL})

# Only create the library if there are source files
if(CTOY_SOURCE_FILES)
    add_library(ctoy_lib STATIC ${CTOY_SOURCE_FILES})
    target_include_directories(ctoy_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
else()
    # Create an interface library with no sources
    add_library(ctoy_lib INTERFACE)
    target_include_directories(ctoy_lib INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
endif()

# Create the main executable
add_executable(ctoy_compiler main.cpp)

# Link the executable with the library
target_link_libraries(ctoy_compiler PRIVATE ctoy_lib)

# Install the executable
install(TARGETS ctoy_compiler
    RUNTIME DESTINATION bin
)