import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_icons.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_list_screen.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_empty_state.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

FinancialVoucher _voucher({
  required String id,
  required String reference,
  required String personName,
  required String description,
  required VoucherType type,
  required DateTime date,
  required bool isPosted,
}) =>
    FinancialVoucher(
      id: id,
      referenceNumber: reference,
      date: date,
      type: type,
      paymentMethod: PaymentMethod.cash,
      amount: Decimal.parse('125.50'),
      accountId: 'account-$id',
      treasuryAccountId: 'cash-$id',
      description: description,
      personName: personName,
      isPosted: isPosted,
      createdAt: date,
    );

Widget _testApp(Future<List<FinancialVoucher>> Function() loadVouchers) =>
    ProviderScope(
      overrides: [
        appIconsProvider.overrideWithValue(const MaterialAppIcons()),
        getVouchersProvider.overrideWith((ref) => loadVouchers()),
      ],
      child: const MaterialApp(
        locale: Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VoucherListScreen(),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final receipt = _voucher(
    id: 'receipt-1',
    reference: 'RC-2026-001',
    personName: 'شركة النور',
    description: 'تحصيل فاتورة شهرية',
    type: VoucherType.receipt,
    date: DateTime(2026, 3, 16),
    isPosted: true,
  );
  final payment = _voucher(
    id: 'payment-1',
    reference: 'PV-2026-002',
    personName: 'مورد الأجهزة',
    description: 'سداد مورد تقني',
    type: VoucherType.payment,
    date: DateTime(2026, 3, 12),
    isPosted: false,
  );

  testWidgets('يعرض السندات مرتبة ويبحث بالاسم والمرجع والوصف', (tester) async {
    await tester.pumpWidget(_testApp(() async => [payment, receipt]));
    await tester.pumpAndSettle();

    expect(find.textContaining('RC-2026-001'), findsOneWidget);
    expect(find.textContaining('PV-2026-002'), findsOneWidget);
    expect(find.text('تحصيل فاتورة شهرية'), findsOneWidget);
    expect(find.text('125.5 ر.س'), findsNWidgets(2));
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'مورد');
    await tester.pumpAndSettle();

    expect(find.text('مورد الأجهزة'), findsOneWidget);
    expect(find.text('شركة النور'), findsNothing);
  });

  testWidgets('يطبق فلترة سندات القبض ويتيح إعادة تعيينها', (tester) async {
    await tester.pumpWidget(_testApp(() async => [receipt, payment]));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('تصفية'));
    await tester.pumpAndSettle();
    expect(find.text('تصفية السندات'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<VoucherType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('قبض').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('تم'));
    await tester.pumpAndSettle();

    expect(find.textContaining(receipt.referenceNumber), findsOneWidget);
    expect(find.textContaining(payment.referenceNumber), findsNothing);

    await tester.tap(find.byTooltip('تصفية'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إعادة تعيين'));
    await tester.pumpAndSettle();

    expect(find.textContaining(receipt.referenceNumber), findsOneWidget);
    expect(find.textContaining(payment.referenceNumber), findsOneWidget);
  });

  testWidgets('يعرض الحالة الفارغة عند غياب السندات', (tester) async {
    await tester.pumpWidget(_testApp(() async => const []));
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('لا توجد سندات مسجلة'), findsOneWidget);
  });

  testWidgets(
    'يعرض خطأ القراءة دون إخفاء سبب فشل خدمة الخزينة',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          () => Future<List<FinancialVoucher>>.error(
            StateError('تعذر قراءة الخزينة'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('تعذر قراءة الخزينة'), findsOneWidget);
    },
  );
}
