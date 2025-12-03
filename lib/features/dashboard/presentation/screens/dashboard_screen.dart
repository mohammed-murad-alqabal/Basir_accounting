import 'dart:async';

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
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
        appBar: const AppSimpleAppBar(
          title: 'لوحة التحكم',
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
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1976D2),
          unselectedItemColor: const Color(0xFF424242),
          selectedFontSize: 13,
          selectedIconTheme: const IconThemeData(
            size: 30,
            color: Color(0xFF1976D2),
          ),
          unselectedIconTheme: const IconThemeData(
            size: 26,
            color: Color(0xFF424242),
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 8,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'الفواتير',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'العملاء',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
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
            childAspectRatio: 2.2,
            children: const [
              AppStatCard(
                label: 'الفواتير',
                value: '24',
                icon: Icons.receipt_long,
              ),
              AppStatCard(
                label: 'العملاء',
                value: '12',
                icon: Icons.people,
                iconColor: AppColors.secondary,
              ),
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
          const SizedBox(height: AppSpacing.md),
          // زر اختبار تحسينات واجهة المستخدم (للتطوير فقط)
          AppTextButton(
            label: '🧪 اختبار تحسينات واجهة المستخدم',
            icon: Icons.science,
            onPressed: () {
              unawaited(Navigator.of(context).pushNamed('/test-ui'));
            },
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
