import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_receivable_service.g.dart';

/// Data model for Customer Debt Aging analysis.
///
/// Categorizes outstanding customer balances into time-based buckets
/// to assess credit risk and collection performance.
class CustomerAging {
  CustomerAging({
    required this.customerId,
    required this.customerNameAr,
    required this.customerNameEn,
    required this.current,
    required this.period1_30,
    required this.period31_60,
    required this.period61_90,
    required this.periodOver90,
    required this.totalBalance,
  });

  /// Unique customer identifier.
  final String customerId;

  /// Customer name in Arabic.
  final String customerNameAr;

  /// Customer name in English.
  final String customerNameEn;

  /// Current balance not yet due.
  final Decimal current;

  /// Past due balance (1-30 days).
  final Decimal period1_30;

  /// Past due balance (31-60 days).
  final Decimal period31_60;

  /// Past due balance (61-90 days).
  final Decimal period61_90;

  /// Long-term past due balance (>90 days).
  final Decimal periodOver90;

  /// Aggregated outstanding balance across all periods.
  final Decimal totalBalance;

  /// Returns the localized customer name based on the system locale.
  String name({required bool isArabic}) => isArabic ? customerNameAr : customerNameEn;
}

/// Accounts Receivable (AR) Service for managing customer billing and debt.
///
/// Implements logic for credit management, collection tracking, and
/// detailed aging analysis for accounts receivable.
@riverpod
class AccountsReceivableService extends _$AccountsReceivableService {
  @override
  FutureOr<void> build() {}

  /// Retrieves the current outstanding balance for a specific customer.
  ///
  /// Analyzes all posted journal entries against the customer's dedicated
  /// receivable account.
  Future<Decimal> getCustomerBalance(String customerId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    final targetAccountId = customer?.receivableAccountId ?? 'acc-1201';

    final entries = await repository.getJournalEntries();

    var balance = Decimal.zero;
    for (final entry in entries) {
      for (final line in entry.lines) {
        if (line.accountId == targetAccountId ||
            (targetAccountId == 'acc-1201' && line.accountName.contains(customerId))) {
          balance += line.debit - line.credit;
        }
      }
    }
    return balance;
  }

  /// Generates a comprehensive aging report for all receivables.
  ///
  /// Buckets outstanding balances into 30/60/90 day periods based on
  /// transaction dates from posted journal entries.
  Future<List<CustomerAging>> getReceivablesAging() async {
    final accountingRepo = ref.read(accountingRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final customers = await customerRepo.getAllCustomers();
    final entries = await accountingRepo.getJournalEntries();
    final now = DateTime.now();

    final result = <CustomerAging>[];

    for (final customer in customers) {
      final targetAccountId = customer.receivableAccountId ?? 'acc-1201';

      var current = Decimal.zero;
      var p1 = Decimal.zero;
      var p2 = Decimal.zero;
      var p3 = Decimal.zero;
      var pOver = Decimal.zero;

      for (final entry in entries) {
        if (entry.status == JournalEntryStatus.posted) {
          for (final line in entry.lines) {
            if (line.accountId == targetAccountId) {
              final balance = line.debit - line.credit;
              if (balance != Decimal.zero) {
                final diff = now.difference(entry.date).inDays;
                if (diff <= 0) {
                  current += balance;
                } else if (diff <= 30) {
                  p1 += balance;
                } else if (diff <= 60) {
                  p2 += balance;
                } else if (diff <= 90) {
                  p3 += balance;
                } else {
                  pOver += balance;
                }
              }
            }
          }
        }
      }

      final total = current + p1 + p2 + p3 + pOver;
      if (total != Decimal.zero) {
        result.add(
          CustomerAging(
            customerId: customer.id,
            customerNameAr: customer.nameAr,
            customerNameEn: customer.nameEn,
            current: current,
            period1_30: p1,
            period31_60: p2,
            period61_90: p3,
            periodOver90: pOver,
            totalBalance: total,
          ),
        );
      }
    }

    return result;
  }

  /// Retrieves a detailed general ledger for a specific customer.
  ///
  /// Returns all journal entries impacting the customer's receivable account.
  Future<List<JournalEntry>> getCustomerLedger(String customerId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final customerRepo = ref.read(customerRepositoryProvider);

    final customer = await customerRepo.getCustomerById(customerId);
    final targetAccountId = customer?.receivableAccountId ?? 'acc-1201';

    final entries = await repository.getJournalEntries();

    return entries
        .where(
          (e) => e.lines.any(
            (l) =>
                l.accountId == targetAccountId ||
                (targetAccountId == 'acc-1201' && l.accountName.contains(customerId)),
          ),
        )
        .toList();
  }
}
