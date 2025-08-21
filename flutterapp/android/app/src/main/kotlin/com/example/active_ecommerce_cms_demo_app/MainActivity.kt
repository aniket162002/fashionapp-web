package com.example.active_ecommerce_cms_demo_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        try {
            super.onCreate(savedInstanceState)
        } catch (e: Exception) {
            // Log the error but don't crash
            e.printStackTrace()
            // Try to continue with basic initialization
            try {
                super.onCreate(null)
            } catch (e2: Exception) {
                e2.printStackTrace()
                // If all else fails, finish the activity gracefully
                finish()
            }
        }
    }
}
