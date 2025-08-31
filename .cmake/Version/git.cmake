#/TestHarness/Resources/Git.cmake

# Get full Git revision (commit hash)
execute_process(
    COMMAND git rev-parse HEAD
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_REVISION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Set a default value if Git is unavailable or the command fails
if(NOT GIT_REVISION)
    set(GIT_REVISION "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
endif()

# Get detailed build date
execute_process(
    COMMAND date "+%d-%m-%Y %H:%M:%S"
    OUTPUT_VARIABLE BUILD_DATE
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Optionally, for Windows, use PowerShell to get the date
if(WIN32)
    execute_process(
        COMMAND powershell -Command "(Get-Date).ToString('dd-MM-yyyy HH:mm:ss')"
        OUTPUT_VARIABLE BUILD_DATE
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

# Store the version, revision, and date in variables for use in other parts of the project
set(BUILD_GIT_REVISION ${GIT_REVISION})
set(BUILD_DATE ${BUILD_DATE})

# Optionally, you can also create a header file (info.h) with the version and revision info
#configure_file(${CMAKE_CURRENT_LIST_DIR}/CMake/Version.h.in ${CMAKE_BINARY_DIR}/Application/Version.h)

# Optionally, include directories for version information
#include_directories(${CMAKE_BINARY_DIR}/Application)
