import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:basir_accounting_system/core/constants.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// ***
/// Cognitive Foundation: AuthService
///
/// The central orchestration layer for localized institutional security.
/// This service manages the entire lifecycle of operator identities, including:
/// - Secure persistence of credentials via hardware-backed encryption.
/// - PBKDF2-HMAC-SHA-256 password derivation with a unique salt per account.
/// - Transient operator (Guest) lifecycle and permanent upgrades.
/// - Real-time state broadcasting for reactive UI updates.
///
/// Security Standard: secure platform storage + PBKDF2-HMAC-SHA-256.
/// ***
class AuthService {
  /// Initializes the localized authentication engine.
  ///
  /// Requires a [FlutterSecureStorage] instance for hardware-backed\n  /// persistence.
  AuthService({required this.secureStorage});

  /// Institutional hardware-backed storage for sensitive credentials.
  final FlutterSecureStorage secureStorage;

  /// وحدة تحكم في حالة المصادقة (Brodcast Stream)
  final _authStateController = StreamController<String?>.broadcast();

  /// دفق التغييرات في حالة المصادقة (يرجع اسم المستخدم أو null)
  Stream<String?> get onAuthStateChange => _authStateController.stream;

  /// Deliberately disabled until a server-verified, single-use recovery-token
  /// flow is introduced. A client-side username is not proof of authority.
  Future<void> changePasswordWithoutOldPassword(
    String username,
    String newPassword,
  ) {
    throw UnsupportedError(
      'Password resets require a verified server-side recovery flow.',
    );
  }

  /// تنظيف البيانات التالفة أو القديمة (Industrial-Grade Robustness)
  ///
  /// يتحقق مما إذا كان هذا هو التشغيل الأول بعد إعادة التثبيت.
  /// إذا كان التخزين يحتوي على بيانات قديمة بدون علامة "التشغيل الأول"،
  /// يتم مسحها لضمان بداية نظيفة ومنع التعليق أو الأخطاء الغامضة.
  Future<void> initialize() async {
    try {
      const firstRunKey = 'basir_first_run_flag';
      final firstRun = await secureStorage.read(key: firstRunKey);

      if (firstRun == null) {
        // هذا تشغيل أول بعد التثبيت
        // نقوم بمسح أي مخلفات قديمة قد تكون بقيت من تثبيت سابق
        // (تحدث في Android)
        await secureStorage.deleteAll();
        // حفظ علامة التشغيل الأول
        await secureStorage.write(key: firstRunKey, value: 'done');
        debugPrint(
          '🛡️ [AUTH] First run detected. Secure storage initialized.',
        );
      }

      // بث الحالة الحالية عند البدء
      final currentUsername = await getCurrentUsername();
      if (await isLoggedIn()) {
        _authStateController.add(currentUsername);
      } else {
        _authStateController.add(null);
      }
    } on Exception catch (e) {
      debugPrint('⚠️ [AUTH] Error during initialization: $e');
    }
  }

  static const _passwordHashScheme = 'pbkdf2-sha256';
  static const _pbkdf2Iterations = 310000;
  static const _derivedKeyLength = 32;

  /// اشتقاق كلمة المرور عبر PBKDF2-HMAC-SHA-256 مع salt فريد لكل حساب.
  /// يحتفظ تنسيق القيمة بالمعاملات لتسهيل تدويرها لاحقًا دون التباس.
  String _hashPassword(String password, String userSalt) {
    final derived = _pbkdf2HmacSha256(
      password: password,
      salt: base64Decode(userSalt),
      iterations: _pbkdf2Iterations,
      length: _derivedKeyLength,
    );
    return '$_passwordHashScheme\$$_pbkdf2Iterations\$${base64Encode(derived)}';
  }

  bool _isCurrentPasswordHash(String hash) =>
      hash.startsWith('$_passwordHashScheme\$');

  bool _verifyPassword(
    String password,
    String userSalt,
    String storedPasswordHash,
  ) {
    final candidate = _isCurrentPasswordHash(storedPasswordHash)
        ? _hashPassword(password, userSalt)
        : _legacyHashPassword(password, userSalt);
    return _constantTimeEquals(candidate, storedPasswordHash);
  }

  bool _constantTimeEquals(String left, String right) {
    final leftBytes = utf8.encode(left);
    final rightBytes = utf8.encode(right);
    if (leftBytes.length != rightBytes.length) return false;

    var mismatch = 0;
    for (var index = 0; index < leftBytes.length; index++) {
      mismatch |= leftBytes[index] ^ rightBytes[index];
    }
    return mismatch == 0;
  }

