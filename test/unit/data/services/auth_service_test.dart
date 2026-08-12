/// اختبارات AuthService
///
/// يختبر جميع عمليات المصادقة والأمان
library;

import 'package:basir_accounting_system/features/auth/application/auth_service.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
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
        await expectLater(
          authService.createAccount(username, password),
          throwsException,
        );
      },
    );

    test(
      'should throw exception for passwords that do not meet the 12-character policy',
      () async {
        // Arrange
        const username = 'testuser';
        const password = '12345'; // أقل من 6 أحرف

        // Act & Assert
        await expectLater(
          authService.createAccount(username, password),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('should throw exception for empty username', () async {
      // Arrange
      const username = '';
      const password = 'redacted';

      // Act & Assert
      await expectLater(
        authService.createAccount(username, password),
        throwsException,
      );
    });

    test(
      'should reject an empty password through the password policy',
      () async {
        // Arrange
        const username = 'testuser';
        const password = '';

        // Act & Assert
        await expectLater(
          authService.createAccount(username, password),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('should store a versioned PBKDF2 password hash', () async {
      // Arrange
      const username = 'testuser';
      const password = 'redacted';

      // Act
      await authService.createAccount(username, password);

      // Assert
      final storedPasswordHash = await mockStorage.read(key: 'password_hash');
      expect(storedPasswordHash, startsWith(r'pbkdf2-sha256$310000$'));
    });

    test('rejects privileged local account creation', () async {
      await expectLater(
        authService.createAccount(
          'testuser',
          'Password123!',
          role: UserRole.admin,
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('does not replace an existing local account', () async {
      await mockStorage.write(key: 'username', value: 'existing-user');

      await expectLater(
        authService.createAccount('testuser', 'Password123!'),
        throwsA(isA<StateError>()),
      );
    });

    test('rejects password reset without a verified recovery flow', () {
      expect(
        () => authService.changePasswordWithoutOldPassword(
          'testuser',
          'NewPassword456!',
        ),
        throwsA(isA<UnsupportedError>()),
      );
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
      const oldPassword = 'Password123!';
      const newPassword = 'NewPassword456!';
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
        const newPassword = 'NewPassword456!';
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
        const newPassword = '12345'; // أقل من سياسة كلمة المرور الجديدة
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
      await expectLater(
        authService.createAccount(username, password),
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
