import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// مستودع اللغة (Locale Repository)
///
/// يدير حفظ واسترجاع تفضيلات اللغة من التخزين المحلي.
/// يستخدم SharedPreferences لحفظ اللغة المفضلة للمستخدم.
class LocaleRepository {
  /// مفتاح تخزين اللغة في SharedPreferences
  static const String _localeKey = 'app_locale';

  /// الحصول على اللغة المحفوظة
  ///
  /// يعيد [Locale] إذا كانت محفوظة، أو null إذا لم تكن محفوظة.
  Future<Locale?> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        return Locale(languageCode);
      }

      return null;
    } on Exception {
      // في حالة حدوث خطأ، نعيد null
      return null;
    }
  }

  /// حفظ اللغة المفضلة
  ///
  /// [locale]: اللغة المراد حفظها
  /// يعيد true إذا تم الحفظ بنجاح، false في حالة الخطأ.
  Future<bool> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      return true;
    } on Exception {
      return false;
    }
  }

  /// مسح اللغة المحفوظة
  ///
  /// يعيد true إذا تم المسح بنجاح، false في حالة الخطأ.
  Future<bool> clearLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);
      return true;
    } on Exception {
      return false;
    }
  }

  /// التحقق من وجود لغة محفوظة
  ///
  /// يعيد true إذا كانت هناك لغة محفوظة، false إذا لم تكن.
  Future<bool> hasLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_localeKey);
    } on Exception {
      return false;
    }
  }
}
