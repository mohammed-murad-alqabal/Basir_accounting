import 'package:basir_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// امتدادات للسياق (BuildContext Extensions)
extension ContextExtensions on BuildContext {
  /// الوصول السريع للترجمات
  ///
  /// بدلاً من كتابة:
  /// `AppLocalizations.of(context)!`
  ///
  /// يمكنك كتابة:
  /// `context.l10n`
  AppLocalizations get l10n => AppLocalizations.of(this);
}
