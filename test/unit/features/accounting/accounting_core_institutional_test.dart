import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/providers/supabase_auth_provider.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/accounts_payable_service.dart';
import 'package:basir_accounting_system/features/accounting/application/accounts_receivable_service.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_reporting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_voucher_repository.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/financial_year_repository.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/vendors/domain/entities/vendor.dart';
import 'package:basir_accounting_system/features/vendors/domain/repositories/vendor_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class InMemoryCustomerRepository implements CustomerRepository {
  final _customers = <String, Customer>{};

  @override
  Future<List<Customer>> getAllCustomers() async => _customers.values.toList();

  @override
  Future<Customer?> getCustomerById(String id) async => _customers[id];

  @override
  Future<void> addCustomer(Customer customer) async {
    _customers[customer.id] = customer;
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    _customers[customer.id] = customer;
  }

  @override
  Future<void> deleteCustomer(String id) async => _customers.remove(id);

  @override
  Future<List<Customer>> searchCustomers(String query) async =>
      _customers.values
          .where((c) => c.nameAr.contains(query) || c.nameEn.contains(query))
          .toList();

  @override
  Future<void> deleteAllCustomers() async => _customers.clear();
}

class InMemoryVendorRepository implements VendorRepository {
  final _vendors = <String, Vendor>{};

  @override
  Future<List<Vendor>> getAllVendors() async => _vendors.values.toList();

  @override
  Future<Vendor?> getVendorById(String id) async => _vendors[id];

  @override
  Future<void> addVendor(Vendor vendor) async => _vendors[vendor.id] = vendor;

  @override
  Future<void> updateVendor(Vendor vendor) async {
    _vendors[vendor.id] = vendor;
  }

  @override
  Future<void> deleteVendor(String id) async => _vendors.remove(id);

  @override
  Future<List<Vendor>> searchVendors(String query) async => _vendors.values
      .where((v) => v.nameAr.contains(query) || v.nameEn.contains(query))
      .toList();
}

class InMemoryFinancialVoucherRepository implements FinancialVoucherRepository {
  final _vouchers = <String, FinancialVoucher>{};

  @override
  Future<List<FinancialVoucher>> getAllVouchers() async =>
      _vouchers.values.toList();

  @override
  Future<FinancialVoucher?> getVoucherById(String id) async => _vouchers[id];

  @override
  Future<void> addVoucher(FinancialVoucher voucher) async =>
      _vouchers[voucher.id] = voucher;

  @override
  Future<void> updateVoucher(FinancialVoucher voucher) async =>
      _vouchers[voucher.id] = voucher;