  /// يتحقق من القيم القديمة لمرة واحدة فقط، ثم تُرقّى بعد تسجيل الدخول الناجح.
  String _legacyHashPassword(String password, String? userSalt) {
    const legacyAppSalt = 'basir_mvp_2025_secure_salt';
    final combinedSalt = legacyAppSalt + (userSalt ?? '');
    var hash = sha256.convert(utf8.encode(password + combinedSalt)).toString();
    for (var i = 0; i < 1000; i++) {
      hash = sha256.convert(utf8.encode(hash + combinedSalt)).toString();
    }
    return hash;
  }

  List<int> _pbkdf2HmacSha256({
    required String password,
    required List<int> salt,
    required int iterations,
    required int length,
  }) {
    final mac = Hmac(sha256, utf8.encode(password));
    final output = <int>[];
    for (var blockIndex = 1; output.length < length; blockIndex++) {
      final block = <int>[...salt, 0, 0, 0, blockIndex];
      var u = mac.convert(block).bytes;
      final accumulated = List<int>.from(u);
      for (var round = 1; round < iterations; round++) {
        u = mac.convert(u).bytes;
        for (var index = 0; index < accumulated.length; index++) {
          accumulated[index] ^= u[index];
        }
      }
      output.addAll(accumulated);
    }
    return output.take(length).toList(growable: false);
  }

  void _validatePasswordPolicy(String password) {
    final strength = checkPasswordStrength(password);
    if (password.length < 12 || !strength.isStrong) {
      throw Exception(
        'كلمة المرور يجب أن تتكون من 12 حرفًا على الأقل وتحتوي على أحرف كبيرة وصغيرة وأرقام ورمز خاص.',
      );
    }
  }

