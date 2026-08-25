// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بصير';

  @override
  String get labelStandard => 'المعيار المحاسبي';

  @override
  String get labelRecognitionBasis => 'أساس الاعتراف';

  @override
  String get labelMeasurementBasis => 'أساس القياس';

  @override
  String get labelCurrency => 'العملة';

  @override
  String get labelAddCurrency => 'إضافة عملة';

  @override
  String get labelPartner => 'الطرف';

  @override
  String get labelAccountCode => 'رقم الحساب';

  @override
  String get labelAccountName => 'اسم الحساب';

  @override
  String get labelFairValueAdjustment => 'التقييم بالقيمة العادلة (IFRS 13)';

  @override
  String get subtitleFairValueAdjustment => 'استخدام أحدث أسعار السوق للمخزون';

  @override
  String get labelTotalAmount => 'الإجمالي';

  @override
  String get msgBalanceBalancedTB => 'الميزان متزن (Balanced)';

  @override
  String get msgBalanceUnbalancedTB => 'الميزان غير متزن! يرجى المراجعة.';

  @override
  String get sectionBasicReports => 'التقارير الأساسية';

  @override
  String get sectionFinancialStatements => 'القوائم المالية (IAS 1/IFRS)';

  @override
  String get sectionAgingAnalysis => 'تحليل السداد وأعمار الديون';

  @override
  String get receivablesAgingTitle => 'أعمار العملاء';

  @override
  String get payablesAgingTitle => 'أعمار الموردين';

  @override
  String get labelGeneralLedger => 'دفتر الأستاذ';

  @override
  String get labelPeriod => 'الفترة';

  @override
  String get msgNoTransactionsFound => 'لا توجد حركات';

  @override
  String get msgExportComingSoon => 'سيتم تفعيل التصدير قريباً';

  @override
  String get appearanceTitle => 'المظهر والتخصيص';

  @override
  String get companySettingsTitle => 'إعدادات الشركة والفواتير';

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
  String get errPasswordShort => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

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
  String get taxConfigTitle => 'الضريبة والفلترة الإلكترونية';

  @override
  String get zatcaPhase2Title =>
      'الفوترة الإلكترونية (المرحلة الثانية - زاتكا)';

  @override
  String get zatcaPhase2Description =>
      'تكوين الإعدادات الخاصة بك للامتثال للمرحلة الثانية من هيئة الزكاة والضريبة والجمارك السعودية.';

  @override
  String get enableTax => 'تمكين الضريبة على الفواتير';

  @override
  String get priceIncludesTax => 'السعر يشمل الضريبة افتراضياً';

  @override
  String get vatNumber => 'الرقم الضريبي';

  @override
  String get defaultTaxRate => 'قيمة الضريبة الافتراضية (%)';

  @override
  String get b2cSimplifiedLabel => 'تسمية فاتورة B2C المبسطة';

  @override
  String get b2bStandardLabel => 'تسمية فاتورة B2B القياسية';

  @override
  String get taxName => 'اسم الضريبة';

  @override
  String get taxPercentage => 'النسبة (%)';

  @override
  String get taxShow => 'إظهار';

  @override
  String get taxDefault => 'افتراضي';

  @override
  String get printSettingsTitle => 'الطباعة والقوالب';

  @override
  String get printSettingsSubtitle =>
      'إدارة تنسيقات الطباعة والقوالب الخاصة بك';

  @override
  String get templateSelection => 'اختيار القالب';

  @override
  String get paperSize => 'حجم الورق';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get paddingBottom => 'خطوط فارغة في النهاية';

  @override
  String get printCopies => 'عدد النسخ';

  @override
  String get printItemUnit => 'إظهار وحدة الصنف في الطباعة';

  @override
  String get saveSettings => 'حفظ الإعدادات';

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
  String get journalEntryFormTitleAdd => 'إضافة قيد يدوي';

  @override
  String get journalEntryFormTitleEdit => 'تعديل قيد يدوي';

  @override
  String get invoiceFormTitleAdd => 'إضافة فاتورة جديدة';

  @override
  String get invoiceFormTitleAddPurchase => 'إضافة فاتورة مشتريات';

  @override
  String get invoiceFormTitleEdit => 'تعديل الفاتورة';

  @override
  String invoiceTitle(String id) {
    return 'فاتورة رقم $id';
  }

  @override
  String get calculatorTitle => 'الحاسبة المالية';

  @override
  String get convertToCurrencies => 'التحويل للعملات';

  @override
  String get clear => 'مسح';

  @override
  String get labelTermsAndConditions => 'الشروط والأحكام';

  @override
  String get labelPaidDate => 'تاريخ الدفع';

  @override
  String get labelDiscountAmount => 'قيمة الخصم';

  @override
  String get labelZatcaQrCode => 'رمز الاستجابة السريعة (زاتكا)';

  @override
  String get labelZatcaUuid => 'المعرف الفريد (UUID)';

  @override
  String get labelZatcaHash => 'بصمة الفاتورة (Hash)';

  @override
  String get labelTaxTotal => 'إجمالي الضريبة';

  @override
  String get labelVatRate => 'نسبة الضريبة';

  @override
  String get zatcaComplianceText =>
      'هذه الفاتورة متوافقة مع متطلبات هيئة الزكاة والضريبة والجمارك';

  @override
  String get actionCreateFirstInvoice => 'إنشاء أول فاتورة';

  @override
  String get noInvoicesTitle => 'لا توجد فواتير';

  @override
  String get noInvoicesDescription =>
      'ابدأ بإضافة فاتورتك الأولى لإدارة مبيعاتك بشكل احترافي.';

  @override
  String get labelFromDate => 'من تاريخ';

  @override
  String get labelToDate => 'إلى تاريخ';

  @override
  String get labelAsOfDate => 'كما في تاريخ';

  @override
  String get tooltipUpdateReport => 'تحديث التقرير';

  @override
  String get labelCogsAccountId => 'حساب تكلفة البضاعة (COGS)';

  @override
  String get labelRevenueAccountId => 'حساب إيرادات المبيعات';

  @override
  String get labelValuationMethod => 'طريقة تقييم المخزون';

  @override
  String get labelInventoryValuation => 'تقييم المخزون (IAS 2)';

  @override
  String get logoutLabel => 'تسجيل الخروج';

  @override
  String msgInvoiceShare(String name, String id, String total, String symbol) {
    return 'مرحباً $name، إليك تفاصيل فاتورة رقم $id:\nالإجمالي: $total $symbol\nشكراً لتعاملك معنا.';
  }

  @override
  String msgSaveError(String error) {
    return 'خطأ في الحفظ: $error';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navInvoices => 'الفواتير';

  @override
  String get navSettings => 'الإعدادات';

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
  String get settingsTitle => 'الإعدادات';

  @override
  String get aboutAppTitle => 'حول التطبيق';

  @override
  String get aboutDescription =>
      'Basir app is a complete system for managing invoices and customers, designed specifically for small and medium businesses.';

  @override
  String get aboutFeature1 => '• Manage invoices easily';

  @override
  String get aboutFeature2 => '• Customer management';

  @override
  String get aboutFeature3 => '• Export invoices as PDF';

  @override
  String get aboutFeature4 => '• Secure data storage';

  @override
  String get aboutFeature5 => '• Full Arabic language support';

  @override
  String get aboutFeaturesTitle => 'الميزات الرئيسية:';

  @override
  String get titleAddInventoryItem => 'إضافة صنف جديد';

  @override
  String get titleEditInventoryItem => 'تعديل بيانات الصنف';

  @override
  String get vendorsScreenTitle => 'الموردون';

  @override
  String get vendorsSearchHint => 'ابحث عن مورد...';

  @override
  String get navVendors => 'الموردون';

  @override
  String get navInventory => 'المخزون';

  @override
  String get navAssets => 'الأصول الثابتة';

  @override
  String get labelNameAr => 'الاسم بالعربية';

  @override
  String get labelNameEn => 'الاسم بالإنجليزية';

  @override
  String get tooltipAddVendor => 'إضافة مورد جديد';

  @override
  String get tooltipEditVendor => 'تعديل المورد';

  @override
  String get tooltipDeleteVendor => 'حذف المورد';

  @override
  String msgConfirmDeleteVendor(String name) {
    return 'هل أنت متأكد من حذف المورد $name؟';
  }

  @override
  String msgConfirmDeleteItem(String name) {
    return 'هل أنت متأكد من حذف الصنف $name؟';
  }

  @override
  String get dialogDelete => 'حذف';

  @override
  String get inventoryItemsScreenTitle => 'المخزون';

  @override
  String get assetsScreenTitle => 'الأصول الثابتة';

  @override
  String get assetsSearchHint => 'ابحث في الأصول...';

  @override
  String get actionAddAsset => 'إضافة أصل';

  @override
  String get tooltipAddAsset => 'إضافة أصل جديد';

  @override
  String get titleAddAsset => 'إضافة أصل جديد';

  @override
  String get titleEditAsset => 'تعديل بيانات الأصل';

  @override
  String get labelCode => 'كود الأصل';

  @override
  String get labelPurchaseDate => 'تاريخ الشراء';

  @override
  String get labelCost => 'تكلفة الاقتناء';

  @override
  String get labelSalvageValue => 'القيمة المتبقية';

  @override
  String get labelUsefulLife => 'العمر الإنتاجي (سنوات)';

  @override
  String get labelDepreciationMethod => 'طريقة الإهلاك';

  @override
  String get labelDepreciationAccountId => 'حساب مصروف الإهلاك';

  @override
  String get labelAccumDepreciationAccountId => 'حساب مجمع الإهلاك';

  @override
  String get labelAssetAccountId => 'حساب المخزون (الأصول)';

  @override
  String get inventoryItemsSearchHint =>
      'ابحث بالاسم أو رمز الصنف أو الباركود...';

  @override
  String get inventoryEmptyHintTitle => 'إدارة المخزون';

  @override
  String get inventoryEmptyHintDescription =>
      'أضف أصناف المخزون هنا لتتبع الكميات والتكاليف بدقة. يمكنك البدء بإضافة صنف يدويًا.';

  @override
  String get labelSKU => 'رمز الصنف (SKU)';

  @override
  String get labelBarcode => 'الباركود';

  @override
  String get inventoryItemNameArRequired => 'أدخل اسم الصنف بالعربية.';

  @override
  String get inventoryItemNameEnRequired => 'أدخل اسم الصنف بالإنجليزية.';

  @override
  String get inventoryItemInvalidPrice =>
      'أدخل سعر شراء وبيع صحيحين غير سالبين.';

  @override
  String get inventoryItemQuantityMustUseMovement =>
      'يُحدّث رصيد الصنف من خلال حركات المخزون أو الجرد فقط.';

  @override
  String get inventoryItemDuplicateSku =>
      'رمز الصنف أو الباركود مستخدم لصنف آخر.';

  @override
  String get inventoryItemDuplicateBarcode => 'الباركود مستخدم لصنف آخر.';

  @override
  String get inventoryItemNotFound => 'تعذر العثور على الصنف المطلوب.';

  @override
  String get inventoryItemSaveFailed => 'تعذر حفظ بيانات الصنف. حاول مرة أخرى.';

  @override
  String get inventoryItemSaved => 'تم حفظ بيانات الصنف.';

  @override
  String get inventoryBarcodeSelectRequired =>
      'اختر صنفًا وأدخل الباركود أولًا.';

  @override
  String get inventoryBarcodeSaved => 'تم حفظ الباركود بنجاح.';

  @override
  String get inventoryBarcodeSaveFailed => 'تعذر حفظ الباركود. حاول مرة أخرى.';

  @override
  String get labelPurchasePrice => 'سعر الشراء';

  @override
  String get labelSalePrice => 'سعر البيع';

  @override
  String get labelUnit => 'الوحدة';

  @override
  String get labelCategoryId => 'الفئة';

  @override
  String get tooltipAddInventoryItem => 'إضافة صنف جديد';

  @override
  String get actionSharePdf => 'مشاركة ملف PDF';

  @override
  String get actionShareWhatsappPdf => 'إرسال عبر الواتساب (PDF)';

  @override
  String get actionShareWhatsappText => 'إرسال عبر الواتساب (نص)';

  @override
  String get actionShare => 'مشاركة';

  @override
  String get actionExportPdf => 'تصدير PDF';

  @override
  String get actionUpgradeAccount => 'ترقية الحساب';

  @override
  String get appColor => 'لون التطبيق';

  @override
  String get appCopyright => '© 2026 فريق وكلاء تطوير مشروع بصير';

  @override
  String get appName => 'بصير';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appearanceSettingsSubtitle =>
      'الوضع الليلي، الألوان، الخطوط، والأيقونات';

  @override
  String get appearanceSettingsTitle => 'إعدادات المظهر';

  @override
  String get btnAdd => 'إضافة';

  @override
  String get btnAddCustomer => 'إضافة العميل';

  @override
  String get btnCreateAccount => 'إنشاء حساب جديد';

  @override
  String get btnDelete => 'حذف';

  @override
  String get btnEdit => 'تعديل';

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
  String get dashboardWelcomeMessage => 'Welcome to your Insightful Dashboard';

  @override
  String get dialogAddItemTitle => 'إضافة بند';

  @override
  String get dialogCancel => 'إلغاء';

  @override
  String get dialogOk => 'حسناً';

  @override
  String get dialogCognitiveRejectionTitle => 'تم رفض العملية';

  @override
  String get dialogCognitiveRejectionMessage =>
      'تم رفض هذه العملية من قبل النظام المعرفي. راجع توافق الوكلاء أدناه:';

  @override
  String get dialogSave => 'حفظ';

  @override
  String get dialogTaxTitle => 'نسبة الضريبة';

  @override
  String get editAccountSubtitle => 'غيّر اسم المستخدم وكلمة المرور';

  @override
  String get editAccountTitle => 'تعديل بيانات الحساب';

  @override
  String get labelAddress => 'العنوان';

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
  String get labelLastUpdated => 'آخر تحديث';

  @override
  String get labelNewPassword => 'كلمة المرور الجديدة';

  @override
  String get labelNotes => 'ملاحظات (اختياري)';

  @override
  String get labelPassword => 'كلمة المرور';

  @override
  String get labelPercentage => 'النسبة المئوية';

  @override
  String get labelPhone => 'رقم الهاتف';

  @override
  String get labelSourceWarehouse => 'مستودع المصدر';

  @override
  String get labelDestinationWarehouse => 'مستودع الوجهة';

  @override
  String get errSameWarehouse =>
      'لا يمكن أن يكون مستودع المصدر والوجهة متطابقين';

  @override
  String get errSelectSourceWarehouse => 'يرجى اختيار المستودع المصدر';

  @override
  String get errSelectDestinationWarehouse => 'يرجى اختيار المستودع الوجهة';

  @override
  String get btnSaveTransfer => 'حفظ التحويل';

  @override
  String get warehouseTransferTitleAdd => 'تحويل مخزني جديد';

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
  String get msgSettingsSaved => 'تم حفظ الإعدادات بنجاح';

  @override
  String get navCustomers => 'العملاء';

  @override
  String get notificationsEnable => 'تفعيل الإشعارات';

  @override
  String get notificationsSubtitle => 'استقبل إشعارات الفواتير المتأخرة';

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
  String get statusRefunded => 'مرتجعة';

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

  @override
  String get msgResetConfirmation =>
      'سيتم إعادة جميع إعدادات المظهر للوضع الافتراضي. هل أنت متأكد؟';

  @override
  String get errorTitle => 'عذراً، حدث خطأ غير متوقع';

  @override
  String get errorDescription =>
      'نحن نعمل على إصلاح المشكلة حالياً. يرجى محاولة إعادة تشغيل التطبيق.';

  @override
  String get labelCurrencySAR => 'ر.س';

  @override
  String get labelAccounting => 'المحاسبة';

  @override
  String get labelChartOfAccounts => 'دليل الحسابات';

  @override
  String get financialSummaryTitle => 'ملخص مالي (تجريبي)';

  @override
  String get statAssets => 'الأصول';

  @override
  String get statLiabilities => 'الخصوم';

  @override
  String get statNetIncome => 'صافي الدخل';

  @override
  String get tooltipRefresh => 'تحديث';

  @override
  String get emptyAccountsMessage =>
      'لا توجد حسابات. اضغط تحديث لإنشاء الدليل الافتراضي.';

  @override
  String get errorLoadingAccounts => 'خطأ في تحميل الحسابات';

  @override
  String get labelBalance => 'الرصيد';

  @override
  String get labelTotal => 'الإجمالي';

  @override
  String get statusPosted => 'مرحل';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get emptyJournalEntriesMessage => 'لا توجد قيود مسجلة.';

  @override
  String get labelDebit => 'مدين';

  @override
  String get labelCredit => 'دائن';

  @override
  String get labelReference => 'المرجع / الرقم';

  @override
  String get msgColorPickerHint => 'اختر لوناً أساسياً مخصصاً للتطبيق';

  @override
  String get msgJournalEntryAdded => 'تم حفظ القيد المحاسبي بنجاح';

  @override
  String get errUnbalancedEntry =>
      'القيد غير متزن! يجب أن يتساوى المدين والدائن';

  @override
  String get btnSaveEntry => 'حفظ كمسودة';

  @override
  String get btnPostEntry => 'ترحيل القيد';

  @override
  String get msgJournalEntryPosted => 'تم ترحيل القيد بنجاح';

  @override
  String get msgJournalEntryDrafted => 'تم حفظ القيد كمسودة';

  @override
  String get hintJournalDescription => 'أدخل وصف العملية المالية';

  @override
  String get labelJournalEntryLines => 'بنود القيد';

  @override
  String get expenseDistributionTitle => 'توزيع المصروفات';

  @override
  String get noExpenseDataMessage => 'لا توجد بيانات مصروفات';

  @override
  String get otherExpensesLabel => 'مصروفات أخرى';

  @override
  String get trialBalanceTitle => 'ميزان المراجعة';

  @override
  String get btnExport => 'تصدير';

  @override
  String get labelAccount => 'الحساب';

  @override
  String get labelExportPdf => 'تصدير PDF';

  @override
  String get labelExportCsv => 'تصدير CSV (Excel)';

  @override
  String get cashFlowTitle => 'قائمة التدفقات النقدية';

  @override
  String get incomeStatementTitle => 'قائمة الدخل';

  @override
  String get balanceSheetTitle => 'الميزانية العمومية';

  @override
  String get labelOperating => 'العمليات التشغيلية';

  @override
  String get labelInvesting => 'العمليات الاستثمارية';

  @override
  String get labelFinancing => 'العمليات التمويلية';

  @override
  String get labelNetCashFlow => 'صافي التدفق النقدي';

  @override
  String get reportingOverviewTitle => 'التقارير المالية';

  @override
  String get trialBalanceSubtitle => 'تحقق من توازن الحسابات المدينة والدائنة';

  @override
  String get incomeStatementSubtitle => 'قائمة الدخل: الأداء المالي والربحية';

  @override
  String get balanceSheetSubtitle =>
      'المركز المالي: الأصول، الالتزامات، وحقوق الملكية';

  @override
  String get cashFlowSubtitle => 'حركة النقدية (تشغيلي، استثماري، تمويلي)';

  @override
  String get agingReportsSubtitle => 'تحليل أعمار ذمم العملاء والموردين';

  @override
  String get agingReportsTitle => 'تقارير تعمير الديون';

  @override
  String get receivablesAgingLabel => 'ذمم مدينة (عملاء)';

  @override
  String get payablesAgingLabel => 'ذمم دائنة (موردون)';

  @override
  String get noDataMessage => 'لا توجد بيانات';

  @override
  String get periodCurrent => 'الحالي';

  @override
  String get period1_30 => '1-30 يوم';

  @override
  String get period31_60 => '31-60 يوم';

  @override
  String get period61_90 => '61-90 يوم';

  @override
  String get periodOver90 => 'أكثر من 90 يوم';

  @override
  String get labelAssets => 'الأصول';

  @override
  String get labelLiabilities => 'الالتزامات';

  @override
  String get labelEquity => 'حقوق الملكية';

  @override
  String get labelTotalAssets => 'إجمالي الأصول';

  @override
  String get labelTotalLiabilitiesAndEquity =>
      'إجمالي الالتزامات وحقوق الملكية';

  @override
  String get msgBalanceBalanced =>
      'الميزانية متزنة: الأصول تساوي الالتزامات وحقوق الملكية.';

  @override
  String msgBalanceUnbalanced(String diff) {
    return 'تنبيه: الميزانية غير متزنة! الفرق: $diff';
  }

  @override
  String get treasuryTitle => 'الخزينة والنقدية';

  @override
  String get cashBalancesTitle => 'أرصدة النقدية والبنوك';

  @override
  String get recentVouchersTitle => 'أحدث السندات';

  @override
  String get receiptVoucherAction => 'سند قبض';

  @override
  String get paymentVoucherAction => 'سند صرف';

  @override
  String get newVoucherLabel => 'سند جديد';

  @override
  String get noVouchersMessage => 'لا توجد سندات مسجلة';

  @override
  String get anonymousPerson => 'بدون اسم';

  @override
  String get actionReverse => 'عكس القيد';

  @override
  String get actionEdit => 'تعديل';

  @override
  String get actionPostNow => 'ترحيل الآن';

  @override
  String get msgConfirmReverse =>
      'هل أنت متأكد من رغبتك في عكس هذا القيد؟ سيؤدي ذلك إلى إنشاء قيد عكسي تلقائي.';

  @override
  String get msgReverseSuccess => 'تم عكس القيد بنجاح';

  @override
  String get labelBalanced => 'متزن';

  @override
  String get labelUnbalanced => 'غير متزن';

  @override
  String get labelDiff => 'الفرق';

  @override
  String get voucherReceiptTitle => 'سند قبض جديد';

  @override
  String get voucherPaymentTitle => 'سند صرف جديد';

  @override
  String get btnSaveAndPostVoucher => 'حفظ السند وترحيله';

  @override
  String get errInvalidAmount => 'مبلغ غير صالح';

  @override
  String get errAmountRequired => 'يرجى إدخال المبلغ';

  @override
  String get errDescriptionRequired => 'يرجى إدخال الشرح';

  @override
  String get labelPaymentMethod => 'طريقة الدفع';

  @override
  String get methodCash => 'نقدي';

  @override
  String get methodBank => 'بنكي';

  @override
  String get methodCheck => 'شيك';

  @override
  String get labelTreasuryAccount => 'حساب الصندوق/البنك';

  @override
  String get labelSourceClient => 'العميل (مصدر السند)';

  @override
  String get labelBeneficiaryVendor => 'المورد (المستفيد)';

  @override
  String get msgVoucherSavedSuccess => 'تم حفظ السند وترحيله بنجاح';

  @override
  String get errFormFill => 'يرجى إكمال البيانات';

  @override
  String get labelAccountSelector => 'اختر الحساب';

  @override
  String get labelRequired => 'مطلوب';

  @override
  String get labelStatus => 'الحالة';

  @override
  String get labelDescription => 'الوصف';

  @override
  String get errorExportingReport => 'خطأ أثناء تصدير التقرير';

  @override
  String get labelAmount => 'المبلغ';

  @override
  String get labelDate => 'التاريخ';

  @override
  String get labelType => 'النوع';

  @override
  String get labelRevenue => 'الإيرادات';

  @override
  String get labelExpenses => 'المصروفات';

  @override
  String get labelIncomeTax => 'ضريبة الدخل';

  @override
  String get labelNetProfit => 'صافي الربح / الخساارة';

  @override
  String get msgOperationSuccess => 'تمت العملية بنجاح';

  @override
  String get aboutAppSubtitle => 'الإصدار 1.0.0';

  @override
  String get accountTitle => 'الحساب';

  @override
  String get actionAddCustomer => 'إضافة عميل';

  @override
  String get actionAddVendor => 'إضافة مورد';

  @override
  String get actionAddInventoryItem => 'إضافة صنف';

  @override
  String get actionAddInvoice => 'إضافة فاتورة';

  @override
  String get actionDeleteCustomer => 'حذف العميل';

  @override
  String get actionDeleteVendor => 'حذف المورد';

  @override
  String get actionDeleteInvoice => 'حذف الفاتورة';

  @override
  String get titleAddVendor => 'إضافة مورد جديد';

  @override
  String get titleEditVendor => 'تعديل بيانات المورد';

  @override
  String get invoicesTitle => 'الفواتير';

  @override
  String get privacyAnalyticsTitle => 'الخصوصية والتحليلات';

  @override
  String get privacyAnalyticsSubtitle =>
      'إدارة بيانات الاستخدام والخصوصية المحلية';

  @override
  String get analyticsEnableTracking => 'تفعيل التحليلات المحلية';

  @override
  String get analyticsPrivacyNotice =>
      'نحن نحترم خصوصيتك. جميع التحليلات تُخزن محلياً فقط على جهازك ولا نجمع أي بيانات شخصية أو مالية. تساعدنا هذه البيانات في تحسين تجربة المستخدم وفهم الميزات الأكثر استخداماً.';

  @override
  String get analyticsClearData => 'مسح بيانات التحليلات';

  @override
  String get analyticsDataCleared => 'تم مسح بيانات التحليلات بنجاح';

  @override
  String get lastSyncLabel => 'آخر مزامنة';

  @override
  String get msgNoActivity => 'لا يوجد نشاط حديث حتى الآن.';

  @override
  String get labelJournalEntries => 'القيود اليومية';

  @override
  String get labelExchangeRate => 'سعر الصرف';

  @override
  String get exchangeRate => 'Exchange Rate';

  @override
  String get labelBaseCurrencyEquivalent => 'المقابل بالعملة الأساسية';

  @override
  String get titleTreasuryVault => 'الخزنة (إدارة النقد)';

  @override
  String get labelTotalLiquidity => 'إجمالي السيولة';

  @override
  String get labelAvailableCashBank => 'إجمالي النقد والبنوك المتاح';

  @override
  String get labelAccounts => 'الحسابات';

  @override
  String get labelForecast30Days => 'نظرة مستقبلية (30 يوم)';

  @override
  String get labelExpectedInflow => 'التدفق الداخل المتوقع';

  @override
  String get labelExpectedOutflow => 'التدفق الخارج المتوقع';

  @override
  String get labelNetChange => 'التغير الصافي';

  @override
  String get msgNoCashAccounts => 'لا توجد حسابات نقدية';

  @override
  String get msgInitCoa => 'قم بتهيئة دليل الحسابات أو أضف حسابات نقدية.';

  @override
  String get originalAmount => 'Original Amount';

  @override
  String get labelInventoryItem => 'صنف من المخزون';

  @override
  String get hintSelectInventoryItem =>
      'اختر صنفاً من المخزون لملء البيانات تلقائياً';

  @override
  String get labelTaxCategory => 'فئة الضريبة';

  @override
  String get labelSearchSku => 'بحث بالباركود / SKU';

  @override
  String get hintSearchSku => 'أدخل الكود واضغط Enter';

  @override
  String get msgItemNotFound => 'الصنف غير موجود';

  @override
  String get tooltipPrintReceipt => 'طباعة إيصال';

  @override
  String get tooltipReverseInvoice => 'إلغاء/عكس';

  @override
  String get titleReverseInvoice => 'عكس الفاتورة';

  @override
  String get msgConfirmReverseInvoice =>
      'هل أنت متأكد من رغبتك في عكس هذه الفاتورة؟ سيتم إنشاء قيد عكسي في المحاسبة.';

  @override
  String get btnConfirmReverse => 'نعم، عكس الفاتورة';

  @override
  String get msgInvoiceReversed => 'تم عكس الفاتورة بنجاح';

  @override
  String get receiptTitleTaxInvoice => 'فاتورة ضريبية';

  @override
  String get receiptTitleSimplified => 'فاتورة ضريبية مبسطة';

  @override
  String get receiptFooterThanks => 'شكراً لزيارتكم';

  @override
  String get receiptFooterBrand => 'بصير - Basir Accounting';

  @override
  String get labelDiscount => 'الخصم';

  @override
  String get labelItemName => 'اسم الصنف';

  @override
  String get labelIssuedDate => 'تاريخ الإصدار';

  @override
  String get errPermissionDenied =>
      'You do not have permission to perform this action';

  @override
  String get agentRationaleStandardsPassed =>
      'تحقق الامتثال: القيد يوافق معايير (IFRS/SOCPA).';

  @override
  String agentRationaleStandardsManualReview(String type) {
    return 'تنبيه: نوع العملية ($type) يتطلب مراجعة بشرية للتحقق من الامتثال.';
  }

  @override
  String get agentRationaleTaxNoId =>
      'تنبيه: لم يتم تقديم رقم ضريبي لهذه العملية.';

  @override
  String get agentRationaleTaxZatcaReject =>
      'رفض: العمليات التي تتجاوز 10,000 ريال تتطلب رقماً ضريبياً صالحاً للامتثال للمرحلة الثانية من (ZATCA).';

  @override
  String agentRationaleTaxValidated(String id) {
    return 'تم التحقق من الرقم الضريبي: $id';
  }

  @override
  String agentRationaleTaxAnalyzing(String account) {
    return 'تحليل الضريبة لحساب $account';
  }

  @override
  String agentRationaleTaxRateMismatch(String rate) {
    return 'تنبيه: معدل الضريبة المحسوب ($rate) يختلف عن المعدل الإقليمي الافتراضي (15%).';
  }

  @override
  String get agentRationaleTaxRateMatch =>
      'تأكيد: معدل الضريبة (15%) يطابق المتطلبات التنظيمية المحلية.';

  @override
  String get agentRationaleTaxNoVatWarning =>
      'تنبيه: تم رصد عملية تجارية بدون بنود ضريبة القيمة المضافة.';

  @override
  String get agentRationaleForensicBalanced => 'فحص ناجح: القيد المحاسبي متزن.';

  @override
  String get agentRationaleForensicUnbalanced =>
      'رفض: القيد المحاسبي المقترح غير متزن.';

  @override
  String agentRationaleForensicHighValue(String amount) {
    return 'تنبيه: تم رصد مبلغ عملية مرتفع بشكل غير معتاد ($amount). نوصي بالمراجعة الإدارية.';
  }

  @override
  String agentRationaleForensicDuplicate(String ref) {
    return 'رفض: تم رصد رقم مرجع مكرر ($ref) في السجلات السابقة.';
  }

  @override
  String agentRationaleOperationalSufficient(String account, String balance) {
    return 'تحليل النقدية: رصيد $account كافٍ ($balance) للعملية.';
  }

  @override
  String agentRationaleOperationalInsufficient(String account, String balance) {
    return 'رفض: رصيد $account غير كافٍ ($balance) لهذه العملية.';
  }

  @override
  String agentRationaleStrategyOutflow(String amount) {
    return 'تحليل استراتيجي: يمثل هذا القيد تدفقاً نقدياً خارجاً بقيمة $amount.';
  }

  @override
  String get agentRationaleStrategyRecommendation =>
      'توصية: راجع توقعات التدفق النقدي للأسبوع القادم لضمان السيولة الكافية للالتزامات الأخرى.';

  @override
  String agentRationaleStrategyInflow(String amount) {
    return 'تحليل استراتيجي: تعزيز السيولة بقيمة $amount يدعم القدرة الاستثمارية قصيرة الأجل.';
  }

  @override
  String get agentRationaleStrategyProfitability =>
      'رؤية استراتيجية: زيادة حجم المبيعات تؤثر إيجابياً على العائد على الأصول (ROA) وأهداف الهامش الصافي.';

  @override
  String get agentRationaleSustainabilityFlagged =>
      'تحليل ISSB: تم وضع علامة على هذه المعاملة للإفصاح البيئي/الاجتماعي الإلزامي.';

  @override
  String get agentRationaleSustainabilityReject =>
      'رفض حرج: تتطلب معايير ISSB S2 مقاييس البصمة الكربونية لهذه المعاملة الخاصة بالصناعة.';

  @override
  String agentRationaleSustainabilitySuccess(int count) {
    return 'تم بنجاح دمج $count من مقاييس الاستدامة المتوافقة.';
  }

  @override
  String get agentRationaleSustainabilityNotRequired =>
      'تقييم الاستدامة: لا توجد إفصاحات محددة من ISSB مطلوبة لهذه الفئة من العمليات.';

  @override
  String agentRationaleForensicTimeAnomaly(String time) {
    return 'تحذير: تم تسجيل العملية في ساعات غير قياسية ($time). تم تطبيق وزن تدقيق جنائي أعلى.';
  }

  @override
  String agentRationaleForensicSequenceGap(String last, String current) {
    return 'ملاحظة: تم اكتشاف فجوة في تسلسل المراجع. الأخير: $last، الحالي: $current.';
  }

  @override
  String get agentRationaleForensicZatcaIdentityMissing =>
      'ملاحظة: الهوية التشفيرية لـ ZATCA (UUID/Hash) مفقودة لهذه الفاتورة.';

  @override
  String get auditTrailTitle => 'سجل المراجعة';

  @override
  String get auditTrailSubtitle => 'سجلات النظام الداخلية وتجاوزات الإجماع';

  @override
  String get auditTrailSectionForensic => 'سجلات النزاهة الجنائية';

  @override
  String get auditTrailNoLogs =>
      'لم يتم العثور على سجلات مراجعة للفترة المختارة.';

  @override
  String get msgInvoiceCognitiveHint =>
      'استخدم هذه الشاشة لإنشاء أو تعديل الفواتير. تأكد من الدقة المتناهية في معدلات الضرائب واختيار العناصر.';

  @override
  String get titleInvoiceCognitiveHint => 'إتقان الفواتير';

  @override
  String get labelReturnsAndDamages => 'المرتجعات والتوالف';

  @override
  String get labelSalesReturn => 'مرتجع مبيعات';

  @override
  String get descSalesReturn => 'إرجاع أصناف مباعة إلى المخزون';

  @override
  String get labelPurchaseReturn => 'مرتجع مشتريات';

  @override
  String get descPurchaseReturn => 'إرجاع أصناف مشتراة للمورد';

  @override
  String get labelDamageInvoice => 'فاتورة تالف';

  @override
  String get descDamageInvoice => 'تسجيل أصناف تالفة أو مفقودة';

  @override
  String get labelEmailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get labelPhoneOptional => 'رقم الهاتف (اختياري)';

  @override
  String get labelAddressOptional => 'العنوان (اختياري)';

  @override
  String get labelNotesOptional => 'ملاحظات (اختياري)';

  @override
  String msgConfirmDeleteCustomer(String name) {
    return 'هل أنت متأكد من حذف العميل $name؟';
  }

  @override
  String get msgConfirmDeleteInvoice => 'هل أنت متأكد من حذف هذه الفاتورة؟';

  @override
  String get dashboardBasirSystemTitle => 'نظام بصير المحاسبي';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get dashboardStatsTitle => 'الإحصائيات';

  @override
  String get dashboardQuickActionsTitle => 'الإجراءات السريعة';

  @override
  String get dashboardRecentActivityTitle => 'النشاط الأخير';

  @override
  String get dashboardMotto => 'المحاسبة الاحترافية بكل بساطة';

  @override
  String get saveLabels => 'حفظ التسميات';

  @override
  String get errInvalidResetLink =>
      'رابط إعادة التعيين غير صالح أو منتهي الصلاحية';

  @override
  String get errInvalidResetToken =>
      'رمز إعادة التعيين غير صالح أو منتهي الصلاحية';

  @override
  String get msgPasswordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح';

  @override
  String get errPasswordResetFailed => 'فشل في إعادة تعيين كلمة المرور';

  @override
  String get errPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get errPasswordTooShort => 'كلمة المرور قصيرة جداً';

  @override
  String get errPasswordNeedsUppercase => 'كلمة المرور تحتاج حرف كبير';

  @override
  String get errPasswordNeedsLowercase => 'كلمة المرور تحتاج حرف صغير';

  @override
  String get errPasswordNeedsNumber => 'كلمة المرور تحتاج رقم';

  @override
  String get errConfirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String resetPasswordSubtitle(String email) {
    return 'أدخل كلمة المرور الجديدة لـ $email';
  }

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get passwordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get passwordRequirements => 'متطلبات كلمة المرور:';

  @override
  String get passwordRequirementsList =>
      '• 8 أحرف على الأقل\n• حرف كبير واحد\n• حرف صغير واحد\n• رقم واحد';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get labelVatNumber => 'الرقم الضريبي';

  @override
  String get labelRegistrationNumber => 'رقم السجل التجاري';

  @override
  String get labelTotalPayables => 'إجمالي الالتزامات للموردين';

  @override
  String get msgValueCopiedToClipboard => 'تم نسخ القيمة إلى الحافظة';

  @override
  String get labelSourceDocument => 'المستند المصدر';

  @override
  String get btnViewSource => 'عرض المصدر';

  @override
  String get msgLoadingSource => 'جاري تحميل المستند المصدر...';

  @override
  String get errSourceNotFound => 'المستند المصدر غير موجود';

  @override
  String get agentSuggestionIfrs18Category => 'اقتراح تصنيف IFRS 18';

  @override
  String get agentSuggestionIfrs18CategoryReason =>
      'يتطلب المعيار الدولي للتقارير المالية 18 تصنيفاً محدداً لعمولات المبيعات.';

  @override
  String get agentSuggestionVatCorrection => 'تصحيح معدل الضريبة';

  @override
  String get agentSuggestionMissingVatLine => 'بند ضريبة مفقود';

  @override
  String get agentSuggestionMissingVatLineReason =>
      'تتطلب عمليات المبيعات عادةً ضريبة قيمة مضافة بنسبة 15% حسب متطلبات زاتكا.';

  @override
  String get agentSuggestionWarehouseOptimization => 'تحسين مستودعي';

  @override
  String get agentSuggestionWarehouseOptimizationReason =>
      'تحقق من \"المركز الرئيسي\" أو \"فرع الرياض\" لطلب تحويل مخزني.';

  @override
  String get agentSuggestionStrategicDiscount => 'خصم استراتيجي';

  @override
  String get agentSuggestionStrategicDiscountReason =>
      'قدم خصماً بنسبة 2% للسداد خلال 10 أيام لتعظيم السيولة النقدية.';

  @override
  String get agentSuggestionIssbMetrics => 'إفصاح ISSB';

  @override
  String get agentSuggestionIssbMetricsReason =>
      'يرجى إرفاق مقاييس استخدام الموارد (لتر/كيلوواط ساعة) للامتثال للمعايير.';

  @override
  String get labelAiSmartSuggestions => 'اقتراحات الذكاء الاصطناعي';

  @override
  String get labelTarget => 'المستهدف:';

  @override
  String get msgForensicSequenceClean =>
      'اكتمل التحقق من التسلسل: لم يتم الكشف عن أي حالات شاذة.';

  @override
  String get msgForensicRisksDetected => 'كشف التحليل الجنائي عن مخاطر مؤسسية.';

  @override
  String get msgForensicEngineError =>
      'فشل الفحص الجنائي: خطأ في المحرك الداخلي.';

  @override
  String get msgForensicLedgerClean =>
      'اكتمل فحص السجل التاريخي: لم يتم العثور على حالات شاذة.';

  @override
  String get msgForensicLedgerAnomalies =>
      'تم الكشف عن حالات جنائية شاذة في السجل التاريخي.';

  @override
  String errForensicImbalance(Object id) {
    return 'تم اكتشاف عدم اتزان: القيد رقم $id غير متزن.';
  }

  @override
  String errForensicDiscrepancy(Object id) {
    return 'تفاوت في السلامة: يوجد تعارض في إجمالي المدين/المجموع للقيد رقم $id.';
  }

  @override
  String errForensicHashBreach(Object curr, Object prev) {
    return 'خرق للسلامة: سلسلة التجزئة (Hash) مكسورة بين القيد رقم $prev والقيد رقم $curr';
  }

  @override
  String get titleForensicPortal => 'بوابة النزاهة الجنائية';

  @override
  String get labelIntegrityPulse => 'نبض النزاهة';

  @override
  String get labelLastVerified => 'آخر تحقق:';

  @override
  String get labelBlocksScanned => 'الكتل المفحوصة:';

  @override
  String get labelHealth => 'الصحة:';

  @override
  String get labelLedgerMutationTimeline => 'جدول زمن طفرات السجل';

  @override
  String get labelHashChain => 'سلسلة التجزئة غير القابلة للتغيير';

  @override
  String get labelVerifiedBy => 'تم التحقق بواسطة:';

  @override
  String get titleStrategicOutlook => 'التوقعات الاستراتيجية والتنبؤ';

  @override
  String get labelPredictivePnL => 'تحليل الأرباح والخسائر التوقعي';

  @override
  String get labelCashFlowProjection => 'توقعات التدفق النقدي';

  @override
  String get labelStrategicInsights => 'رؤى الذكاء الاصطناعي الاستراتيجية';

  @override
  String get labelProjectedRevenue => 'الإيرادات المتوقعة';

  @override
  String get labelProjectedExpense => 'المصروفات المتوقعة';

  @override
  String get labelProjectedNetIncome => 'صافي الدخل المتوقع';

  @override
  String get labelConfidenceScore => 'درجة ثقة الذكاء الاصطناعي';

  @override
  String get msgNoStrategicData =>
      'بيانات تاريخية غير كافية للتنبؤ الدقيق. يرجى ترحيل المزيد من المعاملات.';

  @override
  String get actionEmailInvoice => 'إرسال الفاتورة بالبريد';

  @override
  String get searchInvoicesHint => 'ابحث في الفواتير أو العملاء أو الأرقام';

  @override
  String get searchInvoicesLabel => 'البحث في الفواتير';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortLabel => 'ترتيب';

  @override
  String get sortNewest => 'الأحدث أولًا';

  @override
  String get sortOldest => 'الأقدم أولًا';

  @override
  String get sortAmountDesc => 'الأعلى مبلغًا';

  @override
  String get sortAmountAsc => 'الأدنى مبلغًا';

  @override
  String get sortCustomer => 'اسم العميل';

  @override
  String get sortDueDateAsc => 'تاريخ الاستحقاق (الأقرب)';

  @override
  String get filterCancelled => 'ملغاة';

  @override
  String get noSearchResults => 'لا توجد فواتير تطابق بحثك';

  @override
  String resultsCount(String count) {
    return '$count نتيجة';
  }

  @override
  String get resultsCountZero => 'لا توجد نتائج';

  @override
  String get searchTooltip => 'بحث';

  @override
  String get sortTooltip => 'ترتيب الفواتير';

  @override
  String get clearSearchTooltip => 'مسح البحث';

  @override
  String get shellSearchAll => 'البحث الشامل';

  @override
  String get shellSearchHint => 'ابحث في الفواتير والعملاء والأصناف...';

  @override
  String get shellToggleNav => 'طي/فتح شريط التنقل';

  @override
  String get shellOrgLabel => 'المؤسسة';

  @override
  String get shellBranchLabel => 'الفرع';

  @override
  String get shellPeriodLabel => 'الفترة';

  @override
  String get shellCurrentOrg => 'المؤسسة الافتراضية';

  @override
  String get shellCurrentBranch => 'الفرع الرئيسي';

  @override
  String get shellCurrentPeriod => 'الفترة المالية الحالية';

  @override
  String get shellNotifications => 'الإشعارات';

  @override
  String get shellSearchResults => 'نتائج البحث';

  @override
  String get shellNoResults => 'لا توجد نتائج';

  @override
  String get navReports => 'التقارير';

  @override
  String get shellCloseSearch => 'إغلاق البحث';

  @override
  String get workStatusDraft => 'مسودة';

  @override
  String get workStatusPendingApproval => 'بانتظار الاعتماد';

  @override
  String get workStatusApproved => 'معتمدة';

  @override
  String get workStatusPosted => 'مرحّلة';

  @override
  String get workStatusCancelled => 'ملغاة';

  @override
  String get workStatusReversed => 'معكوسة';

  @override
  String get workAuditTitle => 'سجل التدقيق';

  @override
  String get workAuditEmpty => 'لا توجد أحداث للتدقيق.';

  @override
  String workAuditLinkedDoc(Object arg0) {
    return 'الوثيقة المرتبطة: $arg0';
  }

  @override
  String workAuditOpenLinked(Object arg0) {
    return 'فتح الوثيقة المرتبطة $arg0';
  }

  @override
  String get workAuditEventCreated => 'إنشاء';

  @override
  String get workAuditEventModified => 'تعديل';

  @override
  String get workAuditEventApproved => 'اعتماد';

  @override
  String get workAuditEventReturned => 'إرجاع للمراجعة';

  @override
  String get workAuditEventPosted => 'ترحيل';

  @override
  String get workAuditEventCancelled => 'إلغاء';

  @override
  String get workAuditEventReversed => 'عكس';

  @override
  String get workAuditEventAdministrative => 'إجراء إداري';

  @override
  String get workGridEmpty => 'لا توجد سجلات.';

  @override
  String workGridSortableColumn(Object arg0) {
    return '‎$arg0، عمود قابل للفرز';
  }

  @override
  String get workFilterSearchHint => 'ابحث في الوثائق والعملاء والأصناف...';

  @override
  String get workFilterExport => 'تصدير';

  @override
  String get workFilterCollapse => 'طي الفلاتر';

  @override
  String get workGridSelect => 'تحديد';

  @override
  String get workGridRow => 'صف الجدول';

  @override
  String get workDocumentSummary => 'ملخص المستند';

  @override
  String get workDocumentRequestPreview => 'طلب المعاينة';

  @override
  String get workDocumentPreviewImpact => 'معاينة الأثر';

  @override
  String get workDocumentSaveDraft => 'حفظ كمسودة';

  @override
  String get workDocumentPost => 'تأكيد الترحيل';

  @override
  String get workDocumentPreviewRequired => 'اطلب معاينة الأثر قبل الترحيل.';

  @override
  String get workDocumentApprovalRequired => 'يتطلب اعتمادًا إضافيًا';

  @override
  String get workDocumentNoImpact => 'لا توجد حركات متوقعة.';

  @override
  String get workEntityPickerNoOptions => 'لا توجد خيارات متاحة';

  @override
  String get workEntityPickerDisabled => 'غير مؤهل للاختيار';
  @override
  String get msgPasswordResetRequested =>
      'إذا كان الحساب موجودًا، فسيتم إرسال رابط استعادة إلى البريد المسجل.';
  @override
  String get msgPasswordResetFailed =>
      'تعذر تنفيذ طلب الاستعادة حاليًا. حاول مرة أخرى لاحقًا.';
}
