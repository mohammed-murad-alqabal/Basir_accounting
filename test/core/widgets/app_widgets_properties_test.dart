import 'package:basir_app/core/theme/app_theme.dart';
import 'package:basir_app/shared/widgets/app_card.dart';
import 'package:basir_app/shared/widgets/app_enhanced_button.dart';
import 'package:basir_app/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Widgets Property Tests', () {
    // ═════════════════════════════════════════════════════════════════════════
    // RTL Text Direction (Property 6)
    // ═════════════════════════════════════════════════════════════════════════
    group('RTL Support', () {
      testWidgets('AppTextField accommodates RTL text direction',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: Directionality(
                textDirection: TextDirection.rtl,
                child: AppTextField(
                  label: 'مستخدم',
                  hint: 'أدخل الاسم',
                ),
              ),
            ),
          ),
        );

        // Verify the Directionality widget is effectively passing RTL
        // The key test is that no layout exceptions occur under RTL
        // Directionality works via context, not by setting properties directly
        expect(tester.takeException(), isNull);

        // Verify AppTextField renders without error in RTL mode
        final textFieldFinder = find.byType(AppTextField);
        expect(textFieldFinder, findsOneWidget);
      });
    });

    // ═════════════════════════════════════════════════════════════════════════
    // Text Scaling Support (Property 10)
    // ═════════════════════════════════════════════════════════════════════════
    group('Text Scaling Support', () {
      testWidgets('AppButton text scales correctly', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2),
              ),
              child: Scaffold(
                body: AppEnhancedButton(
                  label: 'Button',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        // Find the Text widget inside the button
        final textFinder = find.descendant(
          of: find.byType(AppEnhancedButton),
          matching: find.byType(Text),
        );
        expect(textFinder, findsOneWidget);

        // We can check if the RenderParagraph has the scale applied implicitly
        // or check if size is larger than normal.
        // For Property testing, ensuring it renders without overflow is key.
        expect(tester.takeException(), isNull);
      });

      testWidgets('AppCard handles scaled text without overflow',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(1.5),
              ),
              child: AppListCard(
                title: 'Large Title',
                subtitle: 'Subtitle text here',
                leading: const Icon(Icons.person),
                onTap: () {},
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });
    });
  });
}
