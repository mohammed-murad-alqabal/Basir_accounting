# ===== Flutter Core & Embedding =====
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# ===== Play Core Deferred Components (not used, suppress R8 warnings) =====
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# ===== Flutter Plugin Registrant (Embedding v2) =====
-keep class **.GeneratedPluginRegistrant { *; }
-keepclassmembers class * {
    @io.flutter.embedding.engine.plugins.** *;
}

# ===== Pigeon Generated Classes (Flutter 3.22+ Platform Channels) =====
# هذه الفئات يتم استدعاؤها عبر Method Channels ديناميكياً لذا يجب حمايتها بالكامل
-keep class dev.flutter.pigeon.** { *; }
-keep class io.flutter.plugins.pigeon.** { *; }
-keep class **.SharedPreferencesApi** { *; }
-keep class **.PathProviderApi** { *; }
-keep class **.SecureStorageApi** { *; }
-keep interface dev.flutter.pigeon.** { *; }
-keep interface **.SharedPreferencesApi** { *; }
-keep interface **.PathProviderApi** { *; }
-keepclassmembers class ** {
    *** dev.flutter.pigeon.**;
    *** io.flutter.plugins.pigeon.**;
    @dev.flutter.pigeon.PigeonApi *;
}
-keepclasseswithmembernames class ** {
    native <methods>;
    @dev.flutter.pigeon.PigeonApi *;
}

# ===== shared_preferences Android =====
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-dontwarn io.flutter.plugins.sharedpreferences.**

# ===== path_provider Android =====
-keep class io.flutter.plugins.pathprovider.** { *; }
-dontwarn io.flutter.plugins.pathprovider.**

# ===== flutter_secure_storage =====
-keep class plugins.it_nomads.fluttersecurestorage.** { *; }
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn plugins.it_nomads.fluttersecurestorage.**
-dontwarn com.it_nomads.fluttersecurestorage.**

# ===== Isar Database (Native Libraries) =====
-keep class dev.isar.** { *; }
-dontwarn dev.isar.**
-keep class isar.** { *; }
-dontwarn isar.**

# ===== Supabase Flutter Libraries =====
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-dontwarn io.supabase.**
-dontwarn com.supabase.**

# ===== File Picker (Kotlin-only) =====
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-dontwarn com.mr.flutter.plugin.filepicker.**

# ===== Kotlin Coroutines (Plugin Compatibility) =====
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# ===== JSON/Serializable (Provider/Riverpod) =====
-keepattributes Signature
-keepattributes *Annotation*
-keep class **_Factory { *; }
-keep class riverpod.** { *; }
-keep class com.example.**_Serializable { *; }

# ===== ML Kit Text Recognition ProGuard rules =====
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

# Keep other ML Kit classes that might be needed
-keep class com.google.android.gms.internal.mlkit_vision_text.** { *; }
-dontwarn com.google.android.gms.internal.mlkit_vision_text.**

# Keep the Japanese and Korean classes specifically as they were causing issues
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
