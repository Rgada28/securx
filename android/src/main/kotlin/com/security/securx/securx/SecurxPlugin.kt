package com.security.securx.securx

import android.app.Activity
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.pm.PackageManager
import android.content.pm.Signature
import java.security.MessageDigest


/** SexurxPlugin */
// Implement ActivityAware to get access to the Activity
class SecurxPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private var applicationContext: Context? = null
    private var activity: Activity? = null

    // Called when the plugin is first attached to a FlutterEngine.
    // Provides the application context.
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
                channel = MethodChannel(flutterPluginBinding.binaryMessenger, "securx")
        channel.setMethodCallHandler(this)
    }

    // Handles method calls from Flutter.
    override fun onMethodCall(call: MethodCall, result: Result) {
        // Ensure context is available before proceeding with calls that need it
        val currentContext = applicationContext
        if (currentContext == null) {
            result.error("UNAVAILABLE", "Plugin not attached to context.", null)
            return
        }

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isDeviceSafe" -> {
                result.success(isDeviceSafe(call, currentContext))
            }
            "isDeviceRooted" -> {
                result.success(RootCheck(currentContext).isRooted())
            }
            "isDeveloperModeEnabled" -> {
                result.success(isDeveloperModeEnabled(currentContext))
            }
            "isDebuggingModeEnable" -> {
                result.success(DebuggingModeCheck(currentContext).isDebuggingModeEnabled())
            }
            "isEmulator" -> {
                result.success(EmulatorCheck().isEmulator())
            }
            "enableScreenshot" -> {
    if (activity != null) {
        Log.d("Securx", "Enabling screenshot (clearing FLAG_SECURE)")
        result.success(ScreenshotProtection(activity).turnScreenshotOn())
    } else {
        Log.e("Securx", "Activity is null when enabling screenshot")
        result.error("UNAVAILABLE", "Activity not available for screenshot protection.", null)
    }
}
"disableScreenshot" -> {
    if (activity != null) {
        Log.d("Securx", "Disabling screenshot (setting FLAG_SECURE)")
        result.success(ScreenshotProtection(activity).turnScreenshotOff())
    } else {
        Log.e("Securx", "Activity is null when disabling screenshot")
        result.error("UNAVAILABLE", "Activity not available for screenshot protection.", null)
    }
}
            "isDebuggerAttached" -> {
                result.success(DebuggerProtection().isDebuggerAttached())
            }
            "isAppCloned" -> {
                // App clone checking might require an Activity
                if (activity != null) {
                    result.success(AppCloneChecker(call, activity).appCloneChecker())
                } else {
                    result.error("UNAVAILABLE", "Activity not available for app clone check.", null)
                }
            }
            "getAppSignature" -> {
                result.success(getAppSignature(currentContext))
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    // Helper function to check device safety, now accepting Context
    fun isDeviceSafe(call: MethodCall, context: Context): Boolean {
        return !RootCheck(context).isRooted() &&
                !isDeveloperModeEnabled(context) &&
                !DebuggingModeCheck(context).isDebuggingModeEnabled() &&
                !EmulatorCheck().isEmulator() &&
                !DebuggerProtection().isDebuggerAttached() &&
                // Pass activity here if AppCloneChecker truly needs it
                !AppCloneChecker(call, activity).appCloneChecker()
    }

    // Helper function to check developer mode, now accepting Context
    fun isDeveloperModeEnabled(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return Settings.Secure.getInt(
                context.contentResolver,
                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
            ) != 0
        } else {
            return false
        }
    }

    private fun getAppSignature(context: Context): String? {
        try {
            val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            } else {
                @Suppress("DEPRECATION")
                context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)
            }

            val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                if (packageInfo.signingInfo.hasMultipleSigners()) {
                    packageInfo.signingInfo.apkContentsSigners
                } else {
                    packageInfo.signingInfo.signingCertificateHistory
                }
            } else {
                @Suppress("DEPRECATION")
                packageInfo.signatures
            }

            if (signatures == null || signatures.isEmpty()) return null

            // We return the hash of the first signature
            val signature = signatures[0]
            val md = MessageDigest.getInstance("SHA-256")
            val digest = md.digest(signature.toByteArray())
            return digest.joinToString("") { "%02x".format(it) }
        } catch (e: Exception) {
            Log.e("Securx", "Error getting app signature", e)
            return null
        }
    }

    // Called when the plugin is detached from the FlutterEngine.
    // Clean up references to prevent memory leaks.
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        applicationContext = null // Clear context reference
    }

    // ActivityAware methods:
    // Called when the plugin is attached to an Activity.
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        // If your plugin needs to listen for activity lifecycle events,
        // you can add a listener here: binding.addActivityResultListener(this)
    }

    // Called when the Activity is detached due to configuration changes.
    override fun onDetachedFromActivityForConfigChanges() {
        activity = null // Clear activity reference
    }

    // Called when the Activity is re-attached after configuration changes.
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    // Called when the Activity is completely detached (e.g., app closed).
    override fun onDetachedFromActivity() {
        activity = null // Clear activity reference
    }
}
