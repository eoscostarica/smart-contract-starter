# Build starter.wasm contract
add_executable(starter src/starter.cpp)
target_include_directories(starter PUBLIC include)
target_link_libraries(starter eosio-contract-simple-malloc)
set_target_properties(starter PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# Build starter-debug.wasm
# This is like starter.wasm, but includes debugging information.
add_executable(starter-debug src/starter.cpp)
target_include_directories(starter-debug PRIVATE include)
target_link_libraries(starter-debug eosio-contract-simple-malloc-debug)
set_target_properties(starter-debug PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# Generate starter.abi
# This is a 2-step process:
# * Build starter.abi.wasm. This must link to eosio-contract-abigen.
# * Run the wasm to generate the abi
add_executable(starter-abigen src/starter.cpp)
target_include_directories(starter-abigen PRIVATE include)
target_link_libraries(starter-abigen eosio-contract-abigen)
add_custom_command(TARGET starter-abigen POST_BUILD
    COMMAND cltester starter-abigen.wasm >${PROJECT_BINARY_DIR}/starter.abi
)

# Builds tests.wasm
# Tests must link to either cltestlib (runs faster) or cltestlib-debug (supports debugging)
add_executable(tests tests/tests.cpp)
target_include_directories(tests PUBLIC include ./tests/include)
target_link_libraries(tests cltestlib-debug)
set_target_properties(tests PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

# These symlinks help vscode
execute_process(COMMAND ln -sf ${clsdk_DIR} ${CMAKE_CURRENT_BINARY_DIR}/clsdk)
execute_process(COMMAND ln -sf ${WASI_SDK_PREFIX} ${CMAKE_CURRENT_BINARY_DIR}/wasi-sdk)

# Generate compile_commands.json to aid vscode and other editors
set(CMAKE_EXPORT_COMPILE_COMMANDS on)