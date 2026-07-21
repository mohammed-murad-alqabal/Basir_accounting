// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/liquidity_forecast.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/voucher_form_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for the Treasury Hub (The Vault).
/// Provides an institutional overview of liquidity and access to fund management.
class TreasuryDashboardScreen extends ConsumerWidget {
  /// Creates the [TreasuryDashboardScreen].
  const TreasuryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsyncValue = ref.watch(accountingServiceProvider);

    return GlassScaffold(
      title: context.l10n.titleTreasuryVault,
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => Navigator.pushNamed(context, '/voucher-list'),
          tooltip: context.l10n.recentVouchersTitle,
        ),
      ],
      body: accountsAsyncValue.when(
        data: (_) => FutureBuilder<List<Account>>(
          future: ref.read(accountingServiceProvider.notifier).getAccounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: AppLoadingIndicator());
            }
            if (snapshot.hasError) {
              return AppErrorWidget(
                message: snapshot.error.toString(),
                onRetry: () => ref.invalidate(accountingServiceProvider),
              );
            }

            final allAccounts = snapshot.data ?? [];
            final treasuryAccounts = allAccounts.where((a) {
              final isCashType = a.subType == 'cash' || a.subType == 'bank';
              final isCashCode =
                  a.code.startsWith('1101') || a.code.startsWith('1102');
              return (isCashType || isCashCode) && !a.isParent;
            }).toList();

            final totalLiquidity = treasuryAccounts.fold<Decimal>(
              Decimal.zero,
              (sum, account) => sum + account.balance,
            );

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(accountingServiceProvider);
                ref.invalidate(getVouchersProvider);
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.lg),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLiquidityCard(context, totalLiquidity),
                    const SizedBox(height: Spacing.xl),
                    Text(
                      context.l10n.dashboardQuickActionsTitle,
                      style: AppTextStyles.titleMedium
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: Spacing.md),
                    _buildQuickActions(context),
                    const SizedBox(height: Spacing.xl),
                    _buildForecastSection(context, ref),
                    const SizedBox(height: Spacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.labelAccounts,
                          style: AppTextStyles.titleMedium
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/chart-of-accounts',
                          ),
                          child: const Text('المزيد'),
                        ),
                      ],
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
                    const SizedBox(height: Spacing.xl),
                    _buildAdministrativeTools(context),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(accountingServiceProvider),
        ),
      ),
    );
  }

  Widget _buildLiquidityCard(BuildContext context, Decimal total) => GlassCard(
        opacity: 0.2,
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          children: [
            Text(
              context.l10n.labelTotalLiquidity,
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              FormatHelpers.formatCurrency(total),
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeights.extraBold,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              context.l10n.labelAvailableCashBank,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );

  Widget _buildQuickActions(BuildContext context) => Row(
        children: [
          Expanded(
            child: AppEnhancedButton(
              label: context.l10n.receiptVoucherAction,
              icon: Icons.add_circle_outline,
              onPressed: () async {
                await _issueVoucher(context, VoucherType.receipt);
              },
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: AppEnhancedButton(
              label: context.l10n.paymentVoucherAction,
              icon: Icons.remove_circle_outline,
              type: AppEnhancedButtonType.secondary,
              onPressed: () async {
                await _issueVoucher(context, VoucherType.payment);
              },
            ),
          ),
        ],
      );

  Widget _buildAdministrativeTools(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أدوات التدقيق والرقابة',
            style:
                AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppEnhancedButton(
                  label: context.l10n.titleForensicPortal,
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/forensic-portal');
                  },
                  icon: Icons.verified_user_outlined,
                  type: AppEnhancedButtonType.outlined,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppEnhancedButton(
                  label: context.l10n.titleStrategicOutlook,
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/strategic-outlook');
                  },
                  icon: Icons.insights_outlined,
                  type: AppEnhancedButtonType.outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          AppEnhancedButton(
            label: 'إدارة الفترات المالية',
            icon: Icons.calendar_month_outlined,
            type: AppEnhancedButtonType.outlined,
            onPressed: () async {
              await Navigator.pushNamed(context, '/fiscal-control-center');
            },
          ),
        ],
      );

  Widget _buildForecastSection(BuildContext context, WidgetRef ref) {
    final forecastAsync =
        ref.watch(accountingServiceProvider.notifier).getLiquidityForecast();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.labelForecast30Days,
          style:
              AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Spacing.md),
        FutureBuilder<LiquidityForecast>(
          future: forecastAsync,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: AppLoadingIndicator());
            }
            if (snapshot.hasError) {
              return AppErrorWidget(
                message: snapshot.error.toString(),
                onRetry: () => ref.invalidate(accountingServiceProvider),
              );
            }
            if (!snapshot.hasData) return const SizedBox.shrink();

            final forecast = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
      GlassCard(
        padding: const EdgeInsets.all(Spacing.md),
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
    final isBank = account.nameEn.toLowerCase().contains('bank') ||
        account.subType == 'bank';
    final icon =
        isBank ? Icons.account_balance_outlined : Icons.attach_money_outlined;

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Radii.full),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name(isArabic: context.isArabic),
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  account.code,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            FormatHelpers.formatCurrency(account.balance),
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: account.balance < Decimal.zero
                  ? AppColors.error
                  : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _issueVoucher(BuildContext context, VoucherType type) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => VoucherFormScreen(type: type)),
    );
  }
}
