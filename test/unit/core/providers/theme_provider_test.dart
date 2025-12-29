/// اختبارات ThemeProvider
///
/// يختبر إدارة حالة الثيم (فاتح/داكن) والحفظ باستخدام SharedPreferences
/// يستخدم AsyncNotifier ونظام التخزين المؤقت
library;

import 'package:basser_app/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('ThemeController - Basic Functionality', () {
    late ProviderContainer container;

    setUp(() {
      // إعداد SharedPreferences الوهمية قبل كل اختبار
      SharedPreferences.setMockInitialValues({});

      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with system theme by default', () async {
      // Act
      final themeMode = await container.read(themeProvider.future);

      // Assert
      expect(themeMode, ThemeMode.system);
    });

    test('should load persisted theme from storage', () async {
      // Arrange - pre-fill storage
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'ThemeMode.dark',
      });

      // Re-create container to simulate app restart
      container = ProviderContainer();

      // Act
      final themeMode = await container.read(themeProvider.future);

      // Assert
      expect(themeMode, ThemeMode.dark);
    });

    test('should toggle from light to dark theme', () async {
      // Arrange
      await container.read(themeProvider.future); // Wait for init
      final controller = container.read(themeProvider.notifier);

      // Act
      await controller.toggleTheme();

      // Assert
      expect(container.read(themeProvider).value, ThemeMode.dark);
      expect(controller.isDarkMode, isTrue);
    });

    test('should toggle from dark to light theme', () async {
      // Arrange
      await container.read(themeProvider.future);
      final controller = container.read(themeProvider.notifier);
      await controller.setThemeMode(ThemeMode.dark);

      // Act
      await controller.toggleTheme();

      // Assert
      expect(container.read(themeProvider).value, ThemeMode.light);
      expect(controller.isDarkMode, isFalse);
    });

    test('should set theme mode explicitly', () async {
      // Arrange
      await container.read(themeProvider.future);
      final controller = container.read(themeProvider.notifier);

      // Act & Assert - System
      await controller.setThemeMode(ThemeMode.system);
      expect(container.read(themeProvider).value, ThemeMode.system);

      // Act & Assert - Dark
      await controller.setThemeMode(ThemeMode.dark);
      expect(container.read(themeProvider).value, ThemeMode.dark);
    });
  });

  group('isDarkModeProvider', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should return true when theme is dark', () async {
      // Arrange
      await container.read(themeProvider.future);
      await container.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);

      // Act
      final isDark = container.read(isDarkModeProvider);

      // Assert
      expect(isDark, isTrue);
    });

    test('should return false when theme is light', () async {
      // Arrange
      await container.read(themeProvider.future);
      await container
          .read(themeProvider.notifier)
          .setThemeMode(ThemeMode.light);

      // Act
      final isDark = container.read(isDarkModeProvider);

      // Assert
      expect(isDark, isFalse);
    });
  });
}
