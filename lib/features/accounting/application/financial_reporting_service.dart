import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_reporting_service.g.dart';

/// Data model for an Account Balance report line.
class AccountBalanceReport {
  /// Creates a report summary for a single account.
  AccountBalanceReport({
    required this.account,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  /// The account being reported.
  final Account account;

  /// Aggregated debit movements in the period.
  final Decimal debit;

  /// Aggregated credit movements in the period.
  final Decimal credit;

  /// Final net balance at the end of the period.
  final Decimal balance;
}

/// Financial Reporting Service for generating regulatory and management
/// statements.
///
/// Provides orchestration for trial balances, income statements (IFRS 18
/// compliant), and high-level financial trend analysis.
@riverpod
class FinancialReportingService extends _$FinancialReportingService {
  @override
  FutureOr<void> build() {}

  /// Generates a comprehensive Trial Balance for the current state.
  ///
  /// Aggregates all [JournalEntryStatus.posted] lines to compute
  /// period-to-date debit and credit totals for every account.
  Future<List<AccountBalanceReport>> getTrialBalance() async {
    final repository = ref.watch(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();
    final entries = await repository.getJournalEntries();

    final report = <AccountBalanceReport>[];

    for (final account in accounts) {
      var totalDebit = Decimal.zero;
      var totalCredit = Decimal.zero;

      for (final entry in entries) {
        if (entry.status == JournalEntryStatus.posted) {
          for (final line in entry.lines) {
            if (line.accountId == account.id) {
              totalDebit += line.debit;
              totalCredit += line.credit;
            }
          }
        }
      }

      report.add(
        AccountBalanceReport(
          account: account,
          debit: totalDebit,
          credit: totalCredit,
          balance: account.balance,
        ),
      );
    }

    return report;
  }

  /// Generates an IFRS 18 compliant Income Statement.
  ///
  /// Categorizes operational performance into:
  /// - **Operating**: Core business activities.
  /// - **Investing**: Asset-related income/expenses.
  /// - **Financing**: Capital and debt service costs.
  Future<Map<Ifrs18Category, Decimal>> getIfrs18IncomeStatement() async {
    final repository = ref.watch(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    final categoryBalances = <Ifrs18Category, Decimal>{};

    for (final category in Ifrs18Category.values) {
      categoryBalances[category] = Decimal.zero;
    }

    for (final account in accounts) {
      if (account.ifrs18Category != null) {
        final balance = account.balance;
        // Revenue (CR) is positive, Expenses (DR) are negative in P&L context
        final sign = account.nature == AccountNature.credit
            ? Decimal.one
            : Decimal.fromInt(-1);
        categoryBalances[account.ifrs18Category!] =
            (categoryBalances[account.ifrs18Category!] ?? Decimal.zero) +
                (balance * sign);
      }
    }

    return categoryBalances;
  }

  /// Generates a traditional Income Statement (P&L).
  ///
  /// Aggregates Revenue and Expense accounts to determine Net Income.
  ///
  /// ## Returns
  /// A map containing `totalRevenue`, `totalExpenses`, `netIncome`,
  /// and detailed breakdown categories.
  Future<Map<String, dynamic>> getIncomeStatement({
    DateTime? from,
    DateTime? to,
  }) async {
    final repository = ref.watch(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    var totalRevenue = Decimal.zero;
    var totalExpenses = Decimal.zero;

    final revenueDetails = <String, Decimal>{};
    final expenseDetails = <String, Decimal>{};

    for (final account in accounts) {
      final balance = account.balance;
      if (account.type == AccountType.revenue) {
        totalRevenue += balance;
        revenueDetails[account.nameEn] = balance;
      } else if (account.type == AccountType.expense) {
        totalExpenses += balance;
        expenseDetails[account.nameEn] = balance;
      }
    }

    return {
      'totalRevenue': totalRevenue,
      'totalExpenses': totalExpenses,
      'netIncome': totalRevenue - totalExpenses,
      'revenueDetails': revenueDetails,
      'expenseDetails': expenseDetails,
    };
  }

  /// Analyzes Revenue trends over the trailing 12-month period.
  ///
  /// Performs time-series aggregation of posted revenue journal lines.
  Future<Map<DateTime, Decimal>> getRevenueTrend() async {
    final repository = ref.read(accountingRepositoryProvider);
    final entries = await repository.getJournalEntries();
    final accounts = await repository.getAccounts();

    final accountMap = {for (final a in accounts) a.id: a.type};

    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - 11);

    final monthlyRevenue = <DateTime, Decimal>{};

    for (var i = 0; i < 12; i++) {
      final date = DateTime(now.year, now.month - i);
      monthlyRevenue[date] = Decimal.zero;
    }

    for (final entry in entries) {
      if (entry.status == JournalEntryStatus.posted &&
          entry.date.isAfter(startDate.subtract(const Duration(days: 1)))) {
        final entryMonth = DateTime(entry.date.year, entry.date.month);

        final matchingKey = <credential-fixture>(
          (k) => k.year == entryMonth.year && k.month == entryMonth.month,
          orElse: () => DateTime(0),
        );

        if (matchingKey.year != 0) {
          for (final line in entry.lines) {
            if (accountMap[line.accountId] == AccountType.revenue) {
              // Revenue is Credit nature (Increases balance)
              final amount = line.credit - line.debit;
              monthlyRevenue[matchingKey] =
                  (monthlyRevenue[matchingKey] ?? Decimal.zero) + amount;
            }
          }
        }
      }
    }

    return monthlyRevenue;
  }

  /// Calculates Expense composition by sub-categories.
  Future<Map<String, Decimal>> getExpenseComposition() async {
    final repository = ref.read(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    final composition = <String, Decimal>{};

    for (final account in accounts) {
      if (account.type == AccountType.expense) {
        final category = account.subType.isNotEmpty ? account.subType : 'Other';
        composition[category] =
            (composition[category] ?? Decimal.zero) + account.balance;
      }
    }

    return composition;
  }
}
