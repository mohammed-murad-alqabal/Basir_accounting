import 'dart:async';

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/foundation.dart';
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
        backgroundColor: AppColors.background,
        appBar: AppSimpleAppBar(
          title: 'لوحة التحكم',
          actions: [
            // زر اختبار الأزرار (يظهر فقط في debug mode)
            if (kDebugMode)
              IconButton(
                icon: const Icon(Icons.bug_report),
                tooltip: 'اختبار الأزرار',
                onPressed: () {
                  unawaited(Navigator.of(context).pushNamed('/button-test'));
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رسالة الترحيب
              _buildGreeting(),
              const SizedBox(height: AppSpacing.xl),

              // الإحصائيات
              _buildStatistics(),
              const SizedBox(height: AppSpacing.xl),

              // الإجراءات السريعة
              _buildQuickActions(context),
              const SizedBox(height: AppSpacing.xl),

              // الأنشطة الأخيرة
              _buildRecentActivity(),

              // مسافة إضافية في الأسفل لتجنب overflow
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          iconSize: 26,
          elevation: 8,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            switch (index) {
              case 0:
                // البقاء في لوحة التحكم
                break;
              case 1:
                unawaited(Navigator.of(context).pushNamed('/invoices'));
              case 2:
                unawaited(Navigator.of(context).pushNamed('/customers'));
              case 3:
                unawaited(Navigator.of(context).pushNamed('/settings'));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), label: 'الفواتير'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'العملاء'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'الإعدادات'),
          ],
        ),
      );

  Widget _buildGreeting() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أهلاً وسهلاً بك!',
            style: TextStyle(
              fontSize: AppTypography.headlineSmall,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'إدارة فواتيرك وعملائك بسهولة',
            style: TextStyle(
              fontSize: AppTypography.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );

  Widget _buildStatistics() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإحصائيات',
            style: TextStyle(
              fontSize: AppTypography.titleMedium,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.1,
            children: const [
              // الصف الأول: إجمالي الفواتير (يمين) - العملاء (يسار)
              AppStatCard(
                label: 'إجمالي الفواتير',
                value: '24',
                icon: Icons.receipt_long,
              ),
              AppStatCard(
                label: 'العملاء',
                value: '12',
                icon: Icons.people,
                iconColor: AppColors.secondary,
              ),
              // الصف الثاني: المبيعات (يمين) - المتأخرة (يسار)
              AppStatCard(
                label: 'المبيعات',
                value: '5,240 ر.س',
                icon: Icons.trending_up,
                iconColor: Colors.orange,
              ),
              AppStatCard(
                label: 'المتأخرة',
                value: '3',
                icon: Icons.warning,
                iconColor: AppColors.error,
              ),
            ],
          ),
        ],
      );

  Widget _buildQuickActions(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: AppTypography.titleMedium,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppPrimaryButton(
                  label: 'فاتورة جديدة',
                  onPressed: () {
                    unawaited(Navigator.of(context).pushNamed('/invoices'));
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppSecondaryButton(
                  label: 'عميل جديد',
                  onPressed: () {
                    unawaited(Navigator.of(context).pushNamed('/customers'));
                  },
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildRecentActivity() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأنشطة الأخيرة',
            style: TextStyle(
              fontSize: AppTypography.titleMedium,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppListCard(
            title: 'فاتورة رقم #001',
            subtitle: 'أحمد محمد - 1,500 ر.س',
            trailing: 'مدفوعة',
            leading: Icon(Icons.check_circle, color: AppColors.secondary),
          ),
          AppListCard(
            title: 'فاتورة رقم #002',
            subtitle: 'سارة علي - 2,300 ر.س',
            trailing: 'قيد الانتظار',
            leading: Icon(Icons.schedule, color: Colors.orange),
          ),
          AppListCard(
            title: 'فاتورة رقم #003',
            subtitle: 'محمود حسن - 1,800 ر.س',
            trailing: 'متأخرة',
            leading: Icon(Icons.error, color: AppColors.error),
          ),
        ],
      );
}
