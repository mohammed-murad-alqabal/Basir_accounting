import 'package:basser_app/core/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnhancedButton', () {
    testWidgets('displays text correctly', (tester) async {
      const testText = 'اختبار النص';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: testText,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      const testIcon = Icons.add;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: 'إضافة',
              onPressed: () {},
              icon: testIcon,
            ),
          ),
        ),
      );

      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: 'اضغط هنا',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppEnhancedButton));
      expect(wasPressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: 'معطل',
              onPressed: () {
                wasPressed = true;
              },
              isEnabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppEnhancedButton));
      expect(wasPressed, isFalse);
    });

    testWidgets('shows loading indicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppEnhancedButton(
              text: 'حفظ',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('جاري التحميل...'), findsOneWidget);
    });

    group('Button Styles', () {
      testWidgets('applies primary style correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'أساسي',
                onPressed: () {},
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });

      testWidgets('applies secondary style correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'ثانوي',
                onPressed: () {},
                style: AppEnhancedButtonStyle.secondary,
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });

      testWidgets('applies outlined style correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'بحدود',
                onPressed: () {},
                style: AppEnhancedButtonStyle.outlined,
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });

      testWidgets('applies text style correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'نصي',
                onPressed: () {},
                style: AppEnhancedButtonStyle.text,
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });
    });

    group('Button Sizes', () {
      testWidgets('applies small size correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'صغير',
                onPressed: () {},
                size: AppEnhancedButtonSize.small,
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });

      testWidgets('applies medium size correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'متوسط',
                onPressed: () {},
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });

      testWidgets('applies large size correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'كبير',
                onPressed: () {},
                size: AppEnhancedButtonSize.large,
              ),
            ),
          ),
        );

        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.style, isNotNull);
      });
    });

    group('Text Handling', () {
      testWidgets('handles long text without overflow', (tester) async {
        const longText =
            'هذا نص طويل جداً يجب أن يظهر بشكل صحيح بدون قص أو overflow';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200, // عرض محدود لاختبار النص الطويل
                child: AppEnhancedButton(
                  text: longText,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text(longText), findsOneWidget);

        // التحقق من عدم وجود RenderFlex overflow
        expect(tester.takeException(), isNull);
      });

      testWidgets('handles multiline text correctly', (tester) async {
        const multilineText = 'نص متعدد الأسطر\nيجب أن يظهر بشكل صحيح';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: multilineText,
                onPressed: () {},
                maxLines: 2,
              ),
            ),
          ),
        );

        expect(find.text(multilineText), findsOneWidget);
      });

      testWidgets('applies RTL text direction correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'نص عربي',
                onPressed: () {},
              ),
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('نص عربي'));
        expect(textWidget.textDirection, TextDirection.rtl);
      });
    });

    group('Accessibility', () {
      testWidgets('has correct semantics', (tester) async {
        const testText = 'زر للاختبار';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: testText,
                onPressed: () {},
                semanticLabel: 'تسمية مخصصة',
              ),
            ),
          ),
        );

        // البحث عن Semantics widget الذي يحتوي على AppEnhancedButton
        final semanticsFinder = find.descendant(
          of: find.byType(AppEnhancedButton),
          matching: find.byType(Semantics),
        );

        expect(semanticsFinder, findsWidgets);

        // البحث عن الـ Semantics الذي يحتوي على label المطلوب
        final semanticsWidgets = tester.widgetList<Semantics>(semanticsFinder);
        final targetSemantics = semanticsWidgets.firstWhere(
          (semantics) => semantics.properties.label == 'تسمية مخصصة',
        );

        expect(targetSemantics.properties.label, 'تسمية مخصصة');
        expect(targetSemantics.properties.button, isTrue);
      });

      testWidgets('shows tooltip when provided', (tester) async {
        const tooltipText = 'نص التوضيح';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppEnhancedButton(
                text: 'زر',
                onPressed: () {},
                tooltip: tooltipText,
              ),
            ),
          ),
        );

        expect(find.byType(Tooltip), findsOneWidget);

        // اختبار عرض tooltip عند الحوم
        await tester.longPress(find.byType(AppEnhancedButton));
        await tester.pumpAndSettle();

        expect(find.text(tooltipText), findsOneWidget);
      });
    });

    group('Text Scale Factor Handling', () {
      testWidgets('handles different text scale factors without overflow',
          (tester) async {
        const testText = 'نص للاختبار مع تكبير';

        // اختبار مع textScaleFactor مختلفة
        for (final scaleFactor in [0.8, 1.0, 1.3, 1.5, 2.0]) {
          await tester.pumpWidget(
            MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(
                  textScaler: TextScaler.linear(scaleFactor),
                ),
                child: Scaffold(
                  body: SizedBox(
                    width: 200,
                    child: AppEnhancedButton(
                      text: testText,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          );

          expect(find.text(testText), findsOneWidget);
          expect(
            tester.takeException(),
            isNull,
            reason:
                'No overflow should occur with textScaleFactor $scaleFactor',
          );
        }
      });
    });
  });

  group('AppEnhancedButtonHelper', () {
    testWidgets('creates add button correctly', (tester) async {
      final addButton = AppEnhancedButtonHelper.add(
        text: 'عميل جديد',
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: addButton),
        ),
      );

      expect(find.text('عميل جديد'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('creates save button correctly', (tester) async {
      final saveButton = AppEnhancedButtonHelper.save(
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: saveButton),
        ),
      );

      expect(find.text('حفظ'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('creates cancel button correctly', (tester) async {
      final cancelButton = AppEnhancedButtonHelper.cancel(
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: cancelButton),
        ),
      );

      expect(find.text('إلغاء'), findsOneWidget);
    });

    testWidgets('creates delete button correctly', (tester) async {
      final deleteButton = AppEnhancedButtonHelper.delete(
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: deleteButton),
        ),
      );

      expect(find.text('حذف'), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('creates edit button correctly', (tester) async {
      final editButton = AppEnhancedButtonHelper.edit(
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: editButton),
        ),
      );

      expect(find.text('تعديل'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('creates search button correctly', (tester) async {
      final searchButton = AppEnhancedButtonHelper.search(
        onPressed: () {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: searchButton),
        ),
      );

      expect(find.text('بحث'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
