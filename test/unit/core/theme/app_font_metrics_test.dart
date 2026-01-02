import 'package:basir_app/core/theme/app_font_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFontMetrics', () {
    group('Constructor', () {
      test('should create metrics with given values', () {
        const metrics = AppFontMetrics(
          fontFamily: 'TestFont',
          fontSize: 16,
          lineHeight: 1.5,
          ascent: 0.8,
          descent: 0.2,
        );

        expect(metrics.fontFamily, 'TestFont');
        expect(metrics.fontSize, 16.0);
        expect(metrics.lineHeight, 1.5);
        expect(metrics.ascent, 0.8);
        expect(metrics.descent, 0.2);
      });
    });

    group('Factory Constructors', () {
      test('cairo() should create Cairo metrics with correct values', () {
        final metrics = AppFontMetrics.cairo(16);

        expect(metrics.fontFamily, 'Cairo');
        expect(metrics.fontSize, 16.0);
        expect(metrics.lineHeight, 1.4);
        expect(metrics.ascent, 0.85);
        expect(metrics.descent, 0.25);
      });

      test('roboto() should create Roboto metrics with correct values', () {
        final metrics = AppFontMetrics.roboto(16);

        expect(metrics.fontFamily, 'Roboto');
        expect(metrics.fontSize, 16.0);
        expect(metrics.lineHeight, 1.3);
        expect(metrics.ascent, 0.75);
        expect(metrics.descent, 0.25);
      });

      test('system() should create System metrics with correct values', () {
        final metrics = AppFontMetrics.system(16);

        expect(metrics.fontFamily, 'System');
        expect(metrics.fontSize, 16.0);
        expect(metrics.lineHeight, 1.3);
        expect(metrics.ascent, 0.75);
        expect(metrics.descent, 0.25);
      });
    });

    group('calculateRequiredHeight', () {
      test('should calculate correct height with textScaleFactor 1.0', () {
        final metrics = AppFontMetrics.cairo(16);
        final height = metrics.calculateRequiredHeight();

        // 16.0 * 1.4 = 22.4
        expect(height, 22.4);
      });

      test('should calculate correct height with textScaleFactor 1.5', () {
        final metrics = AppFontMetrics.cairo(16);
        final height = metrics.calculateRequiredHeight(textScaleFactor: 1.5);

        // (16.0 * 1.5) * 1.4 = 33.6
        expect(height, closeTo(33.6, 0.01));
      });

      test('should calculate correct height with textScaleFactor 2.0', () {
        final metrics = AppFontMetrics.cairo(16);
        final height = metrics.calculateRequiredHeight(textScaleFactor: 2);

        // (16.0 * 2.0) * 1.4 = 44.8
        expect(height, 44.8);
      });
    });

    group('calculateVerticalPadding', () {
      test('should calculate padding with default minPadding', () {
        final metrics = AppFontMetrics.cairo(16);
        final padding = metrics.calculateVerticalPadding();

        expect(padding.top, greaterThanOrEqualTo(12.0));
        expect(padding.bottom, greaterThanOrEqualTo(12.0));
        expect(padding.top, padding.bottom);
      });

      test('should increase padding with higher textScaleFactor', () {
        final metrics = AppFontMetrics.cairo(16);
        final padding1 = metrics.calculateVerticalPadding();
        final padding2 = metrics.calculateVerticalPadding(textScaleFactor: 1.5);

        expect(padding2.top, greaterThan(padding1.top));
      });

      test('should respect custom minPadding', () {
        final metrics = AppFontMetrics.cairo(16);
        final padding = metrics.calculateVerticalPadding(minPadding: 20);

        expect(padding.top, greaterThanOrEqualTo(20.0));
      });
    });

    group('calculatePadding', () {
      test('should calculate full padding with default values', () {
        final metrics = AppFontMetrics.cairo(16);
        final padding = metrics.calculatePadding();

        expect(padding.top, greaterThanOrEqualTo(12.0));
        expect(padding.bottom, greaterThanOrEqualTo(12.0));
        expect(padding.left, 16.0);
        expect(padding.right, 16.0);
      });

      test('should respect custom horizontal padding', () {
        final metrics = AppFontMetrics.cairo(16);
        final padding = metrics.calculatePadding(horizontalPadding: 24);

        expect(padding.left, 24.0);
        expect(padding.right, 24.0);
      });
    });

    group('calculateMinButtonHeight', () {
      test('should return at least minHeight', () {
        final metrics = AppFontMetrics.cairo(12); // خط صغير
        final height = metrics.calculateMinButtonHeight();

        expect(height, greaterThanOrEqualTo(48.0));
      });

      test('should increase with textScaleFactor', () {
        final metrics = AppFontMetrics.cairo(16);
        final height1 = metrics.calculateMinButtonHeight();
        final height2 = metrics.calculateMinButtonHeight(textScaleFactor: 1.5);

        expect(height2, greaterThan(height1));
      });

      test('should calculate correct height for large text', () {
        final metrics = AppFontMetrics.cairo(24);
        final height = metrics.calculateMinButtonHeight(textScaleFactor: 2);

        // يجب أن يكون أكبر بكثير من 48px
        expect(height, greaterThan(80.0));
      });
    });

    group('isHeightSufficient', () {
      test('should return true for sufficient height', () {
        final metrics = AppFontMetrics.cairo(16);
        final isSufficient = metrics.isHeightSufficient(height: 60);

        expect(isSufficient, true);
      });

      test('should return false for insufficient height', () {
        final metrics = AppFontMetrics.cairo(16);
        final isSufficient = metrics.isHeightSufficient(
          height: 30,
          textScaleFactor: 2,
        );

        expect(isSufficient, false);
      });
    });

    group('toTextStyle', () {
      test('should create TextStyle with correct properties', () {
        final metrics = AppFontMetrics.cairo(16);
        final style = metrics.toTextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

        expect(style.fontFamily, 'Cairo');
        expect(style.fontSize, 16.0);
        expect(style.height, 1.4);
        expect(style.color, Colors.black);
        expect(style.fontWeight, FontWeight.bold);
        expect(style.fontFamilyFallback, ['Roboto', 'Arial']);
      });
    });

    group('Equality', () {
      test('should be equal for same values', () {
        final metrics1 = AppFontMetrics.cairo(16);
        final metrics2 = AppFontMetrics.cairo(16);

        expect(metrics1, metrics2);
        expect(metrics1.hashCode, metrics2.hashCode);
      });

      test('should not be equal for different values', () {
        final metrics1 = AppFontMetrics.cairo(16);
        final metrics2 = AppFontMetrics.cairo(18);

        expect(metrics1, isNot(metrics2));
      });
    });

    group('toString', () {
      test('should return readable string representation', () {
        final metrics = AppFontMetrics.cairo(16);
        final string = metrics.toString();

        expect(string, contains('Cairo'));
        expect(string, contains('16.0'));
        expect(string, contains('1.4'));
      });
    });
  });

  group('FontMetricsHelper', () {
    group('getCairoMetrics', () {
      test('should return cached metrics for common sizes', () {
        final metrics1 = FontMetricsHelper.getCairoMetrics(16);
        final metrics2 = FontMetricsHelper.getCairoMetrics(16);

        expect(identical(metrics1, metrics2), true);
      });

      test('should create new metrics for uncommon sizes', () {
        final metrics = FontMetricsHelper.getCairoMetrics(17.5);

        expect(metrics.fontSize, 17.5);
        expect(metrics.fontFamily, 'Cairo');
      });
    });

    group('calculateCairoHeight', () {
      test('should calculate correct height', () {
        final height = FontMetricsHelper.calculateCairoHeight(fontSize: 16);

        expect(height, 22.4);
      });
    });

    group('calculateCairoPadding', () {
      test('should calculate correct padding', () {
        final padding = FontMetricsHelper.calculateCairoPadding(fontSize: 16);

        expect(padding.top, greaterThanOrEqualTo(12.0));
        expect(padding.left, 16.0);
      });
    });
  });
}
