/// Mock Secure Storage - محاكاة للتخزين الآمن
///
/// يوفر تطبيق وهمي لـ FlutterSecureStorage للاستخدام في الاختبارات
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mock implementation لـ FlutterSecureStorage
///
/// يخزن البيانات في Map في الذاكرة بدلاً من التخزين الآمن الفعلي.
/// مفيد للاختبارات لتجنب الاعتماد على النظام الفعلي.
///
/// ملاحظة: هذا Mock بسيط يوفر فقط الدوال الأساسية المستخدمة في الاختبارات.
class MockSecureStorage extends FlutterSecureStorage {
  MockSecureStorage() : super();

  final Map<String, String> _storage = {};

  /// للتحكم في محاكاة الأخطاء في الاختبارات
  bool shouldThrowOnRead = false;
  bool shouldThrowOnWrite = false;

  /// كتابة قيمة في التخزين
  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (shouldThrowOnWrite) {
      throw Exception('Mock storage write error');
    }
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }

  /// قراءة قيمة من التخزين
  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (shouldThrowOnRead) {
      throw Exception('Mock storage read error');
    }
    return _storage[key];
  }

  /// حذف قيمة من التخزين
  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.remove(key);
  }

  /// حذف جميع القيم من التخزين
  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.clear();
  }

  /// التحقق من وجود مفتاح في التخزين
  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      _storage.containsKey(key);

  /// قراءة جميع القيم من التخزين
  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async =>
      Map.from(_storage);

  /// دالة مساعدة للحصول على جميع المفاتيح المخزنة
  Set<String> get keys => _storage.keys.toSet();

  /// دالة مساعدة للحصول على عدد العناصر المخزنة
  int get length => _storage.length;

  /// دالة مساعدة للتحقق من أن التخزين فارغ
  bool get isEmpty => _storage.isEmpty;

  /// دالة مساعدة لمسح جميع البيانات (للاختبارات)
  void clear() {
    _storage.clear();
  }
}
