import 'dart:convert';

import 'package:basser_app/core/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// خدمة المصادقة المحلية
///
/// تدير جميع عمليات المصادقة والأمان في التطبيق
/// تستخدم التخزين الآمن لحفظ بيانات الاعتماد
///
/// Features:
/// - إنشاء حساب جديد مع تشفير كلمة المرور
/// - تسجيل الدخول والخروج
/// - التحقق من حالة تسجيل الدخول
/// - تغيير كلمة المرور
/// - تشفير SHA-256 لكلمات المرور
///
/// Security:
/// - جميع البيانات الحساسة مشفرة
/// - استخدام FlutterSecureStorage للتخزين الآمن
/// - لا يتم تخزين كلمات المرور بشكل نصي
///
/// Example:
/// ```dart
/// final authService = AuthService(secureStorage: secureStorage);
/// await authService.createAccount('admin', 'password123');
/// final isLoggedIn = await authService.login('admin', 'password123');
/// ```
class AuthService {
  /// إنشاء خدمة المصادقة
  ///
  /// Parameters:
  /// - [secureStorage]: خدمة التخزين الآمن (مطلوب)
  AuthService({required this.secureStorage});

  /// خدمة التخزين الآمن لحفظ بيانات الاعتماد
  final FlutterSecureStorage secureStorage;

  /// التحقق من وجود حساب مسجل
  ///
  /// يتحقق من وجود اسم مستخدم محفوظ في التخزين الآمن
  ///
  /// Returns: true إذا كان هناك حساب مسجل، false إذا لم يكن
  ///
  /// Throws: [Exception] إذا حدث خطأ في القراءة من التخزين
  ///
  /// Example:
  /// ```dart
  /// final hasAccount = await authService.hasAccount();
  /// if (hasAccount) {
  ///   // انتقل إلى شاشة تسجيل الدخول
  /// } else {
  ///   // انتقل إلى شاشة الإعداد
  /// }
  /// ```
  Future<bool> hasAccount() async {
    try {
      final username = await secureStorage.read(key: StorageKeys.username);
      return username != null;
    } catch (e) {
      throw Exception('خطأ في التحقق من الحساب: $e');
    }
  }

