// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get aboutAppSubtitle => 'الإصدار 1.0.0';

  @override
  String get aboutAppTitle => 'حول التطبيق';

  @override
  String get aboutDescription =>
      'تطبيق بصير هو نظام متكامل لإدارة الفواتير والعملاء، مصمم خصيصاً للأعمال الصغيرة والمتوسطة.';

  @override
  String get aboutFeature1 => '• إدارة الفواتير بسهولة';

  @override
  String get aboutFeature2 => '• إدارة العملاء';

  @override
  String get aboutFeature3 => '• تصدير الفواتير كـ PDF';

  @override
  String get aboutFeature4 => '• تخزين آمن للبيانات';

  @override
  String get aboutFeature5 => '• دعم كامل للغة العربية';

  @override
  String get aboutFeaturesTitle => 'الميزات الرئيسية:';

  @override
  String get accountTitle => 'الحساب';

  @override
  String get actionAddCustomer => 'إضافة عميل';

  @override
  String get actionAddInvoice => 'إضافة فاتورة';

  @override
  String get actionDeleteCustomer => 'حذف العميل';

  @override
  String get actionDeleteInvoice => 'حذف الفاتورة';

  @override
  String get actionSharePdf => 'مشاركة ملف PDF';

  @override
  String get actionShareWhatsappPdf => 'إرسال عبر الواتساب (PDF)';

  @override
  String get actionShareWhatsappText => 'إرسال عبر الواتساب (نص)';

  @override
  String get actionUpgradeAccount => 'ترقية الحساب';

  @override
  String get appColor => 'لون التطبيق';

  @override
  String get appCopyright => '© 2026 فريق وكلاء تطوير مشروع بصير';

  @override
  String get appName => 'بصير';

  @override
  String get appTitle => 'بصير';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appearanceSettingsSubtitle =>
      'الوضع الليلي، الألوان، الخطوط، والأيقونات';

  @override
  String get appearanceSettingsTitle => 'إعدادات المظهر';

  @override
  String get appearanceTitle => 'المظهر والتخصيص';

  @override
  String get btnAdd => 'إضافة';

  @override
  String get btnAddCustomer => 'إضافة العميل';

  @override
  String get btnCreateAccount => 'إنشاء حساب جديد';

  @override
  String get btnDelete => 'حذف';

  @override
  String get btnDone => 'تم';

  @override
  String get btnRestoreDefault => 'استعادة الافتراضي';

  @override
  String get btnSave => 'حفظ';

  @override
  String get btnSaveChanges => 'حفظ التعديلات';

  @override
  String get btnSaveInvoice => 'إضافة الفاتورة';

  @override
  String get btnSelectFromContacts => 'اختيار من جهات الاتصال';

  @override
  String get btnUpdateInvoice => 'حفظ التعديلات';

  @override
  String get calendarGregorian => 'ميلادي (Gregorian)';

  @override
  String get calendarHijri => 'هجري (Hijri)';

  @override
  String get calendarSelection => 'اختر التقويم المفضل لعرض ومعالجة التواريخ';

  @override
  String get colorCustomized => 'تم تخصيص اللون';

  @override
  String get colorDefault => 'اللون الافتراضي';

  @override
  String get companySettingsDialogTitle => 'إعدادات الشركة والفواتير';

  @override
  String get companySettingsTitle => 'إعدادات الشركة والفواتير';

  @override
  String get customerDetailsTitle => 'تفاصيل العميل';

  @override
  String get customerFormTitleAdd => 'إضافة عميل جديد';

  @override
  String get customerFormTitleEdit => 'تعديل العميل';

  @override
  String get customersAddTooltip => 'إضافة عميل جديد';

  @override
  String get customersScreenTitle => 'العملاء';

  @override
  String get customersSearchHint => 'ابحث عن عميل...';

  @override
  String get customersTitle => 'العملاء';

  @override
  String get dashboardBasirSystemTitle => 'نظام بصير المحاسبي';

  @override
  String get dashboardMotto => 'دقة وموثوقية في كل معاملة';

  @override
  String get dashboardQuickActionsTitle => 'الإجراءات المالية السريعة';

  @override
  String get dashboardRecentActivityTitle => 'سجل العمليات الأحدث';

  @override
  String get dashboardStatsTitle => 'تحليلات الأداء المالي';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get dashboardWelcomeMessage => 'مرحباً بك في بصير';

  @override
  String get dialogAddItemTitle => 'إضافة بند';

  @override
  String get dialogCancel => 'إلغاء';

  @override
  String get dialogOk => 'حسناً';

  @override
  String get dialogSave => 'حفظ';

  @override
  String get dialogTaxTitle => 'نسبة الضريبة';

  @override
  String get editAccountSubtitle => 'غيّر اسم المستخدم وكلمة المرور';

  @override
  String get editAccountTitle => 'تعديل بيانات الحساب';

  @override
  String errContactAccess(String error) {
    return 'خطأ في الوصول لجهات الاتصال: $error';
  }

  @override
  String get errCustomerAdd => 'فشل إضافة العميل';

  @override
  String get errCustomerDelete => 'فشل حذف العميل';

  @override
  String get errCustomerNameLength => 'الاسم يجب أن يحتوي على حرفين على الأقل';

  @override
  String get errCustomerNameRequired => 'اسم العميل مطلوب';

  @override
  String get errCustomerUpdate => 'فشل تحديث بيانات العميل';

  @override
  String get errEmptyField => 'هذا الحقل مطلوب';

  @override
  String errGeneric(String error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get errInvalidEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String get errInvalidNumber => 'الرجاء إدخال رقم صحيح';

  @override
  String get errInvoiceAdd => 'فشل إضافة الفاتورة';

  @override
  String get errInvoiceUpdate => 'فشل تحديث الفاتورة';

  @override
  String errLoadCustomers(String error) {
    return 'خطأ في تحميل العملاء: $error';
  }

  @override
  String get errLoginFailed => 'فشل تسجيل الدخول. يرجى التحقق من البيانات.';

  @override
  String get errNoItems => 'يرجى إضافة بند واحد على الأقل';

  @override
  String get errPasswordShort => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get errPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get errPhoneLength => 'رقم الهاتف يجب أن يتكون من 10 أرقام';

  @override
  String get errPhoneStart05 => 'رقم الهاتف يجب أن يبدأ بـ 05';

  @override
  String get errSelectCustomer => 'يرجى اختيار العميل';

  @override
  String get errUsernameShort => 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';

  @override
  String get errorCustomerNotFound => 'تعذر العثور على بيانات العميل';

  @override
  String get errorCustomerPhone => 'رقم هاتف العميل غير متوفر';

  @override
  String get errorLoadingInvoices => 'حدث خطأ أثناء تحميل الفواتير';

  @override
  String get errorLoadingSettings => 'خطأ في تحميل الإعدادات';

  @override
  String errorScreenNotFound(String name) {
    return 'الشاشة غير موجودة: $name';
  }

  @override
  String errorSharePdf(String error) {
    return 'خطأ في مشاركة PDF: $error';
  }

  @override
  String errorShareWhatsapp(String error) {
    return 'خطأ في المشاركة عبر الواتساب: $error';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get filterDraft => 'مسودة';

  @override
  String get filterIssued => 'مُصدرة';

  @override
  String get filterOverdue => 'مستحقة';

  @override
  String get filterPaid => 'مدفوعة';

  @override
  String get fontCairo => 'Cairo (الافتراضي)';

  @override
  String get fontRoboto => 'Roboto';

  @override
  String get fontSettingsTitle => 'نوع الخط';

  @override
  String get fontSizeLabel => 'حجم النص';

  @override
  String get guestUpgradeDescription =>
      'قم بتحويل حساب الضيف الخاص بك إلى حساب دائم لحفظ بياناتك بشكل آمن.';

  @override
  String get helpTitle => 'المساعدة والدعم';

  @override
  String get highContrast => 'تباين عالي';

  @override
  String get highContrastSubtitle => 'زيادة ووضوح النصوص والعناصر';

  @override
  String get hintAddress => 'أدخل عنوان العميل';

  @override
  String get hintCompanyName => 'أدخل اسم شركتك';

  @override
  String get hintConfirmPassword => 'أعد إدخال كلمة المرور';

  @override
  String get hintCurrencySymbol => 'ر.س';

  @override
  String get hintCustomerName => 'أدخل اسم العميل';

  @override
  String get hintCustomerNotes => 'أضف ملاحظات عن العميل';

  @override
  String get hintEnterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get hintEnterNewUsername => 'أدخل اسم المستخدم الجديد';

  @override
  String get hintEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get hintEnterUsername => 'يرجى إدخال اسم المستخدم';

  @override
  String get hintNotes => 'أضف ملاحظات عن الفاتورة';

  @override
  String get hintSelectCustomer => 'اختر العميل';

  @override
  String get hintTaxNumber => 'أدخل الرقم الضريبي (اختياري)';

  @override
  String get iconCupertino => 'Cupertino (iOS)';

  @override
  String get iconMaterial => 'Material Design';

  @override
  String get iconSettingsTitle => 'نمط الأيقونات';

  @override
  String get invoiceFormTitleAdd => 'إضافة فاتورة جديدة';

  @override
  String get invoiceFormTitleEdit => 'تعديل الفاتورة';

  @override
  String invoiceTitle(String id) {
    return 'فاتورة رقم $id';
  }

  @override
  String get invoicesTitle => 'الفواتير';

  @override
  String get labelAddress => 'العنوان';

  @override
  String get labelAddressOptional => 'العنوان (اختياري)';

  @override
  String get labelCompanyName => 'اسم الشركة';

  @override
  String get labelConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get labelCountryCode => 'كود الدولة';

  @override
  String get labelCreatedDate => 'تاريخ الإضافة';

  @override
  String get labelCreditLimit => 'سقف الائتمان (اختياري)';

  @override
  String get labelCurrencySymbol => 'رمز العملة';

  @override
  String get labelCustomer => 'العميل';

  @override
  String get labelCustomerName => 'اسم العميل';

  @override
  String get labelDueDate => 'تاريخ الاستحقاق';

  @override
  String get labelEmail => 'البريد الإلكتروني';

  @override
  String get labelEmailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get labelGrandTotal => 'الإجمالي الكلي:';

  @override
  String get labelInvoiceItems => 'بنود الفاتورة';

  @override
  String get labelInvoiceNo => 'فاتورة رقم';

  @override
  String get labelInvoiceStatus => 'حالة الفاتورة';

  @override
  String get labelInvoiceStyle => 'شكل الفاتورة';

  @override
  String get labelIssuedDate => 'تاريخ الإصدار';

  @override
  String get labelItemName => 'اسم المنتج/الخدمة';

  @override
  String get labelLastUpdated => 'آخر تحديث';

  @override
  String get labelNewPassword => 'كلمة المرور الجديدة';

  @override
  String get labelNotes => 'ملاحظات (اختياري)';

  @override
  String get labelNotesOptional => 'ملاحظات (اختياري)';

  @override
  String get labelPassword => 'كلمة المرور';

  @override
  String get labelPercentage => 'النسبة المئوية';

  @override
  String get labelPhone => 'رقم الهاتف';

  @override
  String get labelPhoneOptional => 'رقم الهاتف (اختياري)';

  @override
  String get labelPrice => 'السعر';

  @override
  String get labelQuantity => 'الكمية';

  @override
  String get labelRememberMe => 'تذكرني';

  @override
  String get labelSubtotal => 'المجموع الفرعي:';

  @override
  String labelTax(String rate) {
    return 'الضريبة ($rate):';
  }

  @override
  String get labelTaxNumber => 'الرقم الضريبي';

  @override
  String get labelTaxRate => 'نسبة الضريبة';

  @override
  String get labelTaxRateWithExample => 'نسبة الضريبة (مثال: 0.15)';

  @override
  String get labelUsername => 'اسم المستخدم';

  @override
  String get langArabic => 'العربية';

  @override
  String get langEnglish => 'English';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get loginGuest => 'الدخول كضيف';

  @override
  String get loginSubtitle => 'مرحباً بك مجدداً! سجل دخولك للمتابعة';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get logoutLabel => 'تسجيل الخروج';

  @override
  String get modeDark => 'داكن';

  @override
  String get modeLight => 'فاتح';

  @override
  String get modeSystem => 'النظام';

  @override
  String get msgAccountCreated => 'تم إنشاء الحساب بنجاح';

  @override
  String get msgAccountUpdated => 'تم تحديث بيانات الحساب بنجاح';

  @override
  String msgConfirmDeleteCustomer(String name) {
    return 'هل أنت متأكد من حذف العميل $name؟';
  }

  @override
  String get msgConfirmDeleteInvoice => 'هل أنت متأكد من حذف هذه الفاتورة؟';

  @override
  String get msgConfirmLogout => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get msgCustomerAdded => 'تم إضافة العميل بنجاح';

  @override
  String get msgCustomerDeleted => 'تم حذف العميل بنجاح';

  @override
  String get msgCustomerUpdated => 'تم تحديث بيانات العميل بنجاح';

  @override
  String get msgGuestWelcome => 'مرحباً بك كضيف! يمكنك إنشاء حساب لاحقاً';

  @override
  String get msgInvoiceAdded => 'تم إضافة الفاتورة بنجاح';

  @override
  String msgInvoiceShare(String name, String id, String total, String symbol) {
    return 'مرحباً $name، إليك تفاصيل فاتورة رقم $id:\nالإجمالي: $total $symbol\nشكراً لتعاملك معنا.';
  }

  @override
  String get msgInvoiceUpdated => 'تم تحديث الفاتورة بنجاح';

  @override
  String get msgLoginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get msgLogoutSuccess => 'تم تسجيل الخروج بنجاح';

  @override
  String get msgNoAccount => 'لا تملك حساباً؟';

  @override
  String get msgNoContactsFound => 'لا توجد جهات اتصال متاحة';

  @override
  String get msgNoItems => 'لا توجد بنود. اضغط + لإضافة بند';

  @override
  String msgSaveError(String error) {
    return 'خطأ في الحفظ: $error';
  }

  @override
  String get msgSettingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get navCustomers => 'العملاء';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navInvoices => 'الفواتير';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get notificationsEnable => 'تفعيل الإشعارات';

  @override
  String get notificationsSubtitle => 'استقبل إشعارات الفواتير المتأخرة';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String pdfShareSubject(String id) {
    return 'فاتورة رقم $id';
  }

  @override
  String pdfShareText(String customerName) {
    return 'إليك تفاصيل الفاتورة الخاصة بـ $customerName';
  }

  @override
  String placeholderComingSoon(String title) {
    return 'قريبًا: $title';
  }

  @override
  String get privacyFooter =>
      'للمزيد من المعلومات، يرجى زيارة موقعنا الإلكتروني.';

  @override
  String get privacyHeader => 'نحن نحترم خصوصيتك';

  @override
  String get privacyPoint1 => '1. جميع بياناتك محفوظة محلياً على جهازك';

  @override
  String get privacyPoint2 => '2. لا نقوم بجمع أو مشاركة أي معلومات شخصية';

  @override
  String get privacyPoint3 => '3. بياناتك مشفرة وآمنة';

  @override
  String get privacyPoint4 => '4. لا نستخدم خدمات تتبع أو تحليلات خارجية';

  @override
  String get privacyPoint5 => '5. أنت المالك الوحيد لبياناتك';

  @override
  String get privacyPolicySubtitle => 'اقرأ سياسة الخصوصية الخاصة بنا';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get reduceMotion => 'تقليل الحركة';

  @override
  String get reduceMotionSubtitle => 'تقليل تأثيرات الحركة والانتقالات';

  @override
  String get retryLabel => 'انقر لإعادة المحاولة';

  @override
  String get sectionAccessibility => 'إمكانية الوصول';

  @override
  String get sectionAdditionalInfo => 'معلومات إضافية';

  @override
  String get sectionCalendar => 'التقويم';

  @override
  String get sectionContactInfo => 'معلومات الاتصال';

  @override
  String get sectionMode => 'الوضع';

  @override
  String get sectionStyle => 'النمط';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get setupSubtitle => 'أنشئ حسابك للبدء في إدارة فواتيرك';

  @override
  String get setupTitle => 'إنشاء حساب جديد';

  @override
  String get splashCriticalError => 'خطأ تقني في البداية';

  @override
  String get splashInitializing => 'جاري التهيئة...';

  @override
  String get statActiveCustomers => 'العملاء النشطون';

  @override
  String get statOverdue => 'المتأخرة';

  @override
  String get statOverdueInvoices => 'فواتير متأخرة';

  @override
  String get statPaid => 'المدفوعة';

  @override
  String get statTotal => 'الإجمالي';

  @override
  String get statTotalInvoices => 'إجمالي الفواتير';

  @override
  String get statTotalSales => 'المبيعات الكلية';

  @override
  String get statusCancelled => 'ملغاة';

  @override
  String get statusOverdue => 'متأخرة';

  @override
  String get statusPaid => 'مدفوعة';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get styleCompact => 'مختصر';

  @override
  String get styleModern => 'عصري';

  @override
  String get styleStandard => 'قياسي';

  @override
  String get termsFooter => 'باستخدامك للتطبيق، فإنك توافق على هذه الشروط.';

  @override
  String get termsHeader => 'شروط استخدام تطبيق بصير';

  @override
  String get termsOfServiceSubtitle => 'اقرأ شروط الخدمة الخاصة بنا';

  @override
  String get termsOfServiceTitle => 'شروط الخدمة';

  @override
  String get termsPoint1 => '1. التطبيق مجاني للاستخدام الشخصي والتجاري';

  @override
  String get termsPoint2 => '2. أنت مسؤول عن دقة البيانات المدخلة';

  @override
  String get termsPoint3 => '3. يجب عليك الاحتفاظ بنسخة احتياطية من بياناتك';

  @override
  String get termsPoint4 => '4. التطبيق يُقدم كما هو بدون ضمانات';

  @override
  String get termsPoint5 =>
      '5. نحن غير مسؤولين عن أي خسائر ناتجة عن استخدام التطبيق';

  @override
  String get themeColorPickerTitle => 'اختر لون التطبيق';

  @override
  String get tooltipAddInvoice => 'إضافة فاتورة';

  @override
  String get tooltipAddItem => 'إضافة بند جديد';

  @override
  String get tooltipBack => 'رجوع';

  @override
  String get tooltipDeleteItem => 'حذف البند';

  @override
  String get tooltipEditCustomer => 'تعديل العميل';

  @override
  String get tooltipEditTaxRate => 'تعديل نسبة الضريبة';

  @override
  String get tooltipExportAll => 'تصدير الكل';

  @override
  String get btnRetry => 'إعادة المحاولة';

  @override
  String get testEnhancedButtonsTitle => 'اختبار الأزرار المحسّنة';

  @override
  String get msgAccountUpgraded => 'تم ترقية الحساب بنجاح';

  @override
  String get labelHome => 'الرئيسية';

  @override
  String get labelSettings => 'الإعدادات';

  @override
  String get labelPrimary => 'أساسي';

  @override
  String get labelSecondary => 'ثانوي';

  @override
  String get labelTestText => 'نص تجريبي';

  @override
  String get testButtonsTitle => 'اختبار الأزرار';

  @override
  String get sectionPrimaryButtons => 'الأزرار الأساسية';

  @override
  String get sectionSecondaryButtons => 'الأزرار الثانوية';

  @override
  String get sectionTextButtons => 'الأزرار النصية';

  @override
  String get sectionRowButtons => 'صف الأزرار';

  @override
  String get sectionSpecialCases => 'حالات خاصة';
}
