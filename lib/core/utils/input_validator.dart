/// أداة التحقق من صحة المدخلات
///
/// توفر دوال شاملة للتحقق من صحة وأمان المدخلات
/// تطبق معايير الأمان وتمنع الهجمات الشائعة
///
/// Features:
/// - التحقق من أسماء المستخدمين
/// - التحقق من كلمات المرور
/// - التحقق من البريد الإلكتروني
/// - منع SQL Injection
/// - منع XSS attacks
/// - تنظيف المدخلات
class InputValidator {
  /// التحقق من صحة اسم المستخدم
  ///
  /// معايير التحقق:
  /// - الطول بين 3-20 حرف
  /// - يحتوي على أحرف وأرقام فقط
  /// - يبدأ بحرف
  /// - لا يحتوي على مسافات أو رموز خاصة
  ///
  /// Parameters:
  /// - [username]: اسم المستخدم المراد فحصه
  ///
  /// Returns: نتيجة التحقق
  static ValidationResult validateUsername(String username) {
    final issues = <String>[];

    // فحص الطول
    if (username.length < 3) {
      issues.add('اسم المستخدم يجب أن يكون 3 أحرف على الأقل');
    } else if (username.length > 20) {
      issues.add('اسم المستخدم يجب أن يكون 20 حرف على الأكثر');
    }

    // فحص الأحرف المسموحة
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(username)) {
      issues.add('اسم المستخدم يجب أن يبدأ بحرف ويحتوي على أحرف وأرقام فقط');
    }

    // فحص الكلمات المحظورة
    final forbiddenWords = ['admin', 'root', 'user', 'test', 'guest', 'null'];
    if (forbiddenWords.contains(username.toLowerCase())) {
      issues.add('اسم المستخدم محظور، يرجى اختيار اسم آخر');
    }

    return ValidationResult(isValid: issues.isEmpty, issues: issues);
  }

  /// التحقق من صحة كلمة المرور
  ///
  /// معايير التحقق:
  /// - الطول الأدنى 8 أحرف
  /// - وجود أحرف كبيرة وصغيرة
  /// - وجود أرقام
  /// - وجود رموز خاصة (اختياري للمستوى المتقدم)
  /// - عدم احتواء معلومات شخصية
  ///
  /// Parameters:
  /// - [password]: كلمة المرور المراد فحصها
  /// - [username]: اسم المستخدم للتحقق من عدم التشابه
  /// - [strictMode]: وضع صارم يتطلب رموز خاصة
  ///
  /// Returns: نتيجة التحقق مع نقاط القوة
  static PasswordValidationResult validatePassword(
    String password, {
    String? username,
    bool strictMode = false,
  }) {
    final issues = <String>[];
    var score = 0;

    // فحص الطول
    if (password.length < 8) {
      issues.add('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    } else if (password.length >= 12) {
      score += 20; // نقاط إضافية للطول الجيد
    } else {
      score += 10;
    }

    // فحص الأحرف الكبيرة
    if (!password.contains(RegExp('[A-Z]'))) {
      issues.add('يجب أن تحتوي على حرف كبير واحد على الأقل');
    } else {
      score += 15;
    }

    // فحص الأحرف الصغيرة
    if (!password.contains(RegExp('[a-z]'))) {
      issues.add('يجب أن تحتوي على حرف صغير واحد على الأقل');
    } else {
      score += 15;
    }

    // فحص الأرقام
    if (!password.contains(RegExp('[0-9]'))) {
      issues.add('يجب أن تحتوي على رقم واحد على الأقل');
    } else {
      score += 15;
    }

    // فحص الرموز الخاصة
    final hasSpecialChars = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );
    if (strictMode && !hasSpecialChars) {
      issues.add(r'يجب أن تحتوي على رمز خاص واحد على الأقل (!@#$%^&*)');
    } else if (hasSpecialChars) {
      score += 20; // نقاط إضافية للرموز الخاصة
    }

    // فحص عدم التشابه مع اسم المستخدم
    if (username != null &&
        password.toLowerCase().contains(username.toLowerCase())) {
      issues.add('كلمة المرور يجب ألا تحتوي على اسم المستخدم');
      score -= 10;
    }

    // فحص الأنماط الشائعة
    final commonPatterns = [
      '123456',
      'password',
      'qwerty',
      'abc123',
      '111111',
      'admin',
    ];
    for (final pattern in commonPatterns) {
      if (password.toLowerCase().contains(pattern)) {
        issues.add('كلمة المرور تحتوي على نمط شائع وغير آمن');
        score -= 15;
        break;
      }
    }

    // فحص التكرار
    if (RegExp(r'(.)\1{2,}').hasMatch(password)) {
      issues.add('تجنب تكرار نفس الحرف أكثر من مرتين متتاليتين');
      score -= 5;
    }

    return PasswordValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      score: score.clamp(0, 100),
    );
  }

  /// التحقق من صحة البريد الإلكتروني
  ///
  /// Parameters:
  /// - [email]: البريد الإلكتروني المراد فحصه
  ///
  /// Returns: نتيجة التحقق
  static ValidationResult validateEmail(String email) {
    final issues = <String>[];

    // فحص التنسيق الأساسي
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      issues.add('تنسيق البريد الإلكتروني غير صحيح');
    }

    // فحص الطول
    if (email.length > 254) {
      issues.add('البريد الإلكتروني طويل جداً');
    }

    return ValidationResult(isValid: issues.isEmpty, issues: issues);
  }

  /// تنظيف النص من المحتوى الضار
  ///
  /// يزيل أو يحول الأحرف التي قد تستخدم في الهجمات
  ///
  /// Parameters:
  /// - [input]: النص المراد تنظيفه
  /// - [allowHtml]: السماح بـ HTML (افتراضياً false)
  ///
  /// Returns: النص المنظف
  static String sanitizeInput(String input, {bool allowHtml = false}) {
    var cleaned = input.trim();

    if (!allowHtml) {
      // إزالة HTML tags
      cleaned = cleaned.replaceAll(RegExp('<[^>]*>'), '');

      // تحويل الأحرف الخاصة
      cleaned = cleaned
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('"', '&quot;')
          .replaceAll("'", '&#x27;');
    }

    // إزالة null bytes
    cleaned = cleaned.replaceAll('\x00', '');

    // إزالة SQL injection patterns
    final sqlPatterns = [
      RegExp(r';\s*--', caseSensitive: false),
      RegExp(r';\s*#', caseSensitive: false),
      RegExp(r';\s*/\*', caseSensitive: false),
      RegExp(r'union\s+select', caseSensitive: false),
      RegExp(r'drop\s+table', caseSensitive: false),
    ];

    for (final pattern in sqlPatterns) {
      cleaned = cleaned.replaceAll(pattern, '');
    }

    return cleaned;
  }

  /// التحقق من صحة رقم الهاتف السعودي
  ///
  /// Parameters:
  /// - [phone]: رقم الهاتف المراد فحصه
  ///
  /// Returns: نتيجة التحقق
  static ValidationResult validateSaudiPhone(String phone) {
    final issues = <String>[];

    // إزالة المسافات والرموز
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-()]'), '');

    // فحص التنسيق السعودي
    final saudiPhoneRegex = RegExp(r'^(\+966|966|0)?5[0-9]{8}$');

    if (!saudiPhoneRegex.hasMatch(cleanPhone)) {
      issues.add('رقم الهاتف يجب أن يكون رقم سعودي صحيح (05xxxxxxxx)');
    }

    return ValidationResult(isValid: issues.isEmpty, issues: issues);
  }

  /// التحقق من صحة الرقم الضريبي السعودي
  ///
  /// Parameters:
  /// - [taxNumber]: الرقم الضريبي المراد فحصه
  ///
  /// Returns: نتيجة التحقق
  static ValidationResult validateSaudiTaxNumber(String taxNumber) {
    final issues = <String>[];

    // إزالة المسافات
    final cleanTaxNumber = taxNumber.replaceAll(' ', '');

    // فحص التنسيق (15 رقم)
    if (!RegExp(r'^\d{15}$').hasMatch(cleanTaxNumber)) {
      issues.add('الرقم الضريبي يجب أن يكون 15 رقم');
    }

    return ValidationResult(isValid: issues.isEmpty, issues: issues);
  }

  /// فحص المدخلات للحماية من الهجمات
  ///
  /// Parameters:
  /// - [input]: المدخل المراد فحصه
  ///
  /// Returns: تقرير الأمان
  static SecurityScanResult scanForThreats(String input) {
    final threats = <String>[];
    var riskLevel = 0;

    // فحص SQL Injection
    final sqlPatterns = [
      "'.*or.*'.*=.*'",
      "'.*union.*select",
      "'.*drop.*table",
      "'.*insert.*into",
      "'.*delete.*from",
    ];

    for (final pattern in sqlPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        threats.add('محاولة SQL Injection محتملة');
        riskLevel += 30;
        break;
      }
    }

    // فحص XSS
    final xssPatterns = [
      '<script.*?>',
      'javascript:',
      r'on\w+\s*=',
      '<iframe.*?>',
    ];

    for (final pattern in xssPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        threats.add('محاولة XSS محتملة');
        riskLevel += 25;
        break;
      }
    }

    // فحص Path Traversal
    if (input.contains('../') || input.contains(r'..\')) {
      threats.add('محاولة Path Traversal محتملة');
      riskLevel += 20;
    }

    // فحص Command Injection
    final cmdPatterns = [r';\s*rm\s', r';\s*cat\s', r';\s*ls\s', '`.*`'];
    for (final pattern in cmdPatterns) {
      if (RegExp(pattern).hasMatch(input)) {
        threats.add('محاولة Command Injection محتملة');
        riskLevel += 35;
        break;
      }
    }

    return SecurityScanResult(
      isSafe: threats.isEmpty,
      riskLevel: riskLevel.clamp(0, 100),
      threats: threats,
    );
  }
}

/// نتيجة التحقق من صحة المدخلات
class ValidationResult {
  /// إنشاء نتيجة التحقق
  const ValidationResult({required this.isValid, required this.issues});

  /// هل المدخل صحيح؟
  final bool isValid;

  /// قائمة المشاكل المكتشفة
  final List<String> issues;
}

/// نتيجة التحقق من كلمة المرور
class PasswordValidationResult extends ValidationResult {
  /// إنشاء نتيجة التحقق من كلمة المرور
  const PasswordValidationResult({
    required super.isValid,
    required super.issues,
    required this.score,
  });

  /// نقاط قوة كلمة المرور (0-100)
  final int score;

  /// مستوى القوة
  String get strengthLevel {
    if (score >= 80) return 'قوية جداً';
    if (score >= 60) return 'قوية';
    if (score >= 40) return 'متوسطة';
    if (score >= 20) return 'ضعيفة';
    return 'ضعيفة جداً';
  }

  /// لون المؤشر
  String get strengthColor {
    if (score >= 80) return 'green';
    if (score >= 60) return 'lightgreen';
    if (score >= 40) return 'orange';
    if (score >= 20) return 'red';
    return 'darkred';
  }
}

/// نتيجة فحص الأمان
class SecurityScanResult {
  /// إنشاء نتيجة فحص الأمان
  const SecurityScanResult({
    required this.isSafe,
    required this.riskLevel,
    required this.threats,
  });

  /// هل المدخل آمن؟
  final bool isSafe;

  /// مستوى المخاطر (0-100)
  final int riskLevel;

  /// قائمة التهديدات المكتشفة
  final List<String> threats;

  /// مستوى المخاطر كنص
  String get riskLevelText {
    if (riskLevel >= 70) return 'عالي جداً';
    if (riskLevel >= 50) return 'عالي';
    if (riskLevel >= 30) return 'متوسط';
    if (riskLevel >= 10) return 'منخفض';
    return 'آمن';
  }
}
