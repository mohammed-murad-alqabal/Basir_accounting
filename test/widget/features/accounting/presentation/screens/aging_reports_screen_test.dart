/// اختبارات حالات شاشة تقارير أعمار الذمم.
library;

import 'package:basir_accounting_system/features/accounting/application/accounts_payable_service.dart';
import 'package:basir_accounting_system/features/accounting/application/accounts_receivable_service.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/aging_reports_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _ReceivableDataService extends AccountsReceivableService {
  @override
  Future<void> build() async {}

  @override
  Future<List<CustomerAging>> getReceivablesAging() async => [
        CustomerAging(
          customerId: 'customer-1',
          customerNameAr: 'عميل الاختبار',
          customerNameEn: 'Test Customer',
          current: Decimal.parse('100'),
          period1_30: Decimal.parse('25'),
          period31_60: Decimal.zero,
          period61_90: Decimal.zero,
          periodOver90: Decimal.zero,
          totalBalance: Decimal.parse('125'),
        ),
      ];
}

class _PayableDataService extends AccountsPayableService {
  @override
  Future<void> build() async {}

  @override
  Future<List<SupplierAging>> getPayablesAging() async => [
        SupplierAging(
          supplierId: 'supplier-1',
          supplierNameAr: 'مورد الاختبار',
          supplierNameEn: 'Test Supplier',
          current: Decimal.parse('50'),
          period1_30: Decimal.parse('25'),
          period31_60: Decimal.zero,
          periodOver90: Decimal.zero,
          totalBalance: Decimal.parse('75'),
        ),
      ];
}

class _EmptyReceivableService extends AccountsReceivableService {
  @override
  Future<void> build() async {}

  @override
  Future<List<CustomerAging>> getReceivablesAging() async => [];
}

class _EmptyPayableService extends AccountsPayableService {
  @override
  Future<void> build() async {}

  @override
  Future<List<SupplierAging>> getPayablesAging() async => [];
}

class _FailingReceivableService extends AccountsReceivableService {
  @override
  Future<void> build() async {}

  @override
  Future<List<CustomerAging>> getReceivablesAging() =>
      Future.error(StateError('receivables unavailable'));
}

class _FailingPayableService extends AccountsPayableService {
  @override
  Future<void> build() async {}

  @override
  Future<List<SupplierAging>> getPayablesAging() =>
      Future.error(StateError('payables unavailable'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget testApp({
    required Override receivables,
    required Override payables,
  }) =>
      ProviderScope(
        overrides: [receivables, payables],
        child: const MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AgingReportsScreen(),
        ),
      );

  testWidgets('يعرض أعمار العملاء ثم الموردين مع الانتقال بين التبويبات', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        receivables: accountsReceivableServiceProvider.overrideWith(
          _ReceivableDataService.new,
        ),
        payables: accountsPayableServiceProvider.overrideWith(
          _PayableDataService.new,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('عميل الاختبار'), findsOneWidget);
    expect(find.textContaining('125'), findsOneWidget);

    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();
    expect(find.text('مورد الاختبار'), findsOneWidget);
    expect(find.textContaining('75'), findsOneWidget);
  });

  testWidgets('يعرض حالة عدم وجود بيانات في التبويبين', (tester) async {
    await tester.pumpWidget(
      testApp(
        receivables: accountsReceivableServiceProvider.overrideWith(
          _EmptyReceivableService.new,
        ),
        payables: accountsPayableServiceProvider.overrideWith(
          _EmptyPayableService.new,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.description_outlined), findsOneWidget);
  });

  testWidgets('يعرض حالة الخطأ عند تعذر جلب تقرير الذمم', (tester) async {
    await tester.pumpWidget(
      testApp(
        receivables: accountsReceivableServiceProvider.overrideWith(
          _FailingReceivableService.new,
        ),
        payables: accountsPayableServiceProvider.overrideWith(
          _FailingPayableService.new,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('receivables unavailable'), findsOneWidget);
  });
}
