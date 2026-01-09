import 'dart:async';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers/calendar_provider.dart';
import 'package:basir_app/core/providers/theme_provider.dart';
import 'package:basir_app/core/theme/services/appearance_service.dart';
import 'package:basir_app/core/theme/services/color_customization_service.dart';
import 'package:basir_app/core/theme/services/font_customization_service.dart';
import 'package:basir_app/core/theme/services/icon_customization_service.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/settings/presentation/widgets/font_settings_tile.dart';
import 'package:basir_app/features/settings/presentation/widgets/icon_settings_tile.dart';
import 'package:basir_app/features/settings/presentation/widgets/theme_preview_card.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إعدادات المظهر المتقدمة
class AppearanceSettingsScreen extends ConsumerWidget {
  /// إنشاء شاشة إعدادات المظهر المتقدمة
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).valueOrNull ?? ThemeMode.system;
    final appearanceState = ref
            .watch(
              appearanceServiceProvider,
            )
            .valueOrNull ??
        const AppearanceState(
          highContrast: false,
          reduceMotion: false,
        );
    final calendarType =
        ref.watch(calendarProvider).valueOrNull ?? CalendarType.gregorian;
    final customColor = ref.watch(colorCustomizationProvider).valueOrNull;
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.appearanceSettingsTitle,
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          // 0. Preview Section
          const AppSectionHeader(title: 'نظرة سريعة'),
          const SizedBox(height: Spacing.md),
          const ThemePreviewCard(),
          const SizedBox(height: Spacing.xxl),

          // 1. Theme Mode Section
          AppSectionHeader(
            title: context.l10n.sectionMode,
            icon: appIcons.brightness,
          ),
          const SizedBox(height: Spacing.md),
          Center(
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text(context.l10n.modeSystem),
                  icon: Icon(appIcons.update),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text(context.l10n.modeLight),
                  icon: Icon(appIcons.lightMode),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text(context.l10n.modeDark),
                  icon: Icon(appIcons.darkMode),
                ),
              ],
              selected: {
                themeMode,
              },
              onSelectionChanged: (newSelection) {
                unawaited(
                  ref.read(themeProvider.notifier).setThemeMode(
                        newSelection.first,
                      ),
                );
              },
              showSelectedIcon: false,
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // 2. Color Selection Section
          AppSectionHeader(
            title: context.l10n.sectionStyle,
            icon: appIcons.theme,
          ),
          const SizedBox(height: Spacing.md),
          Semantics(
            label: context.l10n.appColor,
            button: true,
            hint: context.l10n.appColor, // Fallback to avoid undefined key
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
              ),
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: customColor ?? Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              title: Text(context.l10n.appColor),
              subtitle: Text(
                customColor == null
                    ? context.l10n.colorDefault
                    : context.l10n.colorCustomized,
              ),
              trailing: Icon(appIcons.palette),
              onTap: () {
                unawaited(ColorPickerDialog.show(context));
              },
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // 3. Icons Section (Platinum Card integrated)
          const IconSettingsTile(),
          const SizedBox(height: Spacing.xxl),

          // 4. Font Section (Platinum Card integrated)
          const FontSettingsTile(),
          const SizedBox(height: Spacing.xxl),

          // 5. Accessibility Section
          AppSectionHeader(
            title: context.l10n.sectionAccessibility,
            icon: appIcons.accessibility,
          ),
          const SizedBox(height: Spacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(
                    alpha: 0.2,
                  ),
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(appIcons.contrast),
                  title: Text(context.l10n.highContrast),
                  subtitle: Text(context.l10n.highContrastSubtitle),
                  value: appearanceState.highContrast,
                  onChanged: (value) {
                    unawaited(
                      ref
                          .read(appearanceServiceProvider.notifier)
                          .setHighContrast(
                            enabled: value,
                          ),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(appIcons.reduceMotion),
                  title: Text(context.l10n.reduceMotion),
                  subtitle: Text(context.l10n.reduceMotionSubtitle),
                  value: appearanceState.reduceMotion,
                  onChanged: (value) {
                    unawaited(
                      ref
                          .read(appearanceServiceProvider.notifier)
                          .setReduceMotion(
                            enabled: value,
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // 6. Calendar Section
          AppSectionHeader(
            title: context.l10n.sectionCalendar,
            icon: appIcons.calendar,
          ),
          const SizedBox(height: Spacing.md),
          Center(
            child: SegmentedButton<CalendarType>(
              segments: [
                ButtonSegment<CalendarType>(
                  value: CalendarType.gregorian,
                  label: Text(context.l10n.calendarGregorian),
                  icon: Icon(appIcons.calendar),
                ),
                ButtonSegment<CalendarType>(
                  value: CalendarType.hijri,
                  label: Text(
                    context.l10n.calendarHijri,
                  ),
                  icon: Icon(appIcons.bolt),
                ),
              ],
              selected: {calendarType},
              onSelectionChanged: (newSelection) {
                unawaited(
                  ref.read(calendarProvider.notifier).setCalendarType(
                        newSelection.first,
                      ),
                );
              },
              showSelectedIcon: false,
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // 7. Reset All Section
          // 7. Reset All Section
          Center(
            child: AppEnhancedButton(
              label: context.l10n.btnRestoreDefault,
              onPressed: () => _showResetConfirmation(context, ref),
              type: AppEnhancedButtonType.danger,
              icon: appIcons.restore,
            ),
          ),
          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) {
          final appIcons = ref.watch(appIconsProvider);
          return AlertDialog(
            icon: Icon(appIcons.warning, size: 48),
            title: Text(context.l10n.btnRestoreDefault),
            content: Text(
              context.l10n.msgResetConfirmation,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(context.l10n.dialogCancel),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(colorCustomizationProvider.notifier)
                      .resetToDefault();
                  await ref
                      .read(fontCustomizationProvider.notifier)
                      .resetToDefault();
                  await ref
                      .read(iconCustomizationProvider.notifier)
                      .resetToDefault();
                  await ref
                      .read(appearanceServiceProvider.notifier)
                      .resetToDefault();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(
                  context.l10n.btnRestoreDefault,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
