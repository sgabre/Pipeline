#/Firmware/Application/Sample/CMakeLists.txt

# Define this application as its own project
set(APPLICATION_NAME "Sample")

# Include the Version.cmake file
include(${CMAKE_SOURCE_DIR}/.cmake/git-version.cmake)

# Now you can use the version information
message(STATUS "APPLICATION_NAME: ${APPLICATION_NAME}")
message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message(STATUS "MAJOR_VERSION: ${PROJECT_VERSION_MAJOR}")
message(STATUS "MINOR_VERSION: ${PROJECT_VERSION_MINOR}")
message(STATUS "PATCH_VERSION: ${PROJECT_VERSION_PATCH}")
message(STATUS "Git Revision: ${BUILD_GIT_REVISION}")
message(STATUS "Build Date: ${BUILD_DATE}")
message(STATUS "Install Prefix: ${CMAKE_INSTALL_PREFIX}")


# Now, configure the Version.h.in file to create Version.h with actual values
configure_file(${CMAKE_SOURCE_DIR}/.cmake/Version.h.in ${CMAKE_CURRENT_BINARY_DIR}/Version.h)

include_directories(${CMAKE_CURRENT_BINARY_DIR})


message(STATUS "Application Type: ${APPLICATION_TYPE}")
if(APPLICATION_TYPE STREQUAL "EMBEDDED_APPLICATION")
    # Path to the external library files
    set(EXTERNAL_LIB_PATH "${CMAKE_SOURCE_DIR}/Packs/Boards/STM32F403RE")

    # Specify the include directory for the external library
    include_directories("${EXTERNAL_LIB_PATH}/inc")

    message(STATUS "PACK_LIB_PATH: ${EXTERNAL_LIB_PATH}")
    message(STATUS "PACK_LIB_PATH: ${EXTERNAL_LIB_PATH}/inc")
    message(STATUS "PACK_LIB_PATH: ${EXTERNAL_LIB_PATH}/Lib")

    # Enable CMake support for ASM and C languages
    enable_language(C ASM)
endif()


# Set source files for the application
set(SOURCES
	main.c
)

if(APPLICATION_TYPE STREQUAL "EMBEDDED_APPLICATION")
    # Set source files for the application
    list(APPEND SOURCES ../Startup/Standalone-stm32f401xe-Startup.s)
endif()

# Create the executable for the application
ADD_EXECUTABLE(${APPLICATION_NAME} ${SOURCES})

# Link with the Module library if required
set(ITEMS )

if(APPLICATION_TYPE STREQUAL "EMBEDDED_APPLICATION")
    list(APPEND ITEMS "${EXTERNAL_LIB_PATH}/Lib/STM32F403RELib.a")
endif()

target_link_libraries(${APPLICATION_NAME} PRIVATE ${ITEMS})

# Include directories
TARGET_INCLUDE_DIRECTORIES(${APPLICATION_NAME} PRIVATE ${CMAKE_CURRENT_LIST_DIR})

install(TARGETS ${APPLICATION_NAME}
    RUNTIME DESTINATION bin
)
