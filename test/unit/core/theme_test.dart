import 'package:basser_app/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors Tests', () {
    test('primary colors should be defined', () {
      expect(AppColors.primary, const Color(0xFF0056B3));
      expect(AppColors.primaryLight, const Color(0xFFE3F2FD));
      expect(AppColors.primaryDark, const Color(0xFF003D82));
    });

    test('secondary colors should be defined', () {
      expect(AppColors.secondary, const Color(0xFF1E7E34));
      expect(AppColors.secondaryLight, const Color(0xFFE8F5E9));
      expect(AppColors.secondaryDark, const Color(0xFF155724));
    });

    test('background colors should be defined', () {
      expect(AppColors.background, const Color(0xFFF5F7FA));
      expect(AppColors.surface, const Color(0xFFFFFFFF));
      expect(AppColors.surfaceVariant, const Color(0xFFF8F9FA));
    });

    test('status colors should be defined', () {
      expect(AppColors.error, const Color(0xFFC62828));
      expect(AppColors.success, const Color(0xFF2E7D32));
      expect(AppColors.warning, const Color(0xFFD73502));
      expect(AppColors.info, const Color(0xFF0277BD));
    });

    test('text colors should be defined', () {
      expect(AppColors.textPrimary, const Color(0xFF1A1A1A));
      expect(AppColors.textSecondary, const Color(0xFF4A4A4A));
      expect(AppColors.textHint, const Color(0xFF5A5A5A));
      expect(AppColors.textDisabled, const Color(0xFFBDBDBD));
      expect(AppColors.textOnDark, const Color(0xFFFFFFFF));
    });

    test('border colors should be defined', () {
      expect(AppColors.border, const Color(0xFFD1D5DB));
      expect(AppColors.borderLight, const Color(0xFFE5E7EB));
      expect(AppColors.borderDark, const Color(0xFF9CA3AF));
      expect(AppColors.divider, const Color(0xFFE5E7EB));
    });
  });

  group('AppTypography Tests', () {
    test('headline sizes should be defined', () {
      expect(AppTypography.headlineLarge, 34);
      expect(AppTypography.headlineMedium, 28);
      expect(AppTypography.headlineSmall, 24);
    });

    test('title sizes should be defined', () {
      expect(AppTypography.titleLarge, 22);
      expect(AppTypography.titleMedium, 18);
      expect(AppTypography.titleSmall, 16);
    });

    test('body sizes should be defined', () {
      expect(AppTypography.bodyLarge, 17);
      expect(AppTypography.bodyMedium, 15);
      expect(AppTypography.bodySmall, 13);
    });

    test('label sizes should be defined', () {
      expect(AppTypography.labelLarge, 15);
      expect(AppTypography.labelMedium, 13);
      expect(AppTypography.labelSmall, 12);
    });

    test('font weights should be defined', () {
      expect(AppTypography.light, FontWeight.w300);
      expect(AppTypography.regular, FontWeight.w400);
      expect(AppTypography.medium, FontWeight.w500);
      expect(AppTypography.semiBold, FontWeight.w600);
      expect(AppTypography.bold, FontWeight.w700);
      expect(AppTypography.extraBold, FontWeight.w800);
    });

    test('line heights should be defined', () {
      expect(AppTypography.headlineLineHeight, 1.2);
      expect(AppTypography.bodyLineHeight, 1.5);
      expect(AppTypography.labelLineHeight, 1.3);
    });

    test('font families should be defined', () {
      expect(AppTypography.arabicFont, 'Cairo');
      expect(AppTypography.englishFont, 'Roboto');
      expect(AppTypography.numberFont, 'Roboto Mono');
    });
  });

  group('AppSpacing Tests', () {
    test('spacing values should be defined', () {
      expect(AppSpacing.xs, 4);
      expect(AppSpacing.sm, 8);
      expect(AppSpacing.md, 16);
      expect(AppSpacing.lg, 24);
      expect(AppSpacing.xl, 32);
      expect(AppSpacing.xxl, 48);
    });
  });

  group('AppBorderRadius Tests', () {
    test('border radius values should be defined', () {
      expect(AppBorderRadius.xs, 4);
      expect(AppBorderRadius.sm, 8);
      expect(AppBorderRadius.md, 12);
      expect(AppBorderRadius.lg, 16);
      expect(AppBorderRadius.xl, 20);
      expect(AppBorderRadius.full, 999);
    });
  });

  group('AppIconSize Tests', () {
    test('icon sizes should be defined', () {
      expect(AppIconSize.xs, 18);
      expect(AppIconSize.sm, 22);
      expect(AppIconSize.md, 26);
      expect(AppIconSize.lg, 32);
      expect(AppIconSize.xl, 40);
      expect(AppIconSize.xxl, 48);
    });
  });

  group('AppShadows Tests', () {
    test('shadow values should be defined', () {
      expect(AppShadows.sm.length, 1);
      expect(AppShadows.md.length, 1);
      expect(AppShadows.lg.length, 1);
      expect(AppShadows.xl.length, 1);
    });

    test('shadows should have correct properties', () {
      final smShadow = AppShadows.sm.first;
      expect(smShadow.color, AppColors.shadow);
      expect(smShadow.offset, const Offset(0, 1));
      expect(smShadow.blurRadius, 2);

      final mdShadow = AppShadows.md.first;
      expect(mdShadow.offset, const Offset(0, 2));
      expect(mdShadow.blurRadius, 4);
    });
  });

  group('AppDurations Tests', () {
    test('duration values should be defined', () {
      expect(AppDurations.fast, const Duration(milliseconds: 100));
      expect(AppDurations.short, const Duration(milliseconds: 200));
      expect(AppDurations.medium, const Duration(milliseconds: 300));
      expect(AppDurations.long, const Duration(milliseconds: 500));
    });
  });

  group('AppCurves Tests', () {
    test('curve values should be defined', () {
      expect(AppCurves.easeIn, Curves.easeIn);
      expect(AppCurves.easeOut, Curves.easeOut);
      expect(AppCurves.easeInOut, Curves.easeInOut);
      expect(AppCurves.elastic, Curves.elasticOut);
    });
  });

  group('createAppTheme Tests', () {
    late ThemeData theme;

    setUp(() {
      theme = createAppTheme();
    });

    test('should create ThemeData instance', () {
      expect(theme, isA<ThemeData>());
    });

    test('should use Material 3', () {
      expect(theme.useMaterial3, isTrue);
    });

    test('should have correct text theme font family', () {
      expect(
        theme.textTheme.bodyMedium?.fontFamily,
        'Cairo',
      ); // يستخدم Cairo font
    });

    test('should have correct scaffold background color', () {
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('should have correct color scheme', () {
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.error, AppColors.error);
      expect(theme.colorScheme.surface, AppColors.surface);
    });

    test('should have correct AppBar theme', () {
      expect(theme.appBarTheme.backgroundColor, AppColors.surface);
      expect(theme.appBarTheme.foregroundColor, AppColors.textPrimary);
      expect(theme.appBarTheme.elevation, 0);
      expect(theme.appBarTheme.centerTitle, isTrue);
    });

    test('should have correct Card theme', () {
      expect(theme.cardTheme.color, AppColors.surface);
      expect(theme.cardTheme.elevation, 0);
      expect(theme.cardTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('should have correct Input Decoration theme', () {
      expect(theme.inputDecorationTheme.filled, isTrue);
      expect(theme.inputDecorationTheme.fillColor, AppColors.surface);
      expect(theme.inputDecorationTheme.border, isA<OutlineInputBorder>());
    });

    test('should have correct Button themes', () {
      expect(
        theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        AppColors.primary,
      );
      expect(
        theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
        AppColors.textOnDark,
      );
      expect(theme.elevatedButtonTheme.style?.elevation?.resolve({}), 0);
    });

    test('should have correct Text theme', () {
      expect(
        theme.textTheme.displayLarge?.fontSize,
        AppTypography.headlineLarge,
      );
      expect(theme.textTheme.displayLarge?.fontWeight, AppTypography.bold);
      expect(theme.textTheme.bodyLarge?.fontSize, AppTypography.bodyLarge);
      expect(theme.textTheme.bodyMedium?.fontSize, AppTypography.bodyMedium);
    });

    test('should have correct Icon theme', () {
      expect(theme.iconTheme.color, AppColors.textPrimary);
      expect(theme.iconTheme.size, 24);
    });

    test('should have correct Divider theme', () {
      expect(theme.dividerTheme.color, AppColors.divider);
      expect(theme.dividerTheme.thickness, 1);
      expect(theme.dividerTheme.space, AppSpacing.md);
    });

    test('should have correct Dialog theme', () {
      expect(theme.dialogTheme.backgroundColor, AppColors.surface);
      expect(theme.dialogTheme.elevation, 8);
      expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('should have correct SnackBar theme', () {
      expect(theme.snackBarTheme.backgroundColor, AppColors.textPrimary);
      expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
      expect(theme.snackBarTheme.elevation, 4);
    });

    test('should have correct BottomSheet theme', () {
      expect(theme.bottomSheetTheme.backgroundColor, AppColors.surface);
      expect(theme.bottomSheetTheme.elevation, 8);
      expect(theme.bottomSheetTheme.shape, isA<RoundedRectangleBorder>());
    });

    test('should have correct ProgressIndicator theme', () {
      expect(theme.progressIndicatorTheme.color, AppColors.primary);
      expect(
        theme.progressIndicatorTheme.linearTrackColor,
        AppColors.borderLight,
      );
    });

    test('should have correct FloatingActionButton theme', () {
      expect(
        theme.floatingActionButtonTheme.backgroundColor,
        AppColors.primary,
      );
      expect(
        theme.floatingActionButtonTheme.foregroundColor,
        AppColors.textOnDark,
      );
      expect(theme.floatingActionButtonTheme.elevation, 4);
    });
  });
}
