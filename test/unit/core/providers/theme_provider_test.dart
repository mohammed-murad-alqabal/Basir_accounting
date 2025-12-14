/// اختبارات ThemeProvider
///
/// يختبر إدارة حالة الثيم (فاتح/داكن) والحفظ في التخزين الآمن
library;

import 'package:basser_app/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'theme_provider_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('ThemeNotifier - Basic Functionality', () {
    late MockFlutterSecureStorage mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith(
            (ref) => ThemeNotifier(mockStorage),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with light theme by default', () {
      // Act
      final themeMode = container.read(themeProvider);

      // Assert
      expect(themeMode, ThemeMode.light);
    });

    test('should toggle from light to dark theme', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act
      await notifier.toggleTheme();

      // Assert
      expect(container.read(themeProvider), ThemeMode.dark);
      verify(mockStorage.write(
        key: 'theme_mode',
        value: 'ThemeMode.dark',
      )).called(1);
    });

    test('should toggle from dark to light theme', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act - First toggle to dark
      await notifier.toggleTheme();
      // Act - Second toggle back to light
      await notifier.toggleTheme();

      // Assert
      expect(container.read(themeProvider), ThemeMode.light);
    });

    test('should set theme to dark mode', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act
      await notifier.setThemeMode(ThemeMode.dark);

      // Assert
      expect(container.read(themeProvider), ThemeMode.dark);
    });

    test('should set theme to light mode', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act
      await notifier.setThemeMode(ThemeMode.light);

      // Assert
      expect(container.read(themeProvider), ThemeMode.light);
    });

    test('should set theme to system mode', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act
      await notifier.setThemeMode(ThemeMode.system);

      // Assert
      expect(container.read(themeProvider), ThemeMode.system);
    });
  });

  group('ThemeNotifier - Getters', () {
    late MockFlutterSecureStorage mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith(
            (ref) => ThemeNotifier(mockStorage),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('isDarkMode should return true when theme is dark', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.dark);

      // Act & Assert
      expect(notifier.isDarkMode, isTrue);
      expect(notifier.isLightMode, isFalse);
    });

    test('isLightMode should return true when theme is light', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.light);

      // Act & Assert
      expect(notifier.isLightMode, isTrue);
      expect(notifier.isDarkMode, isFalse);
    });

    test('should handle system theme mode in getters', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.system);

      // Act & Assert
      expect(notifier.isDarkMode, isFalse);
      expect(notifier.isLightMode, isFalse);
    });
  });

  group('isDarkModeProvider', () {
    late MockFlutterSecureStorage mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith(
            (ref) => ThemeNotifier(mockStorage),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should return true when theme is dark', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.dark);

      // Act
      final isDark = container.read(isDarkModeProvider);

      // Assert
      expect(isDark, isTrue);
    });

    test('should return false when theme is light', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.light);

      // Act
      final isDark = container.read(isDarkModeProvider);

      // Assert
      expect(isDark, isFalse);
    });

    test('should return false when theme is system', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      await notifier.setThemeMode(ThemeMode.system);

      // Act
      final isDark = container.read(isDarkModeProvider);

      // Assert
      expect(isDark, isFalse);
    });
  });

  group('ThemeNotifier - Storage Integration', () {
    late MockFlutterSecureStorage mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith(
            (ref) => ThemeNotifier(mockStorage),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should save theme changes to storage', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act
      await notifier.setThemeMode(ThemeMode.dark);

      // Assert
      verify(mockStorage.write(
        key: 'theme_mode',
        value: 'ThemeMode.dark',
      )).called(1);
    });

    test('should handle storage errors gracefully', () async {
      // Arrange
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception('Storage error'));

      final notifier = container.read(themeProvider.notifier);

      // Act & Assert - Should not throw
      expect(
        () => notifier.setThemeMode(ThemeMode.dark),
        returnsNormally,
      );
    });
  });

  group('ThemeNotifier - Edge Cases', () {
    late MockFlutterSecureStorage mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith(
            (ref) => ThemeNotifier(mockStorage),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should handle multiple rapid toggles', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act - Multiple rapid toggles
      for (int i = 0; i < 5; i++) {
        await notifier.toggleTheme();
      }

      // Assert - Should end up in dark mode (5 toggles from light)
      expect(container.read(themeProvider), ThemeMode.dark);
    });

    test('should handle setting same theme mode multiple times', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act - Set same theme multiple times
      await notifier.setThemeMode(ThemeMode.dark);
      await notifier.setThemeMode(ThemeMode.dark);
      await notifier.setThemeMode(ThemeMode.dark);

      // Assert
      expect(container.read(themeProvider), ThemeMode.dark);
    });

    test('should handle all theme modes', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act & Assert - Test all theme modes
      await notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeProvider), ThemeMode.light);

      await notifier.setThemeMode(ThemeMode.dark);
      expect(container.read(themeProvider), ThemeMode.dark);

      await notifier.setThemeMode(ThemeMode.system);
      expect(container.read(themeProvider), ThemeMode.system);
    });
  });

  group('ThemeNotifier - Performance', () {
    late MockFlutterSecureStorage mockStorage;
    late ProviderContainer container;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      when(mockStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => null);
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith(
            (ref) => ThemeNotifier(mockStorage),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should handle many theme changes efficiently', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);
      final stopwatch = Stopwatch()..start();

      // Act - Many theme changes
      for (int i = 0; i < 10; i++) {
        await notifier.toggleTheme();
      }

      stopwatch.stop();

      // Assert - Should complete in reasonable time (less than 1 second)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(container.read(themeProvider),
          ThemeMode.light); // 10 toggles = back to light
    });

    test('should handle concurrent theme changes', () async {
      // Arrange
      final notifier = container.read(themeProvider.notifier);

      // Act - Concurrent operations
      final future1 = notifier.setThemeMode(ThemeMode.dark);
      final future2 = notifier.setThemeMode(ThemeMode.light);
      final future3 = notifier.setThemeMode(ThemeMode.system);

      await Future.wait([future1, future2, future3]);

      // Assert - Last operation should win
      expect(container.read(themeProvider), ThemeMode.system);
    });
  });
}
