import 'dart:io';

// ignore_for_file: avoid_print

void main() {
  final directory = Directory('lib');
  if (!directory.existsSync()) {
    print('Directory "lib" not found.');
    return;
  }

  final replacements = {
    "import 'package:basir_app/core/theme.dart';":
        "import 'package:basir_app/core/theme/tokens/index.dart';",
    'import "package:basir_app/core/theme.dart";':
        'import "package:basir_app/core/theme/tokens/index.dart";',
    "import 'package:basir_app/core/theme_dark.dart';": '',
    'import "package:basir_app/core/theme_dark.dart";': '',
    'AppColors.': 'AppColors.',
    'Spacing.': 'Spacing.',
    'AppBorderRadius.': 'Radii.',
    'AppIconSize.': 'IconSizes.',
    'AppAppTypography.': 'AppTypography.',
    'AppTypography.arabicFont': 'FontFamilies.arabic',
    'AppTypography.englishFont': 'FontFamilies.english',
    'AppTypography.numberFont': 'FontFamilies.numbers',
    'AppTypography.light': 'FontWeights.light',
    'AppTypography.regular': 'FontWeights.regular',
    'AppTypography.medium': 'FontWeights.medium',
    'AppTypography.semiBold': 'FontWeights.semiBold',
    'AppTypography.bold': 'FontWeights.bold',
    'Radii.xs': 'Radii.radiusXs',
    'Radii.sm': 'Radii.radiusSm',
    'Radii.md': 'Radii.radiusMd',
    'Radii.lg': 'Radii.radiusLg',
    'Radii.xl': 'Radii.radiusXl',
  };

  directory.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      // Skip the theme files themselves to avoid self-destruction before
      // full migration
      if (entity.path.contains('core/theme.dart') ||
          entity.path.contains('core/theme_dark.dart') ||
          entity.path.contains(
            'core/theme/app_colors.dart',
          )) {
        return;
      }

      var content = entity.readAsStringSync();
      var modified = false;

      replacements.forEach((key, value) {
        if (content.contains(key)) {
          content = content.replaceAll(key, value);
          modified = true;
        }
      });

      if (modified) {
        entity.writeAsStringSync(content);
        print('Migrated: ${entity.path}');
      }
    }
  });
}
