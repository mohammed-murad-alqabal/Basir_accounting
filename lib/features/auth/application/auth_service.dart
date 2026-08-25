import 'dart:async';
import 'package:basir_accounting_system/core/constants.dart';
import 'package:basir_accounting_system/core/security/password_hasher.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// ***
/// Cognitive Foundation: AuthService
///
/// The central orchestration layer for localized institutional security.
/// This service manages the entire lifecycle of operator identities, including:
/// - Secure persistence of credentials via hardware-backed encryption.
/// - bcrypt password hashes and bounded legacy-hash migration.
/// - Transient operator (Guest) lifecycle and permanent upgrades.
/// - Real-time state broadcasting for reactive UI updates.
///
/// Password policy: bcrypt cost 12 per ADR-SEC-001; secure storage protects
/// the local credential at rest.
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

  /// Releases resources owned by the authentication service.
  Future<void> dispose() => _authStateController.close();

  /// Changes password without requiring old password verification
  ///
  /// Used for password reset operations where the user has been
  /// authenticated through a secure token. Updates the stored
  /// password hash and maintains user session.
  ///
  /// Parameters:
  /// - [username]: Username for password change
  /// - [newPassword]: New password to set
  ///
  /// Throws: [Exception] if user not found or password invalid
  Future<void> changePasswordWithoutOldPassword(
    String username,
    String newPassword,
  ) async {
    // Validate new password
    if (newPassword.length < 6) {
      throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
    }

    try {
      // Check if user exists
      final storedUsername = await secureStorage.read(key: 'username');
      if (storedUsername != username) {
        throw Exception('المستخدم غير موجود');
      }

      final passwordHash = PasswordHasher.hash(newPassword);

      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: passwordHash,
      );
      await secureStorage.delete(key: '${username}_salt');

      debugPrint('🔐 [AUTH] Password changed successfully for $username');
    } catch (e) {
      debugPrint('⚠️ [AUTH] Password change failed: $e');
      rethrow;
    }
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

      final isCurrentHash = PasswordHasher.isBcryptHash(storedPasswordHash);
      final isValid = isCurrentHash
          ? PasswordHasher.verifyBcrypt(password, storedPasswordHash)
          : userSalt != null &&
              PasswordHasher.verifyLegacySaltedSha256(
                password: password,
                encodedHash: storedPasswordHash,
                userSalt: userSalt,
              );

      if (!isValid) {
        throw Exception('كلمة المرور غير صحيحة');
      }

      if (!isCurrentHash) {
        await secureStorage.write(
          key: StorageKeys.passwordHash,
          value: PasswordHasher.hash(password),
        );
        await secureStorage.delete(key: '${username}_salt');
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

  /// إنشاء حساب جديد مع الصلاحيات (للمدير فقط أو عند التثبيت)
  Future<void> createAccount(
    String username,
    String password, {
    UserRole role = UserRole.viewer,
    String? warehouseId,
  }) async {
    try {
      // التحقق من صحة المدخلات
      if (username.isEmpty || username.length < 3) {
        throw Exception('اسم المستخدم يجب أن يكون 3 أحرف على الأقل');
      }
      if (password.isEmpty || password.length < 6) {
        throw Exception('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      }

      final passwordHash = PasswordHasher.hash(password);

      // حفظ البيانات بشكل آمن
      await secureStorage.write(key: StorageKeys.username, value: username);
      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: passwordHash,
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
      await secureStorage.write(key: 'user_role', value: role.name);
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

      // Preserve only a legacy salt until the next successful password check
      // upgrades the credential to bcrypt.
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

      final isCurrentHash = PasswordHasher.isBcryptHash(storedPasswordHash);
      final isValid = isCurrentHash
          ? PasswordHasher.verifyBcrypt(oldPassword, storedPasswordHash)
          : userSalt != null &&
              PasswordHasher.verifyLegacySaltedSha256(
                password: oldPassword,
                encodedHash: storedPasswordHash,
                userSalt: userSalt,
              );
      if (!isValid) {
        throw Exception('كلمة المرور القديمة غير صحيحة');
      }

      // التحقق من صحة كلمة المرور الجديدة
      if (newPassword.isEmpty || newPassword.length < 6) {
        throw Exception('كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل');
      }

      await secureStorage.write(
        key: StorageKeys.passwordHash,
        value: PasswordHasher.hash(newPassword),
      );
      await secureStorage.delete(key: '${username}_salt');
    } on Exception catch (e) {
      throw Exception('خطأ في تغيير كلمة المرور: $e');
    }
  }

  /// التحقق من قوة كلمة المرور
  PasswordStrengthResult checkPasswordStrength(String password) {
    final issues = <String>[];
    var score = 0;

    // فحص الطول
    if (password.length < 8) {
      issues.add('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
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

      if (passwordHash != null && !PasswordHasher.isBcryptHash(passwordHash)) {
        issues.add('تجزئة كلمة المرور تحتاج ترقية بعد مصادقة ناجحة');
        securityScore -= 20;
      }

      if (passwordHash != null &&
          PasswordHasher.isBcryptHash(passwordHash) &&
          userSalt != null) {
        issues.add('Salt تاريخي زائد يجب تنظيفه بعد الترحيل');
        securityScore -= 5;
      }

      return SecurityAuditResult(
        securityScore: securityScore,
        isSecure: securityScore >= 80,
        issues: issues,
        hasAccount: username != null,
        hasValidEncryption:
            passwordHash != null && PasswordHasher.isBcryptHash(passwordHash),
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
