# All cmake projects need these
cmake_minimum_required(VERSION 3.16)
project(starter)

enable_testing()

# clsdk requires C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(ROOT_BINARY_DIR ${CMAKE_BINARY_DIR})

function(tester_test N)
    add_test(
        NAME t-${N}
        WORKING_DIRECTORY ${ROOT_BINARY_DIR}
        COMMAND cltester -v ${N}.wasm -s
    )
    set_tests_properties(t-${N} PROPERTIES ENVIRONMENT NODE_PATH=dist)
endfunction()

# Libraries for building contracts and tests
find_package(clsdk REQUIRED)

add_subdirectory(starter)