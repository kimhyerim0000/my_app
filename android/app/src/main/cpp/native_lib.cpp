//
// Created by kimhy on 2025-05-27.
//

#include "native_lib.h"
#include <jni.h>
#include <string>

extern "C"
JNIEXPORT jstring JNICALL
Java_com_example_my_1app_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject /* this */) {
    std::string hello = "Hello from native curl!";
    return env->NewStringUTF(hello.c_str());
}
