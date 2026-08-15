/// اختبارات السلوك المرئي لنموذج سند القبض والدفع.
library;

import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:basir_accounting_system/shared/widgets/app_enhanced_button.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAccountingService extends AccountingService {
  _FakeAccountingService(this.accounts);

  final List<Account> accounts;

  @override
  FutureOr<List<JournalEntry>> build() => const [];

  @override
  Future<List<Account>> getAccounts() async => accounts;
}

class _FakeTreasuryService extends TreasuryService {
  final issuedReceipts = <FinancialVoucher>[];
  final issuedPayments = <FinancialVoucher>[];

  @override
  FutureOr<void> build() {}

  @override
  Future<String> issueReceipt(FinancialVoucher voucher) async {
    issuedReceipts.add(voucher);
    return 'receipt-${voucher.id}';
  }

  @override
  Future<String> issuePayment(FinancialVoucher voucher) async {
    issuedPayments.add(voucher);
    return 'payment-${voucher.id}';
  }
}

class _FakeVendors extends Vendors {
  _FakeVendors(this.vendors);

  final List<Vendor> vendors;

  @override
  Future<List<Vendor>> build() async => vendors;
}

Account _account({
  required String id,
  required String code,
  required String nameAr,
  required String subType,
}) =>
    Account(
      id: id,
      code: code,
      nameAr: nameAr,
      nameEn: nameAr,
      type: AccountType.asset,
      nature: AccountNature.debit,
      balance: Decimal.zero,
      subType: subType,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAccountingService accountingService;
  late _FakeTreasuryService treasuryService;
  late _FakeVendors vendors;
  late ProviderContainer container;

  setUp(() {
    accountingService = _FakeAccountingService([
      _account(
        id: 'cash-account',
        code: '110101',
        nameAr: 'صندوق الاختبار',
        subType: 'cash',
      ),
      _account(
        id: 'bank-account',
        code: '110201',
        nameAr: 'حساب بنكي الاختبار',
        subType: 'bank',
      ),
    ]);
    treasuryService = _FakeTreasuryService();
    vendors = _FakeVendors([
      Vendor(
        id: 'vendor-1',
        nameAr: 'مورد الاختبار',
        nameEn: 'Test vendor',
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
        payableAccountId: 'payable-account',
      ),
    ]);
    container = ProviderContainer(
      overrides: [
        accountingServiceProvider.overrideWith(() => accountingService),
        treasuryServiceProvider.overrideWith(() => treasuryService),
        customersProvider.overrideWith(
          (ref) async => [
            Customer(
              id: 'customer-1',
              nameAr: 'عميل الاختبار',
              nameEn: 'Test customer',
              createdAt: DateTime(2025),
              updatedAt: DateTime(2025),
              receivableAccountId: 'receivable-account',
            ),
          ],
        ),
        vendorsProvider.overrideWith(() => vendors),
        basirUserProvider.overrideWith((ref) => null),
      ],
    );
  });

  tearDown(() => container.dispose());

  Widget testApp(VoucherType type) => UncontrolledProviderScope(
        container: container,
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

  testWidgets('يحفظ سند قبض مع العميل والحساب النقدي في خدمة الخزينة', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(VoucherType.receipt));
    await tester.pumpAndSettle();

    final scrollable = find
        .descendant(
          of: find.byType(Form),
          matching: find.byType(Scrollable),
        )
        .first;
    final selectors = find.byType(DropdownButtonFormField<String>);
    await tester.tap(selectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('صندوق الاختبار').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(selectors.at(1), 120, scrollable: scrollable);
    await tester.tap(selectors.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('عميل الاختبار').last);
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '250');
    await tester.enterText(fields.last, 'تحصيل فاتورة اختبارية');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saveButton = find.byType(AppEnhancedButton);
    await tester.scrollUntilVisible(saveButton, 120, scrollable: scrollable);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(treasuryService.issuedReceipts, hasLength(1));
    final voucher = treasuryService.issuedReceipts.single;
    expect(voucher.type, VoucherType.receipt);
    expect(voucher.amount, Decimal.fromInt(250));
    expect(voucher.treasuryAccountId, 'cash-account');
    expect(voucher.accountId, 'receivable-account');
    expect(voucher.personName, 'عميل الاختبار');
    expect(voucher.description, 'تحصيل فاتورة اختبارية');
  });

  testWidgets('يحفظ سند صرف بنكي مع المورد في خدمة الخزينة', (tester) async {
    await tester.pumpWidget(testApp(VoucherType.payment));
    await tester.pumpAndSettle();

    await tester.tap(find.text('بنكي'));
    await tester.pumpAndSettle();
    final scrollable = find
        .descendant(
          of: find.byType(Form),
          matching: find.byType(Scrollable),
        )
        .first;
    final selectors = find.byType(DropdownButtonFormField<String>);
    await tester.tap(selectors.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('حساب بنكي الاختبار').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(selectors.at(1), 120, scrollable: scrollable);
    await tester.tap(selectors.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('مورد الاختبار').last);
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '90');
    await tester.enterText(fields.last, 'سداد فاتورة مورد');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    final saveButton = find.byType(AppEnhancedButton);
    await tester.scrollUntilVisible(saveButton, 120, scrollable: scrollable);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(treasuryService.issuedPayments, hasLength(1));
    final voucher = treasuryService.issuedPayments.single;
    expect(voucher.type, VoucherType.payment);
    expect(voucher.paymentMethod, PaymentMethod.bank);
    expect(voucher.amount, Decimal.fromInt(90));
    expect(voucher.treasuryAccountId, 'bank-account');
    expect(voucher.accountId, 'payable-account');
    expect(voucher.personName, 'مورد الاختبار');
    expect(voucher.description, 'سداد فاتورة مورد');
  });
}
