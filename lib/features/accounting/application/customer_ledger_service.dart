import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/customer_ledger_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_ledger_service.g.dart';

/// Customer Statement - Complete account ledger for a customer.
///
/// Provides a comprehensive view of all transactions affecting a customer's
/// account balance within a specified period.
class CustomerStatement {
  /// Creates a customer statement.
  const CustomerStatement({
    required this.customer,
    required this.fromDate,
    required this.toDate,
    required this.openingBalance,
    required this.entries,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
  });

  /// The customer for this statement.
  final Customer customer;

  /// Start date of the statement period.
  final DateTime fromDate;

  /// End date of the statement period.
  final DateTime toDate;

  /// Balance at the beginning of the period.
  final Decimal openingBalance;

  /// All ledger entries within the period.
  final List<CustomerLedgerEntry> entries;

  /// Total debit transactions in the period.
  final Decimal totalDebit;

  /// Total credit transactions in the period.
  final Decimal totalCredit;

  /// Balance at the end of the period.
  final Decimal closingBalance;

  /// Returns true if the customer has a debit balance (owes money).
  bool get hasDebitBalance => closingBalance > Decimal.zero;

  /// Returns true if the customer has a credit balance (overpaid).
  bool get hasCreditBalance => closingBalance < Decimal.zero;

  /// Returns the number of transactions in the period.
  int get transactionCount => entries.length;
}

/// Customer Ledger Service - Manages customer account transactions.
///
/// This service provides comprehensive customer ledger functionality:
/// - Complete transaction history
/// - Balance calculations at any point in time
/// - Statement generation
/// - Transaction search and filtering
///
/// ## Standards Compliance:
/// - **IAS 1**: Presentation of Financial Statements
/// - **IFRS 15**: Revenue from Contracts with Customers
@riverpod
class CustomerLedgerService extends _$CustomerLedgerService {
  @override
  FutureOr<void> build() {}

  /// Generates a complete customer statement for a period.
  ///
  /// This includes:
  /// - Opening balance calculation
  /// - All transactions in the period
  /// - Totals and closing balance
  Future<CustomerStatement> getCustomerStatement({
    required String customerId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final accountingRepo = ref.read(accountingRepositoryProvider);

    // Retrieve customer
    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer not found: $customerId');
    }

    // Calculate opening balance (balance before fromDate)
    final openingBalance = await calculateOpeningBalance(
      customerId: customerId,
      asOfDate: fromDate.subtract(const Duration(days: 1)),
    );

    // Get all journal entries affecting this customer
    final entries = await accountingRepo.getJournalEntries();
    final arAccountId = customer.receivableAccountId ?? 'acc-1201';

    final ledgerEntries = <CustomerLedgerEntry>[];
    var runningBalance = openingBalance;
    var totalDebit = Decimal.zero;
    var totalCredit = Decimal.zero;

    // Process journal entries within the period
    for (final entry in entries) {
      if (entry.status != JournalEntryStatus.posted) continue;
      if (entry.date.isBefore(fromDate) || entry.date.isAfter(toDate)) continue;

      for (final line in entry.lines) {
        if (line.accountId == arAccountId) {
          final debit = line.debit;
          final credit = line.credit;
          final netAmount = debit - credit;

          runningBalance += netAmount;
          totalDebit += debit;
          totalCredit += credit;

          ledgerEntries.add(
            CustomerLedgerEntry(
              id: '${entry.id}_${line.accountId}',
              customerId: customerId,
              entryNumber: entry.referenceNumber,
              entryDate: entry.date,
              description: line.description ?? entry.description,
              debit: debit,
              credit: credit,
              balance: runningBalance,
              sourceDocument: entry.sourceDocument,
              sourceId: entry.sourceId,
              createdAt: entry.createdAt,
              reference: line.sourceDocumentRef,
              createdBy: entry.createdBy,
              userId: entry.userId,
            ),
          );
        }
      }
    }

    // Sort by date
    ledgerEntries.sort((a, b) => a.entryDate.compareTo(b.entryDate));

    return CustomerStatement(
      customer: customer,
      fromDate: fromDate,
      toDate: toDate,
      openingBalance: openingBalance,
      entries: ledgerEntries,
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      closingBalance: runningBalance,
    );
  }

  /// Calculates the customer balance as of a specific date.
  ///
  /// This is useful for:
  /// - Opening balance calculations
  /// - Historical balance queries
  /// - Aging analysis
  Future<Decimal> calculateOpeningBalance({
    required String customerId,
    required DateTime asOfDate,
  }) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final accountingRepo = ref.read(accountingRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer not found: $customerId');
    }

    final entries = await accountingRepo.getJournalEntries();
    final arAccountId = customer.receivableAccountId ?? 'acc-1201';

    var balance = Decimal.zero;

    for (final entry in entries) {
      if (entry.status != JournalEntryStatus.posted) continue;
      if (entry.date.isAfter(asOfDate)) continue;

      for (final line in entry.lines) {
        if (line.accountId == arAccountId) {
          balance += line.debit - line.credit;
        }
      }
    }

    return balance;
  }

  /// Searches for ledger entries matching specific criteria.
  ///
  /// Supports filtering by:
  /// - Date range
  /// - Amount range
  /// - Description text
  /// - Source document type
  Future<List<CustomerLedgerEntry>> searchEntries({
    required String customerId,
    String? query,
    DateTime? fromDate,
    DateTime? toDate,
    Decimal? minAmount,
    Decimal? maxAmount,
    String? sourceDocument,
  }) async {
    final statement = await getCustomerStatement(
      customerId: customerId,
      fromDate: fromDate ?? DateTime(2000),
      toDate: toDate ?? DateTime.now(),
    );

    var entries = statement.entries;

    // Filter by query text
    if (query != null && query.isNotEmpty) {
      entries = entries
          .where(
            (e) =>
                e.description.toLowerCase().contains(query.toLowerCase()) ||
                e.entryNumber.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    // Filter by source document
    if (sourceDocument != null && sourceDocument.isNotEmpty) {
      entries =
          entries.where((e) => e.sourceDocument == sourceDocument).toList();
    }

    // Filter by amount range
    if (minAmount != null) {
      entries = entries.where((e) => e.netAmount.abs() >= minAmount).toList();
    }
    if (maxAmount != null) {
      entries = entries.where((e) => e.netAmount.abs() <= maxAmount).toList();
    }

    return entries;
  }

  /// Gets the last N transactions for a customer.
  ///
  /// Useful for quick overview without generating full statement.
  Future<List<CustomerLedgerEntry>> getRecentTransactions({
    required String customerId,
    int limit = 10,
  }) async {
    final now = DateTime.now();
    final statement = await getCustomerStatement(
      customerId: customerId,
      fromDate: DateTime(now.year - 1, now.month, now.day),
      toDate: now,
    );

    final sortedEntries = statement.entries
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));

    return sortedEntries.take(limit).toList();
  }

  /// Calculates the total turnover (debit + credit) for a period.
  ///
  /// High turnover may indicate active account or potential issues.
  Future<Decimal> calculateTurnover({
    required String customerId,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final statement = await getCustomerStatement(
      customerId: customerId,
      fromDate: fromDate,
      toDate: toDate,
    );

    return statement.totalDebit + statement.totalCredit;
  }
}
