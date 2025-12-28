import 'dart:async';

import 'package:basser_app/core/providers/theme_provider.dart';
import 'package:basser_app/core/theme/services/appearance_service.dart';
import 'package:basser_app/core/theme/services/color_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/widgets/app_app_bar.dart';
import 'package:basser_app/core/widgets/color_picker_dialog.dart';
import 'package:basser_app/features/settings/presentation/widgets/font_settings_tile.dart';
import 'package:basser_app/features/settings/presentation/widgets/icon_settings_tile.dart';
import 'package:basser_app/features/settings/presentation/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إعدادات المظهر المتقدمة
class AppearanceSettingsScreen extends ConsumerWidget {
  /// إنشاء شاشة إعدادات المظهر المتقدمة
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).valueOrNull ?? ThemeMode.system;
    final appearanceState = ref.watch(appearanceServiceProvider).valueOrNull ??
        const AppearanceState(highContrast: false, reduceMotion: false);
    final customColor = ref.watch(colorCustomizationProvider).value;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'المظهر والتخصيص',
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          // 0. Preview
          const ThemePreviewCard(),
          const SizedBox(height: Spacing.xl),

          // 1. Theme Mode
          _buildSectionHeader(context, 'الوضع'),
          const SizedBox(height: Spacing.sm),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('النظام'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('فاتح'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('داكن'),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (newSelection) {
              unawaited(
                ref
                    .read(themeProvider.notifier)
                    .setThemeMode(newSelection.first),
              );
            },
            showSelectedIcon: false,
            style: const ButtonStyle(
              visualDensity: VisualDensity.comfortable,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // 2. Style
          _buildSectionHeader(context, 'النمط'),
          const SizedBox(height: Spacing.sm),
          Card(
            elevation: 0,
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.md),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        customColor ?? Theme.of(context).colorScheme.primary,
                    radius: 12,
                  ),
                  title: const Text('لون التطبيق'),
                  subtitle: Text(
                    customColor == null ? 'اللون الافتراضي' : 'تم تخصيص اللون',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    unawaited(ColorPickerDialog.show(context));
                  },
                ),
                const Divider(height: 1),
                const IconSettingsTile(),
                const Divider(height: 1),
                const FontSettingsTile(),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // 3. Accessibility
          _buildSectionHeader(context, 'إمكانية الوصول'),
          const SizedBox(height: Spacing.sm),
          Card(
            elevation: 0,
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.md),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.contrast),
                  title: const Text('تباين عالي'),
                  subtitle: const Text(
                    'زيادة وضوح النصوص والعناصر',
                  ),
                  value: appearanceState.highContrast,
                  onChanged: (value) {
                    unawaited(
                      ref
                          .read(appearanceServiceProvider.notifier)
                          .setHighContrast(enabled: value),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.speed),
                  title: const Text('تقليل الحركة'),
                  subtitle: const Text(
                    'تقليل تأثيرات الحركة والانتقالات',
                  ),
                  value: appearanceState.reduceMotion,
                  onChanged: (value) {
                    unawaited(
                      ref
                          .read(appearanceServiceProvider.notifier)
                          .setReduceMotion(enabled: value),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) => Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      );
}