  /// إنشاء حساب جديد
  ///
  /// ينشئ حساب مستخدم جديد مع تشفير كلمة المرور
  ///
  /// Parameters:
  /// - [username]: اسم المستخدم (3 أحرف على الأقل)
  /// - [password]: كلمة المرور (6 أحرف على الأقل)
  ///
  /// Throws:
  /// - [Exception] إذا كان اسم المستخدم أقل من 3 أحرف
  /// - [Exception] إذا كانت كلمة المرور أقل من 6 أحرف
  /// - [Exception] إذا حدث خطأ في الحفظ
  ///
  /// Security:
  /// - يتم تشفير كلمة المرور باستخدام SHA-256
  /// - يتم حفظ البيانات في التخزين الآمن
  ///
  /// Example:
  /// ```dart
  /// await authService.createAccount('admin', 'password123');
  /// ```
  Future<void> createAccount(String username, String password) async {
    try {
      // التحقق من صحة المدخلات
      if (username.isEmpty || username.length < 3) {
        throw Exception('اسم المستخدم يجب أن يكون 3 أحرف على الأقل');
      }
      if (password.isEmpty || password.length < 6) {
        throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }

      // تشفير كلمة المرور
      final passwordHash = sha256.convert(utf8.encode(password)).toString();

      // حفظ البيانات بشكل آمن
      await secureStorage.write(key: StorageKeys.username, value: username);
      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: passwordHash,
      );
      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'true');
    } catch (e) {
      throw Exception('خطأ في إنشاء الحساب: $e');
    }
  }

  /// تسجيل الدخول
  ///
  /// يتحقق من بيانات الاعتماد ويسجل دخول المستخدم
  ///
  /// Parameters:
  /// - [username]: اسم المستخدم
  /// - [password]: كلمة المرور
  ///
  /// Returns: true إذا نجح تسجيل الدخول
  ///
  /// Throws:
  /// - [Exception] إذا لم يكن هناك حساب مسجل
  /// - [Exception] إذا كان اسم المستخدم غير صحيح
  /// - [Exception] إذا كانت كلمة المرور غير صحيحة
  ///
  /// Security:
  /// - يتم مقارنة hash كلمة المرور المشفرة
  /// - لا يتم الكشف عن كلمة المرور الأصلية
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final success = await authService.login('admin', 'password123');
  ///   if (success) {
  ///     // انتقل إلى لوحة التحكم
  ///   }
  /// } catch (e) {
  ///   // عرض رسالة خطأ
  /// }
  /// ```
  Future<bool> login(String username, String password) async {
    try {
      final storedUsername =
          await secureStorage.read(key: StorageKeys.username);
      final storedPasswordHash =
          await secureStorage.read(key: StorageKeys.passwordHash);

      if (storedUsername == null || storedPasswordHash == null) {
        throw Exception('لا يوجد حساب مسجل');
      }

      if (storedUsername != username) {
        throw Exception('اسم المستخدم غير صحيح');
      }

      // التحقق من كلمة المرور
      final passwordHash = sha256.convert(utf8.encode(password)).toString();
      if (storedPasswordHash != passwordHash) {
        throw Exception('كلمة المرور غير صحيحة');
      }

      // تحديث حالة تسجيل الدخول
      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'true');
      return true;
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول: $e');
    }
  }

  /// تسجيل الخروج
  ///
  /// يسجل خروج المستخدم الحالي من التطبيق
  ///
  /// Throws: [Exception] إذا حدث خطأ في التحديث
  ///
  /// Note: لا يحذف بيانات الحساب، فقط يغير حالة تسجيل الدخول
  ///
  /// Example:
  /// ```dart
  /// await authService.logout();
  /// // انتقل إلى شاشة تسجيل الدخول
  /// ```
  Future<void> logout() async {
    try {
      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'false');
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: $e');
    }
  }

  /// التحقق من حالة تسجيل الدخول
  ///
  /// يتحقق من حالة تسجيل الدخول الحالية للمستخدم
  ///
  /// Returns: true إذا كان المستخدم مسجل دخوله، false إذا لم يكن
  ///
  /// Note: يرجع false في حالة حدوث أي خطأ
  ///
  /// Example:
  /// ```dart
  /// final isLoggedIn = await authService.isLoggedIn();
  /// if (isLoggedIn) {
  ///   // المستخدم مسجل دخوله
  /// } else {
  ///   // المستخدم غير مسجل دخوله
  /// }
  /// ```
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await secureStorage.read(key: StorageKeys.isLoggedIn);
      return isLoggedIn == 'true';
    } on Exception {
      return false;
    }
  }

  /// الحصول على اسم المستخدم الحالي
  ///
  /// يسترجع اسم المستخدم المسجل من التخزين الآمن
  ///
  /// Returns: اسم المستخدم أو null إذا لم يكن موجود أو حدث خطأ
  ///
  /// Example:
  /// ```dart
  /// final username = await authService.getCurrentUsername();
  /// if (username != null) {
  ///   print('مرحباً $username');
  /// }
  /// ```
  Future<String?> getCurrentUsername() async {
    try {
      return await secureStorage.read(key: StorageKeys.username);
    } on Exception {
      return null;
    }
  }

  /// تغيير كلمة المرور
  ///
  /// يغير كلمة مرور المستخدم الحالي
  ///
  /// Parameters:
  /// - [oldPassword]: كلمة المرور القديمة للتحقق
  /// - [newPassword]: كلمة المرور الجديدة (6 أحرف على الأقل)
  ///
  /// Throws:
  /// - [Exception] إذا لم يكن هناك حساب مسجل
  /// - [Exception] إذا كانت كلمة المرور القديمة غير صحيحة
  /// - [Exception] إذا كانت كلمة المرور الجديدة أقل من 6 أحرف
  ///
  /// Security:
  /// - يتم التحقق من كلمة المرور القديمة أولاً
  /// - يتم تشفير كلمة المرور الجديدة باستخدام SHA-256
  ///
  /// Example:
  /// ```dart
  /// await authService.changePassword('oldPass123', 'newPass456');
  /// ```
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final storedPasswordHash =
          await secureStorage.read(key: StorageKeys.passwordHash);

      if (storedPasswordHash == null) {
        throw Exception('لا يوجد حساب مسجل');
      }

      // التحقق من كلمة المرور القديمة
      final oldPasswordHash =
          sha256.convert(utf8.encode(oldPassword)).toString();
      if (storedPasswordHash != oldPasswordHash) {
        throw Exception('كلمة المرور القديمة غير صحيحة');
      }

      // التحقق من صحة كلمة المرور الجديدة
      if (newPassword.isEmpty || newPassword.length < 6) {
        throw Exception('كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل');
      }

      // تشفير وحفظ كلمة المرور الجديدة
      final newPasswordHash =
          sha256.convert(utf8.encode(newPassword)).toString();
      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: newPasswordHash,
      );
    } catch (e) {
      throw Exception('خطأ في تغيير كلمة المرور: $e');
    }
  }
}
