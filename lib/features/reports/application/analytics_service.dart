import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/reports/domain/entities/financial_kpi.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// خدمة التحليلات المالية (Analytics Service)
///
/// مسؤولة عن حساب مؤشرات الأداء المالي والنسب المالية.
@Riverpod(keepAlive: true)
class AnalyticsService extends _$AnalyticsService {
  @override
  void build() {}

  /// Calculates key financial ratios and indicators based on real data.
  Future<List<FinancialKpi>> getFinancialKpis() async {
    final repository = ref.read(accountingRepositoryProvider);
    final accounts = await repository.getAccounts();

    if (accounts.isEmpty) {
      return _getEmptyKpis();
    }

    // 1. Current Ratio (Current Assets / Current Liabilities)
    final currentAssets = _sumBalances(
      accounts,
      (a) =>
          a.type == AccountType.asset &&
          (a.code.startsWith('11') ||
              a.subType == 'cash' ||
              a.subType == 'ar' ||
              a.subType == 'inventory'),
    );
    final currentLiabilities = _sumBalances(
      accounts,
      (a) =>
          a.type == AccountType.liability &&
          (a.code.startsWith('21') || a.subType == 'ap' || a.subType == 'tax'),
    );

    double currentRatio = 0.0;
    if (currentLiabilities > Decimal.zero) {
      currentRatio = (currentAssets / currentLiabilities).toDouble();
    }

    // 2. Profit Margin (Net Income / Revenue)
    final totalRevenue = _sumBalances(
      accounts,
      (a) => a.type == AccountType.revenue,
    );
    final totalExpenses = _sumBalances(
      accounts,
      (a) => a.type == AccountType.expense,
    );
    final netIncome = totalRevenue - totalExpenses;

    double profitMargin = 0.0;
    if (totalRevenue > Decimal.zero) {
      profitMargin = (netIncome / totalRevenue).toDouble() * 100;
    }

    // 3. Burn Rate (Average Monthly Expenses)
    final entries = await repository.getJournalEntries();
    final burnRate = _calculateBurnRate(entries, accounts);

    return [
      FinancialKpi(
        name: 'Current Ratio',
        value: currentRatio,
        unit: 'x',
        trend: 0.0,
        health: currentRatio >= 1.2
            ? KpiHealth.healthy
            : (currentRatio > 0 ? KpiHealth.warning : KpiHealth.critical),
        description: 'Measures ability to pay short-term obligations.',
      ),
      FinancialKpi(
        name: 'Burn Rate',
        value: burnRate.toDouble(),
        unit: 'SAR/mo',
        trend: 0.0,
        health: burnRate > Decimal.zero ? KpiHealth.warning : KpiHealth.healthy,
        description: 'Monthly negative cash flow (Expenses).',
      ),
      FinancialKpi(
        name: 'Profit Margin',
        value: profitMargin,
        unit: '%',
        trend: 0.0,
        health: profitMargin > 15
            ? KpiHealth.healthy
            : (profitMargin > 0 ? KpiHealth.warning : KpiHealth.critical),
        description: 'Net income as a percentage of revenue.',
      ),
    ];
  }

  Decimal _sumBalances(
    List<Account> accounts,
    bool Function(Account) filter,
  ) =>
      accounts
          .where((a) => !a.isParent && filter(a))
          .fold(Decimal.zero, (sum, a) => sum + a.balance);

  Decimal _calculateBurnRate(
    List<JournalEntry> entries,
    List<Account> accounts,
  ) {
    final expenseAccountIds = accounts
        .where((a) => a.type == AccountType.expense)
        .map((a) => a.id)
        .toSet();

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    final recentExpenses = entries
        .where(
          (e) =>
              e.status == JournalEntryStatus.posted &&
              e.date.isAfter(thirtyDaysAgo),
        )
        .expand((e) => e.lines)
        .where((l) => expenseAccountIds.contains(l.accountId))
        .fold(Decimal.zero, (sum, l) => sum + l.debit);

    return recentExpenses;
  }

  /// Calculates net cash flow trend for the last 30 days.
  Future<List<double>> getCashFlowTrend() async {
    final repository = ref.read(accountingRepositoryProvider);
    final entries = await repository.getJournalEntries();
    final accounts = await repository.getAccounts();

    final cashAccountIds = accounts
        .where((a) => a.subType == 'cash' || a.subType == 'bank')
        .map((a) => a.id)
        .toSet();

    final now = DateTime.now();
    final trend = <double>[];

    for (var i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailyNet = entries
          .where(
            (e) =>
                e.status == JournalEntryStatus.posted &&
                e.date.year == date.year &&
                e.date.month == date.month &&
                e.date.day == date.day,
          )
          .expand((e) => e.lines)
          .where((l) => cashAccountIds.contains(l.accountId))
          .fold(Decimal.zero, (sum, l) => sum + l.debit - l.credit);

      trend.add(dailyNet.toDouble());
    }

    return trend;
  }

  List<FinancialKpi> _getEmptyKpis() => [
        const FinancialKpi(
          name: 'Current Ratio',
          value: 0.0,
          unit: 'x',
          trend: 0.0,
          health: KpiHealth.critical,
          description: 'No data available. Add accounts to start.',
        ),
        const FinancialKpi(
          name: 'Burn Rate',
          value: 0.0,
          unit: 'SAR/mo',
          trend: 0.0,
          health: KpiHealth.healthy,
          description: 'No transactions recorded.',
        ),
        const FinancialKpi(
          name: 'Profit Margin',
          value: 0.0,
          unit: '%',
          trend: 0.0,
          health: KpiHealth.critical,
          description: 'No revenue or expenses found.',
        ),
      ];
}
