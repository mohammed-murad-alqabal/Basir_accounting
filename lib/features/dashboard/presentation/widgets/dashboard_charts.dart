import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/analytics/presentation/widgets/expense_composition_chart.dart';
import 'package:basir_app/features/analytics/presentation/widgets/revenue_trend_chart.dart';
import 'package:basir_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// رسوم بيانية للوحة التحكم (Dashboard Charts)
class DashboardCharts extends ConsumerWidget {
  /// إنشاء مكون الرسوم البيانية
  const DashboardCharts({required this.data, super.key});

  /// بيانات لوحة التحكم المطلوب عرضها
  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appIcons = ref.watch(appIconsProvider);

    return Column(
      children: [
        _buildSectionTitle(
          context,
          context.l10n.dashboardStatsTitle,
          appIcons.analytics,
        ),
        const SizedBox(height: Spacing.md),
        _buildSalesPerformanceCard(context),
        const SizedBox(height: Spacing.lg),
        _buildRevenueDistributionCard(context),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
  ) =>
      Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: Spacing.xs),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppTypography.titleMedium,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );

  Widget _buildSalesPerformanceCard(BuildContext context) => Card(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.dashboardStatsTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.bodyLarge,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              const SizedBox(
                height: 200,
                child: RevenueTrendChart(),
              ),
            ],
          ),
        ),
      );

  Widget _buildRevenueDistributionCard(BuildContext context) => Card(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.md),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.expenseDistributionTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.bodyLarge,
                ),
              ),
              const SizedBox(height: Spacing.xl),
              const SizedBox(
                height: 200,
                child: ExpenseCompositionChart(),
              ),
            ],
          ),
        ),
      );
}
