import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';

/// شاشة الإعدادات (Settings Screen)
/// تسمح للمستخدم بتخصيص إعدادات التطبيق
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppSimpleAppBar(
          title: 'الإعدادات',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الحساب
              _buildSectionTitle('الحساب'),
              const SizedBox(height: AppSpacing.md),
              AppListCard(
                title: 'تعديل بيانات الحساب',
                subtitle: 'غيّر اسم المستخدم وكلمة المرور',
                leading: const Icon(Icons.person, color: AppColors.primary),
                onTap: () {
                  // TODO: فتح شاشة تعديل الحساب
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // قسم الإشعارات
              _buildSectionTitle('الإشعارات'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: SwitchListTile(
                  title: const Text('تفعيل الإشعارات'),
                  subtitle: const Text('استقبل إشعارات الفواتير المتأخرة'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // قسم المظهر
              _buildSectionTitle('المظهر'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: SwitchListTile(
                  title: const Text('الوضع الليلي'),
                  subtitle: const Text('استخدم الوضع الليلي للعيون'),
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() => _darkModeEnabled = value);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // قسم المساعدة
              _buildSectionTitle('المساعدة والدعم'),
              const SizedBox(height: AppSpacing.md),
              AppListCard(
                title: 'حول التطبيق',
                subtitle: 'الإصدار 1.0.0',
                leading: const Icon(Icons.info, color: AppColors.primary),
                onTap: () {
                  // TODO: عرض معلومات التطبيق
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppListCard(
                title: 'سياسة الخصوصية',
                subtitle: 'اقرأ سياسة الخصوصية الخاصة بنا',
                leading:
                    const Icon(Icons.privacy_tip, color: AppColors.primary),
                onTap: () {
                  // TODO: فتح سياسة الخصوصية
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppListCard(
                title: 'شروط الخدمة',
                subtitle: 'اقرأ شروط الخدمة الخاصة بنا',
                leading:
                    const Icon(Icons.description, color: AppColors.primary),
                onTap: () {
                  // TODO: فتح شروط الخدمة
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // زر تسجيل الخروج
              AppPrimaryButton(
                label: 'تسجيل الخروج',
                onPressed: _showLogoutDialog,
                width: double.infinity,
              ),
            ],
          ),
        ),
      );

  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: AppTypography.titleMedium,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: استدعاء authService.logout()
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}
