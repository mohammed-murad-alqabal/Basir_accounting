import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// مجموعة إعدادات المساعدة والدعم
class HelpSettingsGroup extends ConsumerWidget {
  /// إنشاء مجموعة إعدادات المساعدة
  const HelpSettingsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appIcons = ref.watch(appIconsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(
          title: context.l10n.helpTitle,
          icon: Icons.help_outline,
        ),
        SettingsGroupCard(
          children: [
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
              ),
              title: Text(context.l10n.aboutAppTitle),
              subtitle: Text(context.l10n.aboutAppSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showAboutDialog(context, appIcons),
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(context.l10n.privacyPolicyTitle),
              subtitle: Text(context.l10n.privacyPolicySubtitle),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _openUrl('https://basir-app.com/privacy'),
            ),
            ListTile(
              leading: Icon(
                Icons.description_outlined,
                color: theme.colorScheme.primary,
              ),
              title: Text(context.l10n.termsOfServiceTitle),
              subtitle: Text(context.l10n.termsOfServiceSubtitle),
              trailing: const Icon(Icons.open_in_new, size: 18),
              onTap: () => _openUrl('https://basir-app.com/terms'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showAboutDialog(BuildContext context, AppIconsBase appIcons) {
    showAboutDialog(
      context: context,
      applicationName: context.l10n.appName,
      applicationVersion: context.l10n.appVersion,
      applicationIcon: Icon(
        appIcons.invoices,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      applicationLegalese: context.l10n.appCopyright,
      children: [
        const SizedBox(height: Spacing.md),
        Text(context.l10n.aboutDescription, textAlign: TextAlign.center),
      ],
    );
  }
}
