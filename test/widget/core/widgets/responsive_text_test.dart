import 'package:basser_app/core/widgets/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveText', () {
    testWidgets('should display text correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveText('نص تجريبي'))),
      );

      expect(find.text('نص تجريبي'), findsOneWidget);
    });

    testWidgets('should apply custom style', (tester) async {
      const testStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveText('نص تجريبي', style: testStyle)),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should apply custom color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveText('نص تجريبي', color: Colors.red)),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('should apply custom fontWeight', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText('نص تجريبي', fontWeight: FontWeight.w600),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontWeight, FontWeight.w600);
    });

    testWidgets('should apply maxLines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText('نص تجريبي طويل جداً', maxLines: 2),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, 2);
    });

    testWidgets('should apply overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText('نص تجريبي', overflow: TextOverflow.fade),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.overflow, TextOverflow.fade);
    });

    testWidgets('should apply textAlign', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText('نص تجريبي', textAlign: TextAlign.left),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textAlign, TextAlign.left);
    });

    testWidgets('should apply textDirection', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText('نص تجريبي', textDirection: TextDirection.ltr),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textDirection, TextDirection.ltr);
    });

    testWidgets('should apply default RTL direction', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveText('نص تجريبي'))),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textDirection, TextDirection.rtl);
    });

    testWidgets('should apply default center alignment', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveText('نص تجريبي'))),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('should apply height (line height)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveText('نص تجريبي', height: 2)),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.height, 2.0);
    });

    testWidgets('should apply default height 1.5', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveText('نص تجريبي'))),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.height, 1.5);
    });

    testWidgets('should apply letterSpacing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveText('نص تجريبي', letterSpacing: 1.5)),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.letterSpacing, 1.5);
    });

    testWidgets('should apply softWrap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveText('نص تجريبي', softWrap: false)),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.softWrap, false);
    });

    testWidgets('should use FittedBox when autoScale is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveText('نص تجريبي', autoScale: true)),
        ),
      );

      expect(find.byType(FittedBox), findsOneWidget);
      final fittedBox = tester.widget<FittedBox>(find.byType(FittedBox));
      expect(fittedBox.fit, BoxFit.scaleDown);
    });

    testWidgets('should not use FittedBox when autoScale is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveText('نص تجريبي'))),
      );

      expect(find.byType(FittedBox), findsNothing);
    });

    testWidgets('should handle long text with ellipsis', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: ResponsiveText(
                'نص طويل جداً جداً جداً جداً جداً',
                maxLines: 1,
              ),
            ),
          ),
        ),
      );

      expect(find.text('نص طويل جداً جداً جداً جداً جداً'), findsOneWidget);
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 1);
    });
  });

  group('ResponsiveHeadline', () {
    testWidgets('should display headline text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveHeadline('عنوان كبير')),
        ),
      );

      expect(find.text('عنوان كبير'), findsOneWidget);
    });

    testWidgets('should use headlineLarge style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(headlineLarge: TextStyle(fontSize: 32)),
          ),
          home: const Scaffold(body: ResponsiveHeadline('عنوان كبير')),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.style?.fontSize, 32);
    });

    testWidgets('should apply maxLines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveHeadline('عنوان كبير', maxLines: 3)),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.maxLines, 3);
    });

    testWidgets('should apply custom color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveHeadline('عنوان كبير', color: Colors.blue),
          ),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.color, Colors.blue);
    });

    testWidgets('should enable autoScale by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveHeadline('عنوان كبير')),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.autoScale, true);
    });
  });

  group('ResponsiveTitle', () {
    testWidgets('should display title text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveTitle('عنوان فرعي'))),
      );

      expect(find.text('عنوان فرعي'), findsOneWidget);
    });

    testWidgets('should use titleLarge style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 22)),
          ),
          home: const Scaffold(body: ResponsiveTitle('عنوان فرعي')),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.style?.fontSize, 22);
    });

    testWidgets('should apply maxLines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ResponsiveTitle('عنوان فرعي', maxLines: 3)),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.maxLines, 3);
    });
  });

  group('ResponsiveBody', () {
    testWidgets('should display body text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveBody('نص أساسي'))),
      );

      expect(find.text('نص أساسي'), findsOneWidget);
    });

    testWidgets('should use bodyMedium style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
          ),
          home: const Scaffold(body: ResponsiveBody('نص أساسي')),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.style?.fontSize, 16);
    });

    testWidgets('should allow unlimited lines by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveBody('نص أساسي'))),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.maxLines, null);
    });
  });

  group('ResponsiveLabel', () {
    testWidgets('should display label text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveLabel('تسمية'))),
      );

      expect(find.text('تسمية'), findsOneWidget);
    });

    testWidgets('should use labelLarge style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(labelLarge: TextStyle(fontSize: 14)),
          ),
          home: const Scaffold(body: ResponsiveLabel('تسمية')),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.style?.fontSize, 14);
    });

    testWidgets('should default to 1 line', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveLabel('تسمية'))),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.maxLines, 1);
    });
  });

  group('ResponsiveCaption', () {
    testWidgets('should display caption text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveCaption('نص صغير'))),
      );

      expect(find.text('نص صغير'), findsOneWidget);
    });

    testWidgets('should use bodySmall style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(bodySmall: TextStyle(fontSize: 12)),
          ),
          home: const Scaffold(body: ResponsiveCaption('نص صغير')),
        ),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.style?.fontSize, 12);
    });

    testWidgets('should default to 2 lines', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ResponsiveCaption('نص صغير'))),
      );

      final responsiveText = tester.widget<ResponsiveText>(
        find.byType(ResponsiveText),
      );
      expect(responsiveText.maxLines, 2);
    });
  });

  group('Alignment Tests', () {
    testWidgets('should align left correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText(
              'نص تجريبي',
              textAlign: TextAlign.left,
              autoScale: true,
            ),
          ),
        ),
      );

      final fittedBox = tester.widget<FittedBox>(find.byType(FittedBox));
      expect(fittedBox.alignment, Alignment.centerLeft);
    });

    testWidgets('should align right correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText(
              'نص تجريبي',
              textAlign: TextAlign.right,
              autoScale: true,
            ),
          ),
        ),
      );

      final fittedBox = tester.widget<FittedBox>(find.byType(FittedBox));
      expect(fittedBox.alignment, Alignment.centerRight);
    });

    testWidgets('should align center correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveText(
              'نص تجريبي',
              textAlign: TextAlign.center,
              autoScale: true,
            ),
          ),
        ),
      );

      final fittedBox = tester.widget<FittedBox>(find.byType(FittedBox));
      expect(fittedBox.alignment, Alignment.center);
    });
  });
}
