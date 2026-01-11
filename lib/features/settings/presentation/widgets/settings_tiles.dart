import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/settings/presentation/providers/settings_controller.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/account_settings_sheet.dart';
import 'package:basir_accounting_system/features/settings/presentation/widgets/company_settings_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// بلاطة إعدادات الشركة
class CompanySettingsTile extends ConsumerWidget {
  /// إنشاء بلاطة إعدادات الشركة
  const CompanySettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(companySettingsProvider);
    final settings = settingsAsync.value ?? {};
    final appIcons = ref.watch(appIconsProvider);

    return ListTile(
      leading: Icon(appIcons.business, color: theme.colorScheme.primary),
      title: Text(context.l10n.companySettingsTitle),
      subtitle: Text(
        settings['companyName'] ?? context.l10n.companySettingsTitle,
      ),
      trailing: Icon(appIcons.edit, size: 20),
      onTap: () => CompanySettingsSheet.show(context, settings),
    );
  }
}

/// بلاطة إعدادات الحساب
class AccountSettingsTile extends ConsumerWidget {
  /// إنشاء بلاطة إعدادات الحساب
  const AccountSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final username = ref.watch(currentUsernameProvider);
    final appIcons = ref.watch(appIconsProvider);

    return ListTile(
      leading: Icon(appIcons.users, color: theme.colorScheme.primary),
      title: Text(context.l10n.accountTitle),
      subtitle: Text(username ?? context.l10n.accountTitle),
      trailing: Icon(appIcons.security, size: 20),
      onTap: () => AccountSettingsSheet.show(context, username),
    );
  }
}

/// بلاطة إعدادات الإشعارات
class NotificationSettingsTile extends ConsumerWidget {
  /// إنشاء بلاطة إعدادات الإشعارات
  const NotificationSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(settingsControllerProvider);
    final appIcons = ref.watch(appIconsProvider);

    return SwitchListTile(
      secondary: Icon(
        state.notificationsEnabled
            ? appIcons.notifications
            : appIcons.notificationsOff,
        color: state.notificationsEnabled
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
      ),
      title: Text(context.l10n.notificationsEnable),
      subtitle: Text(context.l10n.notificationsSubtitle),
      value: state.notificationsEnabled,
      onChanged: (value) {
        unawaited(
          ref
              .read(settingsControllerProvider.notifier)
              .toggleNotifications(enabled: value),
        );
      },
    );
  }
}

/// بلاطة إعدادات اللغة
class LanguageSettingsTile extends ConsumerWidget {
  /// إنشاء بلاطة إعدادات اللغة
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localeAsync = ref.watch(localeProvider);
    final currentLocale = localeAsync.value ?? const Locale('ar');
    final appIcons = ref.watch(appIconsProvider);

    return ListTile(
      leading: Icon(appIcons.language, color: theme.colorScheme.primary),
      title: Text(context.l10n.languageTitle),
      subtitle: Text(
        currentLocale.languageCode == 'ar'
            ? context.l10n.langArabic
            : context.l10n.langEnglish,
      ),
      trailing: Icon(appIcons.translate, size: 20),
      onTap: () => _showLanguageDialog(context, ref, currentLocale),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
  ) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.languageTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ignore: deprecated_member_use
              RadioListTile<String>(
                title: Text(context.l10n.langArabic),
                value: 'ar',
                // ignore: deprecated_member_use
                groupValue: currentLocale.languageCode,
                // ignore: deprecated_member_use
                onChanged: (value) =>
                    _handleLanguageChange(dialogContext, ref, value),
              ),
              // ignore: deprecated_member_use
              RadioListTile<String>(
                title: Text(context.l10n.langEnglish),
                value: 'en',
                // ignore: deprecated_member_use
                groupValue: currentLocale.languageCode,
                // ignore: deprecated_member_use
                onChanged: (value) =>
                    _handleLanguageChange(dialogContext, ref, value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.dialogCancel),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLanguageChange(
    BuildContext context,
    WidgetRef ref,
    String? languageCode,
  ) {
    if (languageCode != null) {
      unawaited(
        ref.read(localeProvider.notifier).setLocale(Locale(languageCode)),
      );
    }
    Navigator.pop(context);
  }
}

/// بلاطة إعدادات التقويم
class CalendarSettingsTile extends ConsumerWidget {
  /// إنشاء بلاطة إعدادات التقويم
  const CalendarSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final calendarAsync = ref.watch(calendarProvider);
    final currentType = calendarAsync.value ?? CalendarType.gregorian;
    final appIcons = ref.watch(appIconsProvider);

    return ListTile(
      leading: Icon(appIcons.calendar, color: theme.colorScheme.primary),
      title: Text(context.l10n.sectionCalendar),
      subtitle: Text(
        currentType == CalendarType.hijri
            ? context.l10n.calendarHijri
            : context.l10n.calendarGregorian,
      ),
      trailing: Icon(appIcons.settings, size: 20),
      onTap: () => _showCalendarDialog(context, ref, currentType),
    );
  }

  void _showCalendarDialog(
    BuildContext context,
    WidgetRef ref,
    CalendarType currentType,
  ) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.sectionCalendar),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ignore: deprecated_member_use
              RadioListTile<CalendarType>(
                title: Text(context.l10n.calendarGregorian),
                value: CalendarType.gregorian,
                // ignore: deprecated_member_use
                groupValue: currentType,
                // ignore: deprecated_member_use
                onChanged: (value) =>
                    _handleCalendarChange(dialogContext, ref, value),
              ),
              // ignore: deprecated_member_use
              RadioListTile<CalendarType>(
                title: Text(context.l10n.calendarHijri),
                value: CalendarType.hijri,
                // ignore: deprecated_member_use
                groupValue: currentType,
                // ignore: deprecated_member_use
                onChanged: (value) =>
                    _handleCalendarChange(dialogContext, ref, value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.l10n.dialogCancel),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCalendarChange(
    BuildContext context,
    WidgetRef ref,
    CalendarType? type,
  ) {
    if (type != null) {
      unawaited(ref.read(calendarProvider.notifier).setCalendarType(type));
    }
    Navigator.pop(context);
  }
}
