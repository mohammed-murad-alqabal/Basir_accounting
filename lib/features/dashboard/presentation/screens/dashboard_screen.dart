import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/extensions/invoice_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/chart_of_accounts_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/journal_entries_screen.dart';
import 'package:basir_accounting_system/features/accounting/presentation/widgets/financial_summary_card.dart';
import 'package:basir_accounting_system/features/analytics/application/analytics_service.dart';
import 'package:basir_accounting_system/features/analytics/domain/entities/analytics_event.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/auth/presentation/widgets/permission_guard.dart';
import 'package:basir_accounting_system/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:basir_accounting_system/features/dashboard/presentation/widgets/dashboard_charts.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/warehouse_transfer_screen.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة التحكم (Dashboard Screen)
/// تعرض ملخص الإحصائيات والعمليات الحقيقية بنظام Basir
class DashboardScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة لوحة التحكم
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _logSessionStart();
  }

  void _logSessionStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analytics = ref.read(analyticsServiceProvider);
      unawaited(analytics?.logEvent(AnalyticsEventType.sessionStart));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppSimpleAppBar(
        title: context.l10n.dashboardTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              unawaited(
                ref.read(dashboardControllerProvider.notifier).refresh(),
              );
            },
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (data) => _buildContent(context, ref, data),
        loading: () => const AppLoadingScreen(),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
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
    final analytics = ref.watch(analyticsServiceProvider);

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

            // الملخص المالي (ميزة المحاسبة الجديدة)
            const FinancialSummaryCard(),
            const SizedBox(height: Spacing.md),

            // قسم الإحصائيات الحقيقية
            _buildStatisticsSection(context, ref, data),
            const SizedBox(height: Spacing.xl),

            // الرسوم البيانية التفاعلية
            DashboardCharts(data: data),
            const SizedBox(height: Spacing.xl),

            // الإجراءات السريعة
            _buildQuickActions(context, ref, appIcons, analytics),
            const SizedBox(height: Spacing.xl),

            // الأنشطة الأخيرة (حقيقية)
            _buildRecentActivity(context, ref, data, analytics),
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
        AppSectionHeader(
          title: context.l10n.dashboardStatsTitle,
          icon: appIcons.dashboard,
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

  Widget _buildQuickActions(
    BuildContext context,
    WidgetRef ref,
    AppIcons appIcons,
    AnalyticsService? analytics,
  ) {
    final isGuestAsync = ref.watch(isGuestProvider);
    final isGuest = isGuestAsync.value ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: context.l10n.dashboardQuickActionsTitle,
          icon: appIcons.bolt,
        ),
        const SizedBox(height: Spacing.md),
        if (isGuest) ...[
          AppEnhancedButton(
            label: context.l10n.actionUpgradeAccount,
            onPressed: () {
              unawaited(
                analytics?.logEvent(
                  AnalyticsEventType.featureUsed,
                  metadata: {'feature': 'guest_upgrade_click'},
                ),
              );
              unawaited(Navigator.of(context).pushNamed('/guest-upgrade'));
            },
            icon: appIcons.upgrade,
          ),
          const SizedBox(height: Spacing.md),
        ],

        Row(
          children: [
            Expanded(
              child: AppEnhancedButton(
                label: context.l10n.actionAddInvoice,
                onPressed: () {
                  unawaited(
                    analytics?.logEvent(AnalyticsEventType.invoiceCreated),
                  );
                  unawaited(Navigator.of(context).pushNamed('/invoice-form'));
                },
                icon: appIcons.add,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: AppEnhancedButton(
                label: context.l10n.actionAddCustomer,
                onPressed: () {
                  unawaited(
                    analytics?.logEvent(AnalyticsEventType.customerAdded),
                  );
                  unawaited(Navigator.of(context).pushNamed('/customer-form'));
                },
                icon: appIcons.add,
                type: AppEnhancedButtonType.secondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: Spacing.md),
        // أدوات المحاسبة السريعة
        PermissionGuard(
          permission: Permission.viewFinancials,
          child: Row(
            children: [
              Expanded(
                child: AppEnhancedButton(
                  label: context.l10n.labelChartOfAccounts,
                  onPressed: () {
                    unawaited(
                      analytics?.logEvent(
                        AnalyticsEventType.featureUsed,
                        metadata: {'feature': 'chart_of_accounts'},
                      ),
                    );
                    unawaited(
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const ChartOfAccountsScreen(),
                        ),
                      ),
                    );
                  },
                  icon: appIcons.accounting,
                  type: AppEnhancedButtonType.outlined,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppEnhancedButton(
                  label: context.l10n.labelJournalEntries,
                  onPressed: () {
                    unawaited(
                      analytics?.logEvent(
                        AnalyticsEventType.featureUsed,
                        metadata: {'feature': 'journal_entries'},
                      ),
                    );
                    unawaited(
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const JournalEntriesScreen(),
                        ),
                      ),
                    );
                  },
                  icon: appIcons.list,
                  type: AppEnhancedButtonType.outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    WidgetRef ref,
    DashboardData data,
    AnalyticsService? analytics,
  ) {
    final appIcons = ref.read(appIconsProvider);
    final locale = context.l10n.localeName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: context.l10n.dashboardRecentActivityTitle,
          icon: appIcons.dashboard,
        ),
        const SizedBox(height: Spacing.md),
        if (data.recentInvoices.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.xl),
              child: Text(
                context.l10n.msgNoActivity,
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
                invoice.totalAmount,
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
        const SizedBox(height: Spacing.md),
        Row(
          children: [
            Expanded(
              child: AppEnhancedButton(
                label: context.l10n.warehouseTransferTitleAdd,
                onPressed: () {
                  unawaited(
                    analytics?.logEvent(
                      AnalyticsEventType.featureUsed,
                      metadata: {'feature': 'warehouse_transfer'},
                    ),
                  );
                  unawaited(
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => const WarehouseTransferScreen(),
                      ),
                    ),
                  );
                },
                icon: Icons.transfer_within_a_station,
                type: AppEnhancedButtonType.outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
