/// اختبارات سلوكية لأدوات الوصول ومقياس النص.
library;

import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:basir_accounting_system/shared/widgets/text_scale_factor_tester.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('يغيّر المقياس عبر الأزرار السريعة ويطبقه على المحتوى المختبر', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SizedBox(
          height: 680,
          child: TextScaleFactorTester(
            child: Text('نص محاسبي طويل لاختبار الوصول'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('القيمة الحالية: 1.0x'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('نص محاسبي طويل لاختبار الوصول'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, '2.0x'));
    await tester.pumpAndSettle();

    expect(find.text('القيمة الحالية: 2.0x'), findsOneWidget);
    final content = tester.element(find.text('نص محاسبي طويل لاختبار الوصول'));
    expect(MediaQuery.textScalerOf(content).scale(1), 2);
  });

  testWidgets('يمكن إخفاء لوحات التحكم والمعلومات للاستخدام المضمن', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const SizedBox(
          height: 300,
          child: TextScaleFactorTester(
            showControls: false,
            showInfo: false,
            child: Text('محتوى مضمّن'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Slider), findsNothing);
    expect(find.text('اختبار textScaleFactor'), findsNothing);
    expect(find.text('محتوى مضمّن'), findsOneWidget);
  });

  testWidgets('يعرض الزر المحسن أنواعه وحالتي التحميل والتعطيل ويعالج الضغط', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      _app(
        SingleChildScrollView(
          child: Column(
            children: [
              AppEnhancedButton(
                label: 'أساسي',
                onPressed: () => presses++,
                icon: Icons.check,
              ),
              AppEnhancedButton(
                label: 'ثانوي',
                type: AppEnhancedButtonType.secondary,
                onPressed: () => presses++,
              ),
              AppEnhancedButton(
                label: 'محدد',
                type: AppEnhancedButtonType.outlined,
                onPressed: () => presses++,
              ),
              AppEnhancedButton(
                label: 'نصي',
                type: AppEnhancedButtonType.text,
                onPressed: () => presses++,
              ),
              AppEnhancedButton(
                label: 'خطر',
                type: AppEnhancedButtonType.danger,
                onPressed: () => presses++,
              ),
              const AppEnhancedButton(label: 'معطل', onPressed: null),
              AppEnhancedButton(
                label: 'تحميل',
                isLoading: true,
                onPressed: () => presses++,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppEnhancedButton), findsNWidgets(7));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.text('أساسي'));
    await tester.pump();
    expect(presses, 1);

    final disabled = tester.widget<AppEnhancedButton>(
      find.ancestor(
        of: find.text('معطل'),
        matching: find.byType(AppEnhancedButton),
      ),
    );
    expect(disabled.onPressed, isNull);
  });
}
