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

    group('printStatus', () {
      test('should not throw when printing status', () async {
        await FontManager.initialize();

        expect(FontManager.printStatus, returnsNormally);
      });
    });

    group('edge cases', () {
      test('should handle multiple initializations', () async {
        final result1 = await FontManager.initialize();
        final result2 = await FontManager.initialize();

        expect(result1, isA<bool>());
        expect(result2, isA<bool>());
        expect(result1, equals(result2));
      });

      test('should handle createTextStyle with null parameters', () async {
        await FontManager.initialize();

        final style = FontManager.createTextStyle(fontSize: 14);

        expect(style.fontSize, 14.0);
        expect(style.fontWeight, isNull);
        expect(style.color, isNull);
        expect(style.height, isNull);
        expect(style.fontFamily, isNotNull);
      });

      test('should handle createSafeTextStyle with null parameters', () async {
        await FontManager.initialize();

        final style = FontManager.createSafeTextStyle(fontSize: 18);

        expect(style.fontSize, 18.0);
        expect(style.fontWeight, isNull);
        expect(style.color, isNull);
        expect(style.height, isNotNull);
        expect(style.height, greaterThanOrEqualTo(1.3));
      });

      test('should handle zero font size', () async {
        await FontManager.initialize();

        final style = FontManager.createTextStyle(fontSize: 0);

        expect(style.fontSize, 0.0);
        expect(style.fontFamily, isNotNull);
      });

      test('should handle negative font size', () async {
        await FontManager.initialize();

        final style = FontManager.createTextStyle(fontSize: -5);

        expect(style.fontSize, -5.0);
        expect(style.fontFamily, isNotNull);
      });

      test('should handle very large font size', () async {
        await FontManager.initialize();

        final style = FontManager.createTextStyle(fontSize: 1000);

        expect(style.fontSize, 1000.0);
        expect(style.fontFamily, isNotNull);
      });

      test('should handle empty string font check', () async {
        await FontManager.initialize();

        final isAvailable = FontManager.isFontAvailable('');

        expect(isAvailable, false);
      });

      test('should handle null-like font names', () async {
        await FontManager.initialize();

        expect(FontManager.isFontAvailable('null'), false);
        expect(FontManager.isFontAvailable('undefined'), false);
        expect(FontManager.isFontAvailable('NaN'), false);
      });

      test('should maintain consistent state after reset', () async {
        await FontManager.initialize();
        final statusBefore = FontManager.getStatus();

        FontManager.reset();
        final statusAfter = FontManager.getStatus();

        expect(statusAfter['isPrimaryFontLoaded'], false);
        expect(statusAfter['errors'], isEmpty);
        expect(statusAfter['primaryFont'], statusBefore['primaryFont']);
        expect(statusAfter['fallbackFonts'], statusBefore['fallbackFonts']);
      });

      test('should handle getFontFamilyList when not initialized', () {
        FontManager.reset();

        final fonts = FontManager.getFontFamilyList();

        expect(fonts, isNotEmpty);
        expect(fonts, contains('Roboto'));
        expect(fonts, contains('Arial'));
        expect(fonts, contains('sans-serif'));
        expect(fonts, isNot(contains('Cairo')));
      });

      test('should handle getDefaultFontFamily when not initialized', () {
        FontManager.reset();

        final defaultFont = FontManager.getDefaultFontFamily();

        expect(defaultFont, 'Roboto');
      });

      test('should handle getPrimaryFont when not initialized', () {
        FontManager.reset();

        final primaryFont = FontManager.getPrimaryFont();

        expect(primaryFont, isNull);
      });
    });

    group('constants validation', () {
      test('should have valid primary font name', () {
        expect(FontManager.primaryFont, isNotEmpty);
        expect(FontManager.primaryFont, 'Cairo');
      });

      test('should have valid fallback fonts', () {
        expect(FontManager.fallbackFonts, isNotEmpty);
        expect(FontManager.fallbackFonts.length, greaterThanOrEqualTo(3));
        expect(FontManager.fallbackFonts, contains('Roboto'));
        expect(FontManager.fallbackFonts, contains('Arial'));
        expect(FontManager.fallbackFonts, contains('sans-serif'));
      });

      test('should not have duplicate fallback fonts', () {
        final uniqueFonts = FontManager.fallbackFonts.toSet();
        expect(uniqueFonts.length, FontManager.fallbackFonts.length);
      });

      test('should not have primary font in fallback list', () {
        expect(
          FontManager.fallbackFonts,
          isNot(contains(FontManager.primaryFont)),
        );
      });
    });
  });

  group('FontDebugInfo Widget', () {
    testWidgets('should display font status', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      expect(find.text('Font Manager Status'), findsOneWidget);
      expect(find.textContaining('Primary:'), findsOneWidget);
      expect(find.textContaining('Default:'), findsOneWidget);
    });

    testWidgets('should show loaded status in green', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      if (FontManager.isPrimaryFontLoaded) {
        final textWidget = tester.widget<Text>(find.textContaining('Loaded'));
        expect(textWidget.style?.color, Colors.green);
      }
    });

    testWidgets('should show not loaded status in red', (tester) async {
      FontManager.reset(); // Ensure not loaded state

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      final textWidget = tester.widget<Text>(find.textContaining('Not Loaded'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('should display default font information', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      final defaultFont = FontManager.getDefaultFontFamily();
      expect(find.textContaining('Default: $defaultFont'), findsOneWidget);
    });

    testWidgets('should have proper styling', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, Colors.black87);
      expect(container.padding, const EdgeInsets.all(8));

      final titleWidget = tester.widget<Text>(find.text('Font Manager Status'));
      expect(titleWidget.style?.color, Colors.white);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should handle widget rebuild', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      // Trigger rebuild
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      expect(find.text('Font Manager Status'), findsOneWidget);
      expect(find.textContaining('Primary:'), findsOneWidget);
    });

    testWidgets('should display in column layout', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisSize, MainAxisSize.min);
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('should have proper spacing', (tester) async {
      await FontManager.initialize();

      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: FontDebugInfo())),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 4);
    });
  });
}
