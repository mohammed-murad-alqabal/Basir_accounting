/// نماذج البيانات لخدمة المصادقة
///
/// يحتوي على الكلاسات المساعدة لنتائج العمليات الأمنية
library;

import 'package:supabase_flutter/supabase_flutter.dart';

/// نتيجة فحص قوة كلمة المرور
class PasswordStrengthResult {
  /// إنشاء نتيجة فحص القوة
  const PasswordStrengthResult({
    required this.score,
    required this.isStrong,
    required this.issues,
  });

  /// نقاط القوة (0-100)
  final int score;

  /// هل كلمة المرور قوية؟
  final bool isStrong;

  /// قائمة المشاكل المكتشفة
  final List<String> issues;

  /// مستوى القوة كنص
  String get strengthLevel {
    if (score >= 80) return 'قوية جداً';
    if (score >= 60) return 'قوية';
    if (score >= 40) return 'متوسطة';
    if (score >= 20) return 'ضعيفة';
    return 'ضعيفة جداً';
  }
}

/// نتيجة فحص الأمان
class SecurityAuditResult {
  /// إنشاء نتيجة فحص الأمان
  const SecurityAuditResult({
    required this.securityScore,
    required this.isSecure,
    required this.issues,
    required this.hasAccount,
    required this.hasValidEncryption,
  });

  /// نقاط الأمان (0-100)
  final int securityScore;

  /// هل النظام آمن؟
  final bool isSecure;

  /// قائمة المشاكل الأمنية
  final List<String> issues;

  /// هل يوجد حساب مسجل؟
  final bool hasAccount;

  /// هل التشفير صحيح؟
  final bool hasValidEncryption;

  /// مستوى الأمان كنص
  String get securityLevel {
    if (securityScore >= 90) return 'ممتاز';
    if (securityScore >= 80) return 'جيد جداً';
    if (securityScore >= 70) return 'جيد';
    if (securityScore >= 60) return 'مقبول';
    return 'غير آمن';
  }
}

/// مستخدم بصير (Basir User)
class BasirUser {
  const BasirUser({
    required this.id,
    required this.email,
    this.displayName,
    this.isGuest = false,
    this.metadata = const {},
  });

  /// تحويل من Supabase User
  factory BasirUser.fromSupabase(User user) => BasirUser(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String?,
        metadata: user.userMetadata ?? {},
      );

  /// المعرف الفريد للمستخدم
  final String id;

  /// البريد الإلكتروني
  final String email;

  /// الاسم المعروض
  final String? displayName;

  /// هل هو مستخدم ضيف؟
  final bool isGuest;

  /// بيانات إضافية
  final Map<String, dynamic> metadata;
}
