import 'dart:async';

import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// شاشة الإعدادات (Settings Screen)
/// تسمح للمستخدم بتخصيص إعدادات التطبيق
class SettingsScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة الإعدادات
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: const AppSimpleAppBar(title: 'الإعدادات'),
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
            onTap: _handleEditAccount,
          ),
          const SizedBox(height: AppSpacing.lg),

          // قسم الإشعارات
          _buildSectionTitle('الإشعارات'),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: SwitchListTile(
              title: const ResponsiveText('تفعيل الإشعارات', maxLines: 1),
              subtitle: const ResponsiveText(
                'استقبل إشعارات الفواتير المتأخرة',
                maxLines: 2,
              ),
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
              title: const ResponsiveText('الوضع الليلي', maxLines: 1),
              subtitle: const ResponsiveText(
                'استخدم الوضع الليلي للعيون',
                maxLines: 2,
              ),
              value: ref.watch(isDarkModeProvider),
              onChanged: (value) {
                unawaited(ref.read(themeProvider.notifier).toggleTheme());
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
            onTap: _showAboutDialog,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListCard(
            title: 'سياسة الخصوصية',
            subtitle: 'اقرأ سياسة الخصوصية الخاصة بنا',
            leading: const Icon(Icons.privacy_tip, color: AppColors.primary),
            onTap: _handlePrivacyPolicy,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListCard(
            title: 'شروط الخدمة',
            subtitle: 'اقرأ شروط الخدمة الخاصة بنا',
            leading: const Icon(Icons.description, color: AppColors.primary),
            onTap: _handleTermsOfService,
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

  /// معالج تعديل بيانات الحساب
  void _handleEditAccount() {
    unawaited(_showEditAccountDialog());
  }

  Future<void> _showEditAccountDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل بيانات الحساب'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم',
                  hintText: 'أدخل اسم المستخدم الجديد',
                ),
                onChanged: (value) {
                  // حفظ القيمة
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  hintText: 'أدخل كلمة المرور الجديدة',
                ),
                obscureText: true,
                onChanged: (value) {
                  // حفظ القيمة
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('تم تحديث بيانات الحساب بنجاح');
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// معالج عرض معلومات التطبيق
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'بصير',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.receipt_long,
        size: 48,
        color: AppColors.primary,
      ),
      applicationLegalese: '© 2025 فريق وكلاء تطوير مشروع بصير',
      children: [
        const SizedBox(height: AppSpacing.md),
        const Text(
          'تطبيق بصير هو نظام متكامل لإدارة الفواتير والعملاء، '
          'مصمم خصيصاً للأعمال الصغيرة والمتوسطة.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'الميزات الرئيسية:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Text('• إدارة الفواتير بسهولة'),
        const Text('• إدارة العملاء'),
        const Text('• تصدير الفواتير كـ PDF'),
        const Text('• تخزين آمن للبيانات'),
        const Text('• دعم كامل للغة العربية'),
      ],
    );
  }

  /// معالج فتح سياسة الخصوصية
  void _handlePrivacyPolicy() {
    unawaited(_openPrivacyPolicy());
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      // محاولة فتح رابط سياسة الخصوصية
      final uri = Uri.parse('https://basser-app.com/privacy');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // إذا لم يكن هناك رابط، عرض نافذة بالمعلومات
        if (!mounted) return;
        await _showPrivacyPolicyDialog();
      }
    } on Exception {
      // في حالة الخطأ، عرض نافذة بالمعلومات
      if (!mounted) return;
      await _showPrivacyPolicyDialog();
    }
  }

  /// عرض نافذة سياسة الخصوصية
  Future<void> _showPrivacyPolicyDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'نحن نحترم خصوصيتك',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.md),
              Text('1. جميع بياناتك محفوظة محلياً على جهازك'),
              SizedBox(height: AppSpacing.sm),
              Text('2. لا نقوم بجمع أو مشاركة أي معلومات شخصية'),
              SizedBox(height: AppSpacing.sm),
              Text('3. بياناتك مشفرة وآمنة'),
              SizedBox(height: AppSpacing.sm),
              Text('4. لا نستخدم خدمات تتبع أو تحليلات خارجية'),
              SizedBox(height: AppSpacing.sm),
              Text('5. أنت المالك الوحيد لبياناتك'),
              SizedBox(height: AppSpacing.md),
              Text('للمزيد من المعلومات، يرجى زيارة موقعنا الإلكتروني.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  /// معالج فتح شروط الخدمة
  void _handleTermsOfService() {
    unawaited(_openTermsOfService());
  }

  Future<void> _openTermsOfService() async {
    try {
      // محاولة فتح رابط شروط الخدمة
      final uri = Uri.parse('https://basser-app.com/terms');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // إذا لم يكن هناك رابط، عرض نافذة بالمعلومات
        if (!mounted) return;
        await _showTermsOfServiceDialog();
      }
    } on Exception {
      // في حالة الخطأ، عرض نافذة بالمعلومات
      if (!mounted) return;
      await _showTermsOfServiceDialog();
    }
  }

  /// عرض نافذة شروط الخدمة
  Future<void> _showTermsOfServiceDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('شروط الخدمة'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'شروط استخدام تطبيق بصير',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.md),
              Text('1. التطبيق مجاني للاستخدام الشخصي والتجاري'),
              SizedBox(height: AppSpacing.sm),
              Text('2. أنت مسؤول عن دقة البيانات المدخلة'),
              SizedBox(height: AppSpacing.sm),
              Text('3. يجب عليك الاحتفاظ بنسخة احتياطية من بياناتك'),
              SizedBox(height: AppSpacing.sm),
              Text('4. التطبيق يُقدم "كما هو" بدون ضمانات'),
              SizedBox(height: AppSpacing.sm),
              Text('5. نحن غير مسؤولين عن أي خسائر ناتجة عن استخدام التطبيق'),
              SizedBox(height: AppSpacing.md),
              Text('باستخدامك للتطبيق، فإنك توافق على هذه الشروط.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  /// عرض رسالة نجاح
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// معالج تسجيل الخروج
  void _showLogoutDialog() {
    unawaited(_performLogout());
  }

  Future<void> _performLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      // عرض رسالة تأكيد
      _showSuccessMessage('تم تسجيل الخروج بنجاح');
      // الانتقال إلى شاشة تسجيل الدخول
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
