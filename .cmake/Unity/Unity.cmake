add_library(Unity STATIC ${CMAKE_SOURCE_DIR}/Unity/src/unity.c)
target_include_directories(Unity PUBLIC ${CMAKE_SOURCE_DIR}/Unity/src)
