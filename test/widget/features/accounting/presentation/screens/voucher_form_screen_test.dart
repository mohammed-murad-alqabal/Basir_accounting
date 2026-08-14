/// اختبارات السلوك المرئي لنموذج سند القبض والدفع.
library;

import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
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

    expect(find.byIcon(Icons.payments), findsOneWidget);
    expect(find.byIcon(Icons.account_balance), findsOneWidget);
    expect(find.byIcon(Icons.document_scanner), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.account_balance));
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
}
