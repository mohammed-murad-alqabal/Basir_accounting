/// ملف الثوابت الأساسية للتطبيق
/// يحتوي على جميع القيم الثابتة المستخدمة في جميع أنحاء التطبيق
library;

/// أحجام الخطوط المستخدمة في التطبيق
///
/// يحتوي على جميع أحجام الخطوط القياسية المستخدمة في واجهة المستخدم
/// لضمان التناسق في التصميم عبر جميع الشاشات
class AppFontSizes {
  /// حجم العنوان الكبير (32px)
  /// يُستخدم للعناوين الرئيسية والصفحات الرئيسية
  static const double headingLarge = 32;

  /// حجم العنوان المتوسط (24px)
  /// يُستخدم للعناوين الفرعية والأقسام
  static const double headingMedium = 24;

  /// حجم العنوان الصغير (20px)
  /// يُستخدم للعناوين الثانوية والبطاقات
  static const double headingSmall = 20;

  /// حجم النص الكبير (16px)
  /// يُستخدم للنصوص الأساسية والمحتوى الرئيسي
  static const double bodyLarge = 16;

  /// حجم النص المتوسط (14px)
  /// يُستخدم للنصوص الثانوية والأوصاف
  static const double bodyMedium = 14;

  /// حجم النص الصغير (12px)
  /// يُستخدم للنصوص التوضيحية والملاحظات
  static const double bodySmall = 12;

  /// حجم التسمية الكبيرة (14px)
  /// يُستخدم لتسميات الحقول والأزرار
  static const double labelLarge = 14;

  /// حجم التسمية الصغيرة (12px)
  /// يُستخدم للتسميات الثانوية والمساعدة
  static const double labelSmall = 12;
}

/// أسماء الخطوط المستخدمة في التطبيق
///
/// يحدد الخطوط الافتراضية للغات المختلفة
class AppFonts {
  /// خط اللغة العربية (Tajawal)
  /// خط عربي حديث وواضح مناسب للواجهات
  static const String arabicFont = 'Tajawal';

  /// خط اللغة الإنجليزية (Roboto)
  /// خط إنجليزي قياسي من Google
  static const String englishFont = 'Roboto';
}

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

  /// مفتاح نسبة الضريبة
  static const String taxRate = 'tax_rate';

  /// مفتاح اسم الشركة
  static const String companyName = 'company_name';

  /// مفتاح الرقم الضريبي للشركة
  static const String companyTaxNumber = 'company_tax_number';
}

/// رسائل التطبيق
///
/// يحتوي على جميع الرسائل المعروضة للمستخدم
/// مقسمة إلى رسائل نجاح ورسائل خطأ
class AppMessages {
  /// رسالة نجاح تسجيل الدخول
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';

  /// رسالة نجاح إعداد التطبيق
  static const String setupSuccess = 'تم إعداد التطبيق بنجاح';

  /// رسالة نجاح إنشاء الفاتورة
  static const String invoiceCreatedSuccess = 'تم إنشاء الفاتورة بنجاح';

  /// رسالة نجاح إضافة العميل
  static const String customerAddedSuccess = 'تم إضافة العميل بنجاح';

  /// رسالة نجاح حفظ البيانات
  static const String dataSavedSuccess = 'تم حفظ البيانات بنجاح';

  /// رسالة خطأ بيانات اعتماد غير صحيحة
  static const String invalidCredentials = 'بيانات الاعتماد غير صحيحة';

  /// رسالة خطأ حقل فارغ
  static const String emptyField = 'هذا الحقل مطلوب';

  /// رسالة خطأ بريد إلكتروني غير صحيح
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';

  /// رسالة خطأ كلمة مرور قصيرة
  static const String passwordTooShort = 'كلمة المرور قصيرة جدًا';

  /// رسالة خطأ اسم مستخدم مستخدم
  static const String usernameTaken = 'اسم المستخدم مستخدم بالفعل';

  /// رسالة خطأ عام
  static const String errorOccurred = 'حدث خطأ ما. يرجى المحاولة لاحقًا';

  /// رسالة خطأ عدم وجود اتصال بالإنترنت
  static const String noInternetConnection = 'لا توجد اتصالية إنترنت';

  /// رسالة خطأ في قاعدة البيانات
  static const String databaseError = 'خطأ في قاعدة البيانات';
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
  static const String appDescription = 'نظام إدارة الفواتير والعملاء الذكي';

  /// نسبة الضريبة الافتراضية (15%)
  /// تُستخدم عند إنشاء فواتير جديدة
  static const double defaultTaxRate = 0.15;

  /// الحد الأدنى لطول كلمة المرور (6 أحرف)
  /// يُستخدم في التحقق من صحة كلمة المرور
  static const int minPasswordLength = 6;

  /// الحد الأدنى لطول اسم المستخدم (3 أحرف)
  /// يُستخدم في التحقق من صحة اسم المستخدم
  static const int minUsernameLength = 3;
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

/// تسميات حالات الفاتورة للعرض
///
/// يحتوي على الترجمة العربية لحالات الفاتورة
/// تُستخدم لعرض الحالة للمستخدم بشكل مفهوم
class InvoiceStatusLabels {
  /// خريطة تربط حالة الفاتورة بالتسمية العربية
  static const Map<String, String> labels = {
    'draft': 'مسودة',
    'issued': 'مُصدرة',
    'paid': 'مدفوعة',
    'overdue': 'مستحقة',
    'cancelled': 'ملغاة',
  };
}
