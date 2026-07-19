import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/presentation/screens/financial_calculator_screen.dart';
import 'package:basir_accounting_system/features/analytics/presentation/screens/privacy_analytics_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/providers/settings_controller.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/print_settings_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/screens/tax_config_screen.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/help_settings_group.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/settings_tiles.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 💎 شاشة الإعدادات المتقدمة (Settings Screen Platinum)
/// واجهة عصرية وسهلة الاستخدام لإدارة كافة جوانب التطبيق
class SettingsScreen extends ConsumerWidget {
  /// إنشاء شاشة الإعدادات
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appIcons = ref.watch(appIconsProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return GlassScaffold(
      title: context.l10n.settingsTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            // 🏢 قسم الشركة والفواتير
            SettingsSectionHeader(
              title: context.l10n.companySettingsTitle,
              icon: appIcons.business,
            ),
            const SettingsGroupCard(children: [CompanySettingsTile()]),
            const SizedBox(height: Spacing.md),
            SettingsGroupCard(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.account_balance_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(context.l10n.taxConfigTitle),
                  subtitle: Text(context.l10n.zatcaPhase2Title),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const TaxConfigScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.import_export_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('استيراد من Excel'),
                  subtitle: const Text('ترحيل الأرصدة الافتتاحية'),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () => Navigator.pushNamed(context, '/excel-import'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.cloud_sync_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('النسخ الاحتياطي السحابي'),
                  subtitle: const Text('مزامنة مع Google Drive'),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () => Navigator.pushNamed(context, '/cloud-backup'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    appIcons.barcodeReader,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text('إعدادات الباركود'),
                  subtitle: const Text('تكوين قياسات وطباعة الملصقات'),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () =>
                      Navigator.pushNamed(context, '/barcode-settings'),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // 👤 قسم الحساب والأمن
            SettingsSectionHeader(
              title: context.l10n.accountTitle,
              icon: appIcons.security,
            ),
            const SettingsGroupCard(
              children: [
                AccountSettingsTile(),
                Divider(height: 1),
                _UsersSettingsTile(),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // 🔔 قسم التنبيهات
            SettingsSectionHeader(
              title: context.l10n.notificationsTitle,
              icon: appIcons.notifications,
            ),
            const SettingsGroupCard(children: [NotificationSettingsTile()]),
            const SizedBox(height: Spacing.xl),

            // 🎨 قسم المظهر والتخصيص
            SettingsSectionHeader(
              title: context.l10n.appearanceTitle,
              icon: appIcons.theme,
            ),
            SettingsGroupCard(
              children: [
                const LanguageSettingsTile(),
                const Divider(height: 1),
                const CalendarSettingsTile(),
                const Divider(height: 1),
                Semantics(
                  label: context.l10n.appearanceSettingsTitle,
                  button: true,
                  child: ListTile(
                    leading: Icon(
                      appIcons.style,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(context.l10n.appearanceSettingsTitle),
                    subtitle: Text(context.l10n.appearanceSettingsSubtitle),
                    trailing: Icon(appIcons.chevronRight),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const AppearanceSettingsScreen(),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.print_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(context.l10n.printSettingsTitle),
                  subtitle: Text(context.l10n.printSettingsSubtitle),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const PrintSettingsScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.calculate_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(context.l10n.calculatorTitle),
                  subtitle: Text(context.l10n.convertToCurrencies),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const FinancialCalculatorScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    appIcons.security,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(context.l10n.privacyAnalyticsTitle),
                  subtitle: Text(context.l10n.privacyAnalyticsSubtitle),
                  trailing: Icon(appIcons.chevronRight),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const PrivacyAnalyticsScreen(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // ❓ قسم المساعدة والروابط
            const HelpSettingsGroup(),
            const SizedBox(height: Spacing.xxl),

            // 🚪 منطقة الأوامر النهائية
            // 🚪 منطقة الأوامر النهائية
            AppEnhancedButton(
              label: context.l10n.logoutLabel,
              onPressed: () => _showLogoutDialog(context, controller),
              type: AppEnhancedButtonType.danger,
            ),
            const SizedBox(height: Spacing.xl),

            // نسخة التطبيق
            Text(
              '${context.l10n.appVersion} 1.0.0 (Platinum)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, SettingsController controller) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.logoutLabel),
          content: Text(context.l10n.msgConfirmLogout),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.dialogCancel),
            ),
            TextButton(
              onPressed: () async {
                await controller.logout();
                if (context.mounted) {
                  await Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              child: Text(
                context.l10n.logoutLabel,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersSettingsTile extends StatelessWidget {
  const _UsersSettingsTile();

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(
          Icons.group_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('إدارة المستخدمين'),
        subtitle: const Text('الصلاحيات والحسابات'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, '/users'),
      );
}
