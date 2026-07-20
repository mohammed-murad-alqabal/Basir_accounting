import 'package:basir_accounting_system/core/theme/accessibility/state_contrast_calculator.dart';
import 'package:basir_accounting_system/core/theme/app_state_colors.dart';
import 'package:basir_accounting_system/core/theme/opacity_compositing_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('State Properties', () {
    // Property 10: All button states have ≥ 3:1 contrast
    test('Property 10: All button states have minimum 3:1 contrast', () {
      for (final state in InteractiveState.values) {
        final backgroundColor = AppStateColors.getPrimaryBackgroundColor(state);
        final foregroundColor = AppStateColors.getPrimaryForegroundColor(state);
        // Check contrast against button's own background color
        final contrast = StateContrastCalculator.calculateContrastRatio(
          foregroundColor,
          backgroundColor,
        );
        expect(contrast, greaterThanOrEqualTo(3.0));
      }
    });

    // Property 12: Disabled state has sufficient contrast
    test('Property 12: Disabled state has sufficient contrast', () {
      const background = Colors.white;
      const foreground = AppStateColors.disabledForeground;
      final contrast = StateContrastCalculator.calculateContrastRatio(
        foreground,
        background,
      );
      expect(contrast, greaterThanOrEqualTo(3.0));
    });

    // Property 13: Selected state has sufficient contrast
    test('Property 13: Selected state has sufficient contrast', () {
      const background = AppStateColors.selectedBackground;
      const foreground = AppStateColors.selectedForeground;
      final contrast = StateContrastCalculator.calculateContrastRatio(
        foreground,
        background,
      );
      expect(contrast, greaterThanOrEqualTo(3.0));
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
    test('Property 16: Composited opacity has sufficient contrast', () {
      const background = Colors.white;
      const foreground = Colors.black;
      final composited = OpacityCompositingDesign.calculateCompositedColor(
        foreground: foreground,
        background: background,
        opacity: 0.8,
      );
      final contrast = StateContrastCalculator.calculateContrastRatio(
        composited,
        background,
      );
      expect(contrast, greaterThanOrEqualTo(3.0));
    });
  });
}
