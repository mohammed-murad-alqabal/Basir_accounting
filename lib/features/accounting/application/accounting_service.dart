// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/financial_year_service.dart';
import 'package:basir_accounting_system/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/liquidity_forecast.dart';
import 'package:basir_accounting_system/features/accounting/domain/exceptions/cognitive_exceptions.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_accounting_system/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_accounting_system/features/invoices/application/sales_bridge_service.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart'
    as domain_inv;
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'accounting_service.g.dart';

/// Central Accounting Service managing the Chart of Accounts and core ledger
/// operations.
///
/// This service implements critical financial logic including COA seeding,
/// account validation (IFRS compliance), journal entry posting, and
/// dual-entry orchestration for sales invoices.
///
/// ## Key Capabilities
/// - **COA Management**: Multi-standard Chart of Accounts generation
///   (IFRS, KSA, UAE).
/// - **Ledger Integrity**: Strict validation of account types and nature for
///   hierarchical structures.
/// - **Transaction Orchestration**: Automatic journal entry generation from
/// source documents (Invoices).
/// - **Hierarchical Reporting**: Recursive balance calculation for
///   parent/child accounts.
@Riverpod(keepAlive: true)
class AccountingService extends _$AccountingService {
  AccountingRepository get _repository =>
      ref.read(accountingRepositoryProvider);

  FinancialYearService get _financialYearService =>
      ref.read(financialYearServiceProvider.notifier);

  CustomerRepository get _customerRepository =>
      ref.read(customerRepositoryProvider);

  @override
  FutureOr<List<JournalEntry>> build() => _repository.getJournalEntries();

  /// Generates a liquidity forecast for the next [days].
  /// (Implementation of Treasury Hub Forecasting)
  ///
  /// Aggregates expected inflows (Receivables) and outflows (Payables)
  /// based on invoice due dates.
  Future<LiquidityForecast> getLiquidityForecast({int days = 30}) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = startDate.add(Duration(days: days));

    // Fetch all invoices (this should be optimized with a specialized query in the future)
    // currently performing in-memory filtering as per Phase 1 implementation.
    final invoices = await ref.read(invoiceRepositoryProvider).getAllInvoices();

    var totalInflow = Decimal.zero;
    var totalOutflow = Decimal.zero;
    final dailyMap = <DateTime, DailyCashFlow>{};

    // Initialize map for all days in range
    for (var i = 0; i <= days; i++) {
      final date = startDate.add(Duration(days: i));
      dailyMap[date] = DailyCashFlow(
        date: date,
        inflow: Decimal.zero,
        outflow: Decimal.zero,
      );
    }

    for (final invoice in invoices) {
      // 1. Filter: Only Unpaid (Sent or Overdue)
      if (invoice.status != InvoiceStatus.sent &&
          invoice.status != InvoiceStatus.overdue) {
        continue;
      }

      // 2. Filter: Determine Balance
      final balance = invoice.totalAmount - invoice.paidAmount;
      if (balance <= Decimal.zero) continue;

      // 3. Filter: Date Range
      // Normalize due date to midnight
      final due = DateTime(
        invoice.dueDate.year,
        invoice.dueDate.month,
        invoice.dueDate.day,
      );

      // Handle overdue items as "Due Today" (startDate) for immediate liquidity view
      // or keep their original date?
      // Decision: Determine effective date. If overdue, set to startDate.
      final effectiveDate = due.isBefore(startDate) ? startDate : due;

      if (effectiveDate.isAfter(endDate)) continue;

      // 4. Aggregate
      final isReceivable = invoice.type == InvoiceType.sales ||
          invoice.type == InvoiceType.purchaseReturn; // We get money

      final isPayable = invoice.type == InvoiceType.purchase ||
          invoice.type == InvoiceType.salesReturn; // We pay money

      // Get existing daily flow or create (if mapped to startDate due to overdue)
      var daily = dailyMap[effectiveDate] ??
          DailyCashFlow(
            date: effectiveDate,
            inflow: Decimal.zero,
            outflow: Decimal.zero,
          );

      if (isReceivable) {
        totalInflow += balance;
        daily = daily.copyWith(inflow: daily.inflow + balance);
      } else if (isPayable) {
        totalOutflow += balance;
        daily = daily.copyWith(outflow: daily.outflow + balance);
      }

      dailyMap[effectiveDate] = daily;
    }

