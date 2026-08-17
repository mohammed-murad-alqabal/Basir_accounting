import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart'
    as acct;
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart'
    as je;
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reporting_service.g.dart';

/// Represents a standardized row in a Trial Balance report.
class TrialBalanceRow {
  /// Creates a single row entry for the Trial Balance report.
  const TrialBalanceRow({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  /// Unique identifier of the account.
  final String accountId;

  /// Numerical code of the account (e.g., 101, 201).
  final String accountCode;

  /// Display name of the account.
  final String accountName;

  /// Calculated debit balance.
  final Decimal debit;

  /// Calculated credit balance.
  final Decimal credit;
}

/// Reporting Service for high-level financial intelligence and dashboarding.
///
/// Orchestrates the generation of Trial Balances, IFRS 18 Income Statements,
/// Balance Sheets, and Direct-Method Cash Flow Statements.
@riverpod
class ReportingService extends _$ReportingService {
  @override
  void build() {}

  /// Generates a comprehensive Trial Balance.
  ///
  /// Computes hierarchical (rolled-up) balances for every account and
  /// distributes them into Debit/Credit columns based on account nature.
  Future<List<TrialBalanceRow>> getTrialBalance() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    final rows = <TrialBalanceRow>[];

    for (final account in accounts) {
      final balance = await accountingService.getHierarchicalBalance(
        account.id,
      );

      if (balance != Decimal.zero) {
        if (account.nature == acct.AccountNature.debit) {
          rows.add(
            TrialBalanceRow(
              accountId: account.id,
              accountCode: account.code,
              accountName: account.nameEn,
              debit: balance > Decimal.zero ? balance : Decimal.zero,
              credit: balance < Decimal.zero ? -balance : Decimal.zero,
            ),
          );
        } else {
          rows.add(
            TrialBalanceRow(
              accountId: account.id,
              accountCode: account.code,
              accountName: account.nameEn,
              debit: balance < Decimal.zero ? -balance : Decimal.zero,
              credit: balance > Decimal.zero ? balance : Decimal.zero,
            ),
          );
        }
      }
    }

    return rows;
  }

  /// Generates an IFRS 18 compliant Income Statement (P&L).
  ///
  /// Automatically categorizes Revenue and Expense accounts into
  /// Operating, Investing, and Financing sections.
  Future<Map<Ifrs18Category, Decimal>> getIncomeStatement() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    final result = <Ifrs18Category, Decimal>{
      Ifrs18Category.operating: Decimal.zero,
      Ifrs18Category.investing: Decimal.zero,
      Ifrs18Category.financing: Decimal.zero,
      Ifrs18Category.incomeTax: Decimal.zero,
    };

    for (final account in accounts) {
      if (account.type == acct.AccountType.revenue ||
          account.type == acct.AccountType.expense) {
        final category = _detectIfrs18Category(account);

        final balance = await accountingService.getHierarchicalBalance(
          account.id,
        );

        // Performance Logic: Revenue (CR) adds to profit,
        // Expense (DR) subtracts
        if (account.type == acct.AccountType.revenue) {
          result[category] = (result[category] ?? Decimal.zero) + balance;
        } else {
          result[category] = (result[category] ?? Decimal.zero) - balance;
        }
      }
    }

    return result;
  }

  /// Generates a Balance Sheet summary (Statement of Financial Position).
  ///
  /// Aggregates top-level account hierarchies for Assets, Liabilities, and
  /// Equity.
  Future<Map<String, Decimal>> getBalanceSheet() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    var assets = Decimal.zero;
    var liabilities = Decimal.zero;
    var equity = Decimal.zero;

    for (final account in accounts) {
      if (account.parentId == null) {
        final balance = await accountingService.getHierarchicalBalance(
          account.id,
        );

        if (account.type == acct.AccountType.asset) {
          assets += balance;
        } else if (account.type == acct.AccountType.liability) {
          liabilities += balance;
        } else if (account.type == acct.AccountType.equity) {
          equity += balance;
        }
      }
    }

