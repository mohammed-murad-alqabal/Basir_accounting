import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_report.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:basir_app/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_statement_service.g.dart';

/// مزود خدمة القوائم المالية
@riverpod
class FinancialStatementService extends _$FinancialStatementService {
  AccountingRepository get _repository =>
      ref.read(accountingRepositoryProvider);

  @override
  void build() {}

  /// توليد ميزان المراجعة (Trial Balance)
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
            accountName: account.nameAr,
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

  /// توليد قائمة الدخل (Income Statement) حسب IFRS 18
  Future<FinancialReport> generateIncomeStatement(
    DateTime from,
    DateTime to,
  ) async {
    final accounts = await _repository.getAccounts();
    final lines = <FinancialReportLine>[];

    // تصنيفات IFRS 18
    final sections = {
      Ifrs18Category.operating: 'النشاط التشغيلي (Operating)',
      Ifrs18Category.investing: 'النشاط الاستثماري (Investing)',
      Ifrs18Category.financing: 'النشاط التمويلي (Financing)',
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

        // في قائمة الدخل: الإيرادات موجبة والمصروفات سالبة
        final adjustedBalance =
            account.type == AccountType.revenue ? balance : -balance;

        if (adjustedBalance != Decimal.zero) {
          lines.add(
            FinancialReportLine(
              label: account.nameAr,
              amount: adjustedBalance,
              indentLevel: 1,
            ),
          );
          sectionTotal += adjustedBalance;
        }
      }

      lines.add(
        FinancialReportLine(
          label: 'إجمالي ${entry.value}',
          amount: sectionTotal,
          isTotal: true,
        ),
      );
      netProfit += sectionTotal;
    }

    lines.add(
      FinancialReportLine(
        label: 'صافي الربح أو الخسارة (Net Profit/Loss)',
        amount: netProfit,
        isTotal: true,
        isTitle: true,
      ),
    );

    return FinancialReport(
      title: 'قائمة الأرباح أو الخسائر',
      fromDate: from,
      toDate: to,
      lines: lines,
      generatedAt: DateTime.now(),
    );
  }

  /// توليد الميزانية العمومية (Balance Sheet)
  Future<FinancialReport> generateBalanceSheet(DateTime date) async {
    final accounts = await _repository.getAccounts();
    final lines = <FinancialReportLine>[];

    // الأصول
    lines.add(
      FinancialReportLine(
        label: 'الأصول (Assets)',
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
            label: account.nameAr,
            amount: balance,
            indentLevel: 1,
          ),
        );
        totalAssets += balance;
      }
    }
    lines.add(
      FinancialReportLine(
        label: 'إجمالي الأصول',
        amount: totalAssets,
        isTotal: true,
      ),
    );

    // الخصوم وحقوق الملكية
    lines.add(
      FinancialReportLine(
        label: 'الخصوم وحقوق الملكية (Liabilities & Equity)',
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
              label: account.nameAr,
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
        label: 'إجمالي الخصوم وحقوق الملكية',
        amount: totalLiabilitiesEquity,
        isTotal: true,
      ),
    );

    return FinancialReport(
      title: 'الميزانية العمومية',
      fromDate: date, // استخدام نفس التاريخ للبداية والنهاية في الميزانية
      toDate: date,
      lines: lines,
      generatedAt: DateTime.now(),
    );
  }
}
