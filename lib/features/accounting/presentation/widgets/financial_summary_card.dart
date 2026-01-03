import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// بطاقة ملخص مالي تعرض الأصول والخصوم وصافي الدخل.
class FinancialSummaryCard extends ConsumerWidget {
  /// إنشاء بطاقة الملخص المالي.
  const FinancialSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(accountingRepositoryProvider);

    return FutureBuilder<List<Account>>(
      future: repository.getAccounts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final accounts = snapshot.data!;

        // حساب الإجماليات
        final totalAssets = _sumByType(accounts, AccountType.asset);
        final totalLiabilities = _sumByType(accounts, AccountType.liability);
        // Note: Equity is calculated but currently not displayed in summary
        // final totalEquity = _sumByType(accounts, AccountType.equity);
        final totalRevenue = _sumByType(accounts, AccountType.revenue);
        final totalExpense = _sumByType(accounts, AccountType.expense);

        final netIncome = totalRevenue - totalExpense;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.financialSummaryTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      context.l10n.statAssets,
                      totalAssets,
                      Colors.blue,
                    ),
                    _buildStatItem(
                      context,
                      context.l10n.statLiabilities,
                      totalLiabilities,
                      Colors.red,
                    ),
                    _buildStatItem(
                      context,
                      context.l10n.statNetIncome,
                      netIncome,
                      netIncome >= 0 ? Colors.green : Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _sumByType(List<Account> accounts, AccountType type) => accounts
      .where((a) => a.type == type)
      .fold(0, (sum, a) => sum + a.balance.toDouble());

  Widget _buildStatItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) =>
      Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            amount.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      );
}
