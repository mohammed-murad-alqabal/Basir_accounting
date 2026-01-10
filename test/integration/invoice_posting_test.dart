import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_accounting_repository.dart';
import '../helpers/mock_customer_repository.dart';
import '../helpers/mock_financial_year_repository.dart';

void main() {
  group('Invoice Posting Integration', () {
    late ProviderContainer container;
    late MockAccountingRepository mockAccountingRepo;
    late MockFinancialYearRepository mockFyRepo;
    late MockCustomerRepository mockCustomerRepo;

    setUp(() {
      mockAccountingRepo = MockAccountingRepository();
      mockFyRepo = MockFinancialYearRepository();
      mockCustomerRepo = MockCustomerRepository();

      setUpAccountingMocks(); // Register fallback values if any

      // Fallback for Invoice/JournalEntry logic
      registerFallbackValue(
        JournalEntry(
          id: 'fallback',
          referenceNumber: '',
          date: DateTime.now(),
          temporal: TemporalJustification(
            transactionDate: DateTime.now(),
            effectiveDate: DateTime.now(),
            recordingDate: DateTime.now(),
          ),
          standards: const StandardsJustification(
            standardReference: '',
            recognitionBasis: '',
          ),
          description: '',
          status: JournalEntryStatus.draft,
          sourceDocument: '',
          sourceId: '',
          createdBy: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lines: [],
        ),
      );

      container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(mockAccountingRepo),
          financialYearRepositoryProvider.overrideWithValue(mockFyRepo),
          customerRepositoryProvider.overrideWithValue(mockCustomerRepo),
          basirUserProvider.overrideWith((ref) => null),
        ],
      );

      // Default behaviors
      // 1. Open Financial Year
      when(() => mockFyRepo.getFinancialYearByDate(any())).thenAnswer(
        (_) async => FinancialYear(
          id: 'fy-2025',
          name: '2025',
          startDate: DateTime(2025),
          endDate: DateTime(2025, 12, 31),
        ),
      );

      // 2. Default Accounts for Revenue/Tax
      final revenueAccount = Account(
        id: 'acc-4101',
        code: '4101',
        nameAr: 'المبيعات',
        nameEn: 'Sales',
        type: AccountType.revenue,
        nature: AccountNature.credit,
        balance: Decimal.zero,
      );
      final taxAccount = Account(
        id: 'acc-2105',
        code: '2105',
        nameAr: 'الضريبة',
        nameEn: 'VAT',
        type: AccountType.liability,
        nature: AccountNature.credit,
        balance: Decimal.zero,
      );

      when(() => mockAccountingRepo.getAccounts()).thenAnswer(
        (_) async => [revenueAccount, taxAccount],
      );

      when(() => mockAccountingRepo.getJournalEntries()).thenAnswer(
        (_) async => [],
      );

      when(() => mockAccountingRepo.addJournalEntry(any()))
          .thenAnswer((_) async {});
    });

    tearDown(() {
      container.dispose();
    });

    test('postSalesInvoice should create correct Journal Entry', () async {
      // Setup Customer
      final customer = Customer(
        id: 'cust-1',
        nameAr: 'Client A',
        nameEn: 'Client A',
        email: 'test@test.com',
        phone: '123',
        address: 'Riyadh',
        receivableAccountId: 'acc-1201-c1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockCustomerRepo.getCustomerById('cust-1'))
          .thenAnswer((_) async => customer);

      // Create Invoice
      final invoice = Invoice(
        id: 'inv-100',
        invoiceNumber: 'INV-100',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 30)),
        subtotalAmount: 1000,
        taxAmount: 150,
        discountAmount: 0,
        totalAmount: 1150,
        paidAmount: 0,
        taxRate: 15,
        status: InvoiceStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: [],
      );

      final logic = container.read(accountingServiceProvider.notifier);
      await logic.postSalesInvoice(invoice);

      // Verify Journal Entry
      final captured = verify(
        () => mockAccountingRepo.addJournalEntry(captureAny()),
      ).captured;

      final entry = captured.first as JournalEntry;

      expect(entry.sourceId, equals('inv-100'));
      expect(entry.status, equals(JournalEntryStatus.posted));
      expect(entry.lines.length, equals(3)); // AR, Revenue, Tax

      // Verify Lines
      final arLine =
          entry.lines.firstWhere((l) => l.accountId == 'acc-1201-c1');
      expect(arLine.debit, equals(Decimal.parse('1150.0')));

      final revenueLine =
          entry.lines.firstWhere((l) => l.accountId == 'acc-4101');
      expect(revenueLine.credit, equals(Decimal.parse('1000.0')));

      final taxLine = entry.lines.firstWhere((l) => l.accountId == 'acc-2105');
      expect(taxLine.credit, equals(Decimal.parse('150.0')));
    });

    test('postSalesInvoice should fail if period is closed', () async {
      when(() => mockFyRepo.getFinancialYearByDate(any())).thenAnswer(
        (_) async => FinancialYear(
          id: 'fy-2024',
          name: '2024',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 12, 31),
          isClosed: true,
        ),
      );

      final invoice = Invoice(
        id: 'inv-101',
        invoiceNumber: 'INV-101',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: DateTime.now(),
        dueDate: DateTime.now(),
        subtotalAmount: 100,
        taxAmount: 0,
        discountAmount: 0,
        totalAmount: 100,
        paidAmount: 0,
        taxRate: 0,
        status: InvoiceStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: [],
      );

      final logic = container.read(accountingServiceProvider.notifier);

      expect(
        () => logic.postSalesInvoice(invoice),
        throwsException,
      );
    });
  });
}
