/// اختبارات AuthService
///
/// يختبر جميع عمليات المصادقة والأمان
library;

import 'dart:convert';

import 'package:basir_accounting_system/core/security/password_hasher.dart';
import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_secure_storage.dart';

void main() {
  late MockSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockStorage = MockSecureStorage();
    authService = AuthService(secureStorage: mockStorage);
    // إعادة تعيين حالة الأخطاء
    mockStorage.shouldThrowOnRead = false;
    mockStorage.shouldThrowOnWrite = false;
  });

  group('AuthService - Registration', () {
    test('should create account successfully with valid credentials', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';

      // Act
      await authService.createAccount(username, password);

      // Assert
      final storedUsername = await mockStorage.read(key: 'username');
      final storedPasswordHash = await mockStorage.read(key: 'password_hash');
      final isLoggedIn = await mockStorage.read(key: 'is_logged_in');

      expect(storedUsername, username);
      expect(storedPasswordHash, isNotNull);
      expect(storedPasswordHash, isNot(password)); // يجب أن تكون مشفرة
      expect(isLoggedIn, 'true');
    });

    test(
      'should throw exception for username less than 3 characters',
      () async {
        // Arrange
        const username = 'ab'; // أقل من 3 أحرف
        const password = 'redacted';

        // Act & Assert
        expect(
          () => authService.createAccount(username, password),
          throwsException,
        );
      },
    );

    test(
      'should throw exception for password less than 6 characters',
      () async {
        // Arrange
        const username = 'testuser';
        const password = '12345'; // أقل من 6 أحرف

        // Act & Assert
        expect(
          () => authService.createAccount(username, password),
          throwsException,
        );
      },
    );

    test('should throw exception for empty username', () async {
      // Arrange
      const username = '';
      const password = 'redacted';

      // Act & Assert
      expect(
        () => authService.createAccount(username, password),
        throwsException,
      );
    });

    test('should throw exception for empty password', () async {
      // Arrange
      const username = 'testuser';
      const password = '';

      // Act & Assert
      expect(
        () => authService.createAccount(username, password),
        throwsException,
      );
    });

    test('should hash password using bcrypt', () async {
      const username = 'testuser';
      const password = 'redacted';

      await authService.createAccount(username, password);

      final storedPasswordHash = await mockStorage.read(key: 'password_hash');
      expect(storedPasswordHash, isNotNull);
      expect(PasswordHasher.isBcryptHash(storedPasswordHash!), isTrue);
    });
  });

  group('AuthService - hasAccount', () {
    test('should return true when account exists', () async {
      // Arrange
      await mockStorage.write(key: 'username', value: 'testuser');

      // Act
      final result = await authService.hasAccount();

      // Assert
      expect(result, true);
    });

    test('should return false when no account exists', () async {
      // Act
      final result = await authService.hasAccount();

      // Assert
      expect(result, false);
    });
  });

  group('AuthService - Login/Logout', () {
    test('should login successfully with correct credentials', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);

      // Act
      final result = await authService.login(username, password);

      // Assert
      expect(result, true);
      final isLoggedIn = await authService.isLoggedIn();
      expect(isLoggedIn, true);
    });

    test('should throw exception when no account exists', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';

      // Act & Assert
      expect(() => authService.login(username, password), throwsException);
    });

    test('should throw exception for incorrect username', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);

      // Act & Assert
      expect(() => authService.login('wronguser', password), throwsException);
    });

    test('should throw exception for incorrect password', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);

      // Act & Assert
      expect(
        () => authService.login(username, 'wrongpassword'),
        throwsException,
      );
    });

    test('should upgrade a verified legacy salted SHA-256 hash to bcrypt',
        () async {
      const username = 'legacyuser';
      const password = 'redacted';
      const userSalt = 'legacy-salt';
      const appSalt = 'basir_mvp_2025_secure_salt';
      const combinedSalt = '$appSalt$userSalt';
      var legacyHash =
          sha256.convert(utf8.encode('$password$combinedSalt')).toString();
      for (var iteration = 0; iteration < 1000; iteration++) {
        legacyHash =
            sha256.convert(utf8.encode('$legacyHash$combinedSalt')).toString();
      }
      await mockStorage.write(key: 'username', value: username);
      await mockStorage.write(key: 'password_hash', value: legacyHash);
      await mockStorage.write(key: '${username}_salt', value: userSalt);

      final result = await authService.login(username, password);

      expect(result, isTrue);
      final upgradedHash = await mockStorage.read(key: 'password_hash');
      expect(upgradedHash, isNotNull);
      expect(PasswordHasher.isBcryptHash(upgradedHash!), isTrue);
      expect(await mockStorage.read(key: '${username}_salt'), isNull);
    });

    test('should logout successfully', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);
      await authService.login(username, password);

      // Act
      await authService.logout();

      // Assert
      final isLoggedIn = await authService.isLoggedIn();
      expect(isLoggedIn, false);
    });

    test('should handle logout when not logged in', () async {
      // Act & Assert - لا يجب أن يرمي خطأ
      await authService.logout();

      final isLoggedIn = await authService.isLoggedIn();
      expect(isLoggedIn, false);
    });

    test('isLoggedIn should return true when logged in', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, true);
    });

    test('isLoggedIn should return false when logged out', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);
      await authService.logout();

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, false);
    });

    test('isLoggedIn should return false when no account exists', () async {
      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, false);
    });
  });

  group('AuthService - Additional Features', () {
    test('getCurrentUsername should return username when logged in', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';
      await authService.createAccount(username, password);

      // Act
      final result = await authService.getCurrentUsername();

      // Assert
      expect(result, username);
    });

    test(
      'getCurrentUsername should return null when no account exists',
      () async {
        // Act
        final result = await authService.getCurrentUsername();

        // Assert
        expect(result, null);
      },
    );

    test('changePassword should update password successfully', () async {
      // Arrange
      const username = 'testuser';
      const oldPassword = 'password123';
      const newPassword = 'newpassword456';
      await authService.createAccount(username, oldPassword);

      // Act
      await authService.changePassword(oldPassword, newPassword);

      // Assert - يجب أن نتمكن من تسجيل الدخول بكلمة المرور الجديدة
      await authService.logout();
      final result = await authService.login(username, newPassword);
      expect(result, true);
    });

    test(
      'changePassword should throw exception for incorrect old password',
      () async {
        // Arrange
        const username = 'testuser';
        const password = 'redacted';
        const newPassword = 'newpassword456';
        await authService.createAccount(username, password);

        // Act & Assert
        expect(
          () => authService.changePassword('wrongpassword', newPassword),
          throwsException,
        );
      },
    );

    test(
      'changePassword should throw exception for short new password',
      () async {
        // Arrange
        const username = 'testuser';
        const password = 'redacted';
        const newPassword = '12345'; // أقل من 6 أحرف
        await authService.createAccount(username, password);

        // Act & Assert
        expect(
          () => authService.changePassword(password, newPassword),
          throwsException,
        );
      },
    );

    test(
      'changePassword should throw exception when no account exists',
      () async {
        // Act & Assert
        expect(
          () => authService.changePassword('oldpass', 'newpass123'),
          throwsException,
        );
      },
    );
  });

  group('AuthService - Keep Logged In Feature', () {
    test('should set keep logged in preference', () async {
      // Act
      await authService.setKeepLoggedIn(keepLoggedIn: true);

      // Assert
      final result = await authService.shouldKeepLoggedIn();
      expect(result, true);
    });

    test('should unset keep logged in preference', () async {
      // Arrange
      await authService.setKeepLoggedIn(keepLoggedIn: true);

      // Act
      await authService.setKeepLoggedIn(keepLoggedIn: false);

      // Assert
      final result = await authService.shouldKeepLoggedIn();
      expect(result, false);
    });

    test('shouldKeepLoggedIn should return false by default', () async {
      // Act
      final result = await authService.shouldKeepLoggedIn();

      // Assert
      expect(result, false);
    });

    test(
      'should handle storage errors gracefully for keep logged in',
      () async {
        // Arrange
        mockStorage.shouldThrowOnRead = true;

        // Act
        final result = await authService.shouldKeepLoggedIn();

        // Assert
        expect(result, false);
      },
    );
  });

  group('AuthService - Guest Mode', () {
    test('should login as guest successfully', () async {
      // Act
      await authService.loginAsGuest();

      // Assert
      final isGuest = await authService.isGuest();
      final isLoggedIn = await authService.isLoggedIn();
      expect(isGuest, true);
      expect(isLoggedIn, true);
    });

    test('isGuest should return false by default', () async {
      // Act
      final result = await authService.isGuest();

      // Assert
      expect(result, false);
    });

    test('should convert guest to regular user', () async {
      // Arrange
      await authService.loginAsGuest();
      const username = 'converteduser';
      const password = 'redacted';

      // Act
      await authService.convertGuestToUser(username, password);

      // Assert
      final isGuest = await authService.isGuest();
      final storedUsername = await authService.getCurrentUsername();
      expect(isGuest, false);
      expect(storedUsername, username);
    });

    test('should handle guest conversion with invalid credentials', () async {
      // Arrange
      await authService.loginAsGuest();
      const username = 'ab'; // أقل من 3 أحرف
      const password = 'redacted';

      // Act & Assert
      expect(
        () => authService.convertGuestToUser(username, password),
        throwsException,
      );
    });

    test('should handle storage errors gracefully for guest mode', () async {
      // Arrange
      mockStorage.shouldThrowOnRead = true;

      // Act
      final result = await authService.isGuest();

      // Assert
      expect(result, false);
    });
  });

  group('AuthService - Error Handling', () {
    test('hasAccount should throw exception on storage error', () async {
      // Arrange
      mockStorage.shouldThrowOnRead = true;

      // Act & Assert
      expect(() => authService.hasAccount(), throwsException);
    });

    test('createAccount should handle storage write errors', () async {
      // Arrange
      mockStorage.shouldThrowOnWrite = true;
      const username = 'testuser';
      const password = 'redacted';

      // Act & Assert
      expect(
        () => authService.createAccount(username, password),
        throwsException,
      );
    });

    test('login should handle storage read errors', () async {
      // Arrange
      mockStorage.shouldThrowOnRead = true;
      const username = 'testuser';
      const password = 'redacted';

      // Act & Assert
      expect(() => authService.login(username, password), throwsException);
    });

    test('logout should handle storage write errors', () async {
      // Arrange
      mockStorage.shouldThrowOnWrite = true;

      // Act & Assert
      expect(() => authService.logout(), throwsException);
    });

    test('setKeepLoggedIn should handle storage write errors', () async {
      // Arrange
      mockStorage.shouldThrowOnWrite = true;

      // Act & Assert
      expect(
        () => authService.setKeepLoggedIn(keepLoggedIn: true),
        throwsException,
      );
    });

    test('loginAsGuest should handle storage write errors', () async {
      // Arrange
      mockStorage.shouldThrowOnWrite = true;

      // Act & Assert
      expect(() => authService.loginAsGuest(), throwsException);
    });

    test('changePassword should handle storage read errors', () async {
      // Arrange
      mockStorage.shouldThrowOnRead = true;

      // Act & Assert
      expect(
        () => authService.changePassword('oldpass', 'newpass123'),
        throwsException,
      );
    });
  });
}
