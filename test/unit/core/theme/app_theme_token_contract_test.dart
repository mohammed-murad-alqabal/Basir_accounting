import 'package:basir_accounting_system/core/theme/app_theme.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppTheme canonical token contract', () {
    test('light default ColorScheme is built from AppColors semantic tokens',
        () {
      final theme = AppTheme.getTheme(mode: ThemeMode.light);
      final colors = theme.colorScheme;

      expect(colors.brightness, Brightness.light);
      expect(colors.primary, AppColors.primary);
      expect(colors.primaryContainer, AppColors.primaryLight);
      expect(colors.onPrimaryContainer, AppColors.primaryDark);
      expect(colors.secondary, AppColors.secondary);
      expect(colors.secondaryContainer, AppColors.secondaryLight);
      expect(colors.onSecondaryContainer, AppColors.secondaryDark);
      expect(colors.error, AppColors.error);
      expect(colors.surfaceContainerHighest, AppColors.surfaceVariant);
      expect(colors.outline, AppColors.border);
      expect(colors.outlineVariant, AppColors.borderLight);
    });

    test('dark default ColorScheme is built from AppPalette dark primitives',
        () {
      final theme = AppTheme.getTheme(mode: ThemeMode.dark);
      final colors = theme.colorScheme;

      expect(colors.brightness, Brightness.dark);
      expect(colors.primary, AppPalette.blueCorporate);
      expect(colors.primaryContainer, AppPalette.navyDeep);
      expect(colors.onPrimaryContainer, AppPalette.blueLight);
      expect(colors.secondary, AppPalette.greenEmerald);
      expect(colors.secondaryContainer, AppPalette.greenForest);
      expect(colors.onSecondaryContainer, AppPalette.greenLight);
      expect(colors.surface, AppPalette.darkSurface);
      expect(colors.onSurface, AppPalette.darkTextPrimary);
      expect(colors.surfaceContainerHighest, AppPalette.darkBorder);
      expect(colors.error, AppPalette.redAlert);
      expect(colors.errorContainer, AppPalette.redBurgundy);
      expect(colors.outline, AppPalette.darkOutline);
      expect(colors.outlineVariant, AppPalette.darkBorder);
    });
  });
}
