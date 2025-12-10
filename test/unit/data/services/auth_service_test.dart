/// اختبارات AuthService
///
/// يختبر جميع عمليات المصادقة والأمان
library;

import 'package:basser_app/features/auth/data/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_secure_storage.dart';

void main() {
  late MockSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockStorage = MockSecureStorage();
    authService = AuthService(secureStorage: mockStorage);
  });

  group('AuthService - Registration', () {
    test('should create account successfully with valid credentials', () async {
      // Arrange
      const username = 'testuser';
      const password = 'password123';

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
        const password = 'password123';

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
      const password = 'password123';

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
      const password = 'password123';

      // Act
      await authService.createAccount(username, password);

      // Assert
      final storedPasswordHash = await mockStorage.read(key: 'password_hash');
      // SHA-256 hash يجب أن يكون 64 حرف (hex)
      expect(storedPasswordHash?.length, 64);
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
      const password = 'password123';
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
      const password = 'password123';

      // Act & Assert
      expect(() => authService.login(username, password), throwsException);
    });

    test('should throw exception for incorrect username', () async {
      // Arrange
      const username = 'testuser';
      const password = 'password123';
      await authService.createAccount(username, password);

      // Act & Assert
      expect(() => authService.login('wronguser', password), throwsException);
    });

    test('should throw exception for incorrect password', () async {
      // Arrange
      const username = 'testuser';
      const password = 'password123';
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
      const password = 'password123';
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
      const password = 'password123';
      await authService.createAccount(username, password);

      // Act
      final result = await authService.isLoggedIn();

      // Assert
      expect(result, true);
    });

    test('isLoggedIn should return false when logged out', () async {
      // Arrange
      const username = 'testuser';
      const password = 'password123';
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
      const password = 'password123';
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
        const password = 'password123';
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
        const password = 'password123';
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
}
