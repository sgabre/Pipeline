#/Firmware/CMakeLists.txt

if(NOT CMAKE_BUILD_TYPE STREQUAL UnitTesting)
    add_subdirectory(Applications)
endif()




