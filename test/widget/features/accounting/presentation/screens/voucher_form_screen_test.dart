/// اختبارات السلوك المرئي لنموذج سند القبض والدفع.
library;

import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget testApp(VoucherType type) => ProviderScope(
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VoucherFormScreen(type: type),
        ),
      );

  testWidgets('يبني سند القبض مع حقول المبلغ والوصف وطرق الدفع', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.receipt));
    await tester.pumpAndSettle();

    expect(find.byType(VoucherFormScreen), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(SegmentedButton<PaymentMethod>), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('يعرض طرق الدفع الثلاث وينقل الاختيار إلى التحويل البنكي', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.payment));
    await tester.pumpAndSettle();

    expect(find.text('نقدي'), findsOneWidget);
    expect(find.text('بنكي'), findsOneWidget);
    expect(find.text('شيك'), findsOneWidget);

    await tester.tap(find.text('بنكي'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<SegmentedButton<PaymentMethod>>(
            find.byType(SegmentedButton<PaymentMethod>),
          )
          .selected,
      equals({PaymentMethod.bank}),
    );
  });

  testWidgets('يكشف مبلغ العملة الأجنبية وسعر الصرف بعد اختيار الدولار', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.receipt));
    await tester.pumpAndSettle();

    await tester.tap(find.text('SAR').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD'));
    await tester.pumpAndSettle();

    expect(find.text('المبلغ (USD)'), findsOneWidget);
    expect(find.text('سعر الصرف'), findsOneWidget);
  });

  testWidgets('يحوّل بين مبلغ الريال والدولار ويعيد الحساب عند تعديل السعر', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.receipt));
    await tester.pumpAndSettle();

    await tester.tap(find.text('SAR').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '375');
    await tester.pump();

    var fields = tester.widgetList<TextFormField>(find.byType(TextFormField));
    expect(fields.elementAt(1).initialValue, '100');

    await tester.enterText(find.byType(TextFormField).at(1), '200');
    await tester.pump();
    fields = tester.widgetList<TextFormField>(find.byType(TextFormField));
    expect(Decimal.parse(fields.first.controller!.text), Decimal.fromInt(750));

    await tester.enterText(find.byType(TextFormField).at(2), '4');
    await tester.pump();
    fields = tester.widgetList<TextFormField>(find.byType(TextFormField));
    expect(Decimal.parse(fields.first.controller!.text), Decimal.fromInt(800));
  });

  testWidgets('يعيد إخفاء تفاصيل التحويل عند الرجوع إلى العملة المحلية', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.payment));
    await tester.pumpAndSettle();

    await tester.tap(find.text('SAR').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('EUR'));
    await tester.pumpAndSettle();
    expect(find.text('المبلغ (EUR)'), findsOneWidget);

    await tester.tap(find.text('EUR').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('SAR').last);
    await tester.pumpAndSettle();

    expect(find.text('المبلغ (EUR)'), findsNothing);
    expect(find.text('سعر الصرف'), findsNothing);
  });

  testWidgets('يظهر أخطاء الحقول الإلزامية قبل محاولة حفظ السند', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.receipt));
    await tester.pumpAndSettle();

    final formContext = tester.element(find.byType(Form));
    final l10n = AppLocalizations.of(formContext);
    final saveButton = find.byType(AppEnhancedButton);
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text(l10n.errAmountRequired), findsOneWidget);
    expect(find.text(l10n.errDescriptionRequired), findsOneWidget);
  });
}
