import 'dart:math';
import 'package:basir_accounting_system/core/theme/accessibility/state_contrast_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('State Contrast Calculator', () {
    // Test 1: Relative Luminance for black, white, grey
    test('calculateRelativeLuminance for known colors', () {
      // Black
      expect(
        StateContrastCalculator.calculateRelativeLuminance(Colors.black),
        closeTo(0.0, 0.001),
      );
      // White
      expect(
        StateContrastCalculator.calculateRelativeLuminance(Colors.white),
        closeTo(1.0, 0.001),
      );
      // Mid grey (0.2158 for #808080)
      expect(
        StateContrastCalculator.calculateRelativeLuminance(
          const Color(0xFF808080),
        ),
        closeTo(0.2158, 0.01),
      );
    });

    // Test 2: Contrast ratio for known pairs
    test('calculateContrastRatio for standard pairs', () {
      // Black on White should be ~21:1
      expect(
        StateContrastCalculator.calculateContrastRatio(
          Colors.black,
          Colors.white,
        ),
        closeTo(21.0, 0.1),
      );
      // White on Black should also be ~21:1
      expect(
        StateContrastCalculator.calculateContrastRatio(
          Colors.white,
          Colors.black,
        ),
        closeTo(21.0, 0.1),
      );
    });

    // Test 3: Darken function makes color darker
    test('darken function modifies color correctly', () {
      const original = Colors.blue;
      final darkened = StateContrastCalculator.darken(original, 0.5);

      // HSL lightness should decrease
      final originalHSL = HSLColor.fromColor(original);
      final darkenedHSL = HSLColor.fromColor(darkened);
      expect(darkenedHSL.lightness, lessThan(originalHSL.lightness));
    });

    // Test 4: Lighten function makes color lighter
    test('lighten function modifies color correctly', () {
      const original = Colors.blue;
      final lightened = StateContrastCalculator.lighten(original, 0.5);

      // HSL lightness should increase
      final originalHSL = HSLColor.fromColor(original);
      final lightenedHSL = HSLColor.fromColor(lightened);
      expect(lightenedHSL.lightness, greaterThan(originalHSL.lightness));
    });

    // Test5: Delta E calculation for same color should be zero
    test('calculateDeltaE between same color is zero', () {
      final deltaE =
          StateContrastCalculator.calculateDeltaE(Colors.red, Colors.red);
      expect(deltaE, closeTo(0.0, 0.001));
    });

    // Test6: hasMinimumVisualDifference works correctly
    test('hasMinimumVisualDifference returns correct boolean values', () {
      // Same color, should fail
      expect(
        StateContrastCalculator.hasMinimumVisualDifference(
          Colors.red,
          Colors.red,
        ),
        false,
      );

      // Very different colors should pass
      expect(
        StateContrastCalculator.hasMinimumVisualDifference(
          Colors.white,
          Colors.black,
        ),
        true,
      );
    });

    // Property test: 100 random colors check contrast ratio is positive
    test(
        'Property: Contrast ratio always positive for any color pair '
        '(100 random runs)', () {
      final random = Random();
      for (var i = 0; i < 100; i++) {
        final color1 = Color.fromARGB(
          0xFF,
          random.nextInt(0xFF),
          random.nextInt(0xFF),
          random.nextInt(0xFF),
        );
        final color2 = Color.fromARGB(
          0xFF,
          random.nextInt(0xFF),
          random.nextInt(0xFF),
          random.nextInt(0xFF),
        );

        final ratio =
            StateContrastCalculator.calculateContrastRatio(color1, color2);
        expect(ratio, greaterThan(0.0));
      }
    });
  });
}
