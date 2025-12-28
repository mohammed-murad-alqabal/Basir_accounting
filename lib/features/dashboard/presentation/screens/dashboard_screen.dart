import 'dart:async';

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
      appBar: const AppSimpleAppBar(
        title: 'لوحة التحكم',
        actions: [],
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
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(appIcons.invoices),
            label: 'الفواتير',
          ),
          BottomNavigationBarItem(
            icon: Icon(appIcons.customers),
            label: 'العملاء',
          ),
          BottomNavigationBarItem(
            icon: Icon(appIcons.settings),
            label: 'الإعدادات',
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
              const Text(
                'تحليلات الأداء المالي',
                style: TextStyle(
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
                label: 'إجمالي الفواتير',
                value: '24',
                icon: appIcons.invoices,
                color: SemanticColors.primary,
              ),
              GlassStatCard(
                label: 'العملاء النشطون',
                value: '12',
                icon: appIcons.customers, // Proxy for people_outline
                color: SemanticColors.secondary,
              ),
              GlassStatCard(
                label: 'المبيعات الكلية',
                value: '5,240 ر.س',
                icon: appIcons.invoices, // Proxy for wallet
                color: SemanticColors.warning,
              ),
              GlassStatCard(
                label: 'فواتير متأخرة',
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
              const Text(
                'الإجراءات المالية السريعة',
                style: TextStyle(
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
                  label: 'إضافة فاتورة',
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
                  label: 'إضافة عميل',
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
              const Text(
                'سجل العمليات الأحدث',
                style: TextStyle(
                  fontSize: FontSizes.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: SemanticColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          AppListCard(
            title: 'فاتورة رقم #001',
            subtitle: 'أحمد محمد - 1,500 ر.س',
            trailing: 'مدفوعة',
            leading: Icon(appIcons.check, color: SemanticColors.secondary),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
          AppListCard(
            title: 'فاتورة رقم #002',
            subtitle: 'سارة علي - 2,300 ر.س',
            trailing: 'قيد الانتظار',
            leading: Icon(appIcons.invoices, color: SemanticColors.warning),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
          AppListCard(
            title: 'فاتورة رقم #003',
            subtitle: 'محمود حسن - 1,800 ر.س',
            trailing: 'متأخرة',
            leading: Icon(appIcons.close, color: SemanticColors.error),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
        ],
      );
}
