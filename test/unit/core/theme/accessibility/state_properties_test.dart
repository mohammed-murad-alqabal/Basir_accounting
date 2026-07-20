import 'package:basir_accounting_system/core/theme/accessibility/state_contrast_calculator.dart';
import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/opacity_compositing_design.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('State Properties', () {
    // Property 10: All button states have ≥ 3:1 contrast
    test(
        'Property 10: All button states have minimum 3:1 contrast (light and dark)',
        () {
      for (final brightness in Brightness.values) {
        for (final state in InteractiveState.values) {
          final backgroundColor = AppStateColors.getPrimaryBackgroundColor(
            state,
            brightness,
          );
          final foregroundColor = AppStateColors.getPrimaryForegroundColor(
            state,
            brightness,
          );
          final contrast = StateContrastCalculator.calculateContrastRatio(
            foregroundColor,
            backgroundColor,
          );
          expect(
            contrast,
            greaterThanOrEqualTo(3.0),
            reason: 'State $state in $brightness mode failed',
          );
        }
      }
    });

    // Property 12: Disabled state has sufficient contrast
    test('Property 12: Disabled state has sufficient contrast (light and dark)',
        () {
      const lightBackground = Colors.white;
      const darkBackground = AppPalette.darkBackground;
      for (final brightness in Brightness.values) {
        final foreground = AppStateColors.getDisabledForeground(brightness);
        final background =
            brightness == Brightness.light ? lightBackground : darkBackground;
        final contrast = StateContrastCalculator.calculateContrastRatio(
          foreground,
          background,
        );
        expect(
          contrast,
          greaterThanOrEqualTo(3.0),
          reason: '$brightness mode failed',
        );
      }
    });

    // Property 13: Selected state has sufficient contrast
    test('Property 13: Selected state has sufficient contrast (light and dark)',
        () {
      for (final brightness in Brightness.values) {
        final background = AppStateColors.getSelectedBackground(brightness);
        final foreground = AppStateColors.getSelectedForeground(brightness);
        final contrast = StateContrastCalculator.calculateContrastRatio(
          foreground,
          background,
        );
        expect(
          contrast,
          greaterThanOrEqualTo(3.0),
          reason: '$brightness mode failed',
        );
      }
    });

    // Property 14: Visual difference between states (ΔE ≥10)
    test('Property 14: Visual difference between states is at least 10', () {
      const normal = Colors.blue;
      const hovered = Colors.blueAccent;
      final pressed = Colors.blue[700]!;
      expect(
        StateContrastCalculator.hasMinimumVisualDifference(normal, hovered),
        true,
      );
      expect(
        StateContrastCalculator.hasMinimumVisualDifference(normal, pressed),
        true,
      );
    });

    // Property 16: Composited opacity has sufficient contrast
    test(
        'Property 16: Composited opacity has sufficient contrast (light and dark)',
        () {
      const lightBackground = Colors.white;
      const lightForeground = Colors.black;
      const darkBackground = AppPalette.darkBackground;
      const darkForeground = Colors.white;

      for (final brightness in Brightness.values) {
        final background =
            brightness == Brightness.light ? lightBackground : darkBackground;
        final foreground =
            brightness == Brightness.light ? lightForeground : darkForeground;

        final composited = OpacityCompositingDesign.calculateCompositedColor(
          foreground: foreground,
          background: background,
          opacity: 0.8,
        );

        final contrast = StateContrastCalculator.calculateContrastRatio(
          composited,
          background,
        );

        expect(
          contrast,
          greaterThanOrEqualTo(3.0),
          reason: '$brightness mode failed',
        );
      }
    });
  });
}
