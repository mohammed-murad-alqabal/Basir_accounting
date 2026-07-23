/// إعدادات البيئة للتطبيق (Environment Configuration)
///
/// تهيئة وتحمل متغيرات البيئة من ملف .env
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// بيئة التطبيق
enum AppEnvironment {
  /// بيئة التطوير (Development)
  development,

  /// بيئة المرحلة التجريبية (Staging)
  staging,

  /// بيئة الإنتاج (Production)
  production,
}

/// إعدادات البيئة للتطبيق
class AppEnvironmentConfig {
  AppEnvironmentConfig._();

  /// تهيئة متغيرات البيئة
  static Future<void> initialize() async {
    await dotenv.load();
  }

  /// الحصول على بيئة التطبيق الحالية
  static AppEnvironment get environment {
    final env = dotenv.env['ENVIRONMENT'] ?? 'development';
    switch (env) {
      case 'staging':
        return AppEnvironment.staging;
      case 'production':
        return AppEnvironment.production;
      default:
        return AppEnvironment.development;
    }
  }

  /// هل نحن في بيئة التطوير؟
  static bool get isDevelopment => environment == AppEnvironment.development;

  /// هل نحن في بيئة الإنتاج؟
  static bool get isProduction => environment == AppEnvironment.production;

  /// هل وضع التصحيح مفعل؟
  static bool get isDebugMode => dotenv.env['DEBUG_MODE'] == 'true';

  /// الحصول على قيمة من متغير البيئة
  static String? get(String key, [String? defaultValue]) =>
      dotenv.env[key] ?? defaultValue;

  /// الحصول على قيمة رقمية من متغير البيئة
  static int? getInt(String key, [int? defaultValue]) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// الحصول على قيمة منطقية من متغير البيئة
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }
}
