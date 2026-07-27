// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
// ignore: max_line_length
import 'package:basir_accounting_system/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة الخصوصية والتحليلات
class PrivacyAnalyticsScreen extends ConsumerStatefulWidget {
  /// إنشاء الشاشة
  const PrivacyAnalyticsScreen({super.key});

  @override
  ConsumerState<PrivacyAnalyticsScreen> createState() =>
      _PrivacyAnalyticsScreenState();
}

class _PrivacyAnalyticsScreenState
    extends ConsumerState<PrivacyAnalyticsScreen> {
  bool _isTrackingEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appIcons = ref.watch(appIconsProvider);
    final analytics = ref.watch(analyticsServiceProvider);

    return GlassScaffold(
      title: context.l10n.privacyAnalyticsTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تلميح الخصوصية
            Card(
              color: theme.colorScheme.primaryContainer.withAlpha(50),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Row(
                  children: [
                    Icon(appIcons.info, color: theme.colorScheme.primary),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Text(
                        context.l10n.analyticsPrivacyNotice,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Spacing.xl),

            // مفتاح تفعيل التتبع
            SettingsGroupCard(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    appIcons.chart,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(context.l10n.analyticsEnableTracking),
                  value: _isTrackingEnabled,
                  onChanged: (value) {
                    setState(() => _isTrackingEnabled = value);
                    analytics?.isEnabled = value;
                  },
                ),
              ],
            ),
            const SizedBox(height: Spacing.xl),

            // زر مسح البيانات
            SettingsGroupCard(
              children: [
                ListTile(
                  leading: Icon(
                    appIcons.delete,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    context.l10n.analyticsClearData,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () => _showClearDataDialog(context, analytics),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, AnalyticsService? analytics) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.analyticsClearData),
          content: const Text(
            'هل أنت متأكد من رغبتك في حذف جميع بيانات التحليلات '
            'المحلية؟ لا يمكن التراجع عن هذا الإجراء.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                unawaited(Navigator.of(context).maybePop());
              },
              child: Text(context.l10n.dialogCancel),
            ),
            TextButton(
              onPressed: () async {
                await analytics?.clearAllData();
                if (context.mounted) {
                  unawaited(Navigator.of(context).maybePop());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.analyticsDataCleared)),
                  );
                }
              },
              child: Text(
                context.l10n.btnDelete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