    return {'assets': assets, 'liabilities': liabilities, 'equity': equity};
  }

  /// Generates a Direct-Method Cash Flow Statement.
  ///
  /// Analyzes posted journal entries that impact Cash/Bank accounts and
  /// classifies them based on neighboring ledger lines.
  Future<Map<String, Decimal>> getCashFlowStatement() async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final entries = await accountingService.getJournalEntries();

    var operatingReceipts = Decimal.zero;
    var operatingPayments = Decimal.zero;
    var investingFlow = Decimal.zero;
    var financingFlow = Decimal.zero;

    for (final entry in entries) {
      if (entry.status == je.JournalEntryStatus.posted) {
        for (final line in entry.lines) {
          if (await _isCashAccount(line.accountId)) {
            final amount = line.debit - line.credit;

            final otherLines = entry.lines
                .where((l) => l.accountId != line.accountId)
                .toList();

            if (otherLines.isNotEmpty) {
              final category = await _detectCashFlowCategory(
                otherLines.first.accountId,
              );
              switch (category) {
                case 'operating':
                  if (amount > Decimal.zero) {
                    operatingReceipts += amount;
                  } else {
                    operatingPayments += -amount;
                  }
                case 'investing':
                  investingFlow += amount;
                case 'financing':
                  financingFlow += amount;
              }
            }
          }
        }
      }
    }

    return {
      'operatingReceipts': operatingReceipts,
      'operatingPayments': operatingPayments,
      'netOperating': operatingReceipts - operatingPayments,
      'investing': investingFlow,
      'financing': financingFlow,
      'netChange':
          operatingReceipts - operatingPayments + investingFlow + financingFlow,
    };
  }

  /// Computes core Financial Health Indicators (Ratios).
  ///
  /// Includes Liquidity Ratios and Net Profit Margins for dashboarding.
  Future<Map<String, double>> getFinancialHealthIndicators() async {
    final balanceSheet = await getBalanceSheet();
    final incomeStatement = await getIncomeStatement();
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final accounts = await accountingService.getAccounts();

    final assets = balanceSheet['assets'] ?? Decimal.zero;
    final liabilities = balanceSheet['liabilities'] ?? Decimal.zero;

    // 1. Current Ratio (Approximate)
    final liquidity =
        liabilities != Decimal.zero ? (assets / liabilities).toDouble() : 0.0;

    // 2. Net Margin
    final revenue = accounts
        .where((account) => account.type == acct.AccountType.revenue)
        .fold(Decimal.zero, (total, account) => total + account.balance);

    final netIncome = incomeStatement.values.fold(
      Decimal.zero,
      (prev, curr) => prev + curr,
    );

    final profitability =
        revenue != Decimal.zero ? (netIncome / revenue).toDouble() : 0.0;

    return {
      'liquidity': liquidity,
      'profitability': profitability,
      'operating_margin': profitability,
    };
  }

  /// Internal heuristic for IFRS 18 category detection.
  Ifrs18Category _detectIfrs18Category(acct.Account account) {
    if (account.nameEn.toLowerCase().contains('tax')) {
      return Ifrs18Category.incomeTax;
    }
    if (account.code.startsWith('44')) {
      return Ifrs18Category.investing;
    }
    if (account.code.startsWith('55')) {
      return Ifrs18Category.financing;
    }

    return Ifrs18Category.operating;
  }

  /// Verifies if an account qualifies as a Cash/Liquid Asset.
  Future<bool> _isCashAccount(String accountId) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final account = await accountingService.getAccountById(accountId);
    if (account == null) return false;

    return account.code.startsWith('11') ||
        account.nameEn.toLowerCase().contains('cash') ||
        account.nameEn.toLowerCase().contains('bank');
  }

  /// Heuristic for cash flow classification (Operating/Investing/Financing).
  Future<String> _detectCashFlowCategory(String accountId) async {
    final accountingService = ref.read(accountingServiceProvider.notifier);
    final account = await accountingService.getAccountById(accountId);
    if (account == null) return 'operating';

    if (account.code.startsWith('12') &&
        account.type == acct.AccountType.asset) {
      return 'investing';
    }
    if (account.type == acct.AccountType.equity ||
        account.code.startsWith('22')) {
      return 'financing';
    }

    return 'operating';
  }
}
