import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_accounting_system/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_statement_service.g.dart';

/// Financial Statement Service for generating core balance
/// and performance reports.
///
/// Implements logic for Trial Balance, IFRS 18 Income Statements,
/// and Balance Sheets, incorporating hierarchical account
/// groupings and net income calculations.
@riverpod
class FinancialStatementService extends _$FinancialStatementService {
  AccountingRepository get _repository =>
      ref.read(accountingRepositoryProvider);

  @override
  void build() {}

  /// Generates a standardized Trial Balance report.
  ///
  /// Extracts current balances for all leaf-level accounts and categorizes
  /// them into Debit and Credit columns based on account nature.
  Future<TrialBalance> generateTrialBalance(DateTime date) async {
    final accounts = await _repository.getAccounts();
    final lines = <TrialBalanceLine>[];
    var totalDebit = Decimal.zero;
    var totalCredit = Decimal.zero;

    for (final account in accounts) {
      if (account.isParent) continue;

      final balance = await _repository.getAccountBalance(account.id);

      final debit =
          account.nature == AccountNature.debit ? balance : Decimal.zero;
      final credit =
          account.nature == AccountNature.credit ? balance : Decimal.zero;

      if (balance != Decimal.zero) {
        lines.add(
          TrialBalanceLine(
            accountCode: account.code,
            accountName: account.nameEn,
            debitBalance: debit,
            creditBalance: credit,
          ),
        );
        totalDebit += debit;
        totalCredit += credit;
      }
    }

    return TrialBalance(
      date: date,
      lines: lines,
      totalDebit: totalDebit,
      totalCredit: totalCredit,
    );
  }

  /// Generates an Income Statement (P&L) structured by IFRS 18 categories.
  ///
  /// Segments performance into Operating, Investing, and Financing activities.
  ///
  /// ## IFRS 18 Sections:
  /// - **Operating**: Core business performance.
  /// - **Investing**: ROIs and asset-related activities.
  /// - **Financing**: Cost of capital and debt servicing.
  Future<FinancialReport> generateIncomeStatement(
    DateTime from,
    DateTime to,
  ) async {
    final accounts = await _repository.getAccounts();
    final lines = <FinancialReportLine>[];

    final sections = {
      Ifrs18Category.operating: 'Operating Activities',
      Ifrs18Category.investing: 'Investing Activities',
      Ifrs18Category.financing: 'Financing Activities',
    };

    var netProfit = Decimal.zero;

    for (final entry in sections.entries) {
      lines.add(
        FinancialReportLine(
          label: entry.value,
          amount: Decimal.zero,
          isTitle: true,
        ),
      );

      var sectionTotal = Decimal.zero;
      final sectionAccounts = accounts.where(
        (a) => a.ifrs18Category == entry.key,
      );

      for (final account in sectionAccounts) {
        if (account.isParent) continue;
        final balance = await _repository.getAccountBalance(account.id);

        // Revenue increases profit (+ve), Expenses decrease profit (-ve)
        final adjustedBalance =
            account.type == AccountType.revenue ? balance : -balance;

        if (adjustedBalance != Decimal.zero) {
          lines.add(
            FinancialReportLine(
              label: account.nameEn,
              amount: adjustedBalance,
              indentLevel: 1,
            ),
          );
          sectionTotal += adjustedBalance;
        }
      }

      lines.add(
        FinancialReportLine(
          label: 'Total ${entry.value}',
          amount: sectionTotal,
          isTotal: true,
        ),
      );
      netProfit += sectionTotal;
    }

    lines.add(
      FinancialReportLine(
        label: 'Net Profit / (Loss)',
        amount: netProfit,
        isTotal: true,
        isTitle: true,
      ),
    );

    return FinancialReport(
      title: 'Income Statement (Statement of Profit or Loss)',
      fromDate: from,
      toDate: to,
      lines: lines,
      generatedAt: DateTime.now(),
    );
  }

  /// Generates a Balance Sheet (Statement of Financial Position).
  ///
  /// Presents the fundamental accounting identity:
  /// Assets = Liabilities + Equity.
  Future<FinancialReport> generateBalanceSheet(DateTime date) async {
    final accounts = await _repository.getAccounts();
    final lines = <FinancialReportLine>[];

    // --- Assets Section ---
    lines.add(
      FinancialReportLine(
        label: 'Assets',
        amount: Decimal.zero,
        isTitle: true,
      ),
    );
    var totalAssets = Decimal.zero;
    for (final account in accounts.where(
      (a) => a.type == AccountType.asset && !a.isParent,
    )) {
      final balance = await _repository.getAccountBalance(account.id);
      if (balance != Decimal.zero) {
        lines.add(
          FinancialReportLine(
            label: account.nameEn,
            amount: balance,
            indentLevel: 1,
          ),
        );
        totalAssets += balance;
      }
    }
    lines.add(
      FinancialReportLine(
        label: 'Total Assets',
        amount: totalAssets,
        isTotal: true,
      ),
    );

    // --- Liabilities and Equity Section ---
    lines.add(
      FinancialReportLine(
        label: 'Liabilities and Equity',
        amount: Decimal.zero,
        isTitle: true,
      ),
    );
    var totalLiabilitiesEquity = Decimal.zero;

    for (final type in [AccountType.liability, AccountType.equity]) {
      for (final account in accounts.where(
        (a) => a.type == type && !a.isParent,
      )) {
        final balance = await _repository.getAccountBalance(account.id);
        if (balance != Decimal.zero) {
          lines.add(
            FinancialReportLine(
              label: account.nameEn,
              amount: balance,
              indentLevel: 1,
            ),
          );
          totalLiabilitiesEquity += balance;
        }
      }
    }
    lines.add(
      FinancialReportLine(
        label: 'Total Liabilities and Equity',
        amount: totalLiabilitiesEquity,
        isTotal: true,
      ),
    );

    return FinancialReport(
      title: 'Balance Sheet (Statement of Financial Position)',
      fromDate: date,
      toDate: date,
      lines: lines,
      generatedAt: DateTime.now(),
    );
  }
}
