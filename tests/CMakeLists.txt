find_package(GTest REQUIRED)

file(GLOB_RECURSE TEST_SOURCES *.cpp)

# Get GTest include directories
get_target_property(GTEST_INCLUDE_DIRS GTest::gtest INTERFACE_INCLUDE_DIRECTORIES)

include(GoogleTest)
foreach(SOURCE ${TEST_SOURCES})
    get_filename_component(NAME ${SOURCE} NAME_WE)
    add_executable(${NAME} ${SOURCE})
    target_link_libraries(${NAME} GTest::gtest_main)
    
    # Add include directories explicitly for VS Code IntelliSense
    target_include_directories(${NAME} PRIVATE ${GTEST_INCLUDE_DIRS})
    
    gtest_discover_tests(${NAME})
endforeach()
