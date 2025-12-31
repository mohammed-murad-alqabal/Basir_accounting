import 'package:basser_app/core/providers.dart';
import 'package:basser_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ويدجت اختيار اللغة (Language Selector)
///
/// قائمة منسدلة للسماح للمستخدم بتغيير لغة التطبيق.
class LanguageSelector extends ConsumerWidget {
  /// إنشاء ويدجت اختيار اللغة
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);
    final currentLocale = localeAsync.value ?? const Locale('ar');

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentLocale.languageCode,
        icon: const Icon(Icons.language),
        onChanged: (newLanguageCode) async {
          if (newLanguageCode != null) {
            await ref
                .read(localeProvider.notifier)
                .setLocale(Locale(newLanguageCode));
          }
        },
        items: [
          DropdownMenuItem(
            value: 'ar',
            child: Text(AppLocalizations.of(context).langArabic),
          ),
          DropdownMenuItem(
            value: 'en',
            child: Text(AppLocalizations.of(context).langEnglish),
          ),
        ],
      ),
    );
  }
}
