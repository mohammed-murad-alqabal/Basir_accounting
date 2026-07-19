import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_payable_service.g.dart';

/// Data model for Supplier Debt Aging analysis.
///
/// Categorizes outstanding liabilities to suppliers into time-based buckets
/// to manage accounts payable, cash flow requirements, and credit terms.
class SupplierAging {
  /// Creates a new [SupplierAging] instance.
  SupplierAging({
    required this.supplierId,
    required this.supplierNameAr,
    required this.supplierNameEn,
    required this.current,
    required this.period1_30,
    required this.period31_60,
    required this.periodOver90,
    required this.totalBalance,
  });

  /// Unique supplier identifier.
  final String supplierId;

  /// Supplier name in Arabic.
  final String supplierNameAr;

  /// Supplier name in English.
  final String supplierNameEn;

  /// Current liabilities not yet due.
  final Decimal current;

  /// Past due liabilities (1-30 days).
  final Decimal period1_30;

  /// Past due liabilities (31-60 days).
  final Decimal period31_60;

  /// Long-term past due liabilities (>90 days).
  final Decimal periodOver90;

  /// Aggregated outstanding balance owed to the supplier.
  final Decimal totalBalance;

  /// Returns the localized supplier name based on the system locale.
  String name({required bool isArabic}) =>
      isArabic ? supplierNameAr : supplierNameEn;
}

/// Accounts Payable (AP) Service for managing supplier liabilities and
/// obligations.
///
/// Implements logic for debt tracking, supplier ledger analysis, and
/// detailed aging for financial obligations.
@riverpod
class AccountsPayableService extends _$AccountsPayableService {
  @override
  FutureOr<void> build() {}

  /// Retrieves the current outstanding balance for a specific supplier.
  ///
  /// Analyzes posted journal entries against the supplier's dedicated
  /// payable account.
  ///
  /// Note: In liabilities (CR nature), Credit increases balance and Debit
  /// decreases it.
  Future<Decimal> getSupplierBalance(String supplierId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final vendorRepo = ref.read(vendorRepositoryProvider);

    final vendor = await vendorRepo.getVendorById(supplierId);
    final targetAccountId = vendor?.payableAccountId ?? 'acc-2101';

    final entries = await repository.getJournalEntries();

    var balance = Decimal.zero;
    for (final entry in entries) {
      for (final line in entry.lines) {
        if (line.accountId == targetAccountId ||
            (targetAccountId == 'acc-2101' &&
                line.accountName.contains(supplierId))) {
          balance += line.credit - line.debit;
        }
      }
    }
    return balance;
  }

  /// Generates a comprehensive aging report for all payables.
  ///
  /// Categorizes outstanding balances into 30/60/90+ day buckets based on
  /// transaction dates from posted journal entries.
  Future<List<SupplierAging>> getPayablesAging() async {
    final accountingRepo = ref.read(accountingRepositoryProvider);
    final vendorRepo = ref.read(vendorRepositoryProvider);

    final vendors = await vendorRepo.getAllVendors();
    final entries = await accountingRepo.getJournalEntries();
    final now = DateTime.now();

    final result = <SupplierAging>[];

    for (final vendor in vendors) {
      final targetAccountId = vendor.payableAccountId ?? 'acc-2101';

      var current = Decimal.zero;
      var p1 = Decimal.zero;
      var p2 = Decimal.zero;
      var pOver = Decimal.zero;

      for (final entry in entries) {
        if (entry.status == JournalEntryStatus.posted) {
          for (final line in entry.lines) {
            if (line.accountId == targetAccountId) {
              final balance = line.credit - line.debit;
              if (balance != Decimal.zero) {
                final diff = now.difference(entry.date).inDays;
                if (diff <= 0) {
                  current += balance;
                } else if (diff <= 30) {
                  p1 += balance;
                } else if (diff <= 60) {
                  p2 += balance;
                } else {
                  pOver += balance;
                }
              }
            }
          }
        }
      }

      final total = current + p1 + p2 + pOver;
      if (total != Decimal.zero) {
        result.add(
          SupplierAging(
            supplierId: vendor.id,
            supplierNameAr: vendor.nameAr,
            supplierNameEn: vendor.nameEn,
            current: current,
            period1_30: p1,
            period31_60: p2,
            periodOver90: pOver,
            totalBalance: total,
          ),
        );
      }
    }

    return result;
  }

  /// Retrieves a detailed general ledger for a specific supplier.
  ///
  /// Returns all journal entries impacting the supplier's payable account.
  Future<List<JournalEntry>> getSupplierLedger(String supplierId) async {
    final repository = ref.read(accountingRepositoryProvider);
    final vendorRepo = ref.read(vendorRepositoryProvider);

    final vendor = await vendorRepo.getVendorById(supplierId);
    final targetAccountId = vendor?.payableAccountId ?? 'acc-2101';

    final entries = await repository.getJournalEntries();

    return entries
        .where(
          (e) => e.lines.any(
            (l) =>
                l.accountId == targetAccountId ||
                (targetAccountId == 'acc-2101' &&
                    l.accountName.contains(supplierId)),
          ),
        )
        .toList();
  }
}
