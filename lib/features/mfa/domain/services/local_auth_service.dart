import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:basir_accounting_system/core/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// LocalAuthService - Biometric, PIN, Pattern authentication
class LocalAuthService {
  LocalAuthService({required this.secureStorage});

  final FlutterSecureStorage secureStorage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _authStateController = StreamController<String?>.broadcast();

  Stream<String?> get onAuthStateChange => _authStateController.stream;

  /// Check if biometric is available
  Future<bool> canCheckBiometric() async {
    try {
      // Try to check available biometrics
      final availableBiometrics = await _localAuth.getAvailableBiometrics();

      // If no biometrics available at all
      if (availableBiometrics.isEmpty) {
        debugPrint('No biometric hardware available or enrolled');
        return false;
      }

      // Check if we have any usable biometric
      return availableBiometrics.any(
        (biometricType) =>
            biometricType == BiometricType.face ||
            biometricType == BiometricType.fingerprint ||
            biometricType == BiometricType.iris ||
            biometricType == BiometricType.strong ||
            biometricType == BiometricType.weak,
      );
    } on PlatformException catch (e) {
      debugPrint('Biometric check error: ${e.message}');
      return false;
    } on Exception catch (_) {
      debugPrint('Biometric check error');
      return false;
    }
  }

  /// Authenticate with biometric
  Future<bool> authenticateWithBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'استخدم بصمة إصبعك للمصادقة',
      );
    } on Exception catch (_) {
      debugPrint('Biometric auth error');
      return false;
    }
  }

  String _generateSalt() {
    final random = Random.secure();
    return base64Encode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  String _hashPin(String pin, String salt) {
    var hash = sha256.convert(utf8.encode(pin + salt)).toString();
    for (var i = 0; i < 1000; i++) {
      hash = sha256.convert(utf8.encode(hash + salt)).toString();
    }
    return hash;
  }

  String _hashSecret(String secret, String salt) => _hashPin(secret, salt);

  /// Set PIN code
  Future<void> setPinCode(String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await secureStorage.write(key: StorageKeys.pinCode, value: hash);
    await secureStorage.write(key: StorageKeys.pinSalt, value: salt);
    debugPrint('PIN code set successfully');
  }

  /// Verify PIN code
  Future<bool> verifyPinCode(String pin) async {
    final storedHash = await secureStorage.read(key: StorageKeys.pinCode);
    final salt = await secureStorage.read(key: StorageKeys.pinSalt);
    if (storedHash == null || salt == null) return false;
    return _hashPin(pin, salt) == storedHash;
  }

  /// Check if PIN is set
  Future<bool> hasPinCode() async =>
      await secureStorage.read(key: StorageKeys.pinCode) != null;

  /// Clear PIN code
  Future<void> clearPinCode() async {
    await secureStorage.delete(key: StorageKeys.pinCode);
    await secureStorage.delete(key: StorageKeys.pinSalt);
  }

  /// Set pattern lock (النمط الآن عبارة عن مصفوفة من الأرقام 0-8)
  Future<void> setPatternLock(List<int> pattern) async {
    final salt = _generateSalt();
    // تحويل المصفوفة إلى سلسلة نصية مثل "1-2-3-6"
    final patternString = pattern.join('-');
    final hash = _hashSecret(patternString, salt);
    await secureStorage.write(key: StorageKeys.patternHash, value: hash);
    await secureStorage.write(key: StorageKeys.patternSalt, value: salt);
    await secureStorage.write(
        key: StorageKeys.patternString, value: patternString);
    debugPrint('Pattern lock set successfully');
  }

  /// Verify pattern lock (النمط الآن عبارة عن مصفوفة من الأرقام 0-8)
  Future<bool> verifyPatternLock(List<int> pattern) async {
    final storedHash = await secureStorage.read(key: StorageKeys.patternHash);
    final salt = await secureStorage.read(key: StorageKeys.patternSalt);
    if (storedHash != null && salt != null) {
      // تحويل المصفوفة إلى سلسلة نصية
      final patternString = pattern.join('-');
      return _hashSecret(patternString, salt) == storedHash;
    }

    // دعم الإصدار القديم
    final legacy = await secureStorage.read(key: StorageKeys.patternLock);
    if (legacy == null) return false;

    // تحويل السلسلة النصية إلى مصفوفة
    final legacyPattern =
        legacy.split('-').map(int.tryParse).whereType<int>().toList();
    if (legacyPattern.isNotEmpty) {
      final ok = legacyPattern.length == pattern.length &&
          List.generate(
                  legacyPattern.length, (i) => legacyPattern[i] == pattern[i])
              .every((v) => v);
      if (ok) {
        // تحديث النمط إلى الإصدار الجديد
        await setPatternLock(pattern);
        await secureStorage.delete(key: StorageKeys.patternLock);
        return true;
      }
    }

    return false;
  }

  /// Check if pattern is set
  Future<bool> hasPatternLock() async =>
      await secureStorage.read(key: StorageKeys.patternHash) != null ||
      await secureStorage.read(key: StorageKeys.patternLock) != null ||
      await secureStorage.read(key: StorageKeys.patternString) != null;

  /// Clear pattern lock
  Future<void> clearPatternLock() async {
    await secureStorage.delete(key: StorageKeys.patternHash);
    await secureStorage.delete(key: StorageKeys.patternSalt);
    await secureStorage.delete(key: StorageKeys.patternLock);
    await secureStorage.delete(key: StorageKeys.patternString);
  }

  Future<void> setAppLockEnabled({required bool enabled}) async {
    await secureStorage.write(
      key: StorageKeys.appLockEnabled,
      value: enabled.toString(),
    );
  }

  Future<bool> isAppLockEnabled() async =>
      await secureStorage.read(key: StorageKeys.appLockEnabled) == 'true';

  Future<void> setLockOnResume({required bool enabled}) async {
    await secureStorage.write(
      key: StorageKeys.lockOnResume,
      value: enabled.toString(),
    );
  }

  Future<bool> isLockOnResume() async =>
      await secureStorage.read(key: StorageKeys.lockOnResume) == 'true';

  Future<void> setCloudMfaRequired({required bool enabled}) async {
    await secureStorage.write(
      key: StorageKeys.cloudMfaRequired,
      value: enabled.toString(),
    );
  }

  Future<bool> isCloudMfaRequired() async =>
      await secureStorage.read(key: StorageKeys.cloudMfaRequired) == 'true';

  Future<void> recordMfaUnlock() async {
    await secureStorage.write(
      key: StorageKeys.mfaLastUnlockAtMs,
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  Future<DateTime?> getLastMfaUnlockAt() async {
    final raw = await secureStorage.read(key: StorageKeys.mfaLastUnlockAtMs);
    final ms = int.tryParse(raw ?? '');
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Enable/disable biometric login
  Future<void> setBiometricEnabled({required bool enabled}) async {
    await secureStorage.write(
      key: StorageKeys.biometricEnabled,
      value: enabled.toString(),
    );
    debugPrint('Biometric enabled: $enabled');
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async =>
      await secureStorage.read(key: StorageKeys.biometricEnabled) == 'true';

  /// Login with biometric
  Future<bool> loginWithBiometric() async {
    final enabled = await isBiometricEnabled();
    if (!enabled) return false;

    final authenticated = await authenticateWithBiometric();
    if (authenticated) {
      final username = await secureStorage.read(key: StorageKeys.username);
      _authStateController.add(username);
      debugPrint('Biometric login successful');
    }
    return authenticated;
  }

  /// Login with PIN
  Future<bool> loginWithPin(String pin) async {
    final verified = await verifyPinCode(pin);
    if (verified) {
      final username = await secureStorage.read(key: StorageKeys.username);
      _authStateController.add(username);
      debugPrint('PIN login successful');
    }
    return verified;
  }

  /// Login with pattern (النمط الآن عبارة عن مصفوفة من الأرقام 0-8)
  Future<bool> loginWithPattern(List<int> pattern) async {
    final verified = await verifyPatternLock(pattern);
    if (verified) {
      final username = await secureStorage.read(key: StorageKeys.username);
      _authStateController.add(username);
      debugPrint('Pattern login successful');
    }
    return verified;
  }

  void dispose() => _authStateController.close();
}
