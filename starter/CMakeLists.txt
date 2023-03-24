# Build starter.wasm contract
add_executable(starter src/starter.cpp)
target_include_directories(starter PUBLIC include)
target_link_libraries(starter eosio-contract-simple-malloc)
set_target_properties(starter PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${ROOT_BINARY_DIR})

# Generate starter.abi
add_executable(starter-abigen src/starter.cpp)
target_include_directories(starter-abigen PRIVATE include)
target_link_libraries(starter-abigen eosio-contract-abigen)
add_custom_command(TARGET starter-abigen POST_BUILD
    COMMAND cltester starter-abigen.wasm >${ROOT_BINARY_DIR}/starter.abi
)

function(create_testing test_file suffix)
    add_executable(${test_file}${suffix} tests/${test_file}.cpp src/starter.cpp)
    target_include_directories(${test_file}${suffix} PUBLIC include)
    target_include_directories(${test_file}${suffix} PUBLIC ./tests/include)
    target_link_libraries(${test_file}${suffix} cltestlib${suffix})
    set_target_properties(${test_file}${suffix} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${ROOT_BINARY_DIR})
endfunction()

create_testing("test-starter" "")
create_testing("test-starter" "-debug")
tester_test(test-starter)