  /// إنشاء salt عشوائي للمستخدم
  ///
  /// Returns: salt عشوائي بطول 32 حرف
  String _generateUserSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Encode(bytes);
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
      final username = await secureStorage.read(key: StorageKeys.username);
      return username != null;
    } on Exception catch (e) {
      throw Exception('خطأ في التحقق من الحساب: $e');
    }
  }

  /// الحصول على المستخدم الحالي
  ///
  /// يسترجع بيانات المستخدم المسجل من التخزين الآمن
  Future<BasirUser?> getCurrentUser() async {
    try {
      final username = await secureStorage.read(key: StorageKeys.username);
      if (username == null) return null;

      final roleStr = await secureStorage.read(key: 'user_role');
      final permissionsStr = await secureStorage.read(key: 'user_permissions');
      final warehouseId = await secureStorage.read(key: 'user_warehouse_id');
      final displayName = await secureStorage.read(key: 'user_display_name');
      final guestStatus = await isGuest();

      final role = UserRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => UserRole.viewer,
      );

      final permissions = int.tryParse(permissionsStr ?? '') ??
          BasirUser.getDefaultPermissions(role);

      return BasirUser(
        id: await _getUserId() ?? 'unknown',
        email: username, // Using username as email/identifier
        displayName: displayName,
        role: role,
        permissions: permissions,
        warehouseId: warehouseId,
        isGuest: guestStatus,
      );
    } on Exception {
      return null;
    }
  }

  Future<String?> _getUserId() async {
    // Generate or retrieve a persistent UUID for this local user
    var id = await secureStorage.read(key: 'user_id');
    if (id == null) {
      id = const Uuid().v4();
      await secureStorage.write(key: 'user_id', value: id);
    }
    return id;
  }

  /// تسجيل الدخول
  Future<bool> login(String username, String password) async {
    try {
      final storedUsername = await secureStorage.read(
        key: StorageKeys.username,
      );
      final storedPasswordHash = await secureStorage.read(
        key: StorageKeys.passwordHash,
      );
      final userSalt = await secureStorage.read(
        key: '${username}_salt',
      );

      if (storedUsername == null || storedPasswordHash == null) {
        throw Exception('لا يوجد حساب مسجل');
      }

      if (storedUsername != username) {
        throw Exception('اسم المستخدم غير صحيح');
      }

      if (userSalt == null ||
          !_verifyPassword(password, userSalt, storedPasswordHash)) {
        throw Exception('كلمة المرور غير صحيحة');
      }

      // تُرقّى التجزئات القديمة فقط بعد نجاح التحقق، مع الاحتفاظ بالـ salt.
      if (!_isCurrentPasswordHash(storedPasswordHash)) {
        await secureStorage.write(
          key: StorageKeys.passwordHash,
          value: _hashPassword(password, userSalt),
        );
      }

      // تحديث حالة تسجيل الدخول
      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'true');

      // بث حدث تسجيل الدخول
      _authStateController.add(username);
      return true;
    } on Exception catch (e) {
      throw Exception('خطأ في تسجيل الدخول: $e');
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'false');
      _authStateController.add(null);
    } on Exception catch (e) {
      throw Exception('خطأ في تسجيل الخروج: $e');
    }
  }

  /// التحقق من حالة تسجيل الدخول
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await secureStorage.read(key: StorageKeys.isLoggedIn);
      return isLoggedIn == 'true';
    } on Exception {
      return false;
    }
  }

  /// تفعيل ميزة البقاء مسجلاً
  Future<void> setKeepLoggedIn({required bool keepLoggedIn}) async {
    try {
      await secureStorage.write(
        key: StorageKeys.keepLoggedIn,
        value: keepLoggedIn.toString(),
      );
    } on Exception catch (e) {
      throw Exception('خطأ في حفظ إعداد البقاء مسجلاً: $e');
    }
  }

  /// التحقق من إعداد البقاء مسجلاً
  Future<bool> shouldKeepLoggedIn() async {
    try {
      final keepLoggedIn = await secureStorage.read(
        key: StorageKeys.keepLoggedIn,
      );
      return keepLoggedIn == 'true';
    } on Exception {
      return false;
    }
  }

  /// تفعيل وضع الضيف
  Future<void> loginAsGuest() async {
    try {
      await secureStorage.write(key: StorageKeys.isGuest, value: 'true');
      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'true');
      _authStateController.add(null);
    } on Exception catch (e) {
      throw Exception('خطأ في تسجيل الدخول كضيف: $e');
    }
  }

  /// التحقق من وضع الضيف
  Future<bool> isGuest() async {
    try {
      final isGuest = await secureStorage.read(key: StorageKeys.isGuest);
      return isGuest == 'true';
    } on Exception {
      return false;
    }
  }

  /// تحويل الضيف إلى مستخدم مسجل
  Future<void> convertGuestToUser(String username, String password) async {
    try {
      await createAccount(username, password);
      await secureStorage.delete(key: StorageKeys.isGuest);
      _authStateController.add(username);
    } on Exception catch (e) {
      throw Exception('خطأ في تحويل الضيف إلى مستخدم: $e');
    }
  }

  /// إنشاء حساب محلي محدود الصلاحية أثناء الإعداد أو ترقية الضيف.
  Future<void> createAccount(
    String username,
    String password, {
    UserRole role = UserRole.viewer,
    String? warehouseId,
  }) async {
    try {
      // التحقق من صحة المدخلات. لا يسمح هذا المسار المحلي بإنشاء
      // حساب ذي امتيازات؛ يجب أن تأتي الأدوار المرتفعة من تدفق إداري
      // موثق على الخادم.
      if (username.isEmpty || username.length < 3) {
        throw Exception('اسم المستخدم يجب أن يكون 3 أحرف على الأقل');
      }
      if (role != UserRole.viewer) {
        throw UnsupportedError(
          'Privileged accounts require an authorised server-side administration flow.',
        );
      }
      if (await hasAccount()) {
        throw StateError(
          'A local account already exists; account replacement is not permitted.',
        );
      }
      _validatePasswordPolicy(password);

      // إنشاء salt فريد للمستخدم
      final userSalt = _generateUserSalt();

      // تشفير كلمة المرور باستخدام التشفير المحسن
      final passwordHash = _hashPassword(password, userSalt);

      // حفظ البيانات بشكل آمن
      await secureStorage.write(key: StorageKeys.username, value: username);
      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: passwordHash,
      );
      await secureStorage.write(
        key: '${username}_salt',
        value: userSalt,
      );

      // Save RBAC info
      await secureStorage.write(key: 'user_role', value: role.name);
      await secureStorage.write(key: 'user_warehouse_id', value: warehouseId);
      await secureStorage.write(key: 'user_id', value: const Uuid().v4());

      await secureStorage.write(key: StorageKeys.isLoggedIn, value: 'true');

      // بث حدث تسجيل الدخول
      _authStateController.add(username);
    } on Exception catch (e) {
      throw Exception('خطأ في إنشاء الحساب: $e');
    }
  }

  /// تحديث الملف الشخصي للمستخدم
  Future<void> updateUserProfile({
    String? displayName,
    UserRole? role,
    String? warehouseId,
  }) async {
    if (displayName != null) {
      await secureStorage.write(key: 'user_display_name', value: displayName);
    }
    if (role != null) {
      throw UnsupportedError(
        'Role changes require an authorised server-side administration flow.',
      );
    }
    if (warehouseId != null) {
      await secureStorage.write(key: 'user_warehouse_id', value: warehouseId);
    }
  }

  /// الحصول على اسم المستخدم الحالي (Deprecated: use getCurrentUser)
  Future<String?> getCurrentUsername() async => (await getCurrentUser())?.email;

  /// تغيير اسم المستخدم
  Future<void> updateUsername(String newUsername) async {
    try {
      if (newUsername.isEmpty || newUsername.length < 3) {
        throw Exception('اسم المستخدم يجب أن يكون 3 أحرف على الأقل');
      }

      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('لا يوجد حساب مسجل');
      }

      // حفظ الاسم الجديد
      await secureStorage.write(key: StorageKeys.username, value: newUsername);

      // Handle Salt migration
      final salt = await secureStorage.read(key: '${currentUser.email}_salt');
      if (salt != null) {
        await secureStorage.write(key: '${newUsername}_salt', value: salt);
        await secureStorage.delete(key: '${currentUser.email}_salt');
      }

      // بث حدث التحديث
      _authStateController.add(newUsername);
    } on Exception catch (e) {
      throw Exception('خطأ في تحديث اسم المستخدم: $e');
    }
  }

  /// تغيير كلمة المرور
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final storedPasswordHash = await secureStorage.read(
        key: StorageKeys.passwordHash,
      );
      final username = await secureStorage.read(key: StorageKeys.username);
      final userSalt = await secureStorage.read(
        key: '${username}_salt',
      );

      if (storedPasswordHash == null) {
        throw Exception('لا يوجد حساب مسجل');
      }

      if (username == null ||
          userSalt == null ||
          !_verifyPassword(oldPassword, userSalt, storedPasswordHash)) {
        throw Exception('كلمة المرور القديمة غير صحيحة');
      }

      _validatePasswordPolicy(newPassword);

      // إنشاء salt جديد لكلمة المرور الجديدة (أمان إضافي)
      final newUserSalt = _generateUserSalt();

      // تشفير وحفظ كلمة المرور الجديدة
      final newPasswordHash = _hashPassword(newPassword, newUserSalt);
      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: newPasswordHash,
      );
      await secureStorage.write(
        key: '${username}_salt',
        value: newUserSalt,
      );
    } on Exception catch (e) {
      throw Exception('خطأ في تغيير كلمة المرور: $e');
    }
  }

  /// التحقق من قوة كلمة المرور
  PasswordStrengthResult checkPasswordStrength(String password) {
    final issues = <String>[];
    var score = 0;

    // فحص الطول
          if (password.length < 12) {
        issues.add('كلمة المرور يجب أن تكون 12 حرفًا على الأقل');

    } else {
      score += 25;
    }

    // فحص الأحرف الكبيرة
    if (!password.contains(RegExp('[A-Z]'))) {
      issues.add('يجب أن تحتوي على حرف كبير واحد على الأقل');
    } else {
      score += 25;
    }

    // فحص الأحرف الصغيرة
    if (!password.contains(RegExp('[a-z]'))) {
      issues.add('يجب أن تحتوي على حرف صغير واحد على الأقل');
    } else {
      score += 25;
    }

    // فحص الأرقام
    if (!password.contains(RegExp('[0-9]'))) {
      issues.add('يجب أن تحتوي على رقم واحد على الأقل');
    } else {
      score += 15;
    }

    // فحص الرموز الخاصة
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      issues.add(r'يجب أن تحتوي على رمز خاص واحد على الأقل (!@#$%^&*)');
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
  Future<SecurityAuditResult> performSecurityAudit() async {
    final issues = <String>[];
    var securityScore = 100;

    try {
      // فحص وجود البيانات الأساسية
      final username = await secureStorage.read(key: StorageKeys.username);
      final passwordHash = await secureStorage.read(
        key: StorageKeys.passwordHash,
      );
      final userSalt = await secureStorage.read(
        key: '${username}_salt',
      );

      if (username != null && passwordHash == null) {
        issues.add('اسم المستخدم موجود لكن كلمة المرور مفقودة');
        securityScore -= 50;
      }

      if (passwordHash != null && userSalt == null) {
        issues.add('كلمة المرور موجودة لكن Salt مفقود (تشفير قديم)');
        securityScore -= 30;
      }

      // فحص تنسيق الاشتقاق المعياري الحالي.
      if (passwordHash != null && !_isCurrentPasswordHash(passwordHash)) {
        issues.add('يلزم ترقية تجزئة كلمة المرور عند تسجيل الدخول التالي');
        securityScore -= 30;
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
