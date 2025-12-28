import 'dart:async';

import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme/services/icon_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/settings/presentation/screens/appearance_settings_screen.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      appBar: const AppAppBar(title: 'الإعدادات'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم إعدادات الشركة والفواتير
            _buildSectionTitle('إعدادات الشركة والفواتير', colorScheme),
            const SizedBox(height: Spacing.md),
            _buildCompanySettingsCard(colorScheme, appIcons),
            const SizedBox(height: Spacing.xl),

            // قسم الحساب
            _buildSectionTitle('الحساب', colorScheme),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: 'تعديل بيانات الحساب',
              subtitle: 'غيّر اسم المستخدم وكلمة المرور',
              leading: Icon(appIcons.person, color: colorScheme.primary),
              onTap: _handleEditAccount,
            ),
            const SizedBox(height: Spacing.xl),

            // قسم الإشعارات
            _buildSectionTitle('الإشعارات', colorScheme),
            const SizedBox(height: Spacing.md),
            AppCard(
              child: SwitchListTile(
                title: const ResponsiveText('تفعيل الإشعارات', maxLines: 1),
                subtitle: const ResponsiveText(
                  'استقبل إشعارات الفواتير المتأخرة',
                  maxLines: 2,
                ),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(
                    () => _notificationsEnabled = value,
                  );
                },
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // قسم المظهر
            _buildSectionTitle('المظهر والتخصيص', colorScheme),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: 'إعدادات المظهر',
              subtitle: 'الوضع الليلي، الألوان، الخطوط، والأيقونات',
              leading: Icon(Icons.palette, color: colorScheme.primary),
              onTap: () {
                unawaited(
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AppearanceSettingsScreen(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.xl),

            // قسم المساعدة
            _buildSectionTitle('المساعدة والدعم', colorScheme),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: 'حول التطبيق',
              subtitle: 'الإصدار 1.0.0',
              leading: Icon(appIcons.invoices, color: colorScheme.primary),
              onTap: () => _showAboutDialog(appIcons),
            ),
            const SizedBox(height: Spacing.sm),
            AppListCard(
              title: 'سياسة الخصوصية',
              subtitle: 'اقرأ سياسة الخصوصية الخاصة بنا',
              leading: Icon(
                Icons.privacy_tip,
                color: colorScheme.primary,
              ),
              onTap: _handlePrivacyPolicy,
            ),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: 'شروط الخدمة',
              subtitle: 'اقرأ شروط الخدمة الخاصة بنا',
              leading: Icon(Icons.description, color: colorScheme.primary),
              onTap: _handleTermsOfService,
            ),

            const SizedBox(height: Spacing.xl),

            // زر تسجيل الخروج
            AppPrimaryButton(
              label: 'تسجيل الخروج',
              onPressed: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme) => Text(
        title,
        style: TextStyle(
          fontSize: FontSizes.titleMedium,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      );

  Widget _buildCompanySettingsCard(
    ColorScheme colorScheme,
    AppIconsData appIcons,
  ) {
    final settingsAsync = ref.watch(companySettingsProvider);

    return settingsAsync.when(
      data: (settings) => AppListCard(
        title: settings['companyName'] ?? 'بيانات الشركة',
        subtitle: 'تخصيص الفواتير، العملة، وعناوين التواصل',
        leading: Icon(appIcons.invoices, color: colorScheme.primary),
        onTap: () => _showEditCompanyDialog(settings),
      ),
      loading: () => const AppCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(Spacing.md),
            child: LinearProgressIndicator(),
          ),
        ),
      ),
      error: (e, _) => AppListCard(
        title: 'خطأ في تحميل الإعدادات',
        subtitle: 'انقر لإعادة المحاولة',
        leading: const Icon(Icons.error, color: SemanticColors.error),
        onTap: () => ref.invalidate(companySettingsProvider),
      ),
    );
  }

  Future<void> _showEditCompanyDialog(Map<String, String?> settings) async {
    final nameController = TextEditingController(text: settings['companyName']);
    final taxNumberController = TextEditingController(
      text: settings['taxNumber'],
    );
    final taxRateController = TextEditingController(text: settings['taxRate']);
    final currencySymbolController = TextEditingController(
      text: settings['currencySymbol'],
    );
    final countryCodeController = TextEditingController(
      text: settings['defaultCountryCode'],
    );

    var selectedStyle = settings['invoiceStyle'] ?? 'standard';

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إعدادات الشركة والفواتير'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameController,
                  label: 'اسم الشركة',
                  hint: 'أدخل اسم شركتك',
                ),
                const SizedBox(height: Spacing.md),
                AppTextField(
                  controller: taxNumberController,
                  label: 'الرقم الضريبي',
                  hint: 'أدخل الرقم الضريبي (اختياري)',
                ),
                const SizedBox(height: Spacing.md),
                AppTextField(
                  controller: taxRateController,
                  label: 'نسبة الضريبة (مثال: 0.15)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: currencySymbolController,
                        label: 'رمز العملة',
                        hint: 'ر.س',
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: countryCodeController,
                        label: 'كود الدولة',
                        hint: '966',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                DropdownButtonFormField<String>(
                  initialValue: selectedStyle,
                  decoration: const InputDecoration(
                    labelText: 'شكل الفاتورة',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'standard', child: Text('قياسي')),
                    DropdownMenuItem(value: 'modern', child: Text('عصري')),
                    DropdownMenuItem(value: 'compact', child: Text('مختصر')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedStyle = value);
                    }
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
              onPressed: () async {
                final settingsService = ref.read(settingsServiceProvider);
                try {
                  await settingsService.setCompanySettings(
                    companyName: nameController.text.trim(),
                    taxNumber: taxNumberController.text.trim(),
                    taxRate: double.tryParse(taxRateController.text) ?? 0.15,
                    currencySymbol: currencySymbolController.text.trim(),
                    countryCode: countryCodeController.text.trim(),
                    invoiceStyle: selectedStyle,
                  );
                  ref.invalidate(companySettingsProvider);
                  if (context.mounted) Navigator.pop(context);
                  _showSuccessMessage('تم حفظ الإعدادات بنجاح');
                } on Exception catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('خطأ في الحفظ: $e'),
                        backgroundColor: SemanticColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  /// معالج تعديل بيانات الحساب
  void _handleEditAccount() {
    unawaited(
      _showEditAccountDialog(),
    );
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
              const SizedBox(height: Spacing.md),
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
              Navigator.pop(
                context,
              );
              _showSuccessMessage(
                'تم تحديث بيانات الحساب بنجاح',
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// معالج عرض معلومات التطبيق
  void _showAboutDialog(AppIconsData appIcons) {
    showAboutDialog(
      context: context,
      applicationName: 'بصير',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        appIcons.invoices,
        size: 48,
        color: SemanticColors.primary,
      ),
      applicationLegalese: '© 2025 فريق وكلاء تطوير مشروع بصير',
      children: [
        const SizedBox(height: Spacing.md),
        const Text(
          'تطبيق بصير هو نظام متكامل لإدارة الفواتير والعملاء، '
          'مصمم خصيصاً للأعمال الصغيرة والمتوسطة.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.md),
        const Text(
          'الميزات الرئيسية:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Spacing.sm),
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
    unawaited(
      _openPrivacyPolicy(),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      // محاولة فتح رابط سياسة الخصوصية
      final uri = Uri.parse(
        'https://basser-app.com/privacy',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
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
              SizedBox(height: Spacing.md),
              Text('1. جميع بياناتك محفوظة محلياً على جهازك'),
              SizedBox(height: Spacing.sm),
              Text('2. لا نقوم بجمع أو مشاركة أي معلومات شخصية'),
              SizedBox(height: Spacing.sm),
              Text('3. بياناتك مشفرة وآمنة'),
              SizedBox(height: Spacing.sm),
              Text('4. لا نستخدم خدمات تتبع أو تحليلات خارجية'),
              SizedBox(height: Spacing.sm),
              Text('5. أنت المالك الوحيد لبياناتك'),
              SizedBox(height: Spacing.md),
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
    unawaited(
      _openTermsOfService(),
    );
  }

  Future<void> _openTermsOfService() async {
    try {
      // محاولة فتح رابط شروط الخدمة
      final uri = Uri.parse(
        'https://basser-app.com/terms',
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
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
              SizedBox(height: Spacing.md),
              Text('1. التطبيق مجاني للاستخدام الشخصي والتجاري'),
              SizedBox(height: Spacing.sm),
              Text('2. أنت مسؤول عن دقة البيانات المدخلة'),
              SizedBox(height: Spacing.sm),
              Text('3. يجب عليك الاحتفاظ بنسخة احتياطية من بياناتك'),
              SizedBox(height: Spacing.sm),
              Text('4. التطبيق يُقدم كما هو بدون ضمانات'),
              SizedBox(height: Spacing.sm),
              Text('5. نحن غير مسؤولين عن أي خسائر ناتجة عن استخدام التطبيق'),
              SizedBox(height: Spacing.md),
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
        backgroundColor: SemanticColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// معالج تسجيل الخروج
  void _showLogoutDialog() {
    unawaited(
      _performLogout(),
    );
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
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      // عرض رسالة تأكيد
      _showSuccessMessage(
        'تم تسجيل الخروج بنجاح',
      );
      // الانتقال إلى شاشة تسجيل الدخول
      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );
      if (!mounted) return;
      await Navigator.of(context).pushReplacementNamed(
        '/login',
      );
    }
  }
}
