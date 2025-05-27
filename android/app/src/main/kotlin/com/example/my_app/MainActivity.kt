package com.example.my_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    companion object {
        init {
            System.loadLibrary("native_lib")
        }
    }

    external fun stringFromJNI(): String
}
