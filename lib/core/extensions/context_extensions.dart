import 'package:basir_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// امتدادات للسياق (BuildContext Extensions)
extension ContextExtensions on BuildContext {
  /// الوصول السريع للترجمات
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// هل اللغة الحالية هي العربية؟
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
