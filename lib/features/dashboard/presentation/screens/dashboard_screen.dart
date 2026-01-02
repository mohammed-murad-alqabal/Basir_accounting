import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/extensions/invoice_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/core/widgets/basir_dashboard_widgets.dart';
import 'package:basir_app/core/widgets/index.dart';
import 'package:basir_app/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:basir_app/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:basir_app/features/dashboard/presentation/widgets/dashboard_charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة التحكم (Dashboard Screen)
/// تعرض ملخص الإحصائيات والعمليات الحقيقية بنظام Basir
class DashboardScreen extends ConsumerWidget {
  /// إنشاء شاشة لوحة التحكم
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppSimpleAppBar(
        title: context.l10n.dashboardTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ignore: discarded_futures
              ref.read(dashboardControllerProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => _buildContent(context, ref, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(height: Spacing.md),
              Text(context.l10n.errorLoadingSettings),
              TextButton(
                onPressed: () => ref.invalidate(dashboardControllerProvider),
                child: Text(context.l10n.retryLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    DashboardData data,
  ) {
    final appIcons = ref.watch(appIconsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DashboardBasirHeader(),
            const SizedBox(height: Spacing.xl),

            // قسم الإحصائيات الحقيقية
            _buildStatisticsSection(context, ref, data),
            const SizedBox(height: Spacing.xl),

            // الرسوم البيانية التفاعلية
            DashboardCharts(data: data),
            const SizedBox(height: Spacing.xl),

            // الإجراءات السريعة
            _buildQuickActions(context, appIcons),
            const SizedBox(height: Spacing.xl),

            // الأنشطة الأخيرة (حقيقية)
            _buildRecentActivity(context, ref, data),
            const SizedBox(height: Spacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(
    BuildContext context,
    WidgetRef ref,
    DashboardData data,
  ) {
    final appIcons = ref.read(appIconsProvider);
    final locale = context.l10n.localeName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(appIcons.dashboard, size: 20, color: AppColors.primary),
            const SizedBox(width: Spacing.xs),
            Text(
              context.l10n.dashboardStatsTitle,
              style: const TextStyle(
                fontSize: AppTypography.titleMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: Spacing.md,
          mainAxisSpacing: Spacing.md,
          childAspectRatio: 1.2,
          children: [
            GlassStatCard(
              label: context.l10n.statTotalSales,
              value: FormatHelpers.formatCurrency(
                data.totalSales,
                locale: locale,
              ),
              icon: appIcons.invoices,
              color: AppColors.primary,
            ),
            GlassStatCard(
              label: context.l10n.statActiveCustomers,
              value: data.activeCustomersCount.toString(),
              icon: appIcons.customers,
              color: AppColors.secondary,
            ),
            GlassStatCard(
              label: context.l10n.statPaid,
              value: FormatHelpers.formatCurrency(
                data.paidRevenue,
                locale: locale,
              ),
              icon: appIcons.check,
              color: AppColors.success,
            ),
            GlassStatCard(
              label: context.l10n.statOverdue,
              value: FormatHelpers.formatCurrency(
                data.pendingRevenue,
                locale: locale,
              ),
              icon: appIcons.error,
              color: AppColors.error,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, AppIcons appIcons) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(appIcons.bolt, size: 20, color: AppColors.primary),
              const SizedBox(width: Spacing.xs),
              Text(
                context.l10n.dashboardQuickActionsTitle,
                style: const TextStyle(
                  fontSize: AppTypography.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.actionAddInvoice,
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/invoice-form'),
                  icon: appIcons.add,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppButton(
                  label: context.l10n.actionAddCustomer,
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/customer-form'),
                  icon: appIcons.add,
                  type: AppButtonType.secondary,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildRecentActivity(
    BuildContext context,
    WidgetRef ref,
    DashboardData data,
  ) {
    final appIcons = ref.read(appIconsProvider);
    final locale = context.l10n.localeName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(appIcons.dashboard, size: 20, color: AppColors.primary),
            const SizedBox(width: Spacing.xs),
            Text(
              context.l10n.dashboardRecentActivityTitle,
              style: const TextStyle(
                fontSize: AppTypography.titleMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        if (data.recentInvoices.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
              child: Text(
                context.l10n.filterAll, // Placeholder for empty recent activity
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ...data.recentInvoices.map(
            (invoice) => AppListCard(
              title: context.l10n.invoiceTitle(invoice.id),
              subtitle: invoice.customerName,
              trailing: FormatHelpers.formatCurrency(
                invoice.grandTotal,
                locale: locale,
              ),
              leading: Icon(
                invoice.getStatusIcon(appIcons),
                color: invoice.getStatusColor(Theme.of(context).colorScheme),
                size: 20,
              ),
              onTap: () => Navigator.of(context).pushNamed('/invoices'),
            ),
          ),
      ],
    );
  }
}