    final dailyBreakdown = dailyMap.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return LiquidityForecast(
      startDate: startDate,
      endDate: endDate,
      totalInflow: totalInflow,
      totalOutflow: totalOutflow,
      netChange: totalInflow - totalOutflow,
      dailyBreakdown: dailyBreakdown,
    );
  }

  /// Generates and seeds the default Chart of Accounts for a specific country.
  /// (Implementation of FR-ACC-009)
  ///
  /// Supports international and regional standards (KSA, UAE, Egypt).
  /// Skips seeding if accounts already exist in the repository.
  ///
  /// ## Parameters
  /// - [country]: The [AccountingCountry] standard to apply.

  Future<void> seedDefaultAccounts({
    AccountingCountry country = AccountingCountry.global,
  }) async {
    final existingAccounts = await _repository.getAccounts();
    if (existingAccounts.isNotEmpty) return;

    final accounts = MultiStandardCoaEngine.generateCoa(country);

    for (final account in accounts) {
      await addAccount(account);
    }
  }

  /// Adds a new account with hierarchical integrity validation.
  /// (Implementation of FR-ACC-014)
  ///
  /// ## Validations
  /// - Verifies existence of parent account if [Account.parentId] is provided.
  /// - Ensures [Account.type] and [Account.nature] match the parent account.
  ///
  /// ## Throws
  /// - [Exception] if parent is missing or validation fails.
  Future<void> addAccount(Account account) async {
    if (account.parentId != null) {
      final parent = await _repository.getAccountById(account.parentId!);
      if (parent == null) {
        throw Exception('Parent account not found: ${account.parentId}');
      }

      if (parent.type != account.type) {
        throw Exception(
          'Account type (${account.type}) must match parent type '
          '(${parent.type})',
        );
      }
      if (parent.nature != account.nature) {
        throw Exception(
          'Account nature (${account.nature}) must match parent nature '
          '(${parent.nature})',
        );
      }
    }

    await _repository.addAccount(account);
  }

  /// Unified entry point for posting any invoice type to the ledger.
  /// Dispatches to specialized methods based on [InvoiceType].
  Future<void> postInvoice(
    domain_inv.Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    switch (invoice.type) {
      case InvoiceType.sales:
        return postSalesInvoice(invoice, bypassCognitive: bypassCognitive);
      case InvoiceType.purchase:
        return _postPurchaseInvoice(invoice, bypassCognitive: bypassCognitive);
      case InvoiceType.salesReturn:
        return _postSalesReturn(invoice, bypassCognitive: bypassCognitive);
      case InvoiceType.purchaseReturn:
        return _postPurchaseReturn(invoice, bypassCognitive: bypassCognitive);
      case InvoiceType.damage:
        return _postDamageInvoice(invoice, bypassCognitive: bypassCognitive);
    }
  }

  /// Posts a sales invoice to the ledger using double-entry logic.
  /// (Implementation of FR-ACC-001)
  ///
  /// Transforms an invoice into a balanced [JournalEntry] with the following
  /// impact:
  /// - **Debit**: Accounts Receivable (Total Invoice Amount)
  /// - **Credit**: Revenue (Subtotal Amount)
  /// - **Credit**: Tax Liability (Tax Amount)
  ///
  /// ## Parameters
  /// - [invoice]: The [domain_inv.Invoice] entity to post.
  ///
  ///   invalid.
  Future<void> postSalesInvoice(
    domain_inv.Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    final isPeriodOpen =
        await _financialYearService.canPostToDate(invoice.issuedDate);
    if (!isPeriodOpen) {
      throw Exception('Cannot post to a closed or undefined financial period');
    }

    if (invoice.status != InvoiceStatus.sent &&
        invoice.status != InvoiceStatus.paid &&
        invoice.status != InvoiceStatus.overdue) {
      throw Exception('Can only post issued, paid, or overdue invoices');
    }

    final lines = <JournalEntryLine>[];

    // Debit: Accounts Receivable
    var receivableAccountId = 'acc-1201'; // Default AR

    final customer =
        await _customerRepository.getCustomerById(invoice.customerId);
    if (customer != null && customer.receivableAccountId != null) {
      receivableAccountId = customer.receivableAccountId!;
    }

    lines.add(
      JournalEntryLine(
        accountId: receivableAccountId,
        accountName: 'Receivable - ${invoice.customerName}',
        description: 'Sales Invoice #${invoice.invoiceNumber}',
        debit: invoice.totalAmountBaseCurrency,
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount: invoice.currency != 'SAR' ? invoice.totalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    // Credit: Revenue
    final allAccounts = await _repository.getAccounts();
    final revenueAccount = allAccounts.firstWhere(
      (a) => a.code == '4101' || a.subType == 'revenue',
      orElse: () =>
          allAccounts.firstWhere((a) => a.type == AccountType.revenue),
    );

    final revenueLine = JournalEntryLine(
      accountId: revenueAccount.id,
      credit: invoice.subtotalAmountBaseCurrency,
      debit: Decimal.zero,
      accountName: revenueAccount.nameEn,
      description: 'Revenue for Invoice #${invoice.invoiceNumber}',
      originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
      originalAmount: invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
      exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
    );
    lines.add(revenueLine);

    // Credit: Tax Liability
    if (invoice.taxAmount > Decimal.zero) {
      final taxAccount = allAccounts.firstWhere(
        (a) => a.code == '2105' || a.nameEn.contains('VAT'),
        orElse: () => Account(
          id: 'acc-2105',
          code: '2105',
          nameAr: 'الضريبة',
          nameEn: 'Tax',
          type: AccountType.liability,
          nature: AccountNature.credit,
          balance: Decimal.zero,
        ),
      );

      lines.add(
        JournalEntryLine(
          accountId: taxAccount.id,
          accountName: taxAccount.nameEn,
          description: 'VAT for Invoice #${invoice.invoiceNumber}',
          credit: invoice.taxAmountBaseCurrency,
          debit: Decimal.zero,
          originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
          originalAmount: invoice.currency != 'SAR' ? invoice.taxAmount : null,
          exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
        ),
      );
    }

    final journalEntryId = 'je-inv-${invoice.id}';
    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final existingEntries = await _repository.getJournalEntries();
    if (existingEntries.any((e) => e.id == journalEntryId)) {
      return;
    }

    final entry = JournalEntry(
      id: journalEntryId,
      referenceNumber: 'JE-${invoice.id}',
      date: invoice.issuedDate,
      temporal: TemporalJustification(
        transactionDate: invoice.issuedDate,
        effectiveDate: invoice.issuedDate,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 15',
        recognitionBasis: 'Accrual',
        measurementBasis: 'Transaction Price',
      ),
      description: 'Posting sales invoice ${invoice.id}',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'invoice',
      sourceId: invoice.id,
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    if (!entry.isBalanced) {
      throw Exception(
        'Journal Entry is unbalanced! Difference: '
        '${entry.totalDebit - entry.totalCredit}',
      );
    }

    // Use centralized posting mechanism with Hexagon activation
    await postJournalEntry(entry, bypassCognitive: bypassCognitive);

    // ZATCA Integration: Performs compliance steps via Rust bridge.
    try {
      final salesBridge = ref.read(salesBridgeServiceProvider);

      final updatedInvoice =
          await salesBridge.finalizeInvoiceWithZatca(invoice);

      if (updatedInvoice.qrCode != null) {
        final invoiceRepo = ref.read(invoiceRepositoryProvider);
        await invoiceRepo.updateInvoice(updatedInvoice);
        // ref.invalidate(invoicesProvider); // Removed to break circular dependency
      }
    } on Exception catch (e) {
      debugPrint('❌ [ZATCA] Rust bridge finalization failed: $e');
    }

    ref.invalidateSelf();
  }

  /// Posts a purchase invoice to the ledger.
  ///
  /// Typical impact:
  /// - **Debit**: Inventory or Expense (Subtotal Amount)
  /// - **Debit**: Input VAT (Tax Amount)
  /// - **Credit**: Accounts Payable (Total Invoice Amount)
  Future<void> _postPurchaseInvoice(
    domain_inv.Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    final isPeriodOpen =
        await _financialYearService.canPostToDate(invoice.issuedDate);
    if (!isPeriodOpen) {
      throw Exception('Financial period is closed or locked');
    }

    final lines = <JournalEntryLine>[];

    // Credit: Accounts Payable
    var payableAccountId = 'acc-2101'; // Default AP
    final vendor =
        await _customerRepository.getCustomerById(invoice.customerId);
    if (vendor != null && vendor.receivableAccountId != null) {
      payableAccountId = vendor.receivableAccountId!;
    }

    lines.add(
      JournalEntryLine(
        accountId: payableAccountId,
        accountName: 'Payable - ${invoice.customerName}',
        description: 'Purchase Invoice #${invoice.invoiceNumber}',
        debit: Decimal.zero,
        credit: invoice.totalAmountBaseCurrency,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount: invoice.currency != 'SAR' ? invoice.totalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    // Debit: Expense / Inventory
    final allAccounts = await _repository.getAccounts();
    final expenseAccount = allAccounts.firstWhere(
      (a) => a.code == '5101' || a.type == AccountType.expense,
      orElse: () =>
          allAccounts.firstWhere((a) => a.type == AccountType.expense),
    );

    lines.add(
      JournalEntryLine(
        accountId: expenseAccount.id,
        accountName: expenseAccount.nameEn,
        description: 'Expense for Purchase #${invoice.invoiceNumber}',
        debit: invoice.subtotalAmountBaseCurrency,
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount:
            invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    // Debit: Input VAT
    if (invoice.taxAmount > Decimal.zero) {
      final taxAccount = allAccounts.firstWhere(
        (a) => a.code == '1105' || a.nameEn.contains('Input VAT'),
        orElse: () => allAccounts.firstWhere(
          (a) => a.code == '2105' || a.nameEn.contains('VAT'),
        ),
      );

      lines.add(
        JournalEntryLine(
          accountId: taxAccount.id,
          accountName: taxAccount.nameEn,
          description: 'Input VAT for Purchase #${invoice.invoiceNumber}',
          debit: invoice.taxAmountBaseCurrency,
          credit: Decimal.zero,
          originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
          originalAmount: invoice.currency != 'SAR' ? invoice.taxAmount : null,
          exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
        ),
      );
    }

    await _finalizeAndPostInvoiceEntry(
      invoice,
      lines,
      'purchase_invoice',
      bypassCognitive,
    );
  }

  Future<void> _postSalesReturn(
    domain_inv.Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    final isPeriodOpen =
        await _financialYearService.canPostToDate(invoice.issuedDate);
    if (!isPeriodOpen) {
      throw Exception('Financial period is closed or locked');
    }

    final lines = <JournalEntryLine>[];

    final allAccounts = await _repository.getAccounts();
    final revenueAccount = allAccounts.firstWhere(
      (a) => a.code == '4101' || a.subType == 'revenue',
      orElse: () =>
          allAccounts.firstWhere((a) => a.type == AccountType.revenue),
    );

    lines.add(
      JournalEntryLine(
        accountId: revenueAccount.id,
        accountName: revenueAccount.nameEn,
        description: 'Sales Return for Invoice #${invoice.invoiceNumber}',
        debit: invoice.subtotalAmountBaseCurrency,
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount:
            invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    if (invoice.taxAmount > Decimal.zero) {
      final taxAccount = allAccounts.firstWhere(
        (a) => a.code == '2105' || a.nameEn.contains('VAT'),
      );

      lines.add(
        JournalEntryLine(
          accountId: taxAccount.id,
          accountName: taxAccount.nameEn,
          description: 'VAT Reversal for Return #${invoice.invoiceNumber}',
          debit: invoice.taxAmountBaseCurrency,
          credit: Decimal.zero,
          originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
          originalAmount: invoice.currency != 'SAR' ? invoice.taxAmount : null,
          exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
        ),
      );
    }

    var receivableAccountId = 'acc-1201';
    final customer =
        await _customerRepository.getCustomerById(invoice.customerId);
    if (customer != null && customer.receivableAccountId != null) {
      receivableAccountId = customer.receivableAccountId!;
    }

    lines.add(
      JournalEntryLine(
        accountId: receivableAccountId,
        accountName: 'Receivable - ${invoice.customerName}',
        description: 'Sales Return #${invoice.invoiceNumber}',
        debit: Decimal.zero,
        credit: invoice.totalAmountBaseCurrency,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount: invoice.currency != 'SAR' ? invoice.totalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    await _finalizeAndPostInvoiceEntry(
      invoice,
      lines,
      'sales_return',
      bypassCognitive,
    );
  }

  Future<void> _postPurchaseReturn(
    domain_inv.Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    final isPeriodOpen =
        await _financialYearService.canPostToDate(invoice.issuedDate);
    if (!isPeriodOpen) {
      throw Exception('Financial period is closed or locked');
    }

    final lines = <JournalEntryLine>[];

    var payableAccountId = 'acc-2101';
    final vendor =
        await _customerRepository.getCustomerById(invoice.customerId);
    if (vendor != null && vendor.receivableAccountId != null) {
      payableAccountId = vendor.receivableAccountId!;
    }

    lines.add(
      JournalEntryLine(
        accountId: payableAccountId,
        accountName: 'Payable - ${invoice.customerName}',
        description: 'Purchase Return #${invoice.invoiceNumber}',
        debit: invoice.totalAmountBaseCurrency,
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount: invoice.currency != 'SAR' ? invoice.totalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    final allAccounts = await _repository.getAccounts();
    final expenseAccount = allAccounts.firstWhere(
      (a) => a.code == '5101' || a.type == AccountType.expense,
      orElse: () =>
          allAccounts.firstWhere((a) => a.type == AccountType.expense),
    );

    lines.add(
      JournalEntryLine(
        accountId: expenseAccount.id,
        accountName: expenseAccount.nameEn,
        description: 'Expense Reversal for Return #${invoice.invoiceNumber}',
        credit: invoice.subtotalAmountBaseCurrency,
        debit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount:
            invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    if (invoice.taxAmount > Decimal.zero) {
      final taxAccount = allAccounts.firstWhere(
        (a) => a.code == '1105' || a.nameEn.contains('Input VAT'),
        orElse: () => allAccounts.firstWhere(
          (a) => a.code == '2105' || a.nameEn.contains('VAT'),
        ),
      );

      lines.add(
        JournalEntryLine(
          accountId: taxAccount.id,
          accountName: taxAccount.nameEn,
          description:
              'Input VAT Reversal for Return #${invoice.invoiceNumber}',
          credit: invoice.taxAmountBaseCurrency,
          debit: Decimal.zero,
          originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
          originalAmount: invoice.currency != 'SAR' ? invoice.taxAmount : null,
          exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
        ),
      );
    }

    await _finalizeAndPostInvoiceEntry(
      invoice,
      lines,
      'purchase_return',
      bypassCognitive,
    );
  }

  Future<void> _postDamageInvoice(
    domain_inv.Invoice invoice, {
    bool bypassCognitive = false,
  }) async {
    final isPeriodOpen =
        await _financialYearService.canPostToDate(invoice.issuedDate);
    if (!isPeriodOpen) {
      throw Exception('Financial period is closed or locked');
    }

    final lines = <JournalEntryLine>[];

    final allAccounts = await _repository.getAccounts();
    final lossAccount = allAccounts.firstWhere(
      (a) => a.nameEn.contains('Loss') || a.type == AccountType.expense,
      orElse: () =>
          allAccounts.firstWhere((a) => a.type == AccountType.expense),
    );

    lines.add(
      JournalEntryLine(
        accountId: lossAccount.id,
        accountName: lossAccount.nameEn,
        description: 'Loss from Damages #${invoice.invoiceNumber}',
        debit: invoice.subtotalAmountBaseCurrency,
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount:
            invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    final inventoryAccount = allAccounts.firstWhere(
      (a) => a.code == '1301' || a.nameEn.contains('Inventory'),
      orElse: () => allAccounts.firstWhere((a) => a.type == AccountType.asset),
    );

    lines.add(
      JournalEntryLine(
        accountId: inventoryAccount.id,
        accountName: inventoryAccount.nameEn,
        description:
            'Inventory Reduction for Damages #${invoice.invoiceNumber}',
        credit: invoice.subtotalAmountBaseCurrency,
        debit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount:
            invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? invoice.exchangeRate : null,
      ),
    );

    await _finalizeAndPostInvoiceEntry(
      invoice,
      lines,
      'damage_invoice',
      bypassCognitive,
    );
  }

  Future<void> _finalizeAndPostInvoiceEntry(
    domain_inv.Invoice invoice,
    List<JournalEntryLine> lines,
    String sourceDocument,
    bool bypassCognitive,
  ) async {
    final journalEntryId = 'je-inv-${invoice.id}';
    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final existingEntries = await _repository.getJournalEntries();
    if (existingEntries.any((e) => e.id == journalEntryId)) {
      return;
    }

    final entry = JournalEntry(
      id: journalEntryId,
      referenceNumber: 'JE-${invoice.id}',
      date: invoice.issuedDate,
      temporal: TemporalJustification(
        transactionDate: invoice.issuedDate,
        effectiveDate: invoice.issuedDate,
        recordingDate: now,
      ),
      standards: StandardsJustification(
        standardReference:
            sourceDocument == 'purchase_invoice' ? 'IAS 2' : 'IFRS 15',
        recognitionBasis: 'Accrual',
        measurementBasis: 'Transaction Price',
      ),
      description: 'Posting $sourceDocument ${invoice.id}',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: sourceDocument,
      sourceId: invoice.id,
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    if (!entry.isBalanced) {
      throw Exception(
        'Journal Entry is unbalanced! Difference: '
        '${entry.totalDebit - entry.totalCredit}',
      );
    }

    await postJournalEntry(entry, bypassCognitive: bypassCognitive);
  }

  /// Calculates the hierarchical balance of an account, including all
  /// sub-accounts.
  /// (Implementation of FR-ACC-013)
  ///
  /// ## Parameters
  /// - [accountId]: Target account identifier.
  Future<Decimal> getHierarchicalBalance(String accountId) async {
    final allAccounts = await _repository.getAccounts();
    return _calculateRecursiveBalance(accountId, allAccounts);
  }

  Decimal _calculateRecursiveBalance(
    String accountId,
    List<Account> allAccounts,
  ) {
    final account = allAccounts.firstWhere((a) => a.id == accountId);
    var total = account.balance;

    final children = allAccounts.where((a) => a.parentId == accountId);
    for (final child in children) {
      total += _calculateRecursiveBalance(child.id, allAccounts);
    }

    return total;
  }

  /// Retrieves the complete list of accounts.
  Future<List<Account>> getAccounts() async => _repository.getAccounts();

  /// Updates an existing account.
  Future<void> updateAccount(Account account) async {
    await _repository.updateAccount(account);
    ref.invalidateSelf(); // Refresh the provider state
  }

  /// Retrieves a specific account by identifier.

  Future<Account?> getAccountById(String id) async =>
      _repository.getAccountById(id);

  /// Retrieves the complete list of journal entries.

  Future<List<JournalEntry>> getJournalEntries() async =>
      _repository.getJournalEntries();

  /// Posts a manual journal entry to the ledger.
  ///
  /// Performs balance verification and financial year validation.
  /// If [bypassCognitive] is false (default), triggers the Cognitive Hexagon
  /// consensus mechanism.
  Future<void> postJournalEntry(
    JournalEntry entry, {
    bool bypassCognitive = false,
  }) async {
    if (!entry.isBalanced) {
      throw Exception('Journal entry is unbalanced');
    }

    final isPeriodOpen = await _financialYearService.canPostToDate(entry.date);
    if (!isPeriodOpen) {
      throw Exception(
        'Financial period is closed or locked for date: ${entry.date}',
      );
    }

    var finalEntry = entry;

    if (!bypassCognitive) {
      // ----------------------------------------------------------------------
      // COGNITIVE HEXAGON ACTIVATION (Centralized)
      // ----------------------------------------------------------------------
      final orchestrator = ref.read(orchestratorServiceProvider.notifier);
      // Ensure locale is fetched correctly. Use a direct language code if
      // provider is unavailable or defaults.
      final currentLocale =
          ref.read(localeProvider).value?.languageCode ?? 'ar';

      final context = AccountingContext(
        proposedJournalEntry: entry,
        transactionType: entry.sourceDocument,
        locale: currentLocale,
        metadata: {
          'source_id': entry.sourceId,
          'reference': entry.referenceNumber,
        },
      );
      final consensus = await orchestrator.orchestrate(context);

      if (!consensus.isApproved) {
        throw CognitiveConsensusException(consensus);
      }
      // ----------------------------------------------------------------------
    } else {
      // ----------------------------------------------------------------------
      // INTERNAL AUDIT LOGGING (Bypass Tracking)
      // ----------------------------------------------------------------------
      final log = AuditLogEntry(
        timestamp: DateTime.now(),
        action: 'COGNITIVE_BYPASS',
        rationale:
            'Consensus bypassed by specialized service or system override.',
        actor: 'system',
      );
      finalEntry = entry.copyWith(
        auditLogs: [...entry.auditLogs, log],
      );
    }

    await _repository.addJournalEntry(finalEntry);
    ref.invalidateSelf();
  }

  /// Reverses a posted journal entry with a contra-entry.
  /// (Implementation of FR-ACC-011)
  ///
  /// Creates a new [JournalEntry] with swapped Debit/Credit values.
  ///
  /// ## Parameters
  /// - [entryId]: Target entry to reverse.
  ///
  /// ## Throws
  /// - [Exception] if the entry is not already posted.
  Future<void> reverseJournalEntry(String entryId) async {
    final entries = await _repository.getJournalEntries();
    final original = entries.firstWhere((e) => e.id == entryId);

    if (original.status != JournalEntryStatus.posted) {
      throw Exception('Can only reverse posted entries');
    }

    final now = DateTime.now();
    final user = ref.read(basirUserProvider);

    final reversal = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'RV-${original.referenceNumber}',
      date: now,
      temporal: TemporalJustification(
        transactionDate: now,
        effectiveDate: now,
        recordingDate: now,
      ),
      standards: StandardsJustification(
        standardReference: original.standards.standardReference,
        recognitionBasis: 'Reversal',
        measurementBasis: original.standards.measurementBasis,
      ),
      description: 'Reversal of entry #${original.referenceNumber}',
      status: JournalEntryStatus.posted,
      sourceDocument: original.sourceDocument,
      sourceId: original.sourceId,
      createdBy: user?.id ?? 'user',
      createdAt: now,
      updatedAt: now,
      postedAt: now,
      lines: original.lines
          .map(
            (l) => JournalEntryLine(
              accountId: l.accountId,
              accountName: l.accountName,
              debit: l.credit,
              credit: l.debit,
              description: 'Reversal: ${l.description ?? ""}',
              sourceDocumentRef: l.sourceDocumentRef,
              originalCurrency: l.originalCurrency,
              exchangeRate: l.exchangeRate,
              originalAmount: l.originalAmount,
            ),
          )
          .toList(),
    );

    await postJournalEntry(reversal);
  }

  /// Reverses an invoice by cancelling it and creating a reverse journal entry.
  /// (Implementation of FR-SLS-018)
  Future<void> reverseInvoice(domain_inv.Invoice invoice) async {
    if (invoice.status == InvoiceStatus.cancelled) {
      throw Exception('Invoice is already cancelled');
    }

    final invoiceRepo = ref.read(invoiceRepositoryProvider);

    // 1. Update Invoice Status
    final cancelledInvoice = invoice.copyWith(
      status: InvoiceStatus.cancelled,
      updatedAt: DateTime.now(),
      notes: '${invoice.notes ?? ""}\n[Cancelled on ${DateTime.now()}]'.trim(),
    );
    await invoiceRepo.updateInvoice(cancelledInvoice);

    // 2. Reverse Ledger Entry (if it was posted)
    final journalEntryId = 'je-inv-${invoice.id}';
    final entries = await _repository.getJournalEntries();
    if (entries.any((e) => e.id == journalEntryId)) {
      await reverseJournalEntry(journalEntryId);
    }

    ref.invalidate(invoicesProvider);
    ref.invalidateSelf();
  }
}
