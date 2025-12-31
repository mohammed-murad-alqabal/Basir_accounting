import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart';
import 'package:basser_app/core/providers/calendar_provider.dart';
import 'package:basser_app/core/providers/theme_provider.dart';
import 'package:basser_app/core/theme/services/appearance_service.dart';
import 'package:basser_app/core/theme/services/color_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
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

  /// Builds a RadioListTile for calendar type selection.
  Widget _buildCalendarOption(
    BuildContext context,
    String title,
    CalendarType value,
    CalendarType? groupValue,
    ValueChanged<CalendarType?>? onChanged,
  ) =>
      RadioListTile<CalendarType>(
        key: Key('calendar_option_${value.name}'),
        title: Text(title),
        value: value,
        // ignore: deprecated_member_use
        groupValue: groupValue,
        // ignore: deprecated_member_use
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        controlAffinity: ListTileControlAffinity.trailing,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).valueOrNull ?? ThemeMode.system;
    final appearanceState = ref.watch(appearanceServiceProvider).valueOrNull ??
        const AppearanceState(highContrast: false, reduceMotion: false);
    final customColor = ref.watch(colorCustomizationProvider).value;
    // ignore: lines_longer_than_80_chars
    final calendarType =
        ref.watch(calendarProvider).valueOrNull ?? CalendarType.gregorian;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appearanceSettingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.lg),
        children: [
          // 0. Preview
          const ThemePreviewCard(),
          const SizedBox(height: Spacing.xl),

          // 1. Theme Mode
          _buildSectionHeader(context, context.l10n.sectionMode),
          const SizedBox(height: Spacing.sm),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text(context.l10n.modeSystem),
                icon: const Icon(Icons.brightness_auto),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text(context.l10n.modeLight),
                icon: const Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text(context.l10n.modeDark),
                icon: const Icon(Icons.dark_mode),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (newSelection) {
              unawaited(
                // ignore: lines_longer_than_80_chars
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
          _buildSectionHeader(context, context.l10n.sectionStyle),
          const SizedBox(height: Spacing.sm),
          Card(
            elevation: 0,
            // ignore: lines_longer_than_80_chars
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
                    // ignore: lines_longer_than_80_chars
                    backgroundColor:
                        customColor ?? Theme.of(context).colorScheme.primary,
                    radius: 12,
                  ),
                  title: Text(context.l10n.appColor),
                  subtitle: Text(
                    // ignore: lines_longer_than_80_chars
                    customColor == null
                        ? context.l10n.colorDefault
                        : context.l10n.colorCustomized,
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
          _buildSectionHeader(context, context.l10n.sectionAccessibility),
          const SizedBox(height: Spacing.sm),
          Card(
            elevation: 0,
            // ignore: lines_longer_than_80_chars
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
                  title: Text(context.l10n.highContrast),
                  subtitle: Text(
                    context.l10n.highContrastSubtitle,
                  ),
                  value: appearanceState.highContrast,
                  onChanged: (value) {
                    unawaited(
                      // ignore: lines_longer_than_80_chars
                      ref
                          .read(appearanceServiceProvider.notifier)
                          .setHighContrast(enabled: value),
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.speed),
                  title: Text(context.l10n.reduceMotion),
                  subtitle: Text(
                    context.l10n.reduceMotionSubtitle,
                  ),
                  value: appearanceState.reduceMotion,
                  onChanged: (value) {
                    unawaited(
                      // ignore: lines_longer_than_80_chars
                      ref
                          .read(appearanceServiceProvider.notifier)
                          .setReduceMotion(enabled: value),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // 4. Calendar
          _buildSectionHeader(context, context.l10n.sectionCalendar),
          const SizedBox(height: Spacing.sm),
          Card(
            elevation: 0,
            // ignore: lines_longer_than_80_chars
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
                _buildCalendarOption(
                  context,
                  context.l10n.calendarGregorian,
                  CalendarType.gregorian,
                  calendarType,
                  (newValue) {
                    if (newValue != null) {
                      unawaited(
                        // ignore: lines_longer_than_80_chars
                        ref
                            .read(calendarProvider.notifier)
                            .setCalendarType(newValue),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                _buildCalendarOption(
                  context,
                  context.l10n.calendarHijri,
                  CalendarType.hijri,
                  calendarType,
                  (newValue) {
                    if (newValue != null) {
                      unawaited(
                        // ignore: lines_longer_than_80_chars
                        ref
                            .read(calendarProvider.notifier)
                            .setCalendarType(newValue),
                      );
                    }
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
