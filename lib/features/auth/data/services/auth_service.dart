import 'dart:convert';
import 'dart:math';

import 'package:basser_app/core/constants.dart';
import 'package:basser_app/features/auth/domain/models/auth_models.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
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
/// final authService = <credential-fixture>(secureStorage: secureStorage,);
/// await authService.createAccount('admin', 'password123',);
/// final isLoggedIn = await authService.login('admin', 'password123',);
/// ```
class AuthService {
  /// إنشاء خدمة المصادقة
  ///
  /// Parameters:
  /// - [secureStorage]: خدمة التخزين الآمن (مطلوب)
  AuthService({required this.secureStorage});

  /// خدمة التخزين الآمن لحفظ بيانات الاعتماد
  final FlutterSecureStorage secureStorage;

  /// تنظيف البيانات التالفة أو القديمة (Industrial-Grade Robustness)
  ///
  /// يتحقق مما إذا كان هذا هو التشغيل الأول بعد إعادة التثبيت.
  /// إذا كان التخزين يحتوي على بيانات قديمة بدون علامة "التشغيل الأول"،
  /// يتم مسحها لضمان بداية نظيفة ومنع التعليق أو الأخطاء الغامضة.
  Future<void> initialize() async {
    try {
      const firstRunKey = '<credential-fixture>';
      final firstRun = await secureStorage.read(key: <credential-fixture>);

      if (firstRun == null) {
        // هذا تشغيل أول بعد التثبيت
        // نقوم بمسح أي مخلفات قديمة قد تكون بقيت من تثبيت سابق
        // (تحدث في Android)
        await secureStorage.deleteAll();
        // حفظ علامة التشغيل الأول
        await secureStorage.write(key: <credential-fixture>, value: 'done');
        debugPrint(
          '🛡️ [AUTH] First run detected. Secure storage initialized.',
        );
      }
    } on Exception catch (e) {
      debugPrint('⚠️ [AUTH] Error during initialization: $e');
    }
  }

  /// Salt ثابت للتطبيق (في بيئة إنتاج حقيقية، يجب أن يكون فريد لكل مستخدم)
  static const String _appSalt = 'basser_mvp_2025_secure_salt';

  /// تشفير كلمة المرور باستخدام SHA-256 مع Salt
  ///
  /// يطبق تشفير متعدد المراحل لتحسين الأمان:
  /// 1. إضافة salt للكلمة المرور
  /// 2. تطبيق SHA-256 عدة مرات (key stretching)
  /// 3. إضافة salt إضافي
  ///
  /// Parameters:
  /// - [password]: كلمة المرور المراد تشفيرها
  /// - [userSalt]: salt خاص بالمستخدم (اختياري)
  ///
  /// Returns: كلمة المرور المشفرة كـ hex string
  String _hashPassword(String password, [String? userSalt]) {
    // إنشاء salt مركب
    final combinedSalt = _appSalt + (userSalt ?? '');

    // المرحلة الأولى: إضافة salt وتشفير
    var hash = sha256.convert(utf8.encode(password + combinedSalt)).toString();

    // Key stretching: تطبيق التشفير 1000 مرة لزيادة الأمان
    for (var i = 0; i < 1000; i++) {
      hash = sha256.convert(utf8.encode(hash + combinedSalt)).toString();
    }

    return hash;
  }

