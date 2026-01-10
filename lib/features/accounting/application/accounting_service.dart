import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/application/financial_year_service.dart';
import 'package:basir_app/features/accounting/application/multi_standard_coa_engine.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:basir_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:basir_app/features/invoices/application/sales_bridge_service.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_app/features/invoices/presentation/providers/invoice_provider.dart';
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
  AccountingRepository get _repository => ref.read(accountingRepositoryProvider);

  FinancialYearService get _financialYearService => ref.read(financialYearServiceProvider.notifier);
  CustomerRepository get _customerRepository => ref.read(customerRepositoryProvider);

  @override
  FutureOr<List<JournalEntry>> build() => _repository.getJournalEntries();

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
  /// - Verifies existence of parent account if [account.parentId] is provided.
  /// - Ensures [account.type] and [account.nature] match the parent account.
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

  /// Posts a sales invoice to the ledger using double-entry logic.
  /// (Implementation of FR-ACC-001)
  ///
  /// Transforms an invoice into a balanced [JournalEntry] with the following impact:
  /// - **Debit**: Accounts Receivable (Total Invoice Amount)
  /// - **Credit**: Revenue (Subtotal Amount)
  /// - **Credit**: Tax Liability (Tax Amount)
  ///
  /// ## Parameters
  /// - [invoice]: The [Invoice] entity to post.
  ///
  /// ## Throws
  /// - [Exception] if the financial period is closed or invoice status is
  ///   invalid.
  Future<void> postSalesInvoice(Invoice invoice) async {
    final isPeriodOpen = await _financialYearService.canPostToDate(
      invoice.issuedDate,
    );
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
    final customer = await _customerRepository.getCustomerById(
      invoice.customerId,
    );
    if (customer != null && customer.receivableAccountId != null) {
      receivableAccountId = customer.receivableAccountId!;
    }

    lines.add(
      JournalEntryLine(
        accountId: receivableAccountId,
        accountName: 'Receivable - ${invoice.customerName}',
        description: 'Sales Invoice #${invoice.invoiceNumber}',
        debit: invoice.totalAmount,
        credit: Decimal.zero,
        originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
        originalAmount: invoice.currency != 'SAR' ? invoice.totalAmount : null,
        exchangeRate: invoice.currency != 'SAR' ? Decimal.one : null,
      ),
    );

    // Credit: Revenue
    final allAccounts = await _repository.getAccounts();
    final revenueAccount = allAccounts.firstWhere(
      (a) => a.code == '4101' || a.subType == 'revenue',
      orElse: () => allAccounts.firstWhere(
        (a) => a.type == AccountType.revenue,
      ),
    );

    final revenueLine = JournalEntryLine(
      accountId: revenueAccount.id,
      credit: invoice.subtotalAmount,
      debit: Decimal.zero,
      accountName: revenueAccount.nameEn,
      description: 'Revenue for Invoice #${invoice.invoiceNumber}',
      originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
      originalAmount: invoice.currency != 'SAR' ? invoice.subtotalAmount : null,
      exchangeRate: invoice.currency != 'SAR' ? Decimal.one : null,
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
          credit: invoice.taxAmount,
          debit: Decimal.zero,
          originalCurrency: invoice.currency != 'SAR' ? invoice.currency : null,
          originalAmount: invoice.currency != 'SAR' ? invoice.taxAmount : null,
          exchangeRate: invoice.currency != 'SAR' ? Decimal.one : null,
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

    await _repository.addJournalEntry(entry);

    // ZATCA Integration: Performs compliance steps via Rust bridge.
    try {
      final salesBridge = ref.read(salesBridgeServiceProvider);
      final updatedInvoice = await salesBridge.finalizeInvoiceWithZatca(invoice);

      if (updatedInvoice.qrCode != null) {
        final invoiceRepo = ref.read(invoiceRepositoryProvider);
        await invoiceRepo.updateInvoice(updatedInvoice);
        ref.invalidate(invoicesProvider);
      }
    } on Exception catch (e) {
      debugPrint('❌ [ZATCA] Rust bridge finalization failed: $e');
    }

    ref.invalidateSelf();
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

  /// Retrieves a specific account by identifier.
  Future<Account?> getAccountById(String id) async => _repository.getAccountById(id);

  /// Retrieves the complete list of journal entries.
  Future<List<JournalEntry>> getJournalEntries() async => _repository.getJournalEntries();

  /// Posts a manual journal entry to the ledger.
  ///
  /// Performs balance verification and financial year validation.
  Future<void> postJournalEntry(JournalEntry entry) async {
    if (!entry.isBalanced) {
      throw Exception('Journal entry is unbalanced');
    }

    final isPeriodOpen = await _financialYearService.canPostToDate(entry.date);
    if (!isPeriodOpen) {
      throw Exception('Financial period is closed or locked');
    }

    await _repository.addJournalEntry(entry);
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
  Future<void> reverseInvoice(Invoice invoice) async {
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
