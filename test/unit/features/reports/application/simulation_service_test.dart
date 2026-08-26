import 'dart:async';

import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/reports/application/simulation_service.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _FakeAccountingService extends AccountingService {
  final seededInvoices = <Invoice>[];
  final postedEntries = <JournalEntry>[];
  AccountingCountry? seededCountry;

  final _accounts = [
    Account(
      id: 'expense',
      code: '6000',
      nameAr: 'مصاريف تشغيلية',
      nameEn: 'Operating expense',
      type: AccountType.expense,
      nature: AccountNature.debit,
      subType: 'operating_expense',
      balance: Decimal.zero,
    ),
    Account(
      id: 'cash',
      code: '1000',
      nameAr: 'الصندوق',
      nameEn: 'Cash',
      type: AccountType.asset,
      nature: AccountNature.debit,
      subType: 'cash',
      balance: Decimal.zero,
    ),
  ];

  @override
  FutureOr<List<JournalEntry>> build() => const [];

  @override
  Future<void> seedDefaultAccounts({
    AccountingCountry country = AccountingCountry.global,
  }) async {
    seededCountry = country;
  }

  @override
  Future<List<Account>> getAccounts() async => _accounts;

  @override
  Future<void> postSalesInvoice(
    Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    expect(bypassCognitive, isTrue);
    seededInvoices.add(invoice);
  }

  @override
  Future<void> postJournalEntry(
    JournalEntry entry, {
    bool bypassCognitive = false,
  }) async {
    expect(bypassCognitive, isTrue);
    postedEntries.add(entry);
  }
}

class _FakeFinancialYearService extends FinancialYearService {
  bool wasInitialized = false;

  @override
  FutureOr<void> build() {}

  @override
  Future<void> initializeDefaultYear() async {
    wasInitialized = true;
  }
}

class _MockCustomerRepository extends Mock implements CustomerRepository {}

class _CustomerFake extends Fake implements Customer {}

void main() {
  late _MockCustomerRepository customers;
  ProviderContainer? container;

  setUpAll(() => registerFallbackValue(_CustomerFake()));

  setUp(() {
    customers = _MockCustomerRepository();
    when(() => customers.addCustomer(any())).thenAnswer((_) async {});
    container = ProviderContainer(
      overrides: [
        accountingServiceProvider.overrideWith(_FakeAccountingService.new),
        financialYearServiceProvider
            .overrideWith(_FakeFinancialYearService.new),
        customerRepositoryProvider.overrideWithValue(customers),
      ],
    );
  });

  tearDown(() => container?.dispose());

  test('يبذر بيانات مؤسسية متوازنة مع عملاء وفواتير ومصروفات', () async {
    await container!
        .read(financialSimulationServiceProvider.notifier)
        .seedRealisticData();

    final accounting = container!.read(accountingServiceProvider.notifier)
        as _FakeAccountingService;
    final financialYear = container!.read(financialYearServiceProvider.notifier)
        as _FakeFinancialYearService;

    expect(financialYear.wasInitialized, isTrue);
    expect(accounting.seededCountry, AccountingCountry.saudiArabia);

    final addedCustomers = verify(
      () => customers.addCustomer(captureAny()),
    ).captured.cast<Customer>();
    expect(addedCustomers.map((customer) => customer.nameAr), [
      'شركة الأفق للتقنية',
      'مؤسسة النماء التجارية',
      'مجموعة الاستثمار العربية',
    ]);
    expect(
      addedCustomers.every(
        (customer) => customer.email?.startsWith('info@') ?? false,
      ),
      isTrue,
    );

    expect(accounting.seededInvoices, isNotEmpty);
    expect(
      accounting.seededInvoices.every(
        (invoice) =>
            invoice.totalAmount == invoice.subtotalAmount + invoice.taxAmount,
      ),
      isTrue,
    );
    expect(
      accounting.seededInvoices.every(
        (invoice) => invoice.taxRate == Decimal.parse('0.15'),
      ),
      isTrue,
    );

    expect(accounting.postedEntries, isNotEmpty);
    for (final entry in accounting.postedEntries) {
      expect(entry.status, JournalEntryStatus.posted);
      expect(
        entry.lines.fold(Decimal.zero, (sum, line) => sum + line.debit),
        entry.lines.fold(Decimal.zero, (sum, line) => sum + line.credit),
      );
      expect(entry.lines.first.accountId, 'expense');
      expect(entry.lines.last.accountId, 'cash');
    }
  });
}
