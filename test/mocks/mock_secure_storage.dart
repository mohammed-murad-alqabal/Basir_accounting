/// Mock لـ FlutterSecureStorage
///
/// يوفر هذا الملف mock object لـ FlutterSecureStorage للاستخدام في الاختبارات.
/// يحاكي سلوك التخزين الآمن بدون الحاجة للنظام الفعلي.
library;

/// Mock implementation لـ FlutterSecureStorage
///
/// يستخدم Map في الذاكرة لتخزين البيانات بدلاً من التخزين الآمن الفعلي.
///
/// مثال:
/// ```dart
/// final mockStorage = MockSecureStorage();
/// await mockStorage.write(key: 'username', value: 'test');
/// final value = await mockStorage.read(key: 'username');
/// expect(value, 'test');
/// ```
class MockSecureStorage {
  /// التخزين الداخلي في الذاكرة
  final Map<String, String> _storage = {};

  /// كتابة قيمة في التخزين
  ///
  /// [key] المفتاح
  /// [value] القيمة (إذا كانت null، يتم حذف المفتاح)
  Future<void> write({required String key, required String? value}) async {
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }

  /// قراءة قيمة من التخزين
  ///
  /// [key] المفتاح
  ///
  /// Returns القيمة أو null إذا لم يكن المفتاح موجوداً
  Future<String?> read({required String key}) async => _storage[key];

  /// قراءة جميع القيم من التخزين
  ///
  /// Returns نسخة من جميع البيانات المخزنة
  Future<Map<String, String>> readAll() async => Map.from(_storage);

  /// حذف قيمة من التخزين
  ///
  /// [key] المفتاح المراد حذفه
  Future<void> delete({required String key}) async {
    _storage.remove(key);
  }

  /// حذف جميع القيم من التخزين
  Future<void> deleteAll() async {
    _storage.clear();
  }

  /// التحقق من وجود مفتاح في التخزين
  ///
  /// [key] المفتاح
  ///
  /// Returns true إذا كان المفتاح موجوداً
  Future<bool> containsKey({required String key}) async =>
      _storage.containsKey(key);

  /// تنظيف التخزين (للاستخدام في tearDown)
  void clear() {
    _storage.clear();
  }

  /// الحصول على عدد العناصر المخزنة
  int get length => _storage.length;

  /// التحقق من أن التخزين فارغ
  bool get isEmpty => _storage.isEmpty;

  /// التحقق من أن التخزين يحتوي على بيانات
  bool get isNotEmpty => _storage.isNotEmpty;
}
