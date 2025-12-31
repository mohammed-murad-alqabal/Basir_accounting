import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// اسم التطبيق الرئيسي
  ///
  /// In ar, this message translates to:
  /// **'بصير'**
  String get appTitle;

  /// عنوان شاشة الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// عنوان قسم إعدادات الشركة
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الشركة والفواتير'**
  String get companySettingsTitle;

  /// عنوان قسم الحساب
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get accountTitle;

  /// عنوان قسم الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsTitle;

  /// عنوان قسم المظهر
  ///
  /// In ar, this message translates to:
  /// **'المظهر والتخصيص'**
  String get appearanceTitle;

  /// عنوان قسم المساعدة
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get helpTitle;

  /// نص زر تسجيل الخروج
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutLabel;

  /// No description provided for @editAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات الحساب'**
  String get editAccountTitle;

  /// No description provided for @editAccountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غيّر اسم المستخدم وكلمة المرور'**
  String get editAccountSubtitle;

  /// No description provided for @notificationsEnable.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get notificationsEnable;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استقبل إشعارات الفواتير المتأخرة'**
  String get notificationsSubtitle;

  /// No description provided for @appearanceSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المظهر'**
  String get appearanceSettingsTitle;

  /// No description provided for @appearanceSettingsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي، الألوان، الخطوط، والأيقونات'**
  String get appearanceSettingsSubtitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار 1.0.0'**
  String get aboutAppSubtitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ سياسة الخصوصية الخاصة بنا'**
  String get privacyPolicySubtitle;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'شروط الخدمة'**
  String get termsOfServiceTitle;

  /// No description provided for @termsOfServiceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ شروط الخدمة الخاصة بنا'**
  String get termsOfServiceSubtitle;

  /// No description provided for @dialogCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get dialogCancel;

  /// No description provided for @dialogSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get dialogSave;

  /// No description provided for @dialogOk.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get dialogOk;

  /// No description provided for @companySettingsDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الشركة والفواتير'**
  String get companySettingsDialogTitle;

  /// No description provided for @labelCompanyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الشركة'**
  String get labelCompanyName;

  /// No description provided for @hintCompanyName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم شركتك'**
  String get hintCompanyName;

  /// No description provided for @labelTaxNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الضريبي'**
  String get labelTaxNumber;

  /// No description provided for @hintTaxNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرقم الضريبي (اختياري)'**
  String get hintTaxNumber;

  /// No description provided for @labelTaxRateWithExample.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الضريبة (مثال: 0.15)'**
  String get labelTaxRateWithExample;

  /// No description provided for @labelCurrencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة'**
  String get labelCurrencySymbol;

  /// No description provided for @hintCurrencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'ر.س'**
  String get hintCurrencySymbol;

  /// No description provided for @labelCountryCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الدولة'**
  String get labelCountryCode;

  /// No description provided for @labelInvoiceStyle.
  ///
  /// In ar, this message translates to:
  /// **'شكل الفاتورة'**
  String get labelInvoiceStyle;

  /// No description provided for @styleStandard.
  ///
  /// In ar, this message translates to:
  /// **'قياسي'**
  String get styleStandard;

  /// No description provided for @styleModern.
  ///
  /// In ar, this message translates to:
  /// **'عصري'**
  String get styleModern;

  /// No description provided for @styleCompact.
  ///
  /// In ar, this message translates to:
  /// **'مختصر'**
  String get styleCompact;

  /// No description provided for @msgSettingsSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الإعدادات بنجاح'**
  String get msgSettingsSaved;

  /// No description provided for @msgSaveError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الحفظ: {error}'**
  String msgSaveError(String error);

  /// No description provided for @errorLoadingSettings.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الإعدادات'**
  String get errorLoadingSettings;

  /// No description provided for @retryLabel.
  ///
  /// In ar, this message translates to:
  /// **'انقر لإعادة المحاولة'**
  String get retryLabel;

  /// No description provided for @sectionMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع'**
  String get sectionMode;

  /// No description provided for @modeSystem.
  ///
  /// In ar, this message translates to:
  /// **'النظام'**
  String get modeSystem;

  /// No description provided for @modeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get modeLight;

  /// No description provided for @modeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get modeDark;

  /// No description provided for @sectionStyle.
  ///
  /// In ar, this message translates to:
  /// **'النمط'**
  String get sectionStyle;

  /// No description provided for @appColor.
  ///
  /// In ar, this message translates to:
  /// **'لون التطبيق'**
  String get appColor;

  /// No description provided for @colorDefault.
  ///
  /// In ar, this message translates to:
  /// **'اللون الافتراضي'**
  String get colorDefault;

  /// No description provided for @colorCustomized.
  ///
  /// In ar, this message translates to:
  /// **'تم تخصيص اللون'**
  String get colorCustomized;

  /// No description provided for @sectionAccessibility.
  ///
  /// In ar, this message translates to:
  /// **'إمكانية الوصول'**
  String get sectionAccessibility;

  /// No description provided for @highContrast.
  ///
  /// In ar, this message translates to:
  /// **'تباين عالي'**
  String get highContrast;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'زيادة وضوح النصوص والعناصر'**
  String get highContrastSubtitle;

  /// No description provided for @reduceMotion.
  ///
  /// In ar, this message translates to:
  /// **'تقليل الحركة'**
  String get reduceMotion;

  /// No description provided for @reduceMotionSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تقليل تأثيرات الحركة والانتقالات'**
  String get reduceMotionSubtitle;

  /// No description provided for @sectionCalendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم'**
  String get sectionCalendar;

  /// No description provided for @calendarGregorian.
  ///
  /// In ar, this message translates to:
  /// **'ميلادي (Gregorian)'**
  String get calendarGregorian;

  /// No description provided for @calendarHijri.
  ///
  /// In ar, this message translates to:
  /// **'هجري (Hijri)'**
  String get calendarHijri;

  /// No description provided for @calendarSelection.
  ///
  /// In ar, this message translates to:
  /// **'اختر التقويم المفضل لعرض ومعالجة التواريخ'**
  String get calendarSelection;

  /// No description provided for @invoicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get invoicesTitle;

  /// No description provided for @tooltipAddInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فاتورة'**
  String get tooltipAddInvoice;

  /// No description provided for @tooltipExportAll.
  ///
  /// In ar, this message translates to:
  /// **'تصدير الكل'**
  String get tooltipExportAll;

  /// No description provided for @statTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get statTotal;

  /// No description provided for @statPaid.
  ///
  /// In ar, this message translates to:
  /// **'المدفوعة'**
  String get statPaid;

  /// No description provided for @statOverdue.
  ///
  /// In ar, this message translates to:
  /// **'المتأخرة'**
  String get statOverdue;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get filterDraft;

  /// No description provided for @filterIssued.
  ///
  /// In ar, this message translates to:
  /// **'مُصدرة'**
  String get filterIssued;

  /// No description provided for @filterPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة'**
  String get filterPaid;

  /// No description provided for @filterOverdue.
  ///
  /// In ar, this message translates to:
  /// **'مستحقة'**
  String get filterOverdue;

  /// No description provided for @errorLoadingInvoices.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل الفواتير'**
  String get errorLoadingInvoices;

  /// No description provided for @invoiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {id}'**
  String invoiceTitle(String id);

  /// No description provided for @actionSharePdf.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة ملف PDF'**
  String get actionSharePdf;

  /// No description provided for @actionShareWhatsappText.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عبر الواتساب (نص)'**
  String get actionShareWhatsappText;

  /// No description provided for @actionShareWhatsappPdf.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عبر الواتساب (PDF)'**
  String get actionShareWhatsappPdf;

  /// No description provided for @actionDeleteInvoice.
  ///
  /// In ar, this message translates to:
  /// **'حذف الفاتورة'**
  String get actionDeleteInvoice;

  /// No description provided for @msgConfirmDeleteInvoice.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذه الفاتورة؟'**
  String get msgConfirmDeleteInvoice;

  /// No description provided for @btnDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get btnDelete;

  /// No description provided for @errorCustomerNotFound.
  ///
  /// In ar, this message translates to:
  /// **'تعذر العثور على بيانات العميل'**
  String get errorCustomerNotFound;

  /// No description provided for @errorSharePdf.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في مشاركة PDF: {error}'**
  String errorSharePdf(String error);

  /// No description provided for @errorCustomerPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف العميل غير متوفر'**
  String get errorCustomerPhone;

  /// No description provided for @errorShareWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في المشاركة عبر الواتساب: {error}'**
  String errorShareWhatsapp(String error);

  /// No description provided for @msgInvoiceShare.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً {name}، إليك تفاصيل فاتورة رقم {id}:\nالإجمالي: {total} {symbol}\nشكراً لتعاملك معنا.'**
  String msgInvoiceShare(String name, String id, String total, String symbol);

  /// No description provided for @invoiceFormTitleAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فاتورة جديدة'**
  String get invoiceFormTitleAdd;

  /// No description provided for @invoiceFormTitleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الفاتورة'**
  String get invoiceFormTitleEdit;

  /// No description provided for @labelCustomer.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get labelCustomer;

  /// No description provided for @hintSelectCustomer.
  ///
  /// In ar, this message translates to:
  /// **'اختر العميل'**
  String get hintSelectCustomer;

  /// No description provided for @errSelectCustomer.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار العميل'**
  String get errSelectCustomer;

  /// No description provided for @errLoadCustomers.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل العملاء: {error}'**
  String errLoadCustomers(String error);

  /// No description provided for @labelIssuedDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإصدار'**
  String get labelIssuedDate;

  /// No description provided for @labelDueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستحقاق'**
  String get labelDueDate;

  /// No description provided for @labelTaxRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الضريبة'**
  String get labelTaxRate;

  /// No description provided for @tooltipEditTaxRate.
  ///
  /// In ar, this message translates to:
  /// **'تعديل نسبة الضريبة'**
  String get tooltipEditTaxRate;

  /// No description provided for @labelInvoiceStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الفاتورة'**
  String get labelInvoiceStatus;

  /// No description provided for @statusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get statusCancelled;

  /// No description provided for @labelInvoiceItems.
  ///
  /// In ar, this message translates to:
  /// **'بنود الفاتورة'**
  String get labelInvoiceItems;

  /// No description provided for @tooltipAddItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند جديد'**
  String get tooltipAddItem;

  /// No description provided for @msgNoItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بنود. اضغط + لإضافة بند'**
  String get msgNoItems;

  /// No description provided for @labelQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get labelQuantity;

  /// No description provided for @tooltipDeleteItem.
  ///
  /// In ar, this message translates to:
  /// **'حذف البند'**
  String get tooltipDeleteItem;

  /// No description provided for @labelSubtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الفرعي:'**
  String get labelSubtotal;

  /// No description provided for @labelTax.
  ///
  /// In ar, this message translates to:
  /// **'الضريبة ({rate}):'**
  String labelTax(String rate);

  /// No description provided for @labelGrandTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي الكلي:'**
  String get labelGrandTotal;

  /// No description provided for @labelNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get labelNotes;

  /// No description provided for @hintNotes.
  ///
  /// In ar, this message translates to:
  /// **'أضف ملاحظات عن الفاتورة'**
  String get hintNotes;

  /// No description provided for @btnSaveInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة الفاتورة'**
  String get btnSaveInvoice;

  /// No description provided for @btnUpdateInvoice.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get btnUpdateInvoice;

  /// No description provided for @dialogTaxTitle.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الضريبة'**
  String get dialogTaxTitle;

  /// No description provided for @labelPercentage.
  ///
  /// In ar, this message translates to:
  /// **'النسبة المئوية'**
  String get labelPercentage;

  /// No description provided for @dialogAddItemTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند'**
  String get dialogAddItemTitle;

  /// No description provided for @labelItemName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج/الخدمة'**
  String get labelItemName;

  /// No description provided for @labelPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get labelPrice;

  /// No description provided for @btnAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get btnAdd;

  /// No description provided for @btnSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get btnSave;

  /// No description provided for @errNoItems.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إضافة بند واحد على الأقل'**
  String get errNoItems;

  /// No description provided for @msgInvoiceAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة الفاتورة بنجاح'**
  String get msgInvoiceAdded;

  /// No description provided for @msgInvoiceUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الفاتورة بنجاح'**
  String get msgInvoiceUpdated;

  /// No description provided for @errInvoiceAdd.
  ///
  /// In ar, this message translates to:
  /// **'فشل إضافة الفاتورة'**
  String get errInvoiceAdd;

  /// No description provided for @errInvoiceUpdate.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحديث الفاتورة'**
  String get errInvoiceUpdate;

  /// No description provided for @errGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ: {error}'**
  String errGeneric(String error);

  /// No description provided for @customersScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get customersScreenTitle;

  /// No description provided for @customersAddTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عميل جديد'**
  String get customersAddTooltip;

  /// No description provided for @customersSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن عميل...'**
  String get customersSearchHint;

  /// No description provided for @customerFormTitleAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عميل جديد'**
  String get customerFormTitleAdd;

  /// No description provided for @customerFormTitleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العميل'**
  String get customerFormTitleEdit;

  /// No description provided for @btnSelectFromContacts.
  ///
  /// In ar, this message translates to:
  /// **'اختيار من جهات الاتصال'**
  String get btnSelectFromContacts;

  /// No description provided for @labelCustomerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل'**
  String get labelCustomerName;

  /// No description provided for @hintCustomerName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم العميل'**
  String get hintCustomerName;

  /// No description provided for @errCustomerNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل مطلوب'**
  String get errCustomerNameRequired;

  /// No description provided for @errCustomerNameLength.
  ///
  /// In ar, this message translates to:
  /// **'الاسم يجب أن يحتوي على حرفين على الأقل'**
  String get errCustomerNameLength;

  /// No description provided for @labelEmailOptional.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني (اختياري)'**
  String get labelEmailOptional;

  /// No description provided for @errInvalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صحيح'**
  String get errInvalidEmail;

  /// No description provided for @errLoginFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل الدخول. يرجى التحقق من البيانات.'**
  String get errLoginFailed;

  /// No description provided for @labelPhoneOptional.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف (اختياري)'**
  String get labelPhoneOptional;

  /// No description provided for @errPhoneStart05.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب أن يبدأ بـ 05'**
  String get errPhoneStart05;

  /// No description provided for @errPhoneLength.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب أن يتكون من 10 أرقام'**
  String get errPhoneLength;

  /// No description provided for @labelAddressOptional.
  ///
  /// In ar, this message translates to:
  /// **'العنوان (اختياري)'**
  String get labelAddressOptional;

  /// No description provided for @hintAddress.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عنوان العميل'**
  String get hintAddress;

  /// No description provided for @labelNotesOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get labelNotesOptional;

  /// No description provided for @hintCustomerNotes.
  ///
  /// In ar, this message translates to:
  /// **'أضف ملاحظات عن العميل'**
  String get hintCustomerNotes;

  /// No description provided for @labelCreditLimit.
  ///
  /// In ar, this message translates to:
  /// **'سقف الائتمان (اختياري)'**
  String get labelCreditLimit;

  /// No description provided for @errInvalidNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم صحيح'**
  String get errInvalidNumber;

  /// No description provided for @btnAddCustomer.
  ///
  /// In ar, this message translates to:
  /// **'إضافة العميل'**
  String get btnAddCustomer;

  /// No description provided for @btnSaveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get btnSaveChanges;

  /// No description provided for @msgNoContactsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جهات اتصال متاحة'**
  String get msgNoContactsFound;

  /// No description provided for @errContactAccess.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الوصول لجهات الاتصال: {error}'**
  String errContactAccess(String error);

  /// No description provided for @msgCustomerUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث بيانات العميل بنجاح'**
  String get msgCustomerUpdated;

  /// No description provided for @msgCustomerAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة العميل بنجاح'**
  String get msgCustomerAdded;

  /// No description provided for @errCustomerUpdate.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحديث بيانات العميل'**
  String get errCustomerUpdate;

  /// No description provided for @errCustomerAdd.
  ///
  /// In ar, this message translates to:
  /// **'فشل إضافة العميل'**
  String get errCustomerAdd;

  /// No description provided for @dashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboardTitle;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navInvoices.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get navInvoices;

  /// No description provided for @navCustomers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get navCustomers;

  /// No description provided for @navSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get navSettings;

  /// No description provided for @dashboardStatsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحليلات الأداء المالي'**
  String get dashboardStatsTitle;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإجراءات المالية السريعة'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardRecentActivityTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل العمليات الأحدث'**
  String get dashboardRecentActivityTitle;

  /// No description provided for @statTotalInvoices.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الفواتير'**
  String get statTotalInvoices;

  /// No description provided for @statActiveCustomers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء النشطون'**
  String get statActiveCustomers;

  /// No description provided for @statTotalSales.
  ///
  /// In ar, this message translates to:
  /// **'المبيعات الكلية'**
  String get statTotalSales;

  /// No description provided for @statOverdueInvoices.
  ///
  /// In ar, this message translates to:
  /// **'فواتير متأخرة'**
  String get statOverdueInvoices;

  /// No description provided for @actionAddInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فاتورة'**
  String get actionAddInvoice;

  /// No description provided for @actionAddCustomer.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عميل'**
  String get actionAddCustomer;

  /// No description provided for @labelInvoiceNo.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم'**
  String get labelInvoiceNo;

  /// No description provided for @statusPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة'**
  String get statusPaid;

  /// No description provided for @statusPending.
  ///
  /// In ar, this message translates to:
  /// **'قيد الانتظار'**
  String get statusPending;

  /// No description provided for @statusOverdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get statusOverdue;

  /// No description provided for @tooltipBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get tooltipBack;

  /// No description provided for @actionDeleteCustomer.
  ///
  /// In ar, this message translates to:
  /// **'حذف العميل'**
  String get actionDeleteCustomer;

  /// No description provided for @msgConfirmDeleteCustomer.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف العميل {name}؟'**
  String msgConfirmDeleteCustomer(String name);

  /// No description provided for @msgCustomerDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف العميل بنجاح'**
  String get msgCustomerDeleted;

  /// No description provided for @errCustomerDelete.
  ///
  /// In ar, this message translates to:
  /// **'فشل حذف العميل'**
  String get errCustomerDelete;

  /// No description provided for @customerDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل العميل'**
  String get customerDetailsTitle;

  /// No description provided for @tooltipEditCustomer.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العميل'**
  String get tooltipEditCustomer;

  /// No description provided for @sectionContactInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الاتصال'**
  String get sectionContactInfo;

  /// No description provided for @labelEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get labelEmail;

  /// No description provided for @labelPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get labelPhone;

  /// No description provided for @labelAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get labelAddress;

  /// No description provided for @sectionAdditionalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية'**
  String get sectionAdditionalInfo;

  /// No description provided for @labelCreatedDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإضافة'**
  String get labelCreatedDate;

  /// No description provided for @labelLastUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث'**
  String get labelLastUpdated;

  /// No description provided for @labelUsername.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get labelUsername;

  /// No description provided for @hintEnterNewUsername.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المستخدم الجديد'**
  String get hintEnterNewUsername;

  /// No description provided for @labelNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get labelNewPassword;

  /// No description provided for @hintEnterNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الجديدة'**
  String get hintEnterNewPassword;

  /// No description provided for @msgAccountUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث بيانات الحساب بنجاح'**
  String get msgAccountUpdated;

  /// No description provided for @msgConfirmLogout.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في تسجيل الخروج؟'**
  String get msgConfirmLogout;

  /// No description provided for @msgLogoutSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الخروج بنجاح'**
  String get msgLogoutSuccess;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك مجدداً! سجل دخولك للمتابعة'**
  String get loginSubtitle;

  /// No description provided for @labelPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get labelPassword;

  /// No description provided for @hintEnterUsername.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال اسم المستخدم'**
  String get hintEnterUsername;

  /// No description provided for @hintEnterPassword.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة المرور'**
  String get hintEnterPassword;

  /// No description provided for @errEmptyField.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get errEmptyField;

  /// No description provided for @labelRememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get labelRememberMe;

  /// No description provided for @loginGuest.
  ///
  /// In ar, this message translates to:
  /// **'الدخول كضيف'**
  String get loginGuest;

  /// No description provided for @msgGuestWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك كضيف! يمكنك إنشاء حساب لاحقاً'**
  String get msgGuestWelcome;

  /// No description provided for @msgNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'لا تملك حساباً؟'**
  String get msgNoAccount;

  /// No description provided for @btnCreateAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get btnCreateAccount;

  /// No description provided for @msgLoginSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح'**
  String get msgLoginSuccess;

  /// No description provided for @msgAccountCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح'**
  String get msgAccountCreated;

  /// No description provided for @errUsernameShort.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم يجب أن يكون 3 أحرف على الأقل'**
  String get errUsernameShort;

  /// No description provided for @errPasswordShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 6 أحرف على الأقل'**
  String get errPasswordShort;

  /// No description provided for @labelConfirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get labelConfirmPassword;

  /// No description provided for @hintConfirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'أعد إدخال كلمة المرور'**
  String get hintConfirmPassword;

  /// No description provided for @errPasswordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get errPasswordsDoNotMatch;

  /// No description provided for @setupTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك للبدء في إدارة فواتيرك'**
  String get setupSubtitle;

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'بصير'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In ar, this message translates to:
  /// **'1.0.0'**
  String get appVersion;

  /// No description provided for @appCopyright.
  ///
  /// In ar, this message translates to:
  /// **'© 2025 فريق وكلاء تطوير مشروع بصير'**
  String get appCopyright;

  /// No description provided for @aboutDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق بصير هو نظام متكامل لإدارة الفواتير والعملاء، مصمم خصيصاً للأعمال الصغيرة والمتوسطة.'**
  String get aboutDescription;

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الميزات الرئيسية:'**
  String get aboutFeaturesTitle;

  /// No description provided for @aboutFeature1.
  ///
  /// In ar, this message translates to:
  /// **'• إدارة الفواتير بسهولة'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In ar, this message translates to:
  /// **'• إدارة العملاء'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In ar, this message translates to:
  /// **'• تصدير الفواتير كـ PDF'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In ar, this message translates to:
  /// **'• تخزين آمن للبيانات'**
  String get aboutFeature4;

  /// No description provided for @aboutFeature5.
  ///
  /// In ar, this message translates to:
  /// **'• دعم كامل للغة العربية'**
  String get aboutFeature5;

  /// No description provided for @privacyHeader.
  ///
  /// In ar, this message translates to:
  /// **'نحن نحترم خصوصيتك'**
  String get privacyHeader;

  /// No description provided for @privacyPoint1.
  ///
  /// In ar, this message translates to:
  /// **'1. جميع بياناتك محفوظة محلياً على جهازك'**
  String get privacyPoint1;

  /// No description provided for @privacyPoint2.
  ///
  /// In ar, this message translates to:
  /// **'2. لا نقوم بجمع أو مشاركة أي معلومات شخصية'**
  String get privacyPoint2;

  /// No description provided for @privacyPoint3.
  ///
  /// In ar, this message translates to:
  /// **'3. بياناتك مشفرة وآمنة'**
  String get privacyPoint3;

  /// No description provided for @privacyPoint4.
  ///
  /// In ar, this message translates to:
  /// **'4. لا نستخدم خدمات تتبع أو تحليلات خارجية'**
  String get privacyPoint4;

  /// No description provided for @privacyPoint5.
  ///
  /// In ar, this message translates to:
  /// **'5. أنت المالك الوحيد لبياناتك'**
  String get privacyPoint5;

  /// No description provided for @privacyFooter.
  ///
  /// In ar, this message translates to:
  /// **'للمزيد من المعلومات، يرجى زيارة موقعنا الإلكتروني.'**
  String get privacyFooter;

  /// No description provided for @termsHeader.
  ///
  /// In ar, this message translates to:
  /// **'شروط استخدام تطبيق بصير'**
  String get termsHeader;

  /// No description provided for @termsPoint1.
  ///
  /// In ar, this message translates to:
  /// **'1. التطبيق مجاني للاستخدام الشخصي والتجاري'**
  String get termsPoint1;

  /// No description provided for @termsPoint2.
  ///
  /// In ar, this message translates to:
  /// **'2. أنت مسؤول عن دقة البيانات المدخلة'**
  String get termsPoint2;

  /// No description provided for @termsPoint3.
  ///
  /// In ar, this message translates to:
  /// **'3. يجب عليك الاحتفاظ بنسخة احتياطية من بياناتك'**
  String get termsPoint3;

  /// No description provided for @termsPoint4.
  ///
  /// In ar, this message translates to:
  /// **'4. التطبيق يُقدم كما هو بدون ضمانات'**
  String get termsPoint4;

  /// No description provided for @termsPoint5.
  ///
  /// In ar, this message translates to:
  /// **'5. نحن غير مسؤولين عن أي خسائر ناتجة عن استخدام التطبيق'**
  String get termsPoint5;

  /// No description provided for @termsFooter.
  ///
  /// In ar, this message translates to:
  /// **'باستخدامك للتطبيق، فإنك توافق على هذه الشروط.'**
  String get termsFooter;

  /// No description provided for @langArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @langEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @themeColorPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر لون التطبيق'**
  String get themeColorPickerTitle;

  /// No description provided for @btnRestoreDefault.
  ///
  /// In ar, this message translates to:
  /// **'استعادة الافتراضي'**
  String get btnRestoreDefault;

  /// No description provided for @btnDone.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get btnDone;

  /// No description provided for @fontSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نوع الخط'**
  String get fontSettingsTitle;

  /// No description provided for @fontCairo.
  ///
  /// In ar, this message translates to:
  /// **'Cairo (الافتراضي)'**
  String get fontCairo;

  /// No description provided for @fontRoboto.
  ///
  /// In ar, this message translates to:
  /// **'Roboto'**
  String get fontRoboto;

  /// No description provided for @fontSizeLabel.
  ///
  /// In ar, this message translates to:
  /// **'حجم النص'**
  String get fontSizeLabel;

  /// No description provided for @iconSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نمط الأيقونات'**
  String get iconSettingsTitle;

  /// No description provided for @iconMaterial.
  ///
  /// In ar, this message translates to:
  /// **'Material Design'**
  String get iconMaterial;

  /// No description provided for @iconCupertino.
  ///
  /// In ar, this message translates to:
  /// **'Cupertino (iOS)'**
  String get iconCupertino;

  /// No description provided for @splashInitializing.
  ///
  /// In ar, this message translates to:
  /// **'جاري التهيئة...'**
  String get splashInitializing;

  /// No description provided for @splashCriticalError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ تقني في البداية'**
  String get splashCriticalError;

  /// No description provided for @placeholderComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريبًا: {title}'**
  String placeholderComingSoon(String title);

  /// No description provided for @errorScreenNotFound.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة غير موجودة: {name}'**
  String errorScreenNotFound(String name);

  /// No description provided for @dashboardMasterySystemTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام بصير المطور'**
  String get dashboardMasterySystemTitle;

  /// No description provided for @dashboardWelcomeMessage.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في فضاء الإتقان'**
  String get dashboardWelcomeMessage;

  /// No description provided for @dashboardMotto.
  ///
  /// In ar, this message translates to:
  /// **'بصير يراقب نمو أعمالك بدقة (Φ)'**
  String get dashboardMotto;

  /// No description provided for @pdfShareSubject.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة {id}'**
  String pdfShareSubject(String id);

  /// No description provided for @pdfShareText.
  ///
  /// In ar, this message translates to:
  /// **'إليك فاتورة {customerName}'**
  String pdfShareText(String customerName);

  /// No description provided for @actionUpgradeAccount.
  ///
  /// In ar, this message translates to:
  /// **'ترقية الحساب'**
  String get actionUpgradeAccount;

  /// No description provided for @guestUpgradeDescription.
  ///
  /// In ar, this message translates to:
  /// **'قم بتحويل حساب الضيف الخاص بك إلى حساب دائم لحفظ بياناتك بشكل آمن.'**
  String get guestUpgradeDescription;

  /// No description provided for @msgAccountUpgraded.
  ///
  /// In ar, this message translates to:
  /// **'تم ترقية الحساب بنجاح'**
  String get msgAccountUpgraded;

  /// No description provided for @testButtonsTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختبار الأزرار'**
  String get testButtonsTitle;

  /// No description provided for @testEnhancedButtonsTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختبار الأزرار المحسّنة'**
  String get testEnhancedButtonsTitle;

  /// No description provided for @tooltipAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة {text}'**
  String tooltipAdd(String text);

  /// No description provided for @tooltipSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التغييرات'**
  String get tooltipSave;

  /// No description provided for @tooltipCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء العملية'**
  String get tooltipCancel;

  /// No description provided for @tooltipDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف العنصر'**
  String get tooltipDelete;

  /// No description provided for @tooltipEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العنصر'**
  String get tooltipEdit;

  /// No description provided for @tooltipSearch.
  ///
  /// In ar, this message translates to:
  /// **'البحث في القائمة'**
  String get tooltipSearch;

  /// No description provided for @btnRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get btnRetry;

  /// No description provided for @labelHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get labelHome;

  /// No description provided for @labelSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get labelSettings;

  /// No description provided for @labelProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف'**
  String get labelProfile;

  /// No description provided for @labelNotifications.
  ///
  /// In ar, this message translates to:
  /// **'تنبيهات'**
  String get labelNotifications;

  /// No description provided for @labelPrimary.
  ///
  /// In ar, this message translates to:
  /// **'أساسي'**
  String get labelPrimary;

  /// No description provided for @labelSecondary.
  ///
  /// In ar, this message translates to:
  /// **'ثانوي'**
  String get labelSecondary;

  /// No description provided for @labelTestText.
  ///
  /// In ar, this message translates to:
  /// **'تجربة النص'**
  String get labelTestText;

  /// No description provided for @pdfInvoiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {invoiceId}'**
  String pdfInvoiceTitle(String invoiceId);

  /// No description provided for @sectionPrimaryButtons.
  ///
  /// In ar, this message translates to:
  /// **'أزرار Primary'**
  String get sectionPrimaryButtons;

  /// No description provided for @sectionSecondaryButtons.
  ///
  /// In ar, this message translates to:
  /// **'أزرار Secondary'**
  String get sectionSecondaryButtons;

  /// No description provided for @sectionTextButtons.
  ///
  /// In ar, this message translates to:
  /// **'أزرار Text'**
  String get sectionTextButtons;

  /// No description provided for @sectionRowButtons.
  ///
  /// In ar, this message translates to:
  /// **'أزرار في Row'**
  String get sectionRowButtons;

  /// No description provided for @sectionSpecialCases.
  ///
  /// In ar, this message translates to:
  /// **'حالات خاصة'**
  String get sectionSpecialCases;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
