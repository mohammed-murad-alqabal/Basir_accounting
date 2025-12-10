import 'package:basser_app/core/theme/app_colors.dart';
import 'package:basser_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    group('Primary Colors', () {
      test('primary color should be defined', () {
        expect(AppColors.primary, equals(const Color(0xFF0056B3)));
      });

      test('primaryLight color should be defined', () {
        expect(AppColors.primaryLight, equals(const Color(0xFFE3F2FD)));
      });

      test('primaryDark color should be defined', () {
        expect(AppColors.primaryDark, equals(const Color(0xFF003D82)));
      });

      test('onPrimary color should be white', () {
        expect(AppColors.onPrimary, equals(const Color(0xFFFFFFFF)));
      });
    });

    group('Secondary Colors', () {
      test('secondary color should be defined', () {
        expect(AppColors.secondary, equals(const Color(0xFF1E7E34)));
      });

      test('secondaryLight color should be defined', () {
        expect(AppColors.secondaryLight, equals(const Color(0xFFE8F5E9)));
      });

      test('secondaryDark color should be defined', () {
        expect(AppColors.secondaryDark, equals(const Color(0xFF155724)));
      });

      test('onSecondary color should be white', () {
        expect(AppColors.onSecondary, equals(const Color(0xFFFFFFFF)));
      });
    });

    group('Status Colors', () {
      test('error color should be defined', () {
        expect(AppColors.error, equals(const Color(0xFFC62828)));
      });

      test('success color should be defined', () {
        expect(AppColors.success, equals(const Color(0xFF2E7D32)));
      });

      test('warning color should be defined', () {
        expect(AppColors.warning, equals(const Color(0xFFBF360C)));
      });

      test('info color should be defined', () {
        expect(AppColors.info, equals(const Color(0xFF0D47A1)));
      });
    });

    group('Text Colors', () {
      test('textPrimary should be black', () {
        expect(AppColors.textPrimary, equals(const Color(0xFF000000)));
      });

      test('textSecondary should be dark gray', () {
        expect(AppColors.textSecondary, equals(const Color(0xFF4A4A4A)));
      });

      test('textHint should be medium gray', () {
        expect(AppColors.textHint, equals(const Color(0xFF616161)));
      });

      test('textOnDark should be white', () {
        expect(AppColors.textOnDark, equals(const Color(0xFFFFFFFF)));
      });
    });

    group('Background Colors', () {
      test('background color should be light gray', () {
        expect(AppColors.background, equals(const Color(0xFFF5F7FA)));
      });

      test('surface color should be white', () {
        expect(AppColors.surface, equals(const Color(0xFFFFFFFF)));
      });

      test('surfaceVariant color should be defined', () {
        expect(AppColors.surfaceVariant, equals(const Color(0xFFF8F9FA)));
      });
    });

    group('Border Colors', () {
      test('border color should be defined', () {
        expect(AppColors.border, equals(const Color(0xFFD1D5DB)));
      });

      test('borderLight color should be defined', () {
        expect(AppColors.borderLight, equals(const Color(0xFFE5E7EB)));
      });

      test('borderDark color should be defined', () {
        expect(AppColors.borderDark, equals(const Color(0xFF9CA3AF)));
      });

      test('divider color should be defined', () {
        expect(AppColors.divider, equals(const Color(0xFFE5E7EB)));
      });
    });

    group('Contrast Ratios', () {
      test('textPrimary should have high contrast on white', () {
        final ratio = AppColors.contrastRatio(
          AppColors.textPrimary,
          AppColors.surface,
        );
        expect(ratio, greaterThanOrEqualTo(7.0)); // AAA level
      });

      test('textSecondary should have sufficient contrast on white', () {
        final ratio = AppColors.contrastRatio(
          AppColors.textSecondary,
          AppColors.surface,
        );
        expect(ratio, greaterThanOrEqualTo(4.5)); // AA level
      });

      test('primary color should have sufficient contrast on white', () {
        final ratio = AppColors.contrastRatio(
          AppColors.primary,
          AppColors.surface,
        );
        expect(ratio, greaterThanOrEqualTo(4.5)); // AA level
      });

      test('error color should have sufficient contrast on white', () {
        final ratio = AppColors.contrastRatio(
          AppColors.error,
          AppColors.surface,
        );
        expect(ratio, greaterThanOrEqualTo(4.5)); // AA level
      });
    });

    group('Helper Functions', () {
      test('hasMinimumContrast should return true for high contrast', () {
        expect(AppColors.hasMinimumContrast(AppColors.textPrimary), isTrue);
      });

      test('hasMinimumContrast should return true for sufficient contrast', () {
        expect(AppColors.hasMinimumContrast(AppColors.textSecondary), isTrue);
      });

      test('contrastRatio should calculate correct ratio', () {
        final ratio = AppColors.contrastRatio(
          const Color(0xFF000000), // Black
          const Color(0xFFFFFFFF), // White
        );
        expect(ratio, equals(21.0)); // Maximum contrast
      });

      test('contrastRatio should return 1.0 for same colors', () {
        final ratio = AppColors.contrastRatio(
          AppColors.surface,
          AppColors.surface,
        );
        expect(ratio, equals(1.0)); // No contrast
      });
    });
  });

  group('AppTextStyles', () {
    group('Display Sizes', () {
      test('displayLarge should be 57', () {
        expect(AppTextStyles.displayLarge, equals(57.0));
      });

      test('displayMedium should be 45', () {
        expect(AppTextStyles.displayMedium, equals(45.0));
      });

      test('displaySmall should be 36', () {
        expect(AppTextStyles.displaySmall, equals(36.0));
      });
    });

    group('Headline Sizes', () {
      test('headlineLarge should be 32', () {
        expect(AppTextStyles.headlineLarge, equals(32.0));
      });

      test('headlineMedium should be 28', () {
        expect(AppTextStyles.headlineMedium, equals(28.0));
      });

      test('headlineSmall should be 24', () {
        expect(AppTextStyles.headlineSmall, equals(24.0));
      });
    });

    group('Title Sizes', () {
      test('titleLarge should be 22', () {
        expect(AppTextStyles.titleLarge, equals(22.0));
      });

      test('titleMedium should be 16', () {
        expect(AppTextStyles.titleMedium, equals(16.0));
      });

      test('titleSmall should be 14', () {
        expect(AppTextStyles.titleSmall, equals(14.0));
      });
    });

    group('Body Sizes', () {
      test('bodyLarge should be 16', () {
        expect(AppTextStyles.bodyLarge, equals(16.0));
      });

      test('bodyMedium should be 14', () {
        expect(AppTextStyles.bodyMedium, equals(14.0));
      });

      test('bodySmall should be 12', () {
        expect(AppTextStyles.bodySmall, equals(12.0));
      });
    });

    group('Label Sizes', () {
      test('labelLarge should be 14', () {
        expect(AppTextStyles.labelLarge, equals(14.0));
      });

      test('labelMedium should be 12', () {
        expect(AppTextStyles.labelMedium, equals(12.0));
      });

      test('labelSmall should be 11', () {
        expect(AppTextStyles.labelSmall, equals(11.0));
      });
    });

    group('Font Weights', () {
      test('light should be w300', () {
        expect(AppTextStyles.light, equals(FontWeight.w300));
      });

      test('regular should be w400', () {
        expect(AppTextStyles.regular, equals(FontWeight.w400));
      });

      test('medium should be w500', () {
        expect(AppTextStyles.medium, equals(FontWeight.w500));
      });

      test('semiBold should be w600', () {
        expect(AppTextStyles.semiBold, equals(FontWeight.w600));
      });

      test('bold should be w700', () {
        expect(AppTextStyles.bold, equals(FontWeight.w700));
      });
    });

    group('Line Heights', () {
      test('lineHeightTight should be 1.2', () {
        expect(AppTextStyles.lineHeightTight, equals(1.2));
      });

      test('lineHeightNormal should be 1.5', () {
        expect(AppTextStyles.lineHeightNormal, equals(1.5));
      });

      test('lineHeightRelaxed should be 1.8', () {
        expect(AppTextStyles.lineHeightRelaxed, equals(1.8));
      });
    });

    group('Size Hierarchy', () {
      test('display sizes should be in descending order', () {
        expect(
          AppTextStyles.displayLarge,
          greaterThan(AppTextStyles.displayMedium),
        );
        expect(
          AppTextStyles.displayMedium,
          greaterThan(AppTextStyles.displaySmall),
        );
      });

      test('headline sizes should be in descending order', () {
        expect(
          AppTextStyles.headlineLarge,
          greaterThan(AppTextStyles.headlineMedium),
        );
        expect(
          AppTextStyles.headlineMedium,
          greaterThan(AppTextStyles.headlineSmall),
        );
      });

      test('title sizes should be in descending order', () {
        expect(
          AppTextStyles.titleLarge,
          greaterThan(AppTextStyles.titleMedium),
        );
        expect(
          AppTextStyles.titleMedium,
          greaterThan(AppTextStyles.titleSmall),
        );
      });

      test('body sizes should be in descending order', () {
        expect(AppTextStyles.bodyLarge, greaterThan(AppTextStyles.bodyMedium));
        expect(AppTextStyles.bodyMedium, greaterThan(AppTextStyles.bodySmall));
      });

      test('label sizes should be in descending order', () {
        expect(
          AppTextStyles.labelLarge,
          greaterThan(AppTextStyles.labelMedium),
        );
        expect(
          AppTextStyles.labelMedium,
          greaterThan(AppTextStyles.labelSmall),
        );
      });
    });

    group('Font Weight Hierarchy', () {
      test('font weights should be in ascending order', () {
        expect(
          AppTextStyles.light.index,
          lessThan(AppTextStyles.regular.index),
        );
        expect(
          AppTextStyles.regular.index,
          lessThan(AppTextStyles.medium.index),
        );
        expect(
          AppTextStyles.medium.index,
          lessThan(AppTextStyles.semiBold.index),
        );
        expect(
          AppTextStyles.semiBold.index,
          lessThan(AppTextStyles.bold.index),
        );
      });
    });

    group('Line Height Hierarchy', () {
      test('line heights should be in ascending order', () {
        expect(
          AppTextStyles.lineHeightTight,
          lessThan(AppTextStyles.lineHeightNormal),
        );
        expect(
          AppTextStyles.lineHeightNormal,
          lessThan(AppTextStyles.lineHeightRelaxed),
        );
      });
    });
  });
}
