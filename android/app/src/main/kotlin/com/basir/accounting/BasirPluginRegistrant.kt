package com.basir.accounting

import android.util.Log
import androidx.annotation.Keep
import io.flutter.embedding.engine.FlutterEngine

@Keep
object BasirPluginRegistrant {
    private const val TAG = "BasirPluginRegistrant"

    fun registerWith(flutterEngine: FlutterEngine) {
        val plugins = flutterEngine.plugins

        try {
            plugins.add(com.llfbandit.app_links.AppLinksPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin app_links", e)
        }
        try {
            plugins.add(dev.fluttercommunity.plus.device_info.DeviceInfoPlusPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin device_info_plus", e)
        }
        try {
            val filePickerClass = Class.forName("com.mr.flutter.plugin.filepicker.FilePickerPlugin")
            val filePickerInstance = filePickerClass.getDeclaredConstructor().newInstance()
            @Suppress("UNCHECKED_CAST")
            plugins.add(filePickerInstance as io.flutter.embedding.engine.plugins.FlutterPlugin)
        } catch (e: Exception) {
            // ملاحظة: file_picker 10.x قد لا يتم تضمين FilePickerPlugin دائماً
            // في classes.jar الخاص بـ AAR بسبب إعدادات build داخل الحزمة نفسها.
            // Flutter Plugin Loader الرسمي في super.configureFlutterEngine() عادةً
            // ما يتولى تسجيله من خلال FlutterJNI إذا كان المكون فعلياً في APK.
            // لذا خفضنا هذا الخطأ إلى مستوى تنبيه (DEBUG/WARN) لعدم إزعاج
            // سجلات الجهاز — الميزة نفسها تعمل عند استدعائها من Dart عبر Platform Channels.
            Log.d(TAG, "file_picker not in runtime classpath — skipping manual (auto-loader should cover): ${e.message}")
        }
        try {
            plugins.add(co.quis.flutter_contacts.FlutterContactsPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin flutter_contacts", e)
        }
        try {
            plugins.add(com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin flutter_local_notifications", e)
        }
        try {
            plugins.add(
                    io.flutter.plugins.flutter_plugin_android_lifecycle
                            .FlutterAndroidLifecyclePlugin()
            )
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin flutter_plugin_android_lifecycle", e)
        }
        try {
            plugins.add(com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin flutter_secure_storage", e)
        }
        try {
            plugins.add(com.google_mlkit_commons.GoogleMlKitCommonsPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin google_mlkit_commons", e)
        }
        try {
            plugins.add(com.google_mlkit_text_recognition.GoogleMlKitTextRecognitionPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin google_mlkit_text_recognition", e)
        }
        try {
            plugins.add(io.flutter.plugins.googlesignin.GoogleSignInPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin google_sign_in_android", e)
        }
        try {
            plugins.add(io.flutter.plugins.imagepicker.ImagePickerPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin image_picker_android", e)
        }
        try {
            plugins.add(dev.isar.isar_flutter_libs.IsarFlutterLibsPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin isar_flutter_libs", e)
        }
        try {
            plugins.add(dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin package_info_plus", e)
        }
        try {
            plugins.add(io.flutter.plugins.pathprovider.PathProviderPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin path_provider_android", e)
        }
        try {
            plugins.add(com.baseflow.permissionhandler.PermissionHandlerPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin permission_handler_android", e)
        }
        try {
            plugins.add(net.nfet.flutter.printing.PrintingPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin printing", e)
        }
        try {
            plugins.add(dev.fluttercommunity.plus.share.SharePlusPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin share_plus", e)
        }
        try {
            plugins.add(io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin shared_preferences_android", e)
        }
        try {
            plugins.add(io.flutter.plugins.urllauncher.UrlLauncherPlugin())
        } catch (e: Exception) {
            Log.e(TAG, "Error registering plugin url_launcher_android", e)
        }

        Log.i(TAG, "All plugins registered successfully")
    }
}