  @override
  Future<void> deleteVoucher(String id) async => _vouchers.remove(id);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Institutional Accounting Core Verification', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          financialYearRepositoryProvider.overrideWithValue(
            InMemoryFinancialYearRepository(),
          ),
          accountingRepositoryProvider.overrideWithValue(
            InMemoryAccountingRepository(),
          ),
          customerRepositoryProvider.overrideWithValue(
            InMemoryCustomerRepository(),
          ),
          vendorRepositoryProvider.overrideWithValue(
            InMemoryVendorRepository(),
          ),
          financialVoucherRepositoryProvider.overrideWithValue(
            InMemoryFinancialVoucherRepository(),
          ),
          currentUserProvider.overrideWith((ref) => null),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
        'Verification 1: Accounting Equation Integrity '
        '(Assets = Liabilities + Equity)', () async {
      final accountingService = container.read(
        accountingServiceProvider.notifier,
      );
      final reportingService = container.read(
        financialReportingServiceProvider.notifier,
      );
      final fyRepository = container.read(financialYearRepositoryProvider);

      // Step 0: Seed a financial year
      final now = DateTime.now();
      await fyRepository.saveFinancialYear(
        FinancialYear(
          id: 'fy-2025',
          name: 'FY 2025',
          startDate: DateTime(now.year),
          endDate: DateTime(now.year, 12, 31),
        ),
      );

      // Step 1: Seed global COA
      await accountingService.seedDefaultAccounts();

      // Step 2: Post a sample invoice
      final invoice = Invoice(
        id: 'test-inv-001',
        invoiceNumber: 'INV-GLOBAL-001',
        customerId: 'cust-001',
        customerName: 'Global Client',
        issuedDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 30)),
        taxRate: Decimal.parse('0.15'),
        status: InvoiceStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        exchangeRate: Decimal.one,
        items: [
          InvoiceItem(
            taxRate: Decimal.parse('0.15'),
            id: 'item-1',
            name: 'Elite Consulting',
            quantity: Decimal.one,
            price: Decimal.fromInt(1000),
            total: Decimal.fromInt(1000),
            taxAmount: Decimal.fromInt(150),
          ),
        ],
      );

      await accountingService.postSalesInvoice(invoice);

      // Step 3: Verify Trial Balance sums
      final trialBalance = await reportingService.getTrialBalance();

      var totalDebit = Decimal.zero;
      var totalCredit = Decimal.zero;

      for (final report in trialBalance) {
        totalDebit += report.debit;
        totalCredit += report.credit;
      }

      expect(totalDebit, totalCredit, reason: 'Trial Balance must be equal');
      expect(
        totalDebit,
        Decimal.fromInt(1150),
        reason: 'Total movement should be 1150 (sum of debits) or '
            '1150 (sum of credits)',
      );
    });

    test('Verification 2: Decimal Precision (No Rounding Errors)', () async {
      final accountingService = container.read(
        accountingServiceProvider.notifier,
      );

      await accountingService.seedDefaultAccounts();

      // Accumulate 1,000,000 small transactions of 0.000001
      final tinyAmount = Decimal.parse('0.000001');
      final totalExpected = Decimal.parse('1.0');

      var sum = Decimal.zero;
      for (var i = 0; i < 1000000; i++) {
        sum += tinyAmount;
      }

      expect(
        sum,
        totalExpected,
        reason: 'Decimal must handle high-precision accumulation '
            'without double error',
      );
    });

    test('Verification 3: AR Aging Logic (Institutional Buckets)', () async {
      final arService = container.read(
        accountsReceivableServiceProvider.notifier,
      );
      final accountingService = container.read(
        accountingServiceProvider.notifier,
      );

      await accountingService.seedDefaultAccounts();

      // Get aging report (should be empty initially)
      final report = await arService.getReceivablesAging();
      expect(report.isEmpty, true);
    });

    test(
      'Verification 4: Treasury Service (Receipt & Payment Vouchers)',
      () async {
        final treasuryService = container.read(
          treasuryServiceProvider.notifier,
        );
        final accountingService = container.read(
          accountingServiceProvider.notifier,
        );
        final fyRepository = container.read(financialYearRepositoryProvider);
        final reportingService = container.read(
          financialReportingServiceProvider.notifier,
        );

        // Setup
        final now = DateTime.now();
        await fyRepository.saveFinancialYear(
          FinancialYear(
            id: 'fy-2025',
            name: 'FY 2025',
            startDate: DateTime(now.year),
            endDate: DateTime(now.year, 12, 31),
          ),
        );
        await accountingService.seedDefaultAccounts();

        // 1. Issue Receipt (Dr Cash, Cr Account)
        final receipt = FinancialVoucher(
          id: 'rv-001',
          referenceNumber: 'RV-2025-001',
          date: now,
          type: VoucherType.receipt,
          paymentMethod: PaymentMethod.cash,
          amount: Decimal.parse('500'),
          accountId: 'acc-1201', // AR
          treasuryAccountId: 'acc-1101', // Cash
          description: 'Test Receipt',
          createdAt: now,
        );
        await treasuryService.issueReceipt(receipt);

        final balance = await reportingService.getTrialBalance();
        final cashAcc = balance.firstWhere((b) => b.account.id == 'acc-1101');
        expect(
          cashAcc.balance,
          Decimal.fromInt(500),
          reason: 'Cash should increase by 500',
        );

        // 2. Issue Payment (Dr Account, Cr Cash)
        final payment = FinancialVoucher(
          id: 'pv-001',
          referenceNumber: 'PV-2025-001',
          date: now,
          type: VoucherType.payment,
          paymentMethod: PaymentMethod.cash,
          amount: Decimal.parse('200'),
          accountId: 'acc-5', // Expenses
          treasuryAccountId: 'acc-1101',
          description: 'Test Expense',
          createdAt: now,
        );
        await treasuryService.issuePayment(payment);

        final updatedBalance = await reportingService.getTrialBalance();
        final cashAccUpdated = updatedBalance.firstWhere(
          (b) => b.account.id == 'acc-1101',
        );
        expect(
          cashAccUpdated.balance,
          Decimal.fromInt(300),
          reason: 'Cash should decrease to 300 (500-200)',
        );
      },
    );

    test('Verification 5: Accounts Payable (AP) Logic', () async {
      final apService = container.read(accountsPayableServiceProvider.notifier);
      final accountingService = container.read(
        accountingServiceProvider.notifier,
      );
      final repository = container.read(accountingRepositoryProvider);

      await accountingService.seedDefaultAccounts();

      // Manually add a journal entry for a supplier
      final now = DateTime.now();
      final entry = JournalEntry(
        id: 'je-supp-001',
        referenceNumber: 'SUPP-001',
        date: now,
        temporal: TemporalJustification(
          transactionDate: now,
          effectiveDate: now,
          recordingDate: now,
        ),
        standards: const StandardsJustification(
          standardReference:
              'IFRS 2', // GAAP: Share-based Payment (Placeholder)
          recognitionBasis: 'Accrual',
          measurementBasis: 'Historical Cost',
        ),
        description: 'Purchase from Supplier A',
        status: JournalEntryStatus.posted,
        lines: [
          JournalEntryLine(
            accountId: 'acc-5', // Expense
            accountName: 'Expenses',
            debit: Decimal.parse('1000'),
            credit: Decimal.zero,
            description: 'Test',
          ),
          JournalEntryLine(
            accountId: 'acc-2101', // AP
            accountName: 'Suppliers - Supplier A',
            credit: Decimal.parse('1000'),
            debit: Decimal.zero,
            description: 'Test',
          ),
        ],
        sourceDocument: 'purchase_invoice',
        sourceId: 'inv-supp-001',
        createdAt: now,
        createdBy: 'test',
        updatedAt: now,
        postedAt: now,
      );
      await repository.addJournalEntry(entry);

      final balance = await apService.getSupplierBalance('Supplier A');
      expect(
        balance,
        Decimal.parse('1000'),
        reason: 'Supplier balance should be 1000',
      );

      final aging = await apService.getPayablesAging();
      expect(aging, isA<List<SupplierAging>>());
    });

    test('Verification 6: IFRS 18 Categorization Integrity', () async {
      final reportingService = container.read(
        financialReportingServiceProvider.notifier,
      );
      final accountingService = container.read(
        accountingServiceProvider.notifier,
      );

      await accountingService.seedDefaultAccounts();

      // Seeding logic already sets up ifrs18Category for Operating
      // (acc-4, acc-5)
      // Any movements in acc-4 (Revenue) or acc-5 (Expense) should
      // reflect in IFRS 18

      final ifrs18Report = await reportingService.getIfrs18IncomeStatement();
      expect(ifrs18Report.containsKey(Ifrs18Category.operating), true);
    });
  });
}

