/// أدوات مساعدة لتخزين إعدادات الثيم
class ThemeStorageUtils {
  /// إنشاء مفتاح تخزين خاص بالمستخدم
  ///
  /// إذا كان [username] موجوداً، يرجع مفتاحاً بصيغة: user_{username}_{baseKey}
  /// وإلا يرجع المفتاح الأساسي كما هو (للإعدادات العامة أو الضيوف).
  static String getUserSpecificKey(String baseKey, String? username) {
    if (username != null && username.isNotEmpty) {
      return 'user_${username}_$baseKey';
    }
    return baseKey;
  }
}
