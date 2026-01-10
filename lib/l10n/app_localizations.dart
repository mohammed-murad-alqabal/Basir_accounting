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

  /// No description provided for @labelTermsAndConditions.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get labelTermsAndConditions;

  /// No description provided for @labelPaidDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الدفع'**
  String get labelPaidDate;

  /// No description provided for @labelDiscountAmount.
  ///
  /// In ar, this message translates to:
  /// **'قيمة الخصم'**
  String get labelDiscountAmount;

  /// No description provided for @labelZatcaQrCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز الاستجابة السريعة (ZATCA)'**
  String get labelZatcaQrCode;

  /// No description provided for @zatcaComplianceText.
  ///
  /// In ar, this message translates to:
  /// **'هذه الفاتورة متوافقة مع متطلبات هيئة الزكاة والضريبة والجمارك'**
  String get zatcaComplianceText;

  /// No description provided for @actionCreateFirstInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء أول فاتورة'**
  String get actionCreateFirstInvoice;

  /// No description provided for @noInvoicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد فواتير'**
  String get noInvoicesTitle;

  /// No description provided for @noInvoicesDescription.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بإضافة فاتورتك الأولى لإدارة مبيعاتك بشكل احترافي.'**
  String get noInvoicesDescription;

  /// No description provided for @journalEntryFormTitleAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة قيد يدوي'**
  String get journalEntryFormTitleAdd;

  /// No description provided for @journalEntryFormTitleEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل قيد يدوي'**
  String get journalEntryFormTitleEdit;

  /// No description provided for @labelCogsAccountId.
  ///
  /// In ar, this message translates to:
  /// **'حساب تكلفة البضاعة (COGS)'**
  String get labelCogsAccountId;

  /// No description provided for @labelRevenueAccountId.
  ///
  /// In ar, this message translates to:
  /// **'حساب إيرادات المبيعات'**
  String get labelRevenueAccountId;

  /// No description provided for @labelValuationMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة تقييم المخزون'**
  String get labelValuationMethod;

  /// No description provided for @labelInventoryValuation.
  ///
  /// In ar, this message translates to:
  /// **'تقييم المخزون (IAS 2)'**
  String get labelInventoryValuation;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار 1.0.0'**
  String get aboutAppSubtitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In ar, this message translates to:
  /// **'حول التطبيق'**
  String get aboutAppTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق بصير هو نظام متكامل لإدارة الفواتير والعملاء، مصمم خصيصاً للأعمال الصغيرة والمتوسطة.'**
  String get aboutDescription;

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

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الميزات الرئيسية:'**
  String get aboutFeaturesTitle;

  /// عنوان قسم الحساب
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get accountTitle;

  /// No description provided for @actionAddCustomer.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عميل'**
  String get actionAddCustomer;

  /// No description provided for @actionAddVendor.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مورد'**
  String get actionAddVendor;

  /// No description provided for @actionAddInventoryItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف'**
  String get actionAddInventoryItem;

  /// No description provided for @actionAddInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فاتورة'**
  String get actionAddInvoice;

  /// No description provided for @actionDeleteCustomer.
  ///
  /// In ar, this message translates to:
  /// **'حذف العميل'**
  String get actionDeleteCustomer;

  /// No description provided for @actionDeleteVendor.
  ///
  /// In ar, this message translates to:
  /// **'حذف المورد'**
  String get actionDeleteVendor;

  /// No description provided for @actionDeleteInvoice.
  ///
  /// In ar, this message translates to:
  /// **'حذف الفاتورة'**
  String get actionDeleteInvoice;

  /// No description provided for @titleAddVendor.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مورد جديد'**
  String get titleAddVendor;

  /// No description provided for @titleEditVendor.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات المورد'**
  String get titleEditVendor;

  /// No description provided for @titleAddInventoryItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف جديد'**
  String get titleAddInventoryItem;

  /// No description provided for @titleEditInventoryItem.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات الصنف'**
  String get titleEditInventoryItem;

  /// No description provided for @assetsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الأصول الثابتة'**
  String get assetsScreenTitle;

  /// No description provided for @assetsSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في الأصول...'**
  String get assetsSearchHint;

  /// No description provided for @actionAddAsset.
  ///
  /// In ar, this message translates to:
  /// **'إضافة أصل'**
  String get actionAddAsset;

  /// No description provided for @tooltipAddAsset.
  ///
  /// In ar, this message translates to:
  /// **'إضافة أصل جديد'**
  String get tooltipAddAsset;

  /// No description provided for @titleAddAsset.
  ///
  /// In ar, this message translates to:
  /// **'إضافة أصل جديد'**
  String get titleAddAsset;

  /// No description provided for @titleEditAsset.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات الأصل'**
  String get titleEditAsset;

  /// No description provided for @vendorsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموردون'**
  String get vendorsScreenTitle;

  /// No description provided for @vendorsSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مورد...'**
  String get vendorsSearchHint;

  /// No description provided for @navVendors.
  ///
  /// In ar, this message translates to:
  /// **'الموردون'**
  String get navVendors;

  /// No description provided for @navInventory.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get navInventory;

  /// No description provided for @navAssets.
  ///
  /// In ar, this message translates to:
  /// **'الأصول الثابتة'**
  String get navAssets;

  /// No description provided for @labelNameAr.
  ///
  /// In ar, this message translates to:
  /// **'الاسم بالعربية'**
  String get labelNameAr;

  /// No description provided for @labelNameEn.
  ///
  /// In ar, this message translates to:
  /// **'الاسم بالإنجليزية'**
  String get labelNameEn;

  /// No description provided for @tooltipAddVendor.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مورد جديد'**
  String get tooltipAddVendor;

  /// No description provided for @msgConfirmDeleteVendor.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف المورد {name}؟'**
  String msgConfirmDeleteVendor(String name);

  /// No description provided for @msgConfirmDeleteItem.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف الصنف {name}؟'**
  String msgConfirmDeleteItem(String name);

  /// No description provided for @dialogDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get dialogDelete;

  /// No description provided for @inventoryItemsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'المخزون'**
  String get inventoryItemsScreenTitle;

  /// No description provided for @inventoryItemsSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في المخزون...'**
  String get inventoryItemsSearchHint;

  /// No description provided for @labelSKU.
  ///
  /// In ar, this message translates to:
  /// **'رمز الصنف (SKU)'**
  String get labelSKU;

  /// No description provided for @labelPurchasePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر الشراء'**
  String get labelPurchasePrice;

  /// No description provided for @labelSalePrice.
  ///
  /// In ar, this message translates to:
  /// **'سعر البيع'**
  String get labelSalePrice;

  /// No description provided for @labelCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الأصل'**
  String get labelCode;

  /// No description provided for @labelPurchaseDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الشراء'**
  String get labelPurchaseDate;

  /// No description provided for @labelCost.
  ///
  /// In ar, this message translates to:
  /// **'تكلفة الاقتناء'**
  String get labelCost;

  /// No description provided for @labelSalvageValue.
  ///
  /// In ar, this message translates to:
  /// **'القيمة المتبقية'**
  String get labelSalvageValue;

  /// No description provided for @labelUsefulLife.
  ///
  /// In ar, this message translates to:
  /// **'العمر الإنتاجي (سنوات)'**
  String get labelUsefulLife;

  /// No description provided for @labelDepreciationMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الإهلاك'**
  String get labelDepreciationMethod;

  /// No description provided for @labelDepreciationAccountId.
  ///
  /// In ar, this message translates to:
  /// **'حساب مصروف الإهلاك'**
  String get labelDepreciationAccountId;

  /// No description provided for @labelAccumDepreciationAccountId.
  ///
  /// In ar, this message translates to:
  /// **'حساب مجمع الإهلاك'**
  String get labelAccumDepreciationAccountId;

  /// No description provided for @labelAssetAccountId.
  ///
  /// In ar, this message translates to:
  /// **'حساب المخزون (الأصول)'**
  String get labelAssetAccountId;

  /// No description provided for @labelUnit.
  ///
  /// In ar, this message translates to:
  /// **'الوحدة'**
  String get labelUnit;

  /// No description provided for @labelCategoryId.
  ///
  /// In ar, this message translates to:
  /// **'الفئة'**
  String get labelCategoryId;

  /// No description provided for @tooltipAddInventoryItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صنف جديد'**
  String get tooltipAddInventoryItem;

  /// No description provided for @actionSharePdf.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة ملف PDF'**
  String get actionSharePdf;

  /// No description provided for @actionShareWhatsappPdf.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عبر الواتساب (PDF)'**
  String get actionShareWhatsappPdf;

  /// No description provided for @actionShareWhatsappText.
  ///
  /// In ar, this message translates to:
  /// **'إرسال عبر الواتساب (نص)'**
  String get actionShareWhatsappText;

  /// No description provided for @actionShare.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get actionShare;

  /// No description provided for @actionExportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get actionExportPdf;

  /// No description provided for @actionUpgradeAccount.
  ///
  /// In ar, this message translates to:
  /// **'ترقية الحساب'**
  String get actionUpgradeAccount;

  /// No description provided for @appColor.
  ///
  /// In ar, this message translates to:
  /// **'لون التطبيق'**
  String get appColor;

  /// No description provided for @appCopyright.
  ///
  /// In ar, this message translates to:
  /// **'© 2026 فريق وكلاء تطوير مشروع بصير'**
  String get appCopyright;

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'بصير'**
  String get appName;

  /// اسم التطبيق الرئيسي
  ///
  /// In ar, this message translates to:
  /// **'بصير'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In ar, this message translates to:
  /// **'1.0.0'**
  String get appVersion;

  /// No description provided for @appearanceSettingsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الليلي، الألوان، الخطوط، والأيقونات'**
  String get appearanceSettingsSubtitle;

  /// No description provided for @appearanceSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات المظهر'**
  String get appearanceSettingsTitle;

  /// عنوان قسم المظهر
  ///
  /// In ar, this message translates to:
  /// **'المظهر والتخصيص'**
  String get appearanceTitle;

  /// No description provided for @btnAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get btnAdd;

  /// No description provided for @btnAddCustomer.
  ///
  /// In ar, this message translates to:
  /// **'إضافة العميل'**
  String get btnAddCustomer;

  /// No description provided for @btnCreateAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get btnCreateAccount;

  /// No description provided for @btnDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get btnDelete;

  /// No description provided for @btnEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get btnEdit;

  /// No description provided for @btnDone.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get btnDone;

  /// No description provided for @btnRestoreDefault.
  ///
  /// In ar, this message translates to:
  /// **'استعادة الافتراضي'**
  String get btnRestoreDefault;

  /// No description provided for @btnSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get btnSave;

  /// No description provided for @btnSaveChanges.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get btnSaveChanges;

  /// No description provided for @btnSaveInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة الفاتورة'**
  String get btnSaveInvoice;

  /// No description provided for @btnSelectFromContacts.
  ///
  /// In ar, this message translates to:
  /// **'اختيار من جهات الاتصال'**
  String get btnSelectFromContacts;

  /// No description provided for @btnUpdateInvoice.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get btnUpdateInvoice;

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

  /// No description provided for @colorCustomized.
  ///
  /// In ar, this message translates to:
  /// **'تم تخصيص اللون'**
  String get colorCustomized;

  /// No description provided for @colorDefault.
  ///
  /// In ar, this message translates to:
  /// **'اللون الافتراضي'**
  String get colorDefault;

  /// No description provided for @companySettingsDialogTitle.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الشركة والفواتير'**
  String get companySettingsDialogTitle;

  /// عنوان قسم إعدادات الشركة
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الشركة والفواتير'**
  String get companySettingsTitle;

  /// No description provided for @customerDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل العميل'**
  String get customerDetailsTitle;

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

  /// No description provided for @customersAddTooltip.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عميل جديد'**
  String get customersAddTooltip;

  /// No description provided for @customersScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get customersScreenTitle;

  /// No description provided for @customersSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن عميل...'**
  String get customersSearchHint;

  /// No description provided for @customersTitle.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get customersTitle;

  /// No description provided for @dashboardBasirSystemTitle.
  ///
  /// In ar, this message translates to:
  /// **'نظام بصير المحاسبي'**
  String get dashboardBasirSystemTitle;

  /// No description provided for @dashboardMotto.
  ///
  /// In ar, this message translates to:
  /// **'دقة وموثوقية في كل معاملة'**
  String get dashboardMotto;

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

  /// No description provided for @dashboardStatsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تحليلات الأداء المالي'**
  String get dashboardStatsTitle;

  /// No description provided for @dashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحة التحكم'**
  String get dashboardTitle;

  /// No description provided for @dashboardWelcomeMessage.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك في بصير'**
  String get dashboardWelcomeMessage;

  /// No description provided for @dialogAddItemTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند'**
  String get dialogAddItemTitle;

  /// No description provided for @dialogCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get dialogCancel;

  /// No description provided for @dialogOk.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get dialogOk;

  /// No description provided for @dialogSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get dialogSave;

  /// No description provided for @dialogTaxTitle.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الضريبة'**
  String get dialogTaxTitle;

  /// No description provided for @editAccountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'غيّر اسم المستخدم وكلمة المرور'**
  String get editAccountSubtitle;

  /// No description provided for @editAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل بيانات الحساب'**
  String get editAccountTitle;

  /// No description provided for @errContactAccess.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الوصول لجهات الاتصال: {error}'**
  String errContactAccess(String error);

  /// No description provided for @errCustomerAdd.
  ///
  /// In ar, this message translates to:
  /// **'فشل إضافة العميل'**
  String get errCustomerAdd;

  /// No description provided for @errCustomerDelete.
  ///
  /// In ar, this message translates to:
  /// **'فشل حذف العميل'**
  String get errCustomerDelete;

  /// No description provided for @errCustomerNameLength.
  ///
  /// In ar, this message translates to:
  /// **'الاسم يجب أن يحتوي على حرفين على الأقل'**
  String get errCustomerNameLength;

  /// No description provided for @errCustomerNameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل مطلوب'**
  String get errCustomerNameRequired;

  /// No description provided for @errCustomerUpdate.
  ///
  /// In ar, this message translates to:
  /// **'فشل تحديث بيانات العميل'**
  String get errCustomerUpdate;

  /// No description provided for @errEmptyField.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get errEmptyField;

  /// No description provided for @errGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ: {error}'**
  String errGeneric(String error);

  /// No description provided for @errInvalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني غير صحيح'**
  String get errInvalidEmail;

  /// No description provided for @errInvalidNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال رقم صحيح'**
  String get errInvalidNumber;

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

  /// No description provided for @errLoadCustomers.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل العملاء: {error}'**
  String errLoadCustomers(String error);

  /// No description provided for @errLoginFailed.
  ///
  /// In ar, this message translates to:
  /// **'فشل تسجيل الدخول. يرجى التحقق من البيانات.'**
  String get errLoginFailed;

  /// No description provided for @errNoItems.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إضافة بند واحد على الأقل'**
  String get errNoItems;

  /// No description provided for @errPasswordShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور يجب أن تكون 6 أحرف على الأقل'**
  String get errPasswordShort;

  /// No description provided for @errPasswordsDoNotMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمات المرور غير متطابقة'**
  String get errPasswordsDoNotMatch;

  /// No description provided for @errPhoneLength.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب أن يتكون من 10 أرقام'**
  String get errPhoneLength;

  /// No description provided for @errPhoneStart05.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف يجب أن يبدأ بـ 05'**
  String get errPhoneStart05;

  /// No description provided for @errSelectCustomer.
  ///
  /// In ar, this message translates to:
  /// **'يرجى اختيار العميل'**
  String get errSelectCustomer;

  /// No description provided for @errUsernameShort.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم يجب أن يكون 3 أحرف على الأقل'**
  String get errUsernameShort;

  /// No description provided for @errorCustomerNotFound.
  ///
  /// In ar, this message translates to:
  /// **'تعذر العثور على بيانات العميل'**
  String get errorCustomerNotFound;

  /// No description provided for @errorCustomerPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف العميل غير متوفر'**
  String get errorCustomerPhone;

  /// No description provided for @errorLoadingInvoices.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل الفواتير'**
  String get errorLoadingInvoices;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الإعدادات'**
  String get errorLoadingSettings;

  /// No description provided for @errorScreenNotFound.
  ///
  /// In ar, this message translates to:
  /// **'الشاشة غير موجودة: {name}'**
  String errorScreenNotFound(String name);

  /// No description provided for @errorSharePdf.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في مشاركة PDF: {error}'**
  String errorSharePdf(String error);

  /// No description provided for @errorShareWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في المشاركة عبر الواتساب: {error}'**
  String errorShareWhatsapp(String error);

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

  /// No description provided for @filterOverdue.
  ///
  /// In ar, this message translates to:
  /// **'مستحقة'**
  String get filterOverdue;

  /// No description provided for @filterPaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوعة'**
  String get filterPaid;

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

  /// No description provided for @fontSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نوع الخط'**
  String get fontSettingsTitle;

  /// No description provided for @fontSizeLabel.
  ///
  /// In ar, this message translates to:
  /// **'حجم النص'**
  String get fontSizeLabel;

  /// No description provided for @guestUpgradeDescription.
  ///
  /// In ar, this message translates to:
  /// **'قم بتحويل حساب الضيف الخاص بك إلى حساب دائم لحفظ بياناتك بشكل آمن.'**
  String get guestUpgradeDescription;

  /// عنوان قسم المساعدة
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get helpTitle;

  /// No description provided for @highContrast.
  ///
  /// In ar, this message translates to:
  /// **'تباين عالي'**
  String get highContrast;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'زيادة ووضوح النصوص والعناصر'**
  String get highContrastSubtitle;

  /// No description provided for @hintAddress.
  ///
  /// In ar, this message translates to:
  /// **'أدخل عنوان العميل'**
  String get hintAddress;

  /// No description provided for @hintCompanyName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم شركتك'**
  String get hintCompanyName;

  /// No description provided for @hintConfirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'أعد إدخال كلمة المرور'**
  String get hintConfirmPassword;

  /// No description provided for @hintCurrencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'ر.س'**
  String get hintCurrencySymbol;

  /// No description provided for @hintCustomerName.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم العميل'**
  String get hintCustomerName;

  /// No description provided for @hintCustomerNotes.
  ///
  /// In ar, this message translates to:
  /// **'أضف ملاحظات عن العميل'**
  String get hintCustomerNotes;

  /// No description provided for @hintEnterNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور الجديدة'**
  String get hintEnterNewPassword;

  /// No description provided for @hintEnterNewUsername.
  ///
  /// In ar, this message translates to:
  /// **'أدخل اسم المستخدم الجديد'**
  String get hintEnterNewUsername;

  /// No description provided for @hintEnterPassword.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة المرور'**
  String get hintEnterPassword;

  /// No description provided for @hintEnterUsername.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال اسم المستخدم'**
  String get hintEnterUsername;

  /// No description provided for @hintNotes.
  ///
  /// In ar, this message translates to:
  /// **'أضف ملاحظات عن الفاتورة'**
  String get hintNotes;

  /// No description provided for @hintSelectCustomer.
  ///
  /// In ar, this message translates to:
  /// **'اختر العميل'**
  String get hintSelectCustomer;

  /// No description provided for @hintTaxNumber.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرقم الضريبي (اختياري)'**
  String get hintTaxNumber;

  /// No description provided for @iconCupertino.
  ///
  /// In ar, this message translates to:
  /// **'Cupertino (iOS)'**
  String get iconCupertino;

  /// No description provided for @iconMaterial.
  ///
  /// In ar, this message translates to:
  /// **'Material Design'**
  String get iconMaterial;

  /// No description provided for @iconSettingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نمط الأيقونات'**
  String get iconSettingsTitle;

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

  /// No description provided for @invoiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {id}'**
  String invoiceTitle(String id);

  /// No description provided for @invoicesTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفواتير'**
  String get invoicesTitle;

  /// No description provided for @labelAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get labelAddress;

  /// No description provided for @labelAddressOptional.
  ///
  /// In ar, this message translates to:
  /// **'العنوان (اختياري)'**
  String get labelAddressOptional;

  /// No description provided for @labelCompanyName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الشركة'**
  String get labelCompanyName;

  /// No description provided for @labelConfirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get labelConfirmPassword;

  /// No description provided for @labelCountryCode.
  ///
  /// In ar, this message translates to:
  /// **'كود الدولة'**
  String get labelCountryCode;

  /// No description provided for @labelCreatedDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإضافة'**
  String get labelCreatedDate;

  /// No description provided for @labelCreditLimit.
  ///
  /// In ar, this message translates to:
  /// **'سقف الائتمان (اختياري)'**
  String get labelCreditLimit;

  /// No description provided for @labelCurrencySymbol.
  ///
  /// In ar, this message translates to:
  /// **'رمز العملة'**
  String get labelCurrencySymbol;

  /// No description provided for @labelCustomer.
  ///
  /// In ar, this message translates to:
  /// **'العميل'**
  String get labelCustomer;

  /// No description provided for @labelCustomerName.
  ///
  /// In ar, this message translates to:
  /// **'اسم العميل'**
  String get labelCustomerName;

  /// No description provided for @labelDueDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الاستحقاق'**
  String get labelDueDate;

  /// No description provided for @labelEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get labelEmail;

  /// No description provided for @labelEmailOptional.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني (اختياري)'**
  String get labelEmailOptional;

  /// No description provided for @labelGrandTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي الكلي:'**
  String get labelGrandTotal;

  /// No description provided for @labelInvoiceItems.
  ///
  /// In ar, this message translates to:
  /// **'بنود الفاتورة'**
  String get labelInvoiceItems;

  /// No description provided for @labelInvoiceNo.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم'**
  String get labelInvoiceNo;

  /// No description provided for @labelInvoiceStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الفاتورة'**
  String get labelInvoiceStatus;

  /// No description provided for @labelInvoiceStyle.
  ///
  /// In ar, this message translates to:
  /// **'شكل الفاتورة'**
  String get labelInvoiceStyle;

  /// No description provided for @labelIssuedDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإصدار'**
  String get labelIssuedDate;

  /// No description provided for @labelItemName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج/الخدمة'**
  String get labelItemName;

  /// No description provided for @labelLastUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث'**
  String get labelLastUpdated;

  /// No description provided for @labelNewPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور الجديدة'**
  String get labelNewPassword;

  /// No description provided for @labelNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get labelNotes;

  /// No description provided for @labelNotesOptional.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات (اختياري)'**
  String get labelNotesOptional;

  /// No description provided for @labelPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get labelPassword;

  /// No description provided for @labelPercentage.
  ///
  /// In ar, this message translates to:
  /// **'النسبة المئوية'**
  String get labelPercentage;

  /// No description provided for @labelPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get labelPhone;

  /// No description provided for @labelPhoneOptional.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف (اختياري)'**
  String get labelPhoneOptional;

  /// No description provided for @labelPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر'**
  String get labelPrice;

  /// No description provided for @labelQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get labelQuantity;

  /// No description provided for @labelRememberMe.
  ///
  /// In ar, this message translates to:
  /// **'تذكرني'**
  String get labelRememberMe;

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

  /// No description provided for @labelTaxNumber.
  ///
  /// In ar, this message translates to:
  /// **'الرقم الضريبي'**
  String get labelTaxNumber;

  /// No description provided for @labelTaxRate.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الضريبة'**
  String get labelTaxRate;

  /// No description provided for @labelTaxRateWithExample.
  ///
  /// In ar, this message translates to:
  /// **'نسبة الضريبة (مثال: 0.15)'**
  String get labelTaxRateWithExample;

  /// عنوان شاشة الخصوصية والتحليلات
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والتحليلات'**
  String get privacyAnalyticsTitle;

  /// وصف شاشة الخصوصية والتحليلات
  ///
  /// In ar, this message translates to:
  /// **'إدارة بيانات الاستخدام والخصوصية المحلية'**
  String get privacyAnalyticsSubtitle;

  /// تفعيل التتبع المحلي
  ///
  /// In ar, this message translates to:
  /// **'تفعيل التحليلات المحلية'**
  String get analyticsEnableTracking;

  /// تنبيه الخصوصية للتحليلات
  ///
  /// In ar, this message translates to:
  /// **'نحن نحترم خصوصيتك. جميع التحليلات تُخزن محلياً فقط على جهازك ولا نجمع أي بيانات شخصية أو مالية. تساعدنا هذه البيانات في تحسين تجربة المستخدم وفهم الميزات الأكثر استخداماً.'**
  String get analyticsPrivacyNotice;

  /// مسح جميع بيانات التحليلات
  ///
  /// In ar, this message translates to:
  /// **'مسح بيانات التحليلات'**
  String get analyticsClearData;

  /// تم مسح البيانات
  ///
  /// In ar, this message translates to:
  /// **'تم مسح بيانات التحليلات بنجاح'**
  String get analyticsDataCleared;

  /// No description provided for @lastSyncLabel.
  ///
  /// In ar, this message translates to:
  /// **'آخر مزامنة'**
  String get lastSyncLabel;

  /// No description provided for @labelUsername.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get labelUsername;

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

  /// عنوان إعدادات اللغة
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get languageTitle;

  /// No description provided for @loginGuest.
  ///
  /// In ar, this message translates to:
  /// **'الدخول كضيف'**
  String get loginGuest;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك مجدداً! سجل دخولك للمتابعة'**
  String get loginSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// نص زر تسجيل الخروج
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutLabel;

  /// No description provided for @modeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get modeDark;

  /// No description provided for @modeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get modeLight;

  /// No description provided for @modeSystem.
  ///
  /// In ar, this message translates to:
  /// **'النظام'**
  String get modeSystem;

  /// No description provided for @msgAccountCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح'**
  String get msgAccountCreated;

  /// No description provided for @msgAccountUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث بيانات الحساب بنجاح'**
  String get msgAccountUpdated;

  /// No description provided for @msgConfirmDeleteCustomer.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف العميل {name}؟'**
  String msgConfirmDeleteCustomer(String name);

  /// No description provided for @msgConfirmDeleteInvoice.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذه الفاتورة؟'**
  String get msgConfirmDeleteInvoice;

  /// No description provided for @msgConfirmLogout.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في تسجيل الخروج؟'**
  String get msgConfirmLogout;

  /// No description provided for @msgCustomerAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة العميل بنجاح'**
  String get msgCustomerAdded;

  /// No description provided for @msgCustomerDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف العميل بنجاح'**
  String get msgCustomerDeleted;

  /// No description provided for @msgCustomerUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث بيانات العميل بنجاح'**
  String get msgCustomerUpdated;

  /// No description provided for @msgGuestWelcome.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك كضيف! يمكنك إنشاء حساب لاحقاً'**
  String get msgGuestWelcome;

  /// No description provided for @msgInvoiceAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم إضافة الفاتورة بنجاح'**
  String get msgInvoiceAdded;

  /// No description provided for @msgInvoiceShare.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً {name}، إليك تفاصيل فاتورة رقم {id}:\nالإجمالي: {total} {symbol}\nشكراً لتعاملك معنا.'**
  String msgInvoiceShare(String name, String id, String total, String symbol);

  /// No description provided for @msgInvoiceUpdated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديث الفاتورة بنجاح'**
  String get msgInvoiceUpdated;

  /// No description provided for @msgLoginSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح'**
  String get msgLoginSuccess;

  /// No description provided for @msgLogoutSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الخروج بنجاح'**
  String get msgLogoutSuccess;

  /// No description provided for @msgNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'لا تملك حساباً؟'**
  String get msgNoAccount;

  /// No description provided for @msgNoContactsFound.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد جهات اتصال متاحة'**
  String get msgNoContactsFound;

  /// No description provided for @msgNoItems.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بنود. اضغط + لإضافة بند'**
  String get msgNoItems;

  /// No description provided for @msgSaveError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في الحفظ: {error}'**
  String msgSaveError(String error);

  /// No description provided for @msgSettingsSaved.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ الإعدادات بنجاح'**
  String get msgSettingsSaved;

  /// No description provided for @navCustomers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء'**
  String get navCustomers;

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

  /// No description provided for @navSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get navSettings;

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

  /// عنوان قسم الإشعارات
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsTitle;

  /// No description provided for @pdfShareSubject.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة رقم {id}'**
  String pdfShareSubject(String id);

  /// No description provided for @pdfShareText.
  ///
  /// In ar, this message translates to:
  /// **'إليك تفاصيل الفاتورة الخاصة بـ {customerName}'**
  String pdfShareText(String customerName);

  /// No description provided for @placeholderComingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريبًا: {title}'**
  String placeholderComingSoon(String title);

  /// No description provided for @privacyFooter.
  ///
  /// In ar, this message translates to:
  /// **'للمزيد من المعلومات، يرجى زيارة موقعنا الإلكتروني.'**
  String get privacyFooter;

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

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ سياسة الخصوصية الخاصة بنا'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get privacyPolicyTitle;

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

  /// No description provided for @retryLabel.
  ///
  /// In ar, this message translates to:
  /// **'انقر لإعادة المحاولة'**
  String get retryLabel;

  /// No description provided for @sectionAccessibility.
  ///
  /// In ar, this message translates to:
  /// **'إمكانية الوصول'**
  String get sectionAccessibility;

  /// No description provided for @sectionAdditionalInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات إضافية'**
  String get sectionAdditionalInfo;

  /// No description provided for @sectionCalendar.
  ///
  /// In ar, this message translates to:
  /// **'التقويم'**
  String get sectionCalendar;

  /// No description provided for @sectionContactInfo.
  ///
  /// In ar, this message translates to:
  /// **'معلومات الاتصال'**
  String get sectionContactInfo;

  /// No description provided for @sectionMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع'**
  String get sectionMode;

  /// No description provided for @sectionStyle.
  ///
  /// In ar, this message translates to:
  /// **'النمط'**
  String get sectionStyle;

  /// عنوان شاشة الإعدادات
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك للبدء في إدارة فواتيرك'**
  String get setupSubtitle;

  /// No description provided for @setupTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get setupTitle;

  /// No description provided for @splashCriticalError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ تقني في البداية'**
  String get splashCriticalError;

  /// No description provided for @splashInitializing.
  ///
  /// In ar, this message translates to:
  /// **'جاري التهيئة...'**
  String get splashInitializing;

  /// No description provided for @statActiveCustomers.
  ///
  /// In ar, this message translates to:
  /// **'العملاء النشطون'**
  String get statActiveCustomers;

  /// No description provided for @statOverdue.
  ///
  /// In ar, this message translates to:
  /// **'المتأخرة'**
  String get statOverdue;

  /// No description provided for @statOverdueInvoices.
  ///
  /// In ar, this message translates to:
  /// **'فواتير متأخرة'**
  String get statOverdueInvoices;

  /// No description provided for @statPaid.
  ///
  /// In ar, this message translates to:
  /// **'المدفوعة'**
  String get statPaid;

  /// No description provided for @statTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get statTotal;

  /// No description provided for @statTotalInvoices.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الفواتير'**
  String get statTotalInvoices;

  /// No description provided for @statTotalSales.
  ///
  /// In ar, this message translates to:
  /// **'المبيعات الكلية'**
  String get statTotalSales;

  /// No description provided for @statusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغاة'**
  String get statusCancelled;

  /// No description provided for @statusOverdue.
  ///
  /// In ar, this message translates to:
  /// **'متأخرة'**
  String get statusOverdue;

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

  /// No description provided for @styleCompact.
  ///
  /// In ar, this message translates to:
  /// **'مختصر'**
  String get styleCompact;

  /// No description provided for @styleModern.
  ///
  /// In ar, this message translates to:
  /// **'عصري'**
  String get styleModern;

  /// No description provided for @styleStandard.
  ///
  /// In ar, this message translates to:
  /// **'قياسي'**
  String get styleStandard;

  /// No description provided for @termsFooter.
  ///
  /// In ar, this message translates to:
  /// **'باستخدامك للتطبيق، فإنك توافق على هذه الشروط.'**
  String get termsFooter;

  /// No description provided for @termsHeader.
  ///
  /// In ar, this message translates to:
  /// **'شروط استخدام تطبيق بصير'**
  String get termsHeader;

  /// No description provided for @termsOfServiceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اقرأ شروط الخدمة الخاصة بنا'**
  String get termsOfServiceSubtitle;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In ar, this message translates to:
  /// **'شروط الخدمة'**
  String get termsOfServiceTitle;

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

  /// No description provided for @themeColorPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر لون التطبيق'**
  String get themeColorPickerTitle;

  /// No description provided for @tooltipAddInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إضافة فاتورة'**
  String get tooltipAddInvoice;

  /// No description provided for @tooltipAddItem.
  ///
  /// In ar, this message translates to:
  /// **'إضافة بند جديد'**
  String get tooltipAddItem;

  /// No description provided for @tooltipBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get tooltipBack;

  /// No description provided for @tooltipDeleteItem.
  ///
  /// In ar, this message translates to:
  /// **'حذف البند'**
  String get tooltipDeleteItem;

  /// No description provided for @tooltipEditCustomer.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العميل'**
  String get tooltipEditCustomer;

  /// No description provided for @tooltipEditTaxRate.
  ///
  /// In ar, this message translates to:
  /// **'تعديل نسبة الضريبة'**
  String get tooltipEditTaxRate;

  /// No description provided for @tooltipExportAll.
  ///
  /// In ar, this message translates to:
  /// **'تصدير الكل'**
  String get tooltipExportAll;

  /// No description provided for @btnRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get btnRetry;

  /// No description provided for @testEnhancedButtonsTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختبار الأزرار المحسّنة'**
  String get testEnhancedButtonsTitle;

  /// No description provided for @msgAccountUpgraded.
  ///
  /// In ar, this message translates to:
  /// **'تم ترقية الحساب بنجاح'**
  String get msgAccountUpgraded;

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
  /// **'نص تجريبي'**
  String get labelTestText;

  /// No description provided for @testButtonsTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختبار الأزرار'**
  String get testButtonsTitle;

  /// No description provided for @sectionPrimaryButtons.
  ///
  /// In ar, this message translates to:
  /// **'الأزرار الأساسية'**
  String get sectionPrimaryButtons;

  /// No description provided for @sectionSecondaryButtons.
  ///
  /// In ar, this message translates to:
  /// **'الأزرار الثانوية'**
  String get sectionSecondaryButtons;

  /// No description provided for @sectionTextButtons.
  ///
  /// In ar, this message translates to:
  /// **'الأزرار النصية'**
  String get sectionTextButtons;

  /// No description provided for @sectionRowButtons.
  ///
  /// In ar, this message translates to:
  /// **'صف الأزرار'**
  String get sectionRowButtons;

  /// No description provided for @sectionSpecialCases.
  ///
  /// In ar, this message translates to:
  /// **'حالات خاصة'**
  String get sectionSpecialCases;

  /// No description provided for @msgResetConfirmation.
  ///
  /// In ar, this message translates to:
  /// **'سيتم إعادة جميع إعدادات المظهر للوضع الافتراضي. هل أنت متأكد؟'**
  String get msgResetConfirmation;

  /// No description provided for @errorTitle.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، حدث خطأ غير متوقع'**
  String get errorTitle;

  /// No description provided for @errorDescription.
  ///
  /// In ar, this message translates to:
  /// **'نحن نعمل على إصلاح المشكلة حالياً. يرجى محاولة إعادة تشغيل التطبيق.'**
  String get errorDescription;

  /// No description provided for @labelCurrencySAR.
  ///
  /// In ar, this message translates to:
  /// **'ر.س'**
  String get labelCurrencySAR;

  /// No description provided for @msgNoActivity.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد نشاط حديث حتى الآن.'**
  String get msgNoActivity;

  /// No description provided for @labelAccounting.
  ///
  /// In ar, this message translates to:
  /// **'المحاسبة'**
  String get labelAccounting;

  /// No description provided for @labelChartOfAccounts.
  ///
  /// In ar, this message translates to:
  /// **'دليل الحسابات'**
  String get labelChartOfAccounts;

  /// No description provided for @labelJournalEntries.
  ///
  /// In ar, this message translates to:
  /// **'القيود اليومية'**
  String get labelJournalEntries;

  /// No description provided for @financialSummaryTitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص مالي (تجريبي)'**
  String get financialSummaryTitle;

  /// No description provided for @statAssets.
  ///
  /// In ar, this message translates to:
  /// **'الأصول'**
  String get statAssets;

  /// No description provided for @statLiabilities.
  ///
  /// In ar, this message translates to:
  /// **'الخصوم'**
  String get statLiabilities;

  /// No description provided for @statNetIncome.
  ///
  /// In ar, this message translates to:
  /// **'صافي الدخل'**
  String get statNetIncome;

  /// No description provided for @tooltipRefresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث'**
  String get tooltipRefresh;

  /// No description provided for @emptyAccountsMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حسابات. اضغط تحديث لإنشاء الدليل الافتراضي.'**
  String get emptyAccountsMessage;

  /// No description provided for @errorLoadingAccounts.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الحسابات'**
  String get errorLoadingAccounts;

  /// No description provided for @labelBalance.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد'**
  String get labelBalance;

  /// No description provided for @labelTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get labelTotal;

  /// No description provided for @statusPosted.
  ///
  /// In ar, this message translates to:
  /// **'مرحل'**
  String get statusPosted;

  /// No description provided for @statusDraft.
  ///
  /// In ar, this message translates to:
  /// **'مسودة'**
  String get statusDraft;

  /// No description provided for @emptyJournalEntriesMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد قيود مسجلة.'**
  String get emptyJournalEntriesMessage;

  /// No description provided for @labelDebit.
  ///
  /// In ar, this message translates to:
  /// **'مدين'**
  String get labelDebit;

  /// No description provided for @labelCredit.
  ///
  /// In ar, this message translates to:
  /// **'دائن'**
  String get labelCredit;

  /// No description provided for @labelReference.
  ///
  /// In ar, this message translates to:
  /// **'المرجع / الرقم'**
  String get labelReference;

  /// No description provided for @msgColorPickerHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر لوناً أساسياً مخصصاً للتطبيق'**
  String get msgColorPickerHint;

  /// No description provided for @msgJournalEntryAdded.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ القيد المحاسبي بنجاح'**
  String get msgJournalEntryAdded;

  /// No description provided for @errUnbalancedEntry.
  ///
  /// In ar, this message translates to:
  /// **'القيد غير متزن! يجب أن يتساوى المدين والدائن'**
  String get errUnbalancedEntry;

  /// No description provided for @btnSaveEntry.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كمسودة'**
  String get btnSaveEntry;

  /// No description provided for @btnPostEntry.
  ///
  /// In ar, this message translates to:
  /// **'ترحيل القيد'**
  String get btnPostEntry;

  /// No description provided for @msgJournalEntryPosted.
  ///
  /// In ar, this message translates to:
  /// **'تم ترحيل القيد بنجاح'**
  String get msgJournalEntryPosted;

  /// No description provided for @msgJournalEntryDrafted.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ القيد كمسودة'**
  String get msgJournalEntryDrafted;

  /// No description provided for @hintJournalDescription.
  ///
  /// In ar, this message translates to:
  /// **'أدخل وصف العملية المالية'**
  String get hintJournalDescription;

  /// No description provided for @labelJournalEntryLines.
  ///
  /// In ar, this message translates to:
  /// **'بنود القيد'**
  String get labelJournalEntryLines;

  /// No description provided for @expenseDistributionTitle.
  ///
  /// In ar, this message translates to:
  /// **'توزيع المصروفات'**
  String get expenseDistributionTitle;

  /// No description provided for @noExpenseDataMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات مصروفات'**
  String get noExpenseDataMessage;

  /// No description provided for @otherExpensesLabel.
  ///
  /// In ar, this message translates to:
  /// **'مصروفات أخرى'**
  String get otherExpensesLabel;

  /// No description provided for @trialBalanceTitle.
  ///
  /// In ar, this message translates to:
  /// **'ميزان المراجعة'**
  String get trialBalanceTitle;

  /// No description provided for @btnExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير'**
  String get btnExport;

  /// No description provided for @labelAccount.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get labelAccount;

  /// No description provided for @labelExportPdf.
  ///
  /// In ar, this message translates to:
  /// **'تصدير PDF'**
  String get labelExportPdf;

  /// No description provided for @labelExportCsv.
  ///
  /// In ar, this message translates to:
  /// **'تصدير CSV (Excel)'**
  String get labelExportCsv;

  /// No description provided for @cashFlowTitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة التدفقات النقدية'**
  String get cashFlowTitle;

  /// No description provided for @incomeStatementTitle.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الدخل'**
  String get incomeStatementTitle;

  /// No description provided for @balanceSheetTitle.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية العمومية'**
  String get balanceSheetTitle;

  /// No description provided for @labelOperating.
  ///
  /// In ar, this message translates to:
  /// **'العمليات التشغيلية'**
  String get labelOperating;

  /// No description provided for @labelInvesting.
  ///
  /// In ar, this message translates to:
  /// **'العمليات الاستثمارية'**
  String get labelInvesting;

  /// No description provided for @labelFinancing.
  ///
  /// In ar, this message translates to:
  /// **'العمليات التمويلية'**
  String get labelFinancing;

  /// No description provided for @labelNetCashFlow.
  ///
  /// In ar, this message translates to:
  /// **'صافي التدفق النقدي'**
  String get labelNetCashFlow;

  /// No description provided for @reportingOverviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'التقارير المالية'**
  String get reportingOverviewTitle;

  /// No description provided for @trialBalanceSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من توازن الحسابات المدينة والدائنة'**
  String get trialBalanceSubtitle;

  /// No description provided for @incomeStatementSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الإيرادات والمصروفات حسب IFRS 18'**
  String get incomeStatementSubtitle;

  /// No description provided for @balanceSheetSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة الأصول والالتزامات وحقوق الملكية'**
  String get balanceSheetSubtitle;

  /// No description provided for @cashFlowSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حركة النقدية (الأنشطة التشغيلية، الاستثمارية، التمويلية)'**
  String get cashFlowSubtitle;

  /// No description provided for @agingReportsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تحليل أعمار أرصدة العملاء والموردين'**
  String get agingReportsSubtitle;

  /// No description provided for @agingReportsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقارير تعمير الديون'**
  String get agingReportsTitle;

  /// No description provided for @receivablesAgingLabel.
  ///
  /// In ar, this message translates to:
  /// **'ذمم مدينة (عملاء)'**
  String get receivablesAgingLabel;

  /// No description provided for @payablesAgingLabel.
  ///
  /// In ar, this message translates to:
  /// **'ذمم دائنة (موردون)'**
  String get payablesAgingLabel;

  /// No description provided for @noDataMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noDataMessage;

  /// No description provided for @periodCurrent.
  ///
  /// In ar, this message translates to:
  /// **'الحالي'**
  String get periodCurrent;

  /// No description provided for @period1_30.
  ///
  /// In ar, this message translates to:
  /// **'1-30 يوم'**
  String get period1_30;

  /// No description provided for @period31_60.
  ///
  /// In ar, this message translates to:
  /// **'31-60 يوم'**
  String get period31_60;

  /// No description provided for @period61_90.
  ///
  /// In ar, this message translates to:
  /// **'61-90 يوم'**
  String get period61_90;

  /// No description provided for @periodOver90.
  ///
  /// In ar, this message translates to:
  /// **'أكثر من 90 يوم'**
  String get periodOver90;

  /// No description provided for @labelAssets.
  ///
  /// In ar, this message translates to:
  /// **'الأصول'**
  String get labelAssets;

  /// No description provided for @labelLiabilities.
  ///
  /// In ar, this message translates to:
  /// **'الالتزامات'**
  String get labelLiabilities;

  /// No description provided for @labelEquity.
  ///
  /// In ar, this message translates to:
  /// **'حقوق الملكية'**
  String get labelEquity;

  /// No description provided for @labelTotalAssets.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الأصول'**
  String get labelTotalAssets;

  /// No description provided for @labelTotalLiabilitiesAndEquity.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الالتزامات وحقوق الملكية'**
  String get labelTotalLiabilitiesAndEquity;

  /// No description provided for @msgBalanceBalanced.
  ///
  /// In ar, this message translates to:
  /// **'الميزانية متزنة: الأصول تساوي الالتزامات وحقوق الملكية.'**
  String get msgBalanceBalanced;

  /// No description provided for @msgBalanceUnbalanced.
  ///
  /// In ar, this message translates to:
  /// **'تنبيه: الميزانية غير متزنة! الفرق: {diff}'**
  String msgBalanceUnbalanced(String diff);

  /// No description provided for @treasuryTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخزينة والنقدية'**
  String get treasuryTitle;

  /// No description provided for @cashBalancesTitle.
  ///
  /// In ar, this message translates to:
  /// **'أرصدة النقدية والبنوك'**
  String get cashBalancesTitle;

  /// No description provided for @recentVouchersTitle.
  ///
  /// In ar, this message translates to:
  /// **'أحدث السندات'**
  String get recentVouchersTitle;

  /// No description provided for @receiptVoucherAction.
  ///
  /// In ar, this message translates to:
  /// **'سند قبض'**
  String get receiptVoucherAction;

  /// No description provided for @paymentVoucherAction.
  ///
  /// In ar, this message translates to:
  /// **'سند صرف'**
  String get paymentVoucherAction;

  /// No description provided for @newVoucherLabel.
  ///
  /// In ar, this message translates to:
  /// **'سند جديد'**
  String get newVoucherLabel;

  /// No description provided for @noVouchersMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد سندات مسجلة'**
  String get noVouchersMessage;

  /// No description provided for @anonymousPerson.
  ///
  /// In ar, this message translates to:
  /// **'بدون اسم'**
  String get anonymousPerson;

  /// No description provided for @actionReverse.
  ///
  /// In ar, this message translates to:
  /// **'عكس القيد'**
  String get actionReverse;

  /// No description provided for @actionEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get actionEdit;

  /// No description provided for @actionPostNow.
  ///
  /// In ar, this message translates to:
  /// **'ترحيل الآن'**
  String get actionPostNow;

  /// No description provided for @msgConfirmReverse.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في عكس هذا القيد؟ سيؤدي ذلك إلى إنشاء قيد عكسي تلقائي.'**
  String get msgConfirmReverse;

  /// No description provided for @msgReverseSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم عكس القيد بنجاح'**
  String get msgReverseSuccess;

  /// No description provided for @labelBalanced.
  ///
  /// In ar, this message translates to:
  /// **'متزن'**
  String get labelBalanced;

  /// No description provided for @labelUnbalanced.
  ///
  /// In ar, this message translates to:
  /// **'غير متزن'**
  String get labelUnbalanced;

  /// No description provided for @labelDiff.
  ///
  /// In ar, this message translates to:
  /// **'الفرق'**
  String get labelDiff;

  /// No description provided for @voucherReceiptTitle.
  ///
  /// In ar, this message translates to:
  /// **'سند قبض جديد'**
  String get voucherReceiptTitle;

  /// No description provided for @voucherPaymentTitle.
  ///
  /// In ar, this message translates to:
  /// **'سند صرف جديد'**
  String get voucherPaymentTitle;

  /// No description provided for @btnSaveAndPostVoucher.
  ///
  /// In ar, this message translates to:
  /// **'حفظ السند وترحيله'**
  String get btnSaveAndPostVoucher;

  /// No description provided for @errInvalidAmount.
  ///
  /// In ar, this message translates to:
  /// **'مبلغ غير صالح'**
  String get errInvalidAmount;

  /// No description provided for @errAmountRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال المبلغ'**
  String get errAmountRequired;

  /// No description provided for @errDescriptionRequired.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال الشرح'**
  String get errDescriptionRequired;

  /// No description provided for @labelPaymentMethod.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get labelPaymentMethod;

  /// No description provided for @methodCash.
  ///
  /// In ar, this message translates to:
  /// **'نقدي'**
  String get methodCash;

  /// No description provided for @methodBank.
  ///
  /// In ar, this message translates to:
  /// **'بنكي'**
  String get methodBank;

  /// No description provided for @methodCheck.
  ///
  /// In ar, this message translates to:
  /// **'شيك'**
  String get methodCheck;

  /// No description provided for @labelTreasuryAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب الصندوق/البنك'**
  String get labelTreasuryAccount;

  /// No description provided for @labelSourceClient.
  ///
  /// In ar, this message translates to:
  /// **'العميل (مصدر السند)'**
  String get labelSourceClient;

  /// No description provided for @labelBeneficiaryVendor.
  ///
  /// In ar, this message translates to:
  /// **'المورد (المستفيد)'**
  String get labelBeneficiaryVendor;

  /// No description provided for @msgVoucherSavedSuccess.
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ السند وترحيله بنجاح'**
  String get msgVoucherSavedSuccess;

  /// No description provided for @errFormFill.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إكمال البيانات'**
  String get errFormFill;

  /// No description provided for @labelAccountSelector.
  ///
  /// In ar, this message translates to:
  /// **'اختر الحساب'**
  String get labelAccountSelector;

  /// No description provided for @labelRequired.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get labelRequired;

  /// No description provided for @labelStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get labelStatus;

  /// No description provided for @labelDescription.
  ///
  /// In ar, this message translates to:
  /// **'الوصف'**
  String get labelDescription;

  /// No description provided for @errorExportingReport.
  ///
  /// In ar, this message translates to:
  /// **'خطأ أثناء تصدير التقرير'**
  String get errorExportingReport;

  /// No description provided for @labelStandard.
  ///
  /// In ar, this message translates to:
  /// **'المعيار المحاسبي'**
  String get labelStandard;

  /// No description provided for @labelRecognitionBasis.
  ///
  /// In ar, this message translates to:
  /// **'أساس الاعتراف'**
  String get labelRecognitionBasis;

  /// No description provided for @labelMeasurementBasis.
  ///
  /// In ar, this message translates to:
  /// **'أساس القياس'**
  String get labelMeasurementBasis;

  /// No description provided for @labelExchangeRate.
  ///
  /// In ar, this message translates to:
  /// **'سعر الصرف'**
  String get labelExchangeRate;

  /// No description provided for @labelAddCurrency.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عملة'**
  String get labelAddCurrency;

  /// No description provided for @labelCurrency.
  ///
  /// In ar, this message translates to:
  /// **'العملة'**
  String get labelCurrency;

  /// No description provided for @labelAmount.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ'**
  String get labelAmount;

  /// No description provided for @labelDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get labelDate;

  /// No description provided for @labelType.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get labelType;

  /// No description provided for @labelRevenue.
  ///
  /// In ar, this message translates to:
  /// **'الإيرادات'**
  String get labelRevenue;

  /// No description provided for @labelExpenses.
  ///
  /// In ar, this message translates to:
  /// **'المصروفات'**
  String get labelExpenses;

  /// No description provided for @labelIncomeTax.
  ///
  /// In ar, this message translates to:
  /// **'ضريبة الدخل'**
  String get labelIncomeTax;

  /// No description provided for @labelNetProfit.
  ///
  /// In ar, this message translates to:
  /// **'صافي الربح / الخساارة'**
  String get labelNetProfit;

  /// No description provided for @labelInventoryItem.
  ///
  /// In ar, this message translates to:
  /// **'صنف من المخزون'**
  String get labelInventoryItem;

  /// No description provided for @hintSelectInventoryItem.
  ///
  /// In ar, this message translates to:
  /// **'اختر صنفاً من المخزون لملء البيانات تلقائياً'**
  String get hintSelectInventoryItem;

  /// No description provided for @labelTaxCategory.
  ///
  /// In ar, this message translates to:
  /// **'فئة الضريبة'**
  String get labelTaxCategory;

  /// No description provided for @labelSearchSku.
  ///
  /// In ar, this message translates to:
  /// **'بحث بالباركود / SKU'**
  String get labelSearchSku;

  /// No description provided for @hintSearchSku.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الكود واضغط Enter'**
  String get hintSearchSku;

  /// No description provided for @msgItemNotFound.
  ///
  /// In ar, this message translates to:
  /// **'الصنف غير موجود'**
  String get msgItemNotFound;

  /// No description provided for @tooltipPrintReceipt.
  ///
  /// In ar, this message translates to:
  /// **'طباعة إيصال'**
  String get tooltipPrintReceipt;

  /// No description provided for @tooltipReverseInvoice.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء/عكس'**
  String get tooltipReverseInvoice;

  /// No description provided for @titleReverseInvoice.
  ///
  /// In ar, this message translates to:
  /// **'عكس الفاتورة'**
  String get titleReverseInvoice;

  /// No description provided for @msgConfirmReverseInvoice.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من رغبتك في عكس هذه الفاتورة؟ سيتم إنشاء قيد عكسي في المحاسبة.'**
  String get msgConfirmReverseInvoice;

  /// No description provided for @btnConfirmReverse.
  ///
  /// In ar, this message translates to:
  /// **'نعم، عكس الفاتورة'**
  String get btnConfirmReverse;

  /// No description provided for @receiptTitleTaxInvoice.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة ضريبية'**
  String get receiptTitleTaxInvoice;

  /// No description provided for @receiptTitleSimplified.
  ///
  /// In ar, this message translates to:
  /// **'فاتورة ضريبية مبسطة'**
  String get receiptTitleSimplified;

  /// No description provided for @receiptFooterThanks.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لزيارتكم'**
  String get receiptFooterThanks;

  /// No description provided for @receiptFooterBrand.
  ///
  /// In ar, this message translates to:
  /// **'بصير - Basir Accounting'**
  String get receiptFooterBrand;

  /// No description provided for @labelDiscount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get labelDiscount;

  /// No description provided for @errPermissionDenied.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك صلاحية للقيام بهذا الإجراء'**
  String get errPermissionDenied;

  /// No description provided for @msgInvoiceReversed.
  ///
  /// In ar, this message translates to:
  /// **'تم عكس الفاتورة بنجاح'**
  String get msgInvoiceReversed;
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
