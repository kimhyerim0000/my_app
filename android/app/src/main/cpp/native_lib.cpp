//
// Created by kimhy on 2025-05-27.
//

#include "native_lib.h"
#include <jni.h>
#include <string>
#include <curl/curl.h>

// 응답 데이터를 저장할 버퍼
std::string response_data;

// 콜백 함수: curl이 받은 데이터를 response_data에 누적
size_t WriteCallback(void* contents, size_t size, size_t nmemb, void* userp) {
    response_data.append((char*)contents, size * nmemb);
    return size * nmemb;
}

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_my_1app_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {

    CURL* curl;
    CURLcode res;

    curl = curl_easy_init();
    if (curl) {
        // 요청할 URL
        curl_easy_setopt(curl, CURLOPT_URL, "https://postman-echo.com/get?hello=curl");

        // 콜백 함수와 응답 저장 버퍼 설정
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, NULL);

        // 실제 요청
        res = curl_easy_perform(curl);

        // 종료
        curl_easy_cleanup(curl);
    }

    return env->NewStringUTF(response_data.c_str());
}

