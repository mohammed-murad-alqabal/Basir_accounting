import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
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
      appBar: AppAppBar(title: context.l10n.settingsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم إعدادات الشركة والفواتير
            _buildSectionTitle(context.l10n.companySettingsTitle, colorScheme),
            const SizedBox(height: Spacing.md),
            _buildCompanySettingsCard(colorScheme, appIcons),
            const SizedBox(height: Spacing.xl),

            // قسم الحساب
            _buildSectionTitle(context.l10n.accountTitle, colorScheme),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: context.l10n.editAccountTitle,
              subtitle: context.l10n.editAccountSubtitle,
              leading: Icon(appIcons.person, color: colorScheme.primary),
              onTap: _handleEditAccount,
            ),
            const SizedBox(height: Spacing.xl),

            // قسم الإشعارات
            _buildSectionTitle(context.l10n.notificationsTitle, colorScheme),
            const SizedBox(height: Spacing.md),
            AppCard(
              child: SwitchListTile(
                title: ResponsiveText(
                  context.l10n.notificationsEnable,
                  maxLines: 1,
                ),
                subtitle: ResponsiveText(
                  context.l10n.notificationsSubtitle,
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
            _buildSectionTitle(context.l10n.appearanceTitle, colorScheme),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: context.l10n.appearanceSettingsTitle,
              subtitle: context.l10n.appearanceSettingsSubtitle,
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
            _buildSectionTitle(context.l10n.helpTitle, colorScheme),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: context.l10n.aboutAppTitle,
              subtitle: context.l10n.aboutAppSubtitle,
              leading: Icon(appIcons.invoices, color: colorScheme.primary),
              onTap: () => _showAboutDialog(appIcons),
            ),
            const SizedBox(height: Spacing.sm),
            AppListCard(
              title: context.l10n.privacyPolicyTitle,
              subtitle: context.l10n.privacyPolicySubtitle,
              leading: Icon(
                Icons.privacy_tip,
                color: colorScheme.primary,
              ),
              onTap: _handlePrivacyPolicy,
            ),
            const SizedBox(height: Spacing.md),
            AppListCard(
              title: context.l10n.termsOfServiceTitle,
              subtitle: context.l10n.termsOfServiceSubtitle,
              leading: Icon(Icons.description, color: colorScheme.primary),
              onTap: _handleTermsOfService,
            ),

            const SizedBox(height: Spacing.xl),

            // زر تسجيل الخروج
            AppPrimaryButton(
              label: context.l10n.logoutLabel,
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
        title: settings['companyName'] ?? context.l10n.labelCompanyName,
        subtitle: context.l10n.companySettingsDialogTitle,
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
        title: context.l10n.errorLoadingSettings,
        subtitle: context.l10n.retryLabel,
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
          title: Text(context.l10n.companySettingsDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: nameController,
                  label: context.l10n.labelCompanyName,
                  hint: context.l10n.hintCompanyName,
                ),
                const SizedBox(height: Spacing.md),
                AppTextField(
                  controller: taxNumberController,
                  label: context.l10n.labelTaxNumber,
                  hint: context.l10n.hintTaxNumber,
                ),
                const SizedBox(height: Spacing.md),
                AppTextField(
                  controller: taxRateController,
                  label: context.l10n.labelTaxRate,
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
                        label: context.l10n.labelCurrencySymbol,
                        hint: context.l10n.hintCurrencySymbol,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: countryCodeController,
                        label: context.l10n.labelCountryCode,
                        hint: '966',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                DropdownButtonFormField<String>(
                  initialValue: selectedStyle,
                  decoration: InputDecoration(
                    labelText: context.l10n.labelInvoiceStyle,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'standard',
                      child: Text(context.l10n.styleStandard),
                    ),
                    DropdownMenuItem(
                      value: 'modern',
                      child: Text(context.l10n.styleModern),
                    ),
                    DropdownMenuItem(
                      value: 'compact',
                      child: Text(context.l10n.styleCompact),
                    ),
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
              child: Text(context.l10n.dialogCancel),
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
                  if (context.mounted) {
                    Navigator.pop(context);
                    _showSuccessMessage(context.l10n.msgSettingsSaved);
                  }
                } on Exception catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.msgSaveError(e.toString())),
                        backgroundColor: SemanticColors.error,
                      ),
                    );
                  }
                }
              },
              child: Text(context.l10n.dialogSave),
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
        title: Text(context.l10n.editAccountTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: context.l10n.labelUsername,
                  hintText: context.l10n.hintEnterNewUsername,
                ),
                onChanged: (value) {
                  // حفظ القيمة
                },
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                decoration: InputDecoration(
                  labelText: context.l10n.labelNewPassword,
                  hintText: context.l10n.hintEnterNewPassword,
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
            child: Text(context.l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
              _showSuccessMessage(
                context.l10n.msgAccountUpdated,
              );
            },
            child: Text(context.l10n.dialogSave),
          ),
        ],
      ),
    );
  }

  /// معالج عرض معلومات التطبيق
  void _showAboutDialog(AppIconsData appIcons) {
    showAboutDialog(
      context: context,
      applicationName: context.l10n.appName,
      applicationVersion: context.l10n.appVersion,
      applicationIcon: Icon(
        appIcons.invoices,
        size: 48,
        color: SemanticColors.primary,
      ),
      applicationLegalese: context.l10n.appCopyright,
      children: [
        const SizedBox(height: Spacing.md),
        Text(
          context.l10n.aboutDescription,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.md),
        Text(
          context.l10n.aboutFeaturesTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: Spacing.sm),
        Text(context.l10n.aboutFeature1),
        Text(context.l10n.aboutFeature2),
        Text(context.l10n.aboutFeature3),
        Text(context.l10n.aboutFeature4),
        Text(context.l10n.aboutFeature5),
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
        title: Text(context.l10n.privacyPolicyTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.privacyHeader,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.md),
              Text(context.l10n.privacyPoint1),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.privacyPoint2),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.privacyPoint3),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.privacyPoint4),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.privacyPoint5),
              const SizedBox(height: Spacing.md),
              Text(context.l10n.privacyFooter),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.dialogOk),
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
        title: Text(context.l10n.termsOfServiceTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.termsHeader,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.md),
              Text(context.l10n.termsPoint1),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.termsPoint2),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.termsPoint3),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.termsPoint4),
              const SizedBox(height: Spacing.sm),
              Text(context.l10n.termsPoint5),
              const SizedBox(height: Spacing.md),
              Text(context.l10n.termsFooter),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.dialogOk),
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
        title: Text(context.l10n.logoutLabel),
        content: Text(context.l10n.msgConfirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.dialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.logoutLabel),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      // عرض رسالة تأكيد
      _showSuccessMessage(
        context.l10n.msgLogoutSuccess,
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
