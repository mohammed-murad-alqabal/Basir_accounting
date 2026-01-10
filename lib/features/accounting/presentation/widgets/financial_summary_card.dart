import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/accounting/data/repositories/accounting_repository_impl.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interactive summary card for the dashboard showing mission-critical metrics.
///
/// Dynamically aggregates Assets, Liabilities, and Net Income from the
/// underlying Chart of Accounts to provide an immediate pulse-check on
/// financial health.
class FinancialSummaryCard extends ConsumerWidget {
  /// Creates the financial summary card.
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

        // Aggregating hierarchical totals for dashboard consumption.
        final totalAssets = _sumByType(accounts, AccountType.asset);
        final totalLiabilities = _sumByType(accounts, AccountType.liability);
        final totalRevenue = _sumByType(accounts, AccountType.revenue);
        final totalExpense = _sumByType(accounts, AccountType.expense);

        final netIncome = totalRevenue - totalExpense;

        return AppCard(
          elevation: 4,
          margin: const EdgeInsets.all(Spacing.md),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
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
                const SizedBox(height: Spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      context.l10n.statAssets,
                      totalAssets,
                      AppColors.info,
                    ),
                    _buildStatItem(
                      context,
                      context.l10n.statLiabilities,
                      totalLiabilities,
                      AppColors.error,
                    ),
                    _buildStatItem(
                      context,
                      context.l10n.statNetIncome,
                      netIncome,
                      netIncome >= 0 ? AppColors.success : AppColors.warning,
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

  /// Calculates the flat sum of balances for a specific [AccountType].
  double _sumByType(List<Account> accounts, AccountType type) => accounts
      .where((a) => a.type == type)
      .fold(0, (sum, a) => sum + a.balance.toDouble());

  /// Builds a vertical metric indicator with thematic coloring.
  Widget _buildStatItem(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) =>
      Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Spacing.xs),
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
