/// إعدادات البيئة للتطبيق (Environment Configuration)
///
/// تهيئة وتحمل متغيرات البيئة من ملف .env
library;

import 'package:flutter/foundation.dart';
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

  static bool _isInitialized = false;

  /// تهيئة متغيرات البيئة
  static Future<void> initialize() async {
    try {
      await dotenv.load();
      _isInitialized = true;
    } on Object catch (e) {
      debugPrint('⚠️ Failed to load .env file: $e');
      _isInitialized = false;
    }
  }

  /// يتحقق من الحد الأدنى لإعدادات التشغيل في الإنتاج.
  static void validateForStartup() {
    if (!isProduction) return;

    const requiredKeys = <String>['SUPABASE_URL', 'SUPABASE_ANON_KEY'];
    final missing = requiredKeys
        .where((key) {
          final value = _safeEnv[key]?.trim();
          return value == null || value.isEmpty || value.startsWith('your_');
        })
        .toList(growable: false);

    if (missing.isNotEmpty) {
      throw StateError(
        'Production environment is missing required configuration: '
        '${missing.join(', ')}',
      );
    }
  }

  /// الحصول على قيمة من dotenv.env, safely
  static Map<String, String> get _safeEnv => _isInitialized ? dotenv.env : {};

  /// الحصول على بيئة التطبيق الحالية
  static AppEnvironment get environment {
    final env = _safeEnv['ENVIRONMENT'] ?? 'development';
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
  static bool get isDebugMode => _safeEnv['DEBUG_MODE'] == 'true';

  /// الحصول على قيمة من متغير البيئة
  static String? get(String key, [String? defaultValue]) =>
      _safeEnv[key] ?? defaultValue;

  /// الحصول على قيمة رقمية من متغير البيئة
  static int? getInt(String key, [int? defaultValue]) {
    final value = _safeEnv[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// الحصول على قيمة منطقية من متغير البيئة
  static bool getBool(String key, {bool defaultValue = false}) {
    final value = _safeEnv[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }
}
