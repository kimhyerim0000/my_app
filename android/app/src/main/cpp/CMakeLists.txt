cmake_minimum_required(VERSION 3.4.1)

# curl 소스 등록
if(NOT TARGET curl)
    file(GLOB CURL_SRC "curl/lib/*.c")
    add_library(curl STATIC ${CURL_SRC})
    include_directories("curl/include")
endif()

# native 라이브러리 정의 (curl API 사용하는 JNI)
add_library(native_lib SHARED
        native_lib.cpp)

# 안드로이드 로그 라이브러리
find_library(log-lib log)

# 연결
target_link_libraries(native_lib
        curl
        ${log-lib})
