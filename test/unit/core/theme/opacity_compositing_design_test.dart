import 'package:basir_accounting_system/core/theme/opacity_compositing_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Opacity Compositing Design', () {
    test('calculateCompositedColor with full opacity uses foreground', () {
      const foreground = Colors.red;
      const background = Colors.blue;
      final composited = OpacityCompositingDesign.calculateCompositedColor(
        foreground: foreground,
        background: background,
        opacity: 1,
      );
      expect(composited.toARGB32(), equals(foreground.toARGB32()));
    });

    test('calculateCompositedColor with zero opacity uses background', () {
      const foreground = Colors.red;
      const background = Colors.blue;
      final composited = OpacityCompositingDesign.calculateCompositedColor(
        foreground: foreground,
        background: background,
        opacity: 0,
      );
      expect(composited.toARGB32(), equals(background.toARGB32()));
    });

    test('verifyCompositedContrast returns true for high contrast pairs', () {
      const textColor = Colors.white;
      const foreground = Colors.black;
      const background = Colors.white;
      const opacity = 0.8;

      expect(
        OpacityCompositingDesign.verifyCompositedContrast(
          textColor: textColor,
          foreground: foreground,
          background: background,
          opacity: opacity,
        ),
        isTrue,
      );
    });

    // Property test: 100 random pairs, calculate composited color without error
    test('Property: No exceptions for random color pairs and opacity values', () {
      for (var i = 0; i < 100; i++) {
        const foregrounds = [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.white,
          Colors.black,
        ];
        const backgrounds = [
          Colors.yellow,
          Colors.purple,
          Colors.orange,
          Colors.grey,
          Colors.teal,
        ];
        final foreground = foregrounds[i % foregrounds.length];
        final background = backgrounds[i % backgrounds.length];
        final opacity = (i % 10) / 10.0;

        expect(
          () => OpacityCompositingDesign.calculateCompositedColor(
            foreground: foreground,
            background: background,
            opacity: opacity,
          ),
          returnsNormally,
        );
      }
    });
  });
}
