import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/liquidity_forecast.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for the Treasury Hub (The Vault).
/// Displays real-time liquidity status (Cash & Bank).
class TreasuryDashboardScreen extends ConsumerWidget {
  const TreasuryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountingRepositoryProvider).getAccounts();

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.titleTreasuryVault,
      ),
      body: FutureBuilder<List<Account>>(
        future: accountsAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allAccounts = snapshot.data ?? [];
          // Filter for Liquid assets: Cash and Bank
          // Strategy: Look for subType 'cash', 'bank' or code starting with 1101
          final treasuryAccounts = allAccounts.where((a) {
            final isCashType = a.subType == 'cash' || a.subType == 'bank';
            final isCashCode = a.code.startsWith('1101');
            // Ensure we don't include the parent "Cash and Cash Equivalents" header if it has no balance itself (usually headers are 0 or sum of children)
            // But if it's a parent, we might want to just show leaf nodes?
            // For now, let's show all leaf nodes that match.
            return (isCashType || isCashCode) && !a.isParent;
          }).toList();

          final totalLiquidity = treasuryAccounts.fold<Decimal>(
            Decimal.zero,
            (sum, account) => sum + account.balance,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLiquidityCard(context, totalLiquidity),
                const SizedBox(height: Spacing.lg),
                _buildForecastSection(context, ref),
                const SizedBox(height: Spacing.lg),
                Text(
                  context.l10n.labelAccounts,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeights.bold,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                if (treasuryAccounts.isEmpty)
                  AppEmptyState(
                    title: context.l10n.msgNoCashAccounts,
                    description: context.l10n.msgInitCoa,
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: treasuryAccounts.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Spacing.sm),
                    itemBuilder: (context, index) {
                      final account = treasuryAccounts[index];
                      return _buildAccountRow(context, account);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiquidityCard(BuildContext context, Decimal total) => AppCard(
        backgroundColor: AppColors.primary,
        child: Column(
          children: [
            Text(
              context.l10n.labelTotalLiquidity,
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              FormatHelpers.formatCurrency(total),
              style: AppTextStyles.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeights.extraBold,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              context.l10n.labelAvailableCashBank,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );

  Widget _buildForecastSection(BuildContext context, WidgetRef ref) {
    // 30-day forecast by default
    final forecastFuture =
        ref.watch(accountingServiceProvider.notifier).getLiquidityForecast();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Text(
            context.l10n.labelForecast30Days,
            style: AppTextStyles.titleMedium,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        FutureBuilder<LiquidityForecast>(
          future: forecastFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final forecast = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                children: [
                  _buildSummaryCard(
                    context,
                    label: context.l10n.labelExpectedInflow,
                    amount: forecast.totalInflow,
                    color: AppColors.success,
                    icon: Icons.arrow_downward,
                  ),
                  const SizedBox(width: Spacing.md),
                  _buildSummaryCard(
                    context,
                    label: context.l10n.labelExpectedOutflow,
                    amount: forecast.totalOutflow,
                    color: AppColors.error,
                    icon: Icons.arrow_upward,
                  ),
                  const SizedBox(width: Spacing.md),
                  _buildSummaryCard(
                    context,
                    label: context.l10n.labelNetChange,
                    amount: forecast.netChange,
                    color: AppColors.primary,
                    icon: Icons.show_chart,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String label,
    required Decimal amount,
    required Color color,
    required IconData icon,
  }) =>
      AppCard(
        padding: Spacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: Spacing.xs),
                Text(
                  label,
                  style: AppTextStyles.labelMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              FormatHelpers.formatCurrency(amount),
              style: AppTextStyles.titleLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildAccountRow(BuildContext context, Account account) {
    // Determine icon based on name or subtype
    final isBank = account.nameEn.toLowerCase().contains('bank') ||
        account.subType == 'bank';
    final icon = isBank ? Icons.account_balance : Icons.attach_money;

    return AppCard(
      padding: Spacing.paddingMd,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Radii.full),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: Spacing.md),
          // ... (rest of row)

          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name(isArabic: context.l10n.localeName == 'ar'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeights.bold,
                  ),
                ),
                Text(
                  account.code,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            FormatHelpers.formatCurrency(account.balance),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeights.bold,
              color: account.balance < Decimal.zero
                  ? AppColors.error
                  : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