  /// إنشاء salt عشوائي للمستخدم
  ///
  /// Returns: salt عشوائي بطول 32 حرف
  String _generateUserSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(
      16,
      (i) => random.nextInt(256),
    );
    return base64Encode(
      bytes,
    );
  }

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
      final username = await secureStorage.read(
        key: <credential-fixture>,
      );
      return username != null;
    } on Exception catch (e) {
      throw Exception(
        'خطأ في التحقق من الحساب: $e',
      );
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
  /// await authService.createAccount('admin', 'password123',);
  /// ```
  Future<void> createAccount(String username, String password) async {
    try {
      // التحقق من صحة المدخلات
      if (username.isEmpty || username.length < 3) {
        throw Exception(
          'اسم المستخدم يجب أن يكون 3 أحرف على الأقل',
        );
      }
      if (password.isEmpty || password.length < 6) {
        throw Exception(
          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      // إنشاء salt فريد للمستخدم
      final userSalt = _generateUserSalt();

      // تشفير كلمة المرور باستخدام التشفير المحسن
      final passwordHash = _hashPassword(
        password,
        userSalt,
      );

      // حفظ البيانات بشكل آمن
      await secureStorage.write(
        key: <credential-fixture>,
        value: username,
      );
      await secureStorage.write(
        key: <credential-fixture>,
        value: passwordHash,
      );
      await secureStorage.write(
        key: '${StorageKeys.username}_salt',
        value: userSalt,
      );
      await secureStorage.write(
        key: <credential-fixture>,
        value: 'true',
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في إنشاء الحساب: $e',
      );
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
  ///   final success = await authService.login('admin', 'password123',);
  ///   if (success) {
  ///     // انتقل إلى لوحة التحكم
  ///   }
  /// } on Exception catch (e) {
  ///   // عرض رسالة خطأ
  /// }
  /// ```
  Future<bool> login(String username, String password) async {
    try {
      final storedUsername = await secureStorage.read(
        key: <credential-fixture>,
      );
      final storedPasswordHash = await secureStorage.read(
        key: <credential-fixture>,
      );
      final userSalt = await secureStorage.read(
        key: '${StorageKeys.username}_salt',
      );

      if (storedUsername == null || storedPasswordHash == null) {
        throw Exception(
          'لا يوجد حساب مسجل',
        );
      }

      if (storedUsername != username) {
        throw Exception(
          'اسم المستخدم غير صحيح',
        );
      }

      // التحقق من كلمة المرور باستخدام التشفير المحسن
      final passwordHash = _hashPassword(
        password,
        userSalt,
      );
      if (storedPasswordHash != passwordHash) {
        throw Exception(
          'كلمة المرور غير صحيحة',
        );
      }

      // تحديث حالة تسجيل الدخول
      await secureStorage.write(
        key: <credential-fixture>,
        value: 'true',
      );
      return true;
    } on Exception catch (e) {
      throw Exception(
        'خطأ في تسجيل الدخول: $e',
      );
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
      await secureStorage.write(
        key: <credential-fixture>,
        value: 'false',
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في تسجيل الخروج: $e',
      );
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
      final isLoggedIn = await secureStorage.read(
        key: <credential-fixture>,
      );
      return isLoggedIn == 'true';
    } on Exception {
      return false;
    }
  }

  /// تفعيل ميزة البقاء مسجلاً
  ///
  /// يحفظ إعداد البقاء مسجلاً للدخول التلقائي
  ///
  /// Parameters:
  /// - [keepLoggedIn]: true للبقاء مسجلاً، false لعدم البقاء
  ///
  /// Example:
  /// ```dart
  /// await authService.setKeepLoggedIn(keepLoggedIn: true,);
  /// ```
  Future<void> setKeepLoggedIn({required bool keepLoggedIn}) async {
    try {
      await secureStorage.write(
        key: <credential-fixture>,
        value: keepLoggedIn.toString(),
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في حفظ إعداد البقاء مسجلاً: $e',
      );
    }
  }

  /// التحقق من إعداد البقاء مسجلاً
  ///
  /// Returns: true إذا كان البقاء مسجلاً مفعل
  ///
  /// Example:
  /// ```dart
  /// final keepLoggedIn = await authService.shouldKeepLoggedIn();
  /// ```
  Future<bool> shouldKeepLoggedIn() async {
    try {
      final keepLoggedIn = await secureStorage.read(
        key: <credential-fixture>,
      );
      return keepLoggedIn == 'true';
    } on Exception {
      return false;
    }
  }

  /// تفعيل وضع الضيف (الدخول بدون حساب)
  ///
  /// يسمح للمستخدم بالدخول كضيف بدون إنشاء حساب
  ///
  /// Example:
  /// ```dart
  /// await authService.loginAsGuest();
  /// ```
  Future<void> loginAsGuest() async {
    try {
      await secureStorage.write(
        key: <credential-fixture>,
        value: 'true',
      );
      await secureStorage.write(
        key: <credential-fixture>,
        value: 'true',
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في تسجيل الدخول كضيف: $e',
      );
    }
  }

  /// التحقق من وضع الضيف
  ///
  /// Returns: true إذا كان المستخدم ضيف
  ///
  /// Example:
  /// ```dart
  /// final isGuest = await authService.isGuest();
  /// ```
  Future<bool> isGuest() async {
    try {
      final isGuest = await secureStorage.read(
        key: <credential-fixture>,
      );
      return isGuest == 'true';
    } on Exception {
      return false;
    }
  }

  /// تحويل الضيف إلى مستخدم مسجل
  ///
  /// يسمح للضيف بإنشاء حساب والاحتفاظ ببياناته
  ///
  /// Parameters:
  /// - [username]: اسم المستخدم الجديد
  /// - [password]: كلمة المرور الجديدة
  ///
  /// Example:
  /// ```dart
  /// await authService.convertGuestToUser('admin', 'password123',);
  /// ```
  Future<void> convertGuestToUser(String username, String password) async {
    try {
      // إنشاء الحساب
      await createAccount(
        username,
        password,
      );

      // إزالة وضع الضيف
      await secureStorage.delete(
        key: <credential-fixture>,
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في تحويل الضيف إلى مستخدم: $e',
      );
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
  ///   debugPrint('مرحباً $username',);
  /// }
  /// ```
  Future<String?> getCurrentUsername() async {
    try {
      return await secureStorage.read(
        key: <credential-fixture>,
      );
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
  /// await authService.changePassword('oldPass123', 'newPass456',);
  /// ```
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final storedPasswordHash = await secureStorage.read(
        key: <credential-fixture>,
      );
      final userSalt = await secureStorage.read(
        key: '${StorageKeys.username}_salt',
      );

      if (storedPasswordHash == null) {
        throw Exception(
          'لا يوجد حساب مسجل',
        );
      }

      // التحقق من كلمة المرور القديمة باستخدام التشفير المحسن
      final oldPasswordHash = _hashPassword(
        oldPassword,
        userSalt,
      );
      if (storedPasswordHash != oldPasswordHash) {
        throw Exception(
          'كلمة المرور القديمة غير صحيحة',
        );
      }

      // التحقق من صحة كلمة المرور الجديدة
      if (newPassword.isEmpty || newPassword.length < 6) {
        throw Exception(
          'كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل',
        );
      }

      // إنشاء salt جديد لكلمة المرور الجديدة (أمان إضافي)
      final newUserSalt = _generateUserSalt();

      // تشفير وحفظ كلمة المرور الجديدة
      final newPasswordHash = _hashPassword(
        newPassword,
        newUserSalt,
      );
      await secureStorage.write(
        key: <credential-fixture>,
        value: newPasswordHash,
      );
      await secureStorage.write(
        key: '${StorageKeys.username}_salt',
        value: newUserSalt,
      );
    } on Exception catch (e) {
      throw Exception(
        'خطأ في تغيير كلمة المرور: $e',
      );
    }
  }

  /// التحقق من قوة كلمة المرور
  ///
  /// يتحقق من معايير الأمان لكلمة المرور:
  /// - الطول الأدنى 8 أحرف
  /// - وجود أحرف كبيرة وصغيرة
  /// - وجود أرقام
  /// - وجود رموز خاصة
  ///
  /// Parameters:
  /// - [password]: كلمة المرور المراد فحصها
  ///
  /// Returns: نتيجة التحقق مع التفاصيل
  PasswordStrengthResult checkPasswordStrength(String password) {
    final issues = <String>[];
    var score = 0;

    // فحص الطول
    if (password.length < 8) {
      issues.add(
        'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
      );
    } else {
      score += 25;
    }

    // فحص الأحرف الكبيرة
    if (!password.contains(RegExp('[A-Z]'))) {
      issues.add(
        'يجب أن تحتوي على حرف كبير واحد على الأقل',
      );
    } else {
      score += 25;
    }

    // فحص الأحرف الصغيرة
    if (!password.contains(RegExp('[a-z]'))) {
      issues.add(
        'يجب أن تحتوي على حرف صغير واحد على الأقل',
      );
    } else {
      score += 25;
    }

    // فحص الأرقام
    if (!password.contains(RegExp('[0-9]'))) {
      issues.add(
        'يجب أن تحتوي على رقم واحد على الأقل',
      );
    } else {
      score += 15;
    }

    // فحص الرموز الخاصة
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      issues.add(
        r'يجب أن تحتوي على رمز خاص واحد على الأقل (!@#$%^&*)',
      );
    } else {
      score += 10;
    }

    return PasswordStrengthResult(
      score: score,
      isStrong: score >= 80,
      issues: issues,
    );
  }

  /// فحص سلامة البيانات المحفوظة
  ///
  /// يتحقق من سلامة وتماسك البيانات في التخزين الآمن
  ///
  /// Returns: تقرير حالة البيانات
  Future<SecurityAuditResult> performSecurityAudit() async {
    final issues = <String>[];
    var securityScore = 100;

    try {
      // فحص وجود البيانات الأساسية
      final username = await secureStorage.read(
        key: <credential-fixture>,
      );
      final passwordHash = await secureStorage.read(
        key: <credential-fixture>,
      );
      final userSalt = await secureStorage.read(
        key: '${StorageKeys.username}_salt',
      );

      if (username != null && passwordHash == null) {
        issues.add(
          'اسم المستخدم موجود لكن كلمة المرور مفقودة',
        );
        securityScore -= 50;
      }

      if (passwordHash != null && userSalt == null) {
        issues.add(
          'كلمة المرور موجودة لكن Salt مفقود (تشفير قديم)',
        );
        securityScore -= 30;
      }

      // فحص قوة التشفير
      if (passwordHash != null && passwordHash.length != 64) {
        issues.add(
          'تنسيق تشفير كلمة المرور غير صحيح',
        );
        securityScore -= 40;
      }

      return SecurityAuditResult(
        securityScore: securityScore,
        isSecure: securityScore >= 80,
        issues: issues,
        hasAccount: username != null,
        hasValidEncryption: passwordHash != null && userSalt != null,
      );
    } on Exception catch (e) {
      return SecurityAuditResult(
        securityScore: 0,
        isSecure: false,
        issues: ['خطأ في فحص البيانات: $e'],
        hasAccount: false,
        hasValidEncryption: false,
      );
    }
  }
}
