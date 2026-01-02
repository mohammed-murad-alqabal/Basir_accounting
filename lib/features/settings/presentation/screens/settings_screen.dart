import 'dart:async';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/core/widgets/index.dart';
import 'package:basir_app/features/settings/presentation/providers/settings_controller.dart';
import 'package:basir_app/features/settings/presentation/screens/appearance_settings_screen.dart';
import 'package:basir_app/features/settings/presentation/widgets/help_settings_group.dart';
import 'package:basir_app/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:basir_app/features/settings/presentation/widgets/settings_tiles.dart';
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
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.settingsTitle,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          children: [
            // 🏢 قسم الشركة والفواتير
            SettingsSectionHeader(
              title: context.l10n.companySettingsTitle,
              icon: Icons.business_center,
            ),
            const SettingsGroupCard(
              children: [
                CompanySettingsTile(),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // 👤 قسم الحساب والأمن
            SettingsSectionHeader(
              title: context.l10n.accountTitle,
              icon: Icons.security,
            ),
            const SettingsGroupCard(
              children: [
                AccountSettingsTile(),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // 🔔 قسم التنبيهات
            SettingsSectionHeader(
              title: context.l10n.notificationsTitle,
              icon: Icons.notifications_none,
            ),
            const SettingsGroupCard(
              children: [
                NotificationSettingsTile(),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // 🎨 قسم المظهر والتخصيص
            SettingsSectionHeader(
              title: context.l10n.appearanceTitle,
              icon: Icons.palette_outlined,
            ),
            SettingsGroupCard(
              children: [
                const LanguageSettingsTile(),
                const Divider(height: 1),
                const CalendarSettingsTile(),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.style, color: theme.colorScheme.primary),
                  title: Text(context.l10n.appearanceSettingsTitle),
                  subtitle: Text(context.l10n.appearanceSettingsSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AppearanceSettingsScreen(),
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
            AppButton(
              label: context.l10n.logoutLabel,
              onPressed: () => _showLogoutDialog(context, controller),
              type: AppButtonType.danger,
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
                  await Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (route) => false);
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