/// نسخة تجريبية في الذاكرة لمستودع السنوات المالية
class InMemoryFinancialYearRepository implements FinancialYearRepository {
  final Map<String, FinancialYear> _years = {};

  @override
  Future<FinancialYear?> getCurrentFinancialYear() async =>
      _years.values.where((y) => !y.isClosed).lastOrNull;

  @override
  Future<FinancialYear?> getFinancialYearByDate(DateTime date) async {
    for (final year in _years.values) {
      if (year.containsDate(date)) return year;
    }
    return null;
  }

  @override
  Future<List<FinancialYear>> getAllFinancialYears() async =>
      _years.values.toList();

  @override
  Future<void> saveFinancialYear(FinancialYear year) async {
    _years[year.id] = year;
  }

  @override
  Future<void> closeFinancialYear(String id, String userId) async {
    final year = _years[id];
    if (year != null) {
      _years[id] = year.copyWith(
        isClosed: true,
        closedAt: DateTime.now(),
        closedBy: userId,
      );
    }
  }

  @override
  Future<bool> isPeriodOpen(DateTime date) async {
    final year = await getFinancialYearByDate(date);
    if (year == null) return false;
    if (year.isClosed) return false;
    final periodId = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    return !year.lockedPeriodIds.contains(periodId);
  }
}

/// نسخة تجريبية في الذاكرة لمستودع المحاسبة
class InMemoryAccountingRepository implements AccountingRepository {
  final Map<String, Account> _accounts = {};
  final List<JournalEntry> _entries = [];

  @override
  Future<List<Account>> getAccounts() async => _accounts.values.toList();

  @override
  Future<Account?> getAccountById(String id) async => _accounts[id];

  @override
  Future<void> addAccount(Account account) async {
    _accounts[account.id] = account;
  }

  @override
  Future<void> updateAccount(Account account) async {
    _accounts[account.id] = account;
  }

  @override
  Future<List<JournalEntry>> getJournalEntries() async => _entries;

  @override
  Future<void> addJournalEntry(JournalEntry entry) async {
    _entries.add(entry);
    // تحديث الأرصدة
    for (final line in entry.lines) {
      final account = _accounts[line.accountId];
      if (account != null) {
        var movement = Decimal.zero;
        if (account.nature == AccountNature.debit) {
          movement = line.debit - line.credit;
        } else {
          movement = line.credit - line.debit;
        }
        _accounts[account.id] = account.copyWith(
          balance: account.balance + movement,
        );
      }
    }
  }

  @override
  Future<Decimal> getAccountBalance(String accountId) async =>
      _accounts[accountId]?.balance ?? Decimal.zero;
}
