import 'dart:async';

import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/core/widgets/mastery_dashboard_widgets.dart';
import 'package:flutter/material.dart';

/// شاشة لوحة التحكم (Dashboard Screen)
/// تعرض ملخص الإحصائيات والعمليات الرئيسية
class DashboardScreen extends StatefulWidget {
  /// إنشاء شاشة لوحة التحكم
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
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
              _buildMasteryStatistics(),
              const SizedBox(height: Spacing.xl),

              // الإجراءات السريعة
              _buildQuickActions(context),
              const SizedBox(height: Spacing.xl),

              // الأنشطة الأخيرة
              _buildRecentActivity(),

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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'الفواتير',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'العملاء'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
          ],
        ),
      );

  Widget _buildMasteryStatistics() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 20,
                color: SemanticColors.primary,
              ),
              SizedBox(width: Spacing.xs),
              Text(
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
            children: const [
              GlassStatCard(
                label: 'إجمالي الفواتير',
                value: '24',
                icon: Icons.receipt_long,
                color: SemanticColors.primary,
              ),
              GlassStatCard(
                label: 'العملاء النشطون',
                value: '12',
                icon: Icons.people_outline,
                color: SemanticColors.secondary,
              ),
              GlassStatCard(
                label: 'المبيعات الكلية',
                value: '5,240 ر.س',
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.orange,
              ),
              GlassStatCard(
                label: 'فواتير متأخرة',
                value: '3',
                icon: Icons.timelapse_rounded,
                color: SemanticColors.error,
              ),
            ],
          ),
        ],
      );

  Widget _buildQuickActions(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.bolt_outlined,
                size: 20,
                color: SemanticColors.primary,
              ),
              SizedBox(width: Spacing.xs),
              Text(
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
                  icon: Icons.add,
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
                  icon: Icons.person_add,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildRecentActivity() => Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                size: 20,
                color: SemanticColors.primary,
              ),
              SizedBox(width: Spacing.xs),
              Text(
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
            leading:
                const Icon(Icons.check_circle, color: SemanticColors.secondary),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
          AppListCard(
            title: 'فاتورة رقم #002',
            subtitle: 'سارة علي - 2,300 ر.س',
            trailing: 'قيد الانتظار',
            leading: const Icon(Icons.schedule, color: Colors.orange),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
          AppListCard(
            title: 'فاتورة رقم #003',
            subtitle: 'محمود حسن - 1,800 ر.س',
            trailing: 'متأخرة',
            leading: const Icon(Icons.error, color: SemanticColors.error),
            onTap: () =>
                unawaited(Navigator.of(context).pushNamed('/invoices')),
          ),
        ],
      );
}
