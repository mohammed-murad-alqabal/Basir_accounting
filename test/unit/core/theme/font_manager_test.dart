import 'package:basser_app/core/theme/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FontManager', () {
    setUp(FontManager.reset);

    group('initialize', () {
      test('should initialize successfully', () async {
        final result = await FontManager.initialize();

        expect(result, isA<bool>());
        expect(FontManager.errors, isEmpty);
      });

      test('should set isPrimaryFontLoaded', () async {
        await FontManager.initialize();

        expect(FontManager.isPrimaryFontLoaded, isA<bool>());
      });
    });

    group('getPrimaryFont', () {
      test('should return primary font name when loaded', () async {
        await FontManager.initialize();

        if (FontManager.isPrimaryFontLoaded) {
          expect(FontManager.getPrimaryFont(), 'Cairo');
        } else {
          expect(FontManager.getPrimaryFont(), isNull);
        }
      });
    });

    group('getFontFamilyList', () {
      test('should return list with primary font first when loaded', () async {
        await FontManager.initialize();

        final fonts = FontManager.getFontFamilyList();

        expect(fonts, isNotEmpty);
        expect(fonts, contains('Roboto'));
        expect(fonts, contains('Arial'));

        if (FontManager.isPrimaryFontLoaded) {
          expect(fonts.first, 'Cairo');
        }
      });

      test('should include fallback fonts', () async {
        await FontManager.initialize();

        final fonts = FontManager.getFontFamilyList();

        expect(fonts, contains('Roboto'));
        expect(fonts, contains('Arial'));
        expect(fonts, contains('sans-serif'));
      });
    });

    group('getDefaultFontFamily', () {
      test('should return primary font when loaded', () async {
        await FontManager.initialize();

        final defaultFont = FontManager.getDefaultFontFamily();

        if (FontManager.isPrimaryFontLoaded) {
          expect(defaultFont, 'Cairo');
        } else {
          expect(defaultFont, 'Roboto');
        }
      });
    });

    group('createTextStyle', () {
      test('should create TextStyle with correct properties', () async {
        await FontManager.initialize();

        final style = FontManager.createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          height: 1.5,
        );

        expect(style.fontSize, 16.0);
        expect(style.fontWeight, FontWeight.bold);
        expect(style.color, Colors.black);
        expect(style.height, 1.5);
        expect(style.fontFamilyFallback, isNotEmpty);
      });

      test('should include fallback fonts', () async {
        await FontManager.initialize();

        final style = FontManager.createTextStyle(fontSize: 16);

        expect(style.fontFamilyFallback, contains('Roboto'));
        expect(style.fontFamilyFallback, contains('Arial'));
      });
    });

    group('createSafeTextStyle', () {
      test('should create TextStyle with safe line-height', () async {
        await FontManager.initialize();

        final style = FontManager.createSafeTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        );

        expect(style.height, greaterThanOrEqualTo(1.3));
        expect(style.fontSize, 16.0);
      });

      test('should use higher line-height for Cairo', () async {
        await FontManager.initialize();

        final style = FontManager.createSafeTextStyle(fontSize: 16);

        if (FontManager.isPrimaryFontLoaded) {
          expect(style.height, 1.4);
        } else {
          expect(style.height, 1.3);
        }
      });
    });

    group('isFontAvailable', () {
      test('should return correct status for primary font', () async {
        await FontManager.initialize();

        final isAvailable = FontManager.isFontAvailable('Cairo');

        expect(isAvailable, FontManager.isPrimaryFontLoaded);
      });

      test('should return true for fallback fonts', () async {
        await FontManager.initialize();

        expect(FontManager.isFontAvailable('Roboto'), true);
        expect(FontManager.isFontAvailable('Arial'), true);
        expect(FontManager.isFontAvailable('sans-serif'), true);
      });

      test('should return false for unknown fonts', () async {
        await FontManager.initialize();

        expect(FontManager.isFontAvailable('UnknownFont'), false);
      });
    });

    group('getStatus', () {
      test('should return complete status information', () async {
        await FontManager.initialize();

        final status = FontManager.getStatus();

        expect(status, isA<Map<String, dynamic>>());
        expect(status, containsPair('primaryFont', 'Cairo'));
        expect(status, containsPair('isPrimaryFontLoaded', isA<bool>()));
        expect(status, containsPair('fallbackFonts', isA<List<String>>()));
        expect(status, containsPair('defaultFont', isA<String>()));
        expect(status, containsPair('errors', isA<List<String>>()));
      });

      test('should include fallback fonts in status', () async {
        await FontManager.initialize();

        final status = FontManager.getStatus();
        final fallbackFonts = status['fallbackFonts'] as List;

        expect(fallbackFonts, contains('Roboto'));
        expect(fallbackFonts, contains('Arial'));
        expect(fallbackFonts, contains('sans-serif'));
      });
    });

    group('reset', () {
      test('should reset all state', () async {
        await FontManager.initialize();

        FontManager.reset();

        expect(FontManager.isPrimaryFontLoaded, false);
        expect(FontManager.errors, isEmpty);
      });
    });

    group('errors', () {
      test('should return empty list initially', () {
        expect(FontManager.errors, isEmpty);
      });

      test('should return unmodifiable list', () {
        final errors = FontManager.errors;

        expect(() => errors.add('test'), throwsUnsupportedError);
      });
    });
  });

  group('FontDebugInfo Widget', () {
    testWidgets('should display font status', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FontDebugInfo(),
          ),
        ),
      );

      expect(find.text('Font Manager Status'), findsOneWidget);
      expect(find.textContaining('Primary:'), findsOneWidget);
      expect(find.textContaining('Default:'), findsOneWidget);
    });

    testWidgets('should show loaded status in green', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FontDebugInfo(),
          ),
        ),
      );

      if (FontManager.isPrimaryFontLoaded) {
        final textWidget = tester.widget<Text>(
          find.textContaining('Loaded'),
        );
        expect(textWidget.style?.color, Colors.green);
      }
    });
  });
}
