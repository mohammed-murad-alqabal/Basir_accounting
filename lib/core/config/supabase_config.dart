import 'package:supabase_flutter/supabase_flutter.dart';

/// إعدادات Supabase (Supabase Configuration)
/// يرجى استبدال القيم Placeholder بالقيم الحقيقية من لوحة تحكم Supabase.
class SupabaseConfig {
  static const String supabaseUrl = 'https://your-project-url.supabase.co';
  static const String anonKey = 'your-anon-key';

  /// تهيئة Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
  }

  /// الحصول على العميل النشط
  static SupabaseClient get client => Supabase.instance.client;
}
