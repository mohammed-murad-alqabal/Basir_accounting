/// نماذج البيانات لخدمة المصادقة
///
/// يحتوي على الكلاسات المساعدة لنتائج العمليات الأمنية

/// نتيجة فحص قوة كلمة المرور
class PasswordStrengthResult {
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
