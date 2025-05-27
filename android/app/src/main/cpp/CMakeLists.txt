#cmake_minimum_required(VERSION 3.4.1)
#
#file(GLOB CURL_SRC
#        "curl/lib/*.c")
#
#add_library(curl STATIC ${CURL_SRC})
#
#include_directories(curl/include)
#
#add_library(native_lib SHARED
#        native_lib.cpp)
#
#find_library(log-lib log)
#
#target_link_libraries(native_lib
#        curl
#        ${log-lib})
