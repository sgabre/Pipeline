find_package(Doxygen REQUIRED)

# Find all .doxy files in Doxygen directory
file(GLOB DOXYGEN_FILES LIST_DIRECTORIES false ${CMAKE_SOURCE_DIR}/Doxygen/*.doxy)

# Create a global 'docs' target first
add_custom_target(docs ALL COMMENT "Generating all module documentation")

foreach(DOXY_FILE ${DOXYGEN_FILES})
    get_filename_component(MODULE_NAME ${DOXY_FILE} NAME_WE)
    add_custom_target(
        docs_${MODULE_NAME}
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXY_FILE}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/Doxygen
        COMMENT "Generating documentation for ${MODULE_NAME}"
        VERBATIM
    )
    add_dependencies(docs docs_${MODULE_NAME})  # Now docs_${MODULE_NAME} exists
endforeach()