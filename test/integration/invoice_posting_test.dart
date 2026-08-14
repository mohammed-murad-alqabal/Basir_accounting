import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/invoices/application/sales_bridge_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_accounting_repository.dart';
import '../helpers/mock_customer_repository.dart';
import '../helpers/mock_financial_year_repository.dart';
import '../helpers/mock_invoice_repository.dart';
import '../helpers/mock_sales_bridge_service.dart';
import '../helpers/rust_lib_test_helper.dart';

class FakeOrchestratorService extends OrchestratorService {
  @override
  Future<AgentConsensus> orchestrate(AccountingContext context) async =>
      AgentConsensus(
        isApproved: true,
        explanation: 'Fake approval',
        agentResults: [],
        orchestrationTimestamp: DateTime.now(),
      );
}

void main() {
  group('Invoice Posting Integration', () {
    late ProviderContainer container;
    late MockAccountingRepository mockAccountingRepo;
    late MockFinancialYearRepository mockFyRepo;
    late MockCustomerRepository mockCustomerRepo;
    late MockSalesBridgeService mockSalesBridge;
    late MockInvoiceRepository mockInvoiceRepo;

    setUp(() {
      // Initialize mock RustLib to prevent initialization errors
      setupMockRustLib();

      mockAccountingRepo = MockAccountingRepository();
      mockFyRepo = MockFinancialYearRepository();
      mockCustomerRepo = MockCustomerRepository();
      mockSalesBridge = MockSalesBridgeService();
      mockInvoiceRepo = MockInvoiceRepository();

      setUpAccountingMocks(); // Register fallback values if any
      setUpInvoiceMocks();

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
      registerFallbackValue(
        AccountingContext(
          proposedJournalEntry: JournalEntry(
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
          transactionType: '',
        ),
      );

      container = ProviderContainer(
        overrides: [
          accountingRepositoryProvider.overrideWithValue(mockAccountingRepo),
          financialYearRepositoryProvider.overrideWithValue(mockFyRepo),
          customerRepositoryProvider.overrideWithValue(mockCustomerRepo),
          salesBridgeServiceProvider.overrideWithValue(mockSalesBridge),
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
          orchestratorServiceProvider.overrideWith(FakeOrchestratorService.new),
          basirUserProvider.overrideWith((ref) => null),
        ],
      );

      // 1. Open Financial Year
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

      when(
        () => mockAccountingRepo.getAccounts(),
      ).thenAnswer((_) async => [revenueAccount, taxAccount]);

      when(
        () => mockAccountingRepo.getJournalEntries(),
      ).thenAnswer((_) async => []);

      when(
        () => mockAccountingRepo.addJournalEntry(any()),
      ).thenAnswer((_) async {});
    });

    tearDown(() {
      container.dispose();
      disposeMockRustLib();
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

      when(
        () => mockCustomerRepo.getCustomerById('cust-1'),
      ).thenAnswer((_) async => customer);

      when(
        () => mockInvoiceRepo.updateInvoice(any()),
      ).thenAnswer((_) async {});

      // Create Invoice
      final invoice = Invoice(
        id: 'inv-100',
        invoiceNumber: 'INV-100',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: DateTime(2025, 5, 20),
        dueDate: DateTime(2025, 6, 20),
        subtotalAmount: Decimal.fromInt(1000),
        taxAmount: Decimal.fromInt(150),
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        totalAmount: Decimal.fromInt(1150),
        paidAmount: Decimal.zero,
        taxRate: Decimal.fromInt(15),
        status: InvoiceStatus.sent,
        createdAt: DateTime(2025, 5, 20),
        updatedAt: DateTime(2025, 5, 20),
        exchangeRate: Decimal.one,
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
      final arLine = entry.lines.firstWhere(
        (l) => l.accountId == 'acc-1201-c1',
      );
      expect(arLine.debit, equals(Decimal.parse('1150.0')));

      final revenueLine = entry.lines.firstWhere(
        (l) => l.accountId == 'acc-4101',
      );
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
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        totalAmount: Decimal.fromInt(100),
        paidAmount: Decimal.zero,
        taxRate: Decimal.zero,
        status: InvoiceStatus.sent,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        exchangeRate: Decimal.one,
        items: [],
      );

      final logic = container.read(accountingServiceProvider.notifier);

      expect(() => logic.postSalesInvoice(invoice), throwsException);
    });

    test('postSalesInvoice لا يرحّل فاتورة سبق إنشاء قيدها', () async {
      const invoiceId = 'inv-existing';
      final existingEntry = JournalEntry(
        id: 'je-inv-$invoiceId',
        referenceNumber: 'JE-$invoiceId',
        date: DateTime(2025, 5, 20),
        temporal: TemporalJustification(
          transactionDate: DateTime(2025, 5, 20),
          effectiveDate: DateTime(2025, 5, 20),
          recordingDate: DateTime(2025, 5, 20),
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS 15',
          recognitionBasis: 'Accrual',
        ),
        description: 'Existing posting',
        status: JournalEntryStatus.posted,
        sourceDocument: 'invoice',
        sourceId: invoiceId,
        createdBy: 'system',
        createdAt: DateTime(2025, 5, 20),
        updatedAt: DateTime(2025, 5, 20),
        lines: const [],
      );
      when(
        () => mockAccountingRepo.getJournalEntries(),
      ).thenAnswer((_) async => [existingEntry]);
      when(
        () => mockCustomerRepo.getCustomerById('cust-1'),
      ).thenAnswer((_) async => null);

      final invoice = Invoice(
        id: invoiceId,
        invoiceNumber: 'INV-EXISTING',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: DateTime(2025, 5, 20),
        dueDate: DateTime(2025, 6, 20),
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        totalAmount: Decimal.fromInt(100),
        paidAmount: Decimal.zero,
        taxRate: Decimal.zero,
        status: InvoiceStatus.sent,
        createdAt: DateTime(2025, 5, 20),
        updatedAt: DateTime(2025, 5, 20),
        exchangeRate: Decimal.one,
        items: const [],
      );

      await container
          .read(accountingServiceProvider.notifier)
          .postSalesInvoice(invoice);

      verifyNever(() => mockAccountingRepo.addJournalEntry(any()));
    });

    test('postSalesInvoice يرفض الفاتورة غير القابلة للترحيل', () async {
      final invoice = Invoice(
        id: 'inv-draft',
        invoiceNumber: 'INV-DRAFT',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: DateTime(2025, 5, 20),
        dueDate: DateTime(2025, 6, 20),
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        totalAmount: Decimal.fromInt(100),
        paidAmount: Decimal.zero,
        taxRate: Decimal.zero,
        status: InvoiceStatus.draft,
        createdAt: DateTime(2025, 5, 20),
        updatedAt: DateTime(2025, 5, 20),
        exchangeRate: Decimal.one,
        items: const [],
      );

      await expectLater(
        container
            .read(accountingServiceProvider.notifier)
            .postSalesInvoice(invoice),
        throwsA(
          isA<Exception>().having(
            (error) => error.toString(),
            'message',
            contains('Can only post'),
          ),
        ),
      );
      verifyNever(() => mockAccountingRepo.addJournalEntry(any()));
    });

    test('postJournalEntry يسجل تجاوز الإجماع للقيد اليدوي المتوازن', () async {
      final entry = JournalEntry(
        id: 'manual-1',
        referenceNumber: 'JE-MANUAL-1',
        date: DateTime(2025, 5, 20),
        temporal: TemporalJustification(
          transactionDate: DateTime(2025, 5, 20),
          effectiveDate: DateTime(2025, 5, 20),
          recordingDate: DateTime(2025, 5, 20),
        ),
        standards: const StandardsJustification(
          standardReference: 'IAS 1',
          recognitionBasis: 'Accrual',
        ),
        description: 'Manual balanced entry',
        status: JournalEntryStatus.posted,
        sourceDocument: 'manual',
        sourceId: 'manual-1',
        createdBy: 'tester',
        createdAt: DateTime(2025, 5, 20),
        updatedAt: DateTime(2025, 5, 20),
        lines: [
          JournalEntryLine(
            accountId: 'acc-1000',
            accountName: 'Cash',
            debit: Decimal.fromInt(100),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-4101',
            accountName: 'Sales',
            debit: Decimal.zero,
            credit: Decimal.fromInt(100),
          ),
        ],
      );

      await container
          .read(accountingServiceProvider.notifier)
          .postJournalEntry(entry, bypassCognitive: true);

      final captured = verify(
        () => mockAccountingRepo.addJournalEntry(captureAny()),
      ).captured.single as JournalEntry;
      expect(captured.isBalanced, isTrue);
      expect(captured.auditLogs, hasLength(1));
      expect(captured.auditLogs.single.action, 'COGNITIVE_BYPASS');
    });

    test('postJournalEntry يرفض القيد اليدوي غير المتوازن قبل ترحيله',
        () async {
      final entry = JournalEntry(
        id: 'manual-unbalanced',
        referenceNumber: 'JE-MANUAL-UNBALANCED',
        date: DateTime(2025, 5, 20),
        temporal: TemporalJustification(
          transactionDate: DateTime(2025, 5, 20),
          effectiveDate: DateTime(2025, 5, 20),
          recordingDate: DateTime(2025, 5, 20),
        ),
        standards: const StandardsJustification(
          standardReference: 'IAS 1',
          recognitionBasis: 'Accrual',
        ),
        description: 'Manual unbalanced entry',
        status: JournalEntryStatus.draft,
        sourceDocument: 'manual',
        sourceId: 'manual-unbalanced',
        createdBy: 'tester',
        createdAt: DateTime(2025, 5, 20),
        updatedAt: DateTime(2025, 5, 20),
        lines: [
          JournalEntryLine(
            accountId: 'acc-1000',
            accountName: 'Cash',
            debit: Decimal.fromInt(100),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-4101',
            accountName: 'Sales',
            debit: Decimal.zero,
            credit: Decimal.fromInt(90),
          ),
        ],
      );

      await expectLater(
        container
            .read(accountingServiceProvider.notifier)
            .postJournalEntry(entry, bypassCognitive: true),
        throwsA(isA<Exception>()),
      );
      verifyNever(() => mockAccountingRepo.addJournalEntry(any()));
    });

    test('reverseJournalEntry ينشئ قيداً معاكساً متوازناً للقيد المرحّل',
        () async {
      final now = DateTime.now();
      final original = JournalEntry(
        id: 'posted-entry',
        referenceNumber: 'JE-POSTED-1',
        date: now,
        temporal: TemporalJustification(
          transactionDate: now,
          effectiveDate: now,
          recordingDate: now,
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS 15',
          recognitionBasis: 'Accrual',
          measurementBasis: 'Transaction Price',
        ),
        description: 'Posted sales entry',
        status: JournalEntryStatus.posted,
        sourceDocument: 'invoice',
        sourceId: 'inv-reversal',
        createdBy: 'tester',
        createdAt: now,
        updatedAt: now,
        lines: [
          JournalEntryLine(
            accountId: 'acc-1201',
            accountName: 'Receivable',
            debit: Decimal.fromInt(115),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-4101',
            accountName: 'Sales',
            debit: Decimal.zero,
            credit: Decimal.fromInt(115),
          ),
        ],
      );
      when(() => mockAccountingRepo.getJournalEntries())
          .thenAnswer((_) async => [original]);
      when(() => mockFyRepo.getFinancialYearByDate(any())).thenAnswer(
        (_) async => FinancialYear(
          id: 'fy-current',
          name: '${now.year}',
          startDate: DateTime(now.year),
          endDate: DateTime(now.year, 12, 31),
        ),
      );

      await container
          .read(accountingServiceProvider.notifier)
          .reverseJournalEntry(original.id);

      final reversal = verify(
        () => mockAccountingRepo.addJournalEntry(captureAny()),
      ).captured.single as JournalEntry;
      expect(reversal.referenceNumber, 'RV-${original.referenceNumber}');
      expect(reversal.status, JournalEntryStatus.posted);
      expect(reversal.isBalanced, isTrue);
      expect(reversal.lines[0].debit, original.lines[0].credit);
      expect(reversal.lines[0].credit, original.lines[0].debit);
      expect(reversal.lines[1].debit, original.lines[1].credit);
      expect(reversal.lines[1].credit, original.lines[1].debit);
    });

    test('reverseInvoice يلغي الفاتورة ويعكس قيدها المرحّل', () async {
      final now = DateTime.now();
      final invoice = Invoice(
        id: 'inv-cancel',
        invoiceNumber: 'INV-CANCEL',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: now,
        dueDate: now.add(const Duration(days: 7)),
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.fromInt(15),
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        totalAmount: Decimal.fromInt(115),
        paidAmount: Decimal.zero,
        taxRate: Decimal.fromInt(15),
        status: InvoiceStatus.sent,
        createdAt: now,
        updatedAt: now,
        exchangeRate: Decimal.one,
        items: const [],
      );
      final original = JournalEntry(
        id: 'je-inv-${invoice.id}',
        referenceNumber: 'JE-${invoice.id}',
        date: now,
        temporal: TemporalJustification(
          transactionDate: now,
          effectiveDate: now,
          recordingDate: now,
        ),
        standards: const StandardsJustification(
          standardReference: 'IFRS 15',
          recognitionBasis: 'Accrual',
        ),
        description: 'Invoice posting',
        status: JournalEntryStatus.posted,
        sourceDocument: 'invoice',
        sourceId: invoice.id,
        createdBy: 'tester',
        createdAt: now,
        updatedAt: now,
        lines: [
          JournalEntryLine(
            accountId: 'acc-1201',
            accountName: 'Receivable',
            debit: Decimal.fromInt(115),
            credit: Decimal.zero,
          ),
          JournalEntryLine(
            accountId: 'acc-4101',
            accountName: 'Sales',
            debit: Decimal.zero,
            credit: Decimal.fromInt(115),
          ),
        ],
      );
      when(() => mockInvoiceRepo.updateInvoice(any())).thenAnswer((_) async {});
      when(() => mockAccountingRepo.getJournalEntries())
          .thenAnswer((_) async => [original]);
      when(() => mockFyRepo.getFinancialYearByDate(any())).thenAnswer(
        (_) async => FinancialYear(
          id: 'fy-current',
          name: '${now.year}',
          startDate: DateTime(now.year),
          endDate: DateTime(now.year, 12, 31),
        ),
      );

      await container
          .read(accountingServiceProvider.notifier)
          .reverseInvoice(invoice);

      final cancelled = verify(
        () => mockInvoiceRepo.updateInvoice(captureAny()),
      ).captured.single as Invoice;
      expect(cancelled.status, InvoiceStatus.cancelled);
      expect(cancelled.notes, contains('Cancelled on'));
      final reversal = verify(
        () => mockAccountingRepo.addJournalEntry(captureAny()),
      ).captured.single as JournalEntry;
      expect(reversal.referenceNumber, 'RV-${original.referenceNumber}');
      expect(reversal.isBalanced, isTrue);
    });

    test('getLiquidityForecast يجمع المستحقات والمدفوعات ضمن نطاق اليوم',
        () async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final receivable = Invoice(
        id: 'inv-receivable',
        invoiceNumber: 'INV-RECEIVABLE',
        customerId: 'cust-1',
        customerName: 'Client A',
        issuedDate: today,
        dueDate: today.add(const Duration(days: 1)),
        subtotalAmount: Decimal.fromInt(100),
        taxAmount: Decimal.zero,
        discountAmount: Decimal.zero,
        discountRate: Decimal.zero,
        totalAmount: Decimal.fromInt(120),
        paidAmount: Decimal.fromInt(20),
        taxRate: Decimal.zero,
        status: InvoiceStatus.sent,
        createdAt: today,
        updatedAt: today,
        exchangeRate: Decimal.one,
        items: const [],
      );
      final overduePayable = receivable.copyWith(
        id: 'inv-payable',
        invoiceNumber: 'INV-PAYABLE',
        customerId: 'vendor-1',
        customerName: 'Vendor A',
        dueDate: today.subtract(const Duration(days: 2)),
        subtotalAmount: Decimal.fromInt(60),
        totalAmount: Decimal.fromInt(75),
        paidAmount: Decimal.fromInt(15),
        status: InvoiceStatus.overdue,
        type: InvoiceType.purchase,
      );
      final settled = receivable.copyWith(
        id: 'inv-settled',
        invoiceNumber: 'INV-SETTLED',
        dueDate: today.add(const Duration(days: 2)),
        totalAmount: Decimal.fromInt(999),
        paidAmount: Decimal.zero,
        status: InvoiceStatus.paid,
      );
      when(() => mockInvoiceRepo.getAllInvoices())
          .thenAnswer((_) async => [receivable, overduePayable, settled]);

      final forecast = await container
          .read(accountingServiceProvider.notifier)
          .getLiquidityForecast(days: 3);

      expect(forecast.totalInflow, Decimal.fromInt(100));
      expect(forecast.totalOutflow, Decimal.fromInt(60));
      expect(forecast.netChange, Decimal.fromInt(40));
      expect(forecast.dailyBreakdown, hasLength(4));
      expect(forecast.dailyBreakdown.first.outflow, Decimal.fromInt(60));
      expect(forecast.dailyBreakdown[1].inflow, Decimal.fromInt(100));
    });

    test('seedDefaultAccounts يضيف دليل الحسابات العالمي عندما يكون فارغاً',
        () async {
      final expectedAccounts = MultiStandardCoaEngine.generateCoa(
        AccountingCountry.global,
      );
      when(() => mockAccountingRepo.getAccounts()).thenAnswer((_) async => []);
      when(() => mockAccountingRepo.getAccountById(any()))
          .thenAnswer((call) async {
        final id = call.positionalArguments.single as String;
        return expectedAccounts.firstWhere((account) => account.id == id);
      });
      when(() => mockAccountingRepo.addAccount(any())).thenAnswer((_) async {});

      await container
          .read(accountingServiceProvider.notifier)
          .seedDefaultAccounts();

      final addedAccounts = verify(
        () => mockAccountingRepo.addAccount(captureAny()),
      ).captured.cast<Account>();
      expect(addedAccounts, hasLength(expectedAccounts.length));
      expect(
        addedAccounts.map((account) => account.code),
        containsAll(expectedAccounts.map((account) => account.code)),
      );
    });
  });
}
