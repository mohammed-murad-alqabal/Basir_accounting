/// اختبارات AuthService
///
/// يختبر جميع عمليات المصادقة والأمان
library;

import 'package:basir_app/features/auth/application/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_secure_storage.dart';

void main() {
  late MockSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockStorage = MockSecureStorage();
    authService = <credential-fixture>(secureStorage: mockStorage);
    // إعادة تعيين حالة الأخطاء
    mockStorage.shouldThrowOnRead = false;
    mockStorage.shouldThrowOnWrite = false;
  });

  group('AuthService - Registration', () {
    test('should create account successfully with valid credentials', () async {
      // Arrange
      const username = 'testuser';
      const password = '<credential-fixture>';

      // Act
      await authService.createAccount(username, password);

      // Assert
      final storedUsername = await mockStorage.read(key: '<credential-fixture>');
      final storedPasswordHash = await mockStorage.read(key: '<credential-fixture>');
      final isLoggedIn = await mockStorage.read(key: '<credential-fixture>');

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
        const password = '<credential-fixture>';

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
      const password = '<credential-fixture>';

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

    test('should hash password using SHA-256', () async {
      // Arrange
      const username = 'testuser';
      const password = '<credential-fixture>';

      // Act
      await authService.createAccount(username, password);

      // Assert
      final storedPasswordHash = await mockStorage.read(key: '<credential-fixture>');
      // SHA-256 hash يجب أن يكون 64 حرف (hex)
      expect(storedPasswordHash?.length, 64);
    });
  });

  group('AuthService - hasAccount', () {
    test('should return true when account exists', () async {
      // Arrange
      await mockStorage.write(key: '<credential-fixture>', value: 'testuser');

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
      const password = '<credential-fixture>';
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
      const password = '<credential-fixture>';

      // Act & Assert
      expect(() => authService.login(username, password), throwsException);
    });

    test('should throw exception for incorrect username', () async {
      // Arrange
      const username = 'testuser';
      const password = '<credential-fixture>';
      await authService.createAccount(username, password);

      // Act & Assert
      expect(() => authService.login('wronguser', password), throwsException);
    });

    test('should throw exception for incorrect password', () async {
      // Arrange
      const username = 'testuser';
      const password = '<credential-fixture>';
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
      const password = '<credential-fixture>';
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
      const password = '<credential-fixture>';
      await authService.createAccount(username, password);

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, true);
    });

    test('isLoggedIn should return false when logged out', () async {
      // Arrange
      const username = 'testuser';
      const password = '<credential-fixture>';
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
      const password = '<credential-fixture>';
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
        const password = '<credential-fixture>';
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
        const password = '<credential-fixture>';
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
      const password = '<credential-fixture>';

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
      const password = '<credential-fixture>';

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
      const password = '<credential-fixture>';

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
      const password = '<credential-fixture>';

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
