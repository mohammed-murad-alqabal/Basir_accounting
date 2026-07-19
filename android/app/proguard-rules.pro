# ML Kit Text Recognition ProGuard rules
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
