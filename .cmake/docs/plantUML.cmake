# Define the source directory for your PlantUML files
set(PLANTUML_SRC_DIR "${CMAKE_SOURCE_DIR}/Documents/UML")

# Define the output directory for your generated UML images
set(PLANTUML_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/Documents/Images")

# Ensure the output directory exists
file(MAKE_DIRECTORY ${PLANTUML_OUTPUT_DIR})

# Add a custom target to generate UML diagrams
add_custom_target(generate_uml
    COMMAND plantuml -o ${PLANTUML_OUTPUT_DIR} ${PLANTUML_SRC_DIR}/*.puml
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Generating UML diagrams with PlantUML CLI"
)

# Optionally, make it depend on the `all` target so it's built by default
add_dependencies(all generate_uml)