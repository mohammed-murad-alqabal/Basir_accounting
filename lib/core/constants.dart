// ملف الثوابت الأساسية للتطبيق
// يحتوي على جميع القيم الثابتة المستخدمة في جميع أنحاء التطبيق

// ملاحظة: تم نقل إعدادات الخطوط والأحجام إلى Design Tokens في core/theme/tokens/
// استخدم AppTypography.و FontFamilies من هناك.

/// مفاتيح التخزين الآمن
///
/// يحتوي على جميع المفاتيح المستخدمة في التخزين الآمن (Secure Storage)
/// لضمان عدم تكرار المفاتيح وسهولة الصيانة
class StorageKeys {
  /// مفتاح اسم المستخدم
  static const String username = 'username';

  /// مفتاح hash كلمة المرور المشفرة
  static const String passwordHash = 'password_hash';

  /// مفتاح حالة تسجيل الدخول
  static const String isLoggedIn = 'is_logged_in';

  /// مفتاح البقاء مسجلاً
  static const String keepLoggedIn = 'keep_logged_in';

  /// مفتاح وضع الضيف
  static const String isGuest = 'is_guest';

  /// مفتاح نسبة الضريبة
  static const String taxRate = 'tax_rate';

  /// مفتاح اسم الشركة
  static const String companyName = 'company_name';

  /// مفتاح الرقم الضريبي للشركة
  static const String companyTaxNumber = 'company_tax_number';

  /// مفتاح عنوان الشركة
  static const String companyAddress = 'company_address';

  /// مفتاح هاتف الشركة
  static const String companyPhone = 'company_phone';

  /// مفتاح رمز العملة
  static const String currencySymbol = 'currency_symbol';

  /// مفتاح كود العملة (مثل SAR)
  static const String currencyCode = 'currency_code';

  /// مفتاح كود الدولة الافتراضي (للواتساب)
  static const String defaultCountryCode = 'default_country_code';

  /// مفتاح شكل الفاتورة (قالب)
  static const String invoiceStyle = 'invoice_style';
}

/// إعدادات التطبيق الأساسية
///
/// يحتوي على جميع الإعدادات والقيم الافتراضية للتطبيق
class AppConfig {
  /// اسم التطبيق
  static const String appName = 'بصير';

  /// إصدار التطبيق الحالي
  static const String appVersion = '1.0.0';

  /// وصف التطبيق
  static const String appDescription = 'نظام بصير المحاسبي والمالي الذكي';

  /// نسبة الضريبة الافتراضية (15%)
  /// تُستخدم عند إنشاء فواتير جديدة
  static const double defaultTaxRate = 0.15;

  /// الحد الأدنى لطول كلمة المرور (6 أحرف)
  /// يُستخدم في التحقق من صحة كلمة المرور
  static const int minPasswordLength = 6;

  /// الحد الأدنى لطول اسم المستخدم (3 أحرف)
  /// يُستخدم في التحقق من صحة اسم المستخدم
  static const int minUsernameLength = 3;

  /// رمز العملة الافتراضي
  static const String defaultCurrencySymbol = 'ر.س';

  /// كود العملة الافتراضي
  static const String defaultCurrencyCode = 'SAR';

  /// كود الدولة الافتراضي (السعودية)
  static const String defaultCountryCode = '966';

  /// قالب الفاتورة الافتراضي
  static const String defaultInvoiceStyle = 'classic';
}

/// حالات الفاتورة
///
/// يحتوي على جميع الحالات الممكنة للفاتورة
/// تُستخدم لتتبع دورة حياة الفاتورة
class InvoiceStatus {
  /// حالة المسودة - الفاتورة قيد الإنشاء
  static const String draft = 'draft';

  /// حالة مُصدرة - الفاتورة تم إصدارها للعميل
  static const String issued = 'issued';

  /// حالة مدفوعة - الفاتورة تم دفعها بالكامل
  static const String paid = 'paid';

  /// حالة مستحقة - الفاتورة تجاوزت تاريخ الاستحقاق
  static const String overdue = 'overdue';

  /// حالة ملغاة - الفاتورة تم إلغاؤها
  static const String cancelled = 'cancelled';
}
