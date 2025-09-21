package com.example.ripple

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app_size_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getApkFileSize" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        try {
                            val size = getApkFileSize(packageName)
                            result.success(size)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to get APK size: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getApkFileSize(packageName: String): Long? {
        return try {
            val packageInfo = packageManager.getPackageInfo(packageName, 0)
            val apkPath = packageInfo.applicationInfo?.sourceDir
            if (apkPath != null) {
                val apkFile = File(apkPath)
                if (apkFile.exists()) {
                    apkFile.length()
                } else {
                    null
                }
            } else {
                null
            }
        } catch (e: PackageManager.NameNotFoundException) {
            // Package not found
            null
        } catch (e: Exception) {
            // Other errors
            e.printStackTrace()
            null
        }
    }
}
