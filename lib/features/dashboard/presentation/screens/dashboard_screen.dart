import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme/services/icon_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/core/widgets/mastery_dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة لوحة التحكم (Dashboard Screen)
/// تعرض ملخص الإحصائيات والعمليات الرئيسية
class DashboardScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة لوحة التحكم
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      backgroundColor: SemanticColors.background,
      appBar: AppSimpleAppBar(
        title: context.l10n.dashboardTitle,
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس لوحة التحكم المطور
            const DashboardMasteryHeader(),
            const SizedBox(height: Spacing.xl),

            // الإحصائيات المطورة
            _buildMasteryStatistics(appIcons),
            const SizedBox(height: Spacing.xl),

            // زر ترقية الحساب للضيوف
            FutureBuilder<bool>(
              future: ref.read(authServiceProvider).isGuest(),
              builder: (context, snapshot) {
                if (snapshot.data ?? false) {
                  return Column(
                    children: [
                      AppPrimaryButton(
                        label: context.l10n.actionUpgradeAccount,
                        icon: Icons.upgrade,
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/guest-upgrade'),
                      ),
                      const SizedBox(height: Spacing.xl),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // الإجراءات السريعة
            _buildQuickActions(context, appIcons),
            const SizedBox(height: Spacing.xl),

            // الأنشطة الأخيرة
            _buildRecentActivity(appIcons),

            // مسافة إضافية في الأسفل لتجنب overflow
            const SizedBox(height: Spacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: SemanticColors.surface,
        selectedItemColor: SemanticColors.primary,
        unselectedItemColor: SemanticColors.textSecondary,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        iconSize: 26,
        elevation: 8,
        onTap: (index) {
          setState(
            () => _selectedIndex = index,
          );
          switch (index) {
            case 0:
              // البقاء في لوحة التحكم
              break;
            case 1:
              unawaited(
                Navigator.of(context).pushNamed('/invoices'),
              );
            case 2:
              unawaited(
                Navigator.of(context).pushNamed('/customers'),
              );
            case 3:
              unawaited(
                Navigator.of(context).pushNamed('/settings'),
              );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(appIcons.home),
            label: context.l10n.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(appIcons.invoices),
            label: context.l10n.navInvoices,
          ),
          BottomNavigationBarItem(
            icon: Icon(appIcons.customers),
            label: context.l10n.navCustomers,
          ),
          BottomNavigationBarItem(
            icon: Icon(appIcons.settings),
            label: context.l10n.navSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryStatistics(AppIconsData appIcons) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                appIcons.dashboard,
                size: 20,
                color: SemanticColors.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                context.l10n.dashboardStatsTitle,
                style: const TextStyle(
                  fontSize: FontSizes.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: SemanticColors.textPrimary,
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
                label: context.l10n.statTotalInvoices,
                value: '24',
                icon: appIcons.invoices,
                color: SemanticColors.primary,
              ),
              GlassStatCard(
                label: context.l10n.statActiveCustomers,
                value: '12',
                icon: appIcons.customers, // Proxy for people_outline
                color: SemanticColors.secondary,
              ),
              GlassStatCard(
                label: context.l10n.statTotalSales,
                value: '5,240 ${context.l10n.hintCurrencySymbol}',
                icon: appIcons.invoices, // Proxy for wallet
                color: SemanticColors.warning,
              ),
              GlassStatCard(
                label: context.l10n.statOverdueInvoices,
                value: '3',
                icon: appIcons.error,
                color: SemanticColors.error,
              ),
            ],
          ),
        ],
      );

  Widget _buildQuickActions(
    BuildContext context,
    AppIconsData appIcons,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                appIcons.bolt,
                size: 20,
                color: SemanticColors.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                context.l10n.dashboardQuickActionsTitle,
                style: const TextStyle(
                  fontSize: FontSizes.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: SemanticColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Row(
            children: [
              Expanded(
                child: AppPrimaryButton(
                  label: context.l10n.actionAddInvoice,
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).pushNamed('/invoice-form'),
                    );
                  },
                  icon: appIcons.add,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppSecondaryButton(
                  label: context.l10n.actionAddCustomer,
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).pushNamed('/customer-form'),
                    );
                  },
                  icon: appIcons.add,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildRecentActivity(AppIconsData appIcons) => Column(
        children: [
          Row(
            children: [
              Icon(
                appIcons.dashboard, // Proxy for history
                size: 20,
                color: SemanticColors.primary,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                context.l10n.dashboardRecentActivityTitle,
                style: const TextStyle(
                  fontSize: FontSizes.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: SemanticColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          AppListCard(
            title: context.l10n.invoiceTitle('#001'),
            subtitle: 'أحمد محمد - 1,500 ${context.l10n.hintCurrencySymbol}',
            trailing: context.l10n.statusPaid,
            leading: Icon(appIcons.check, color: SemanticColors.secondary),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
          AppListCard(
            title: context.l10n.invoiceTitle('#002'),
            subtitle: 'سارة علي - 2,300 ${context.l10n.hintCurrencySymbol}',
            trailing: context.l10n.statusPending,
            leading: Icon(appIcons.invoices, color: SemanticColors.warning),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
          AppListCard(
            title: context.l10n.invoiceTitle('#003'),
            subtitle: 'محمود حسن - 1,800 ${context.l10n.hintCurrencySymbol}',
            trailing: context.l10n.statusOverdue,
            leading: Icon(appIcons.close, color: SemanticColors.error),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
        ],
      );
}
