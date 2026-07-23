import 'package:basir_accounting_system/core/config/app_environment_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// إعدادات Supabase (Supabase Configuration)
///
/// تحمل الإعدادات من متغيرات البيئة (Environment Variables).
/// تأكد من تعبئة القيم في ملف .env.
class SupabaseConfig {
  /// رابط مشروع Supabase
  static String get supabaseUrl => AppEnvironmentConfig.get(
        'SUPABASE_URL',
        'https://your-project-url.supabase.co',
      )!;

  /// المفتاح المجهول (Anonymous Key)
  static String get anonKey => AppEnvironmentConfig.get(
        'SUPABASE_ANON_KEY',
        'your-anon-key',
      )!;

  /// تهيئة Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);
  }

  /// الحصول على العميل النشط
  static SupabaseClient get client => Supabase.instance.client;
}
