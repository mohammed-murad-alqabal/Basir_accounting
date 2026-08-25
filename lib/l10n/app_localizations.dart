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

  /// The main application title
  ///
  /// In en, this message translates to:
  /// **'Basir'**
  String get appTitle;

  /// No description provided for @labelStandard.
  ///
  /// In en, this message translates to:
  /// **'Accounting Standard'**
  String get labelStandard;

  /// No description provided for @labelRecognitionBasis.
  ///
  /// In en, this message translates to:
  /// **'Recognition Basis'**
  String get labelRecognitionBasis;

  /// No description provided for @labelMeasurementBasis.
  ///
  /// In en, this message translates to:
  /// **'Measurement Basis'**
  String get labelMeasurementBasis;

  /// No description provided for @labelCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get labelCurrency;

  /// No description provided for @labelAddCurrency.
  ///
  /// In en, this message translates to:
  /// **'Add Currency'**
  String get labelAddCurrency;

  /// No description provided for @labelPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get labelPartner;

  /// No description provided for @labelAccountCode.
  ///
  /// In en, this message translates to:
  /// **'Account Code'**
  String get labelAccountCode;

  /// No description provided for @labelAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get labelAccountName;

  /// No description provided for @labelFairValueAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Fair Value Adjustment (IFRS 13)'**
  String get labelFairValueAdjustment;

  /// No description provided for @subtitleFairValueAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Use latest market prices for inventory'**
  String get subtitleFairValueAdjustment;

  /// No description provided for @labelTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get labelTotalAmount;

  /// No description provided for @msgBalanceBalancedTB.
  ///
  /// In en, this message translates to:
  /// **'Balance is balanced (Balanced)'**
  String get msgBalanceBalancedTB;

  /// No description provided for @msgBalanceUnbalancedTB.
  ///
  /// In en, this message translates to:
  /// **'Balance is unbalanced! Please review.'**
  String get msgBalanceUnbalancedTB;

  /// No description provided for @sectionBasicReports.
  ///
  /// In en, this message translates to:
  /// **'Basic Reports'**
  String get sectionBasicReports;

  /// No description provided for @sectionFinancialStatements.
  ///
  /// In en, this message translates to:
  /// **'Financial Statements (IAS 1/IFRS)'**
  String get sectionFinancialStatements;

  /// No description provided for @sectionAgingAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Aging Analysis'**
  String get sectionAgingAnalysis;

  /// No description provided for @receivablesAgingTitle.
  ///
  /// In en, this message translates to:
  /// **'Receivables Aging'**
  String get receivablesAgingTitle;

  /// No description provided for @payablesAgingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payables Aging'**
  String get payablesAgingTitle;

  /// No description provided for @labelGeneralLedger.
  ///
  /// In en, this message translates to:
  /// **'General Ledger'**
  String get labelGeneralLedger;

  /// No description provided for @labelPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get labelPeriod;

  /// No description provided for @msgNoTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get msgNoTransactionsFound;

  /// No description provided for @msgExportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon'**
  String get msgExportComingSoon;

  /// Title for appearance section
  ///
  /// In en, this message translates to:
  /// **'Appearance & Customization'**
  String get appearanceTitle;

  /// Title for company settings section
  ///
  /// In en, this message translates to:
  /// **'Company & Billing Settings'**
  String get companySettingsTitle;

  /// No description provided for @errContactAccess.
  ///
  /// In en, this message translates to:
  /// **'Contact access error: {error}'**
  String errContactAccess(String error);

  /// No description provided for @errCustomerAdd.
  ///
  /// In en, this message translates to:
  /// **'Failed to add customer'**
  String get errCustomerAdd;

  /// No description provided for @errCustomerDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete customer'**
  String get errCustomerDelete;

  /// No description provided for @errCustomerNameLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get errCustomerNameLength;

  /// No description provided for @errCustomerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get errCustomerNameRequired;

  /// No description provided for @errCustomerUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update customer'**
  String get errCustomerUpdate;

  /// No description provided for @errEmptyField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errEmptyField;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error occurred: {error}'**
  String errGeneric(String error);

  /// No description provided for @errInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get errInvalidEmail;

  /// No description provided for @errInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get errInvalidNumber;

  /// No description provided for @errInvoiceAdd.
  ///
  /// In en, this message translates to:
  /// **'Failed to add invoice'**
  String get errInvoiceAdd;

  /// No description provided for @errInvoiceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update invoice'**
  String get errInvoiceUpdate;

  /// No description provided for @errLoadCustomers.
  ///
  /// In en, this message translates to:
  /// **'Error loading customers: {error}'**
  String errLoadCustomers(String error);

  /// No description provided for @errLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get errLoginFailed;

  /// No description provided for @errNoItems.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one item'**
  String get errNoItems;

  /// No description provided for @errPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'
  String get errPasswordShort;

  /// No description provided for @errPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errPasswordsDoNotMatch;

  /// No description provided for @errPhoneLength.
  ///
  /// In en, this message translates to:
  /// **'Phone must be 10 digits'**
  String get errPhoneLength;

  /// No description provided for @errPhoneStart05.
  ///
  /// In en, this message translates to:
  /// **'Phone must start with 05'**
  String get errPhoneStart05;

  /// No description provided for @errSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer'**
  String get errSelectCustomer;

  /// No description provided for @errUsernameShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get errUsernameShort;

  /// No description provided for @errorCustomerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer data not found'**
  String get errorCustomerNotFound;

  /// No description provided for @errorCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer phone not available'**
  String get errorCustomerPhone;

  /// No description provided for @errorLoadingInvoices.
  ///
  /// In en, this message translates to:
  /// **'Error loading invoices'**
  String get errorLoadingInvoices;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @errorScreenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Screen not found: {name}'**
  String errorScreenNotFound(String name);

  /// No description provided for @errorSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Error sharing PDF: {error}'**
  String errorSharePdf(String error);

  /// No description provided for @errorShareWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Error sharing via WhatsApp: {error}'**
  String errorShareWhatsapp(String error);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get filterDraft;

  /// No description provided for @filterIssued.
  ///
  /// In en, this message translates to:
  /// **'Issued'**
  String get filterIssued;

  /// No description provided for @filterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get filterOverdue;

  /// No description provided for @filterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get filterPaid;

  /// No description provided for @fontCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo (Default)'**
  String get fontCairo;

  /// No description provided for @fontRoboto.
  ///
  /// In en, this message translates to:
  /// **'Roboto'**
  String get fontRoboto;

  /// No description provided for @fontSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Type'**
  String get fontSettingsTitle;

  /// No description provided for @fontSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get fontSizeLabel;

  /// No description provided for @taxConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax & E-Invoicing'**
  String get taxConfigTitle;

  /// No description provided for @zatcaPhase2Title.
  ///
  /// In en, this message translates to:
  /// **'ZATCA E-Invoicing (Phase 2)'**
  String get zatcaPhase2Title;

  /// No description provided for @zatcaPhase2Description.
  ///
  /// In en, this message translates to:
  /// **'Configure your settings for compliance with Saudi ZATCA Phase 2 (Integration Phase).'**
  String get zatcaPhase2Description;

  /// No description provided for @enableTax.
  ///
  /// In en, this message translates to:
  /// **'Enable Tax on Invoices'**
  String get enableTax;

  /// No description provided for @priceIncludesTax.
  ///
  /// In en, this message translates to:
  /// **'Price includes tax by default'**
  String get priceIncludesTax;

  /// No description provided for @vatNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax ID / VAT Number'**
  String get vatNumber;

  /// No description provided for @defaultTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Default Tax Value (%)'**
  String get defaultTaxRate;

  /// No description provided for @b2cSimplifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'B2C Simplified Invoice Label'**
  String get b2cSimplifiedLabel;

  /// No description provided for @b2bStandardLabel.
  ///
  /// In en, this message translates to:
  /// **'B2B Standard Invoice Label'**
  String get b2bStandardLabel;

  /// No description provided for @taxName.
  ///
  /// In en, this message translates to:
  /// **'Tax Name'**
  String get taxName;

  /// No description provided for @taxPercentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage (%)'**
  String get taxPercentage;

  /// No description provided for @taxShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get taxShow;

  /// No description provided for @taxDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get taxDefault;

  /// No description provided for @printSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Printing & Templates'**
  String get printSettingsTitle;

  /// No description provided for @printSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your printing formats and templates'**
  String get printSettingsSubtitle;

  /// No description provided for @templateSelection.
  ///
  /// In en, this message translates to:
  /// **'Template Selection'**
  String get templateSelection;

  /// No description provided for @paperSize.
  ///
  /// In en, this message translates to:
  /// **'Paper Size'**
  String get paperSize;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @paddingBottom.
  ///
  /// In en, this message translates to:
  /// **'Empty lines at end'**
  String get paddingBottom;

  /// No description provided for @printCopies.
  ///
  /// In en, this message translates to:
  /// **'Number of copies'**
  String get printCopies;

  /// No description provided for @printItemUnit.
  ///
  /// In en, this message translates to:
  /// **'Show item unit in print'**
  String get printItemUnit;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @guestUpgradeDescription.
  ///
  /// In en, this message translates to:
  /// **'Convert your guest account to a permanent account to save your data securely.'**
  String get guestUpgradeDescription;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpTitle;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get highContrast;

  /// No description provided for @highContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Increase text and element clarity'**
  String get highContrastSubtitle;

  /// No description provided for @hintAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter customer address'**
  String get hintAddress;

  /// No description provided for @hintCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter your company name'**
  String get hintCompanyName;

  /// No description provided for @hintConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get hintConfirmPassword;

  /// No description provided for @hintCurrencySymbol.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get hintCurrencySymbol;

  /// No description provided for @hintCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get hintCustomerName;

  /// No description provided for @hintCustomerNotes.
  ///
  /// In en, this message translates to:
  /// **'Add customer notes'**
  String get hintCustomerNotes;

  /// No description provided for @hintEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get hintEnterNewPassword;

  /// No description provided for @hintEnterNewUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter new username'**
  String get hintEnterNewUsername;

  /// No description provided for @hintEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get hintEnterPassword;

  /// No description provided for @hintEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get hintEnterUsername;

  /// No description provided for @hintNotes.
  ///
  /// In en, this message translates to:
  /// **'Add invoice notes'**
  String get hintNotes;

  /// No description provided for @hintSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get hintSelectCustomer;

  /// No description provided for @hintTaxNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter tax number (optional)'**
  String get hintTaxNumber;

  /// No description provided for @iconCupertino.
  ///
  /// In en, this message translates to:
  /// **'Cupertino (iOS)'**
  String get iconCupertino;

  /// No description provided for @iconMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material Design'**
  String get iconMaterial;

  /// No description provided for @iconSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Icon Style'**
  String get iconSettingsTitle;

  /// No description provided for @journalEntryFormTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Journal Entry'**
  String get journalEntryFormTitleAdd;

  /// No description provided for @journalEntryFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Journal Entry'**
  String get journalEntryFormTitleEdit;

  /// No description provided for @invoiceFormTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add New Invoice'**
  String get invoiceFormTitleAdd;

  /// No description provided for @invoiceFormTitleAddPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add Purchase Invoice'**
  String get invoiceFormTitleAddPurchase;

  /// No description provided for @invoiceFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Invoice'**
  String get invoiceFormTitleEdit;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice {id}'**
  String invoiceTitle(String id);

  /// No description provided for @calculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Calculator'**
  String get calculatorTitle;

  /// No description provided for @convertToCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Convert to currencies'**
  String get convertToCurrencies;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @labelTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get labelTermsAndConditions;

  /// No description provided for @labelPaidDate.
  ///
  /// In en, this message translates to:
  /// **'Paid Date'**
  String get labelPaidDate;

  /// No description provided for @labelDiscountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount'**
  String get labelDiscountAmount;

  /// No description provided for @labelZatcaQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code (ZATCA)'**
  String get labelZatcaQrCode;

  /// No description provided for @labelZatcaUuid.
  ///
  /// In en, this message translates to:
  /// **'ZATCA UUID'**
  String get labelZatcaUuid;

  /// No description provided for @labelZatcaHash.
  ///
  /// In en, this message translates to:
  /// **'Invoice Hash'**
  String get labelZatcaHash;

  /// No description provided for @labelTaxTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Tax'**
  String get labelTaxTotal;

  /// No description provided for @labelVatRate.
  ///
  /// In en, this message translates to:
  /// **'VAT Rate'**
  String get labelVatRate;

  /// No description provided for @zatcaComplianceText.
  ///
  /// In en, this message translates to:
  /// **'This invoice is compliant with ZATCA electronic invoicing requirements.'**
  String get zatcaComplianceText;

  /// No description provided for @actionCreateFirstInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create Your First Invoice'**
  String get actionCreateFirstInvoice;

  /// No description provided for @noInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Invoices Found'**
  String get noInvoicesTitle;

  /// No description provided for @noInvoicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first invoice to manage your sales professionally.'**
  String get noInvoicesDescription;

  /// No description provided for @labelFromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get labelFromDate;

  /// No description provided for @labelToDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get labelToDate;

  /// No description provided for @labelAsOfDate.
  ///
  /// In en, this message translates to:
  /// **'As of Date'**
  String get labelAsOfDate;

  /// No description provided for @tooltipUpdateReport.
  ///
  /// In en, this message translates to:
  /// **'Update Report'**
  String get tooltipUpdateReport;

  /// No description provided for @labelCogsAccountId.
  ///
  /// In en, this message translates to:
  /// **'COGS Account'**
  String get labelCogsAccountId;

  /// No description provided for @labelRevenueAccountId.
  ///
  /// In en, this message translates to:
  /// **'Revenue Account'**
  String get labelRevenueAccountId;

  /// No description provided for @labelValuationMethod.
  ///
  /// In en, this message translates to:
  /// **'Valuation Method'**
  String get labelValuationMethod;

  /// No description provided for @labelInventoryValuation.
  ///
  /// In en, this message translates to:
  /// **'Inventory Valuation (IAS 2)'**
  String get labelInventoryValuation;

  /// No description provided for @logoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutLabel;

  /// No description provided for @msgInvoiceShare.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}, here is invoice #{id}:\nTotal: {total} {symbol}\nThank you.'**
  String msgInvoiceShare(String name, String id, String total, String symbol);

  /// No description provided for @msgSaveError.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String msgSaveError(String error);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get navInvoices;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @pdfShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Invoice {id}'**
  String pdfShareSubject(String id);

  /// No description provided for @pdfShareText.
  ///
  /// In en, this message translates to:
  /// **'Here is the invoice for {customerName}'**
  String pdfShareText(String customerName);

  /// No description provided for @placeholderComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: {title}'**
  String placeholderComingSoon(String title);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutAppTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Basir app is a complete system for managing invoices and customers, designed specifically for small and medium businesses.'**
  String get aboutDescription;

  /// No description provided for @aboutFeature1.
  ///
  /// In en, this message translates to:
  /// **'• Manage invoices easily'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In en, this message translates to:
  /// **'• Customer management'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In en, this message translates to:
  /// **'• Export invoices as PDF'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In en, this message translates to:
  /// **'• Secure data storage'**
  String get aboutFeature4;

  /// No description provided for @aboutFeature5.
  ///
  /// In en, this message translates to:
  /// **'• Full Arabic language support'**
  String get aboutFeature5;

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Features:'**
  String get aboutFeaturesTitle;

  /// No description provided for @titleAddInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get titleAddInventoryItem;

  /// No description provided for @titleEditInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item Details'**
  String get titleEditInventoryItem;

  /// No description provided for @vendorsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get vendorsScreenTitle;

  /// No description provided for @vendorsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search vendors...'**
  String get vendorsSearchHint;

  /// No description provided for @navVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get navVendors;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get navAssets;

  /// No description provided for @labelNameAr.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get labelNameAr;

  /// No description provided for @labelNameEn.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get labelNameEn;

  /// No description provided for @tooltipAddVendor.
  ///
  /// In en, this message translates to:
  /// **'Add New Vendor'**
  String get tooltipAddVendor;

  /// No description provided for @tooltipEditVendor.
  ///
  /// In en, this message translates to:
  /// **'Edit Vendor'**
  String get tooltipEditVendor;

  /// No description provided for @tooltipDeleteVendor.
  ///
  /// In en, this message translates to:
  /// **'Delete Vendor'**
  String get tooltipDeleteVendor;

  /// No description provided for @msgConfirmDeleteVendor.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete vendor {name}?'**
  String msgConfirmDeleteVendor(String name);

  /// No description provided for @msgConfirmDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete item {name}?'**
  String msgConfirmDeleteItem(String name);

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDelete;

  /// No description provided for @inventoryItemsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryItemsScreenTitle;

  /// No description provided for @assetsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed Assets'**
  String get assetsScreenTitle;

  /// No description provided for @assetsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search assets...'**
  String get assetsSearchHint;

  /// No description provided for @actionAddAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get actionAddAsset;

  /// No description provided for @tooltipAddAsset.
  ///
  /// In en, this message translates to:
  /// **'Add New Asset'**
  String get tooltipAddAsset;

  /// No description provided for @titleAddAsset.
  ///
  /// In en, this message translates to:
  /// **'Add New Asset'**
  String get titleAddAsset;

  /// No description provided for @titleEditAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset Details'**
  String get titleEditAsset;

  /// No description provided for @labelCode.
  ///
  /// In en, this message translates to:
  /// **'Asset Code'**
  String get labelCode;

  /// No description provided for @labelPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get labelPurchaseDate;

  /// No description provided for @labelCost.
  ///
  /// In en, this message translates to:
  /// **'Purchase Cost'**
  String get labelCost;

  /// No description provided for @labelSalvageValue.
  ///
  /// In en, this message translates to:
  /// **'Salvage Value'**
  String get labelSalvageValue;

  /// No description provided for @labelUsefulLife.
  ///
  /// In en, this message translates to:
  /// **'Useful Life (Years)'**
  String get labelUsefulLife;

  /// No description provided for @labelDepreciationMethod.
  ///
  /// In en, this message translates to:
  /// **'Depreciation Method'**
  String get labelDepreciationMethod;

  /// No description provided for @labelDepreciationAccountId.
  ///
  /// In en, this message translates to:
  /// **'Depreciation Expense Account'**
  String get labelDepreciationAccountId;

  /// No description provided for @labelAccumDepreciationAccountId.
  ///
  /// In en, this message translates to:
  /// **'Accumulated Depreciation Account'**
  String get labelAccumDepreciationAccountId;

  /// No description provided for @labelAssetAccountId.
  ///
  /// In en, this message translates to:
  /// **'Inventory Account (Assets)'**
  String get labelAssetAccountId;

  /// No description provided for @inventoryItemsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, SKU, or barcode...'**
  String get inventoryItemsSearchHint;

  /// No description provided for @inventoryEmptyHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory management'**
  String get inventoryEmptyHintTitle;

  /// No description provided for @inventoryEmptyHintDescription.
  ///
  /// In en, this message translates to:
  /// **'Add inventory items here to track quantities and costs accurately. You can start by adding an item manually.'**
  String get inventoryEmptyHintDescription;

  /// No description provided for @labelSKU.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get labelSKU;

  /// No description provided for @labelBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get labelBarcode;

  /// No description provided for @inventoryItemNameArRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the item name in Arabic.'**
  String get inventoryItemNameArRequired;

  /// No description provided for @inventoryItemNameEnRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the item name in English.'**
  String get inventoryItemNameEnRequired;

  /// No description provided for @inventoryItemInvalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter valid, non-negative purchase and sales prices.'**
  String get inventoryItemInvalidPrice;

  /// No description provided for @inventoryItemQuantityMustUseMovement.
  ///
  /// In en, this message translates to:
  /// **'Update item quantity through an inventory movement or stock count only.'**
  String get inventoryItemQuantityMustUseMovement;

  /// No description provided for @inventoryItemDuplicateSku.
  ///
  /// In en, this message translates to:
  /// **'The SKU or barcode is already used by another item.'**
  String get inventoryItemDuplicateSku;

  /// No description provided for @inventoryItemDuplicateBarcode.
  ///
  /// In en, this message translates to:
  /// **'The barcode is already used by another item.'**
  String get inventoryItemDuplicateBarcode;

  /// No description provided for @inventoryItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item could not be found.'**
  String get inventoryItemNotFound;

  /// No description provided for @inventoryItemSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Item details could not be saved. Please try again.'**
  String get inventoryItemSaveFailed;

  /// No description provided for @inventoryItemSaved.
  ///
  /// In en, this message translates to:
  /// **'Item details were saved.'**
  String get inventoryItemSaved;

  /// No description provided for @inventoryBarcodeSelectRequired.
  ///
  /// In en, this message translates to:
  /// **'Select an item and enter the barcode first.'**
  String get inventoryBarcodeSelectRequired;

  /// No description provided for @inventoryBarcodeSaved.
  ///
  /// In en, this message translates to:
  /// **'Barcode was saved successfully.'**
  String get inventoryBarcodeSaved;

  /// No description provided for @inventoryBarcodeSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Barcode could not be saved. Please try again.'**
  String get inventoryBarcodeSaveFailed;

  /// No description provided for @labelPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get labelPurchasePrice;

  /// No description provided for @labelSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get labelSalePrice;

  /// No description provided for @labelUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get labelUnit;

  /// No description provided for @labelCategoryId.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get labelCategoryId;

  /// No description provided for @tooltipAddInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get tooltipAddInventoryItem;

  /// No description provided for @actionSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get actionSharePdf;

  /// No description provided for @actionShareWhatsappPdf.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp (PDF)'**
  String get actionShareWhatsappPdf;

  /// No description provided for @actionShareWhatsappText.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp (Text)'**
  String get actionShareWhatsappText;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get actionExportPdf;

  /// No description provided for @actionUpgradeAccount.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Account'**
  String get actionUpgradeAccount;

  /// No description provided for @appColor.
  ///
  /// In en, this message translates to:
  /// **'App Color'**
  String get appColor;

  /// No description provided for @appCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Basir Development Agents Team'**
  String get appCopyright;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Basir'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get appVersion;

  /// No description provided for @appearanceSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode, colors, fonts, and icons'**
  String get appearanceSettingsSubtitle;

  /// No description provided for @appearanceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance Settings'**
  String get appearanceSettingsTitle;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @btnAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get btnAddCustomer;

  /// No description provided for @btnCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get btnCreateAccount;

  /// No description provided for @btnDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnDelete;

  /// No description provided for @btnEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get btnEdit;

  /// No description provided for @btnDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get btnDone;

  /// No description provided for @btnRestoreDefault.
  ///
  /// In en, this message translates to:
  /// **'Restore Default'**
  String get btnRestoreDefault;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get btnSaveChanges;

  /// No description provided for @btnSaveInvoice.
  ///
  /// In en, this message translates to:
  /// **'Add Invoice'**
  String get btnSaveInvoice;

  /// No description provided for @btnSelectFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Select from Contacts'**
  String get btnSelectFromContacts;

  /// No description provided for @btnUpdateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get btnUpdateInvoice;

  /// No description provided for @calendarGregorian.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get calendarGregorian;

  /// No description provided for @calendarHijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get calendarHijri;

  /// No description provided for @calendarSelection.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred calendar system'**
  String get calendarSelection;

  /// No description provided for @colorCustomized.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get colorCustomized;

  /// No description provided for @colorDefault.
  ///
  /// In en, this message translates to:
  /// **'Default Color'**
  String get colorDefault;

  /// No description provided for @companySettingsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Company & Billing Settings'**
  String get companySettingsDialogTitle;

  /// No description provided for @customerDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetailsTitle;

  /// No description provided for @customerFormTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get customerFormTitleAdd;

  /// No description provided for @customerFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get customerFormTitleEdit;

  /// No description provided for @customersAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add New Customer'**
  String get customersAddTooltip;

  /// No description provided for @customersScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersScreenTitle;

  /// No description provided for @customersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a customer...'**
  String get customersSearchHint;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @dashboardWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your Insightful Dashboard'**
  String get dashboardWelcomeMessage;

  /// No description provided for @dialogAddItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get dialogAddItemTitle;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogOk;

  /// No description provided for @dialogCognitiveRejectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Rejected'**
  String get dialogCognitiveRejectionTitle;

  /// No description provided for @dialogCognitiveRejectionMessage.
  ///
  /// In en, this message translates to:
  /// **'The Cognitive Hexagon has rejected this transaction. Review the agent consensus below:'**
  String get dialogCognitiveRejectionMessage;

  /// No description provided for @dialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dialogSave;

  /// No description provided for @dialogTaxTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate'**
  String get dialogTaxTitle;

  /// No description provided for @editAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change username and password'**
  String get editAccountSubtitle;

  /// No description provided for @editAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Account Details'**
  String get editAccountTitle;

  /// No description provided for @labelAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get labelAddress;

  /// No description provided for @labelCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get labelCompanyName;

  /// No description provided for @labelConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get labelConfirmPassword;

  /// No description provided for @labelCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Country Code'**
  String get labelCountryCode;

  /// No description provided for @labelCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get labelCreatedDate;

  /// No description provided for @labelCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit (Optional)'**
  String get labelCreditLimit;

  /// No description provided for @labelCurrencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Currency Symbol'**
  String get labelCurrencySymbol;

  /// No description provided for @labelCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get labelCustomer;

  /// No description provided for @labelCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get labelCustomerName;

  /// No description provided for @labelDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get labelDueDate;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total:'**
  String get labelGrandTotal;

  /// No description provided for @labelInvoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get labelInvoiceItems;

  /// No description provided for @labelInvoiceNo.
  ///
  /// In en, this message translates to:
  /// **'Invoice No'**
  String get labelInvoiceNo;

  /// No description provided for @labelInvoiceStatus.
  ///
  /// In en, this message translates to:
  /// **'Invoice Status'**
  String get labelInvoiceStatus;

  /// No description provided for @labelInvoiceStyle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Style'**
  String get labelInvoiceStyle;

  /// No description provided for @labelLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get labelLastUpdated;

  /// No description provided for @labelNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get labelNewPassword;

  /// No description provided for @labelNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get labelNotes;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @labelPercentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get labelPercentage;

  /// No description provided for @labelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get labelPhone;

  /// No description provided for @labelSourceWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Source Warehouse'**
  String get labelSourceWarehouse;

  /// No description provided for @labelDestinationWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Destination Warehouse'**
  String get labelDestinationWarehouse;

  /// No description provided for @errSameWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Source and destination warehouses cannot be the same'**
  String get errSameWarehouse;

  /// No description provided for @errSelectSourceWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Please select source warehouse'**
  String get errSelectSourceWarehouse;

  /// No description provided for @errSelectDestinationWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Please select destination warehouse'**
  String get errSelectDestinationWarehouse;

  /// No description provided for @btnSaveTransfer.
  ///
  /// In en, this message translates to:
  /// **'Save Transfer'**
  String get btnSaveTransfer;

  /// No description provided for @warehouseTransferTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'New Warehouse Transfer'**
  String get warehouseTransferTitleAdd;

  /// No description provided for @labelPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get labelPrice;

  /// No description provided for @labelQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get labelQuantity;

  /// No description provided for @labelRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get labelRememberMe;

  /// No description provided for @labelSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:'**
  String get labelSubtotal;

  /// No description provided for @labelTax.
  ///
  /// In en, this message translates to:
  /// **'Tax ({rate}):'**
  String labelTax(String rate);

  /// No description provided for @labelTaxNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get labelTaxNumber;

  /// No description provided for @labelTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate'**
  String get labelTaxRate;

  /// No description provided for @labelTaxRateWithExample.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate (e.g. 0.15)'**
  String get labelTaxRateWithExample;

  /// No description provided for @labelUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get labelUsername;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get langArabic;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @loginGuest.
  ///
  /// In en, this message translates to:
  /// **'Login as Guest'**
  String get loginGuest;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Login to continue'**
  String get loginSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @modeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get modeDark;

  /// No description provided for @modeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get modeLight;

  /// No description provided for @modeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get modeSystem;

  /// No description provided for @msgAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get msgAccountCreated;

  /// No description provided for @msgAccountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account details updated successfully'**
  String get msgAccountUpdated;

  /// No description provided for @msgConfirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get msgConfirmLogout;

  /// No description provided for @msgCustomerAdded.
  ///
  /// In en, this message translates to:
  /// **'Customer added successfully'**
  String get msgCustomerAdded;

  /// No description provided for @msgCustomerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted successfully'**
  String get msgCustomerDeleted;

  /// No description provided for @msgCustomerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated successfully'**
  String get msgCustomerUpdated;

  /// No description provided for @msgGuestWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome as Guest! You can create an account later'**
  String get msgGuestWelcome;

  /// No description provided for @msgInvoiceAdded.
  ///
  /// In en, this message translates to:
  /// **'Invoice added successfully'**
  String get msgInvoiceAdded;

  /// No description provided for @msgInvoiceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Invoice updated successfully'**
  String get msgInvoiceUpdated;

  /// No description provided for @msgLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get msgLoginSuccess;

  /// No description provided for @msgLogoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get msgLogoutSuccess;

  /// No description provided for @msgNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get msgNoAccount;

  /// No description provided for @msgNoContactsFound.
  ///
  /// In en, this message translates to:
  /// **'No contacts available'**
  String get msgNoContactsFound;

  /// No description provided for @msgNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items. Press + to add.'**
  String get msgNoItems;

  /// No description provided for @msgSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get msgSettingsSaved;

  /// No description provided for @navCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// No description provided for @notificationsEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get notificationsEnable;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications for overdue invoices'**
  String get notificationsSubtitle;

  /// No description provided for @privacyFooter.
  ///
  /// In en, this message translates to:
  /// **'For more information, please visit our website.'**
  String get privacyFooter;

  /// No description provided for @privacyHeader.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy'**
  String get privacyHeader;

  /// No description provided for @privacyPoint1.
  ///
  /// In en, this message translates to:
  /// **'1. All your data is stored locally on your device'**
  String get privacyPoint1;

  /// No description provided for @privacyPoint2.
  ///
  /// In en, this message translates to:
  /// **'2. We do not collect or share any personal information'**
  String get privacyPoint2;

  /// No description provided for @privacyPoint3.
  ///
  /// In en, this message translates to:
  /// **'3. Your data is encrypted and secure'**
  String get privacyPoint3;

  /// No description provided for @privacyPoint4.
  ///
  /// In en, this message translates to:
  /// **'4. We do not use third-party tracking or analytics services'**
  String get privacyPoint4;

  /// No description provided for @privacyPoint5.
  ///
  /// In en, this message translates to:
  /// **'5. You are the sole owner of your data'**
  String get privacyPoint5;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @reduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce Motion'**
  String get reduceMotion;

  /// No description provided for @reduceMotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion effects and transitions'**
  String get reduceMotionSubtitle;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Tap to retry'**
  String get retryLabel;

  /// No description provided for @sectionAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get sectionAccessibility;

  /// No description provided for @sectionAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get sectionAdditionalInfo;

  /// No description provided for @sectionCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get sectionCalendar;

  /// No description provided for @sectionContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get sectionContactInfo;

  /// No description provided for @sectionMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get sectionMode;

  /// No description provided for @sectionStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get sectionStyle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start managing invoices'**
  String get setupSubtitle;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get setupTitle;

  /// No description provided for @splashCriticalError.
  ///
  /// In en, this message translates to:
  /// **'Critical initialization error'**
  String get splashCriticalError;

  /// No description provided for @splashInitializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get splashInitializing;

  /// No description provided for @statActiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'Active Customers'**
  String get statActiveCustomers;

  /// No description provided for @statOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statOverdue;

  /// No description provided for @statOverdueInvoices.
  ///
  /// In en, this message translates to:
  /// **'Overdue Invoices'**
  String get statOverdueInvoices;

  /// No description provided for @statPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statPaid;

  /// No description provided for @statTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statTotal;

  /// No description provided for @statTotalInvoices.
  ///
  /// In en, this message translates to:
  /// **'Total Invoices'**
  String get statTotalInvoices;

  /// No description provided for @statTotalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get statTotalSales;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get statusRefunded;

  /// No description provided for @styleCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get styleCompact;

  /// No description provided for @styleModern.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get styleModern;

  /// No description provided for @styleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get styleStandard;

  /// No description provided for @termsFooter.
  ///
  /// In en, this message translates to:
  /// **'By using the application, you agree to these terms.'**
  String get termsFooter;

  /// No description provided for @termsHeader.
  ///
  /// In en, this message translates to:
  /// **'Basir App Terms of Service'**
  String get termsHeader;

  /// No description provided for @termsOfServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get termsOfServiceSubtitle;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @termsPoint1.
  ///
  /// In en, this message translates to:
  /// **'1. The application is free for personal and commercial use'**
  String get termsPoint1;

  /// No description provided for @termsPoint2.
  ///
  /// In en, this message translates to:
  /// **'2. You are responsible for the accuracy of entered data'**
  String get termsPoint2;

  /// No description provided for @termsPoint3.
  ///
  /// In en, this message translates to:
  /// **'3. You must keep a backup of your data'**
  String get termsPoint3;

  /// No description provided for @termsPoint4.
  ///
  /// In en, this message translates to:
  /// **'4. The application is provided \'as is\' without warranties'**
  String get termsPoint4;

  /// No description provided for @termsPoint5.
  ///
  /// In en, this message translates to:
  /// **'5. We are not liable for any losses resulting from app use'**
  String get termsPoint5;

  /// No description provided for @themeColorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose App Color'**
  String get themeColorPickerTitle;

  /// No description provided for @tooltipAddInvoice.
  ///
  /// In en, this message translates to:
  /// **'Add Invoice'**
  String get tooltipAddInvoice;

  /// No description provided for @tooltipAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get tooltipAddItem;

  /// No description provided for @tooltipBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tooltipBack;

  /// No description provided for @tooltipDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get tooltipDeleteItem;

  /// No description provided for @tooltipEditCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get tooltipEditCustomer;

  /// No description provided for @tooltipEditTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Edit Tax Rate'**
  String get tooltipEditTaxRate;

  /// No description provided for @tooltipExportAll.
  ///
  /// In en, this message translates to:
  /// **'Export All'**
  String get tooltipExportAll;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// No description provided for @testEnhancedButtonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enhanced Buttons Test'**
  String get testEnhancedButtonsTitle;

  /// No description provided for @msgAccountUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Account upgraded successfully'**
  String get msgAccountUpgraded;

  /// No description provided for @labelHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get labelHome;

  /// No description provided for @labelSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get labelSettings;

  /// No description provided for @labelPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get labelPrimary;

  /// No description provided for @labelSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get labelSecondary;

  /// No description provided for @labelTestText.
  ///
  /// In en, this message translates to:
  /// **'Test Text'**
  String get labelTestText;

  /// No description provided for @testButtonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Button Tests'**
  String get testButtonsTitle;

  /// No description provided for @sectionPrimaryButtons.
  ///
  /// In en, this message translates to:
  /// **'Primary Buttons'**
  String get sectionPrimaryButtons;

  /// No description provided for @sectionSecondaryButtons.
  ///
  /// In en, this message translates to:
  /// **'Secondary Buttons'**
  String get sectionSecondaryButtons;

  /// No description provided for @sectionTextButtons.
  ///
  /// In en, this message translates to:
  /// **'Text Buttons'**
  String get sectionTextButtons;

  /// No description provided for @sectionRowButtons.
  ///
  /// In en, this message translates to:
  /// **'Button Row'**
  String get sectionRowButtons;

  /// No description provided for @sectionSpecialCases.
  ///
  /// In en, this message translates to:
  /// **'Special Cases'**
  String get sectionSpecialCases;

  /// No description provided for @msgResetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Resetting all appearance settings to default. Are you sure?'**
  String get msgResetConfirmation;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops, an unexpected error occurred'**
  String get errorTitle;

  /// No description provided for @errorDescription.
  ///
  /// In en, this message translates to:
  /// **'We are working on fixing it. Please try restarting the app.'**
  String get errorDescription;

  /// No description provided for @labelCurrencySAR.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get labelCurrencySAR;

  /// No description provided for @labelAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get labelAccounting;

  /// No description provided for @labelChartOfAccounts.
  ///
  /// In en, this message translates to:
  /// **'Chart of Accounts'**
  String get labelChartOfAccounts;

  /// No description provided for @financialSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary (Beta)'**
  String get financialSummaryTitle;

  /// No description provided for @statAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get statAssets;

  /// No description provided for @statLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get statLiabilities;

  /// No description provided for @statNetIncome.
  ///
  /// In en, this message translates to:
  /// **'Net Income'**
  String get statNetIncome;

  /// No description provided for @tooltipRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get tooltipRefresh;

  /// No description provided for @emptyAccountsMessage.
  ///
  /// In en, this message translates to:
  /// **'No accounts found. Click refresh to seed default data.'**
  String get emptyAccountsMessage;

  /// No description provided for @errorLoadingAccounts.
  ///
  /// In en, this message translates to:
  /// **'Error loading accounts'**
  String get errorLoadingAccounts;

  /// No description provided for @labelBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get labelBalance;

  /// No description provided for @labelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// No description provided for @statusPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get statusPosted;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @emptyJournalEntriesMessage.
  ///
  /// In en, this message translates to:
  /// **'No journal entries found.'**
  String get emptyJournalEntriesMessage;

  /// No description provided for @labelDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get labelDebit;

  /// No description provided for @labelCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get labelCredit;

  /// No description provided for @labelReference.
  ///
  /// In en, this message translates to:
  /// **'Reference / ID'**
  String get labelReference;

  /// No description provided for @msgColorPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a custom primary color for the application'**
  String get msgColorPickerHint;

  /// No description provided for @msgJournalEntryAdded.
  ///
  /// In en, this message translates to:
  /// **'Journal entry saved successfully'**
  String get msgJournalEntryAdded;

  /// No description provided for @errUnbalancedEntry.
  ///
  /// In en, this message translates to:
  /// **'Entry is unbalanced! Debits must equal credits.'**
  String get errUnbalancedEntry;

  /// No description provided for @btnSaveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get btnSaveEntry;

  /// No description provided for @btnPostEntry.
  ///
  /// In en, this message translates to:
  /// **'Post Entry'**
  String get btnPostEntry;

  /// No description provided for @msgJournalEntryPosted.
  ///
  /// In en, this message translates to:
  /// **'Journal entry posted successfully'**
  String get msgJournalEntryPosted;

  /// No description provided for @msgJournalEntryDrafted.
  ///
  /// In en, this message translates to:
  /// **'Journal entry saved as draft'**
  String get msgJournalEntryDrafted;

  /// No description provided for @hintJournalDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter transaction description'**
  String get hintJournalDescription;

  /// No description provided for @labelJournalEntryLines.
  ///
  /// In en, this message translates to:
  /// **'Entry Lines'**
  String get labelJournalEntryLines;

  /// No description provided for @expenseDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Distribution'**
  String get expenseDistributionTitle;

  /// No description provided for @noExpenseDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No expense data available'**
  String get noExpenseDataMessage;

  /// No description provided for @otherExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other Expenses'**
  String get otherExpensesLabel;

  /// No description provided for @trialBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Trial Balance'**
  String get trialBalanceTitle;

  /// No description provided for @btnExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get btnExport;

  /// No description provided for @labelAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get labelAccount;

  /// No description provided for @labelExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get labelExportPdf;

  /// No description provided for @labelExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV (Excel)'**
  String get labelExportCsv;

  /// No description provided for @cashFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Statement'**
  String get cashFlowTitle;

  /// No description provided for @incomeStatementTitle.
  ///
  /// In en, this message translates to:
  /// **'Income Statement'**
  String get incomeStatementTitle;

  /// No description provided for @balanceSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance Sheet'**
  String get balanceSheetTitle;

  /// No description provided for @labelOperating.
  ///
  /// In en, this message translates to:
  /// **'Operating Activities'**
  String get labelOperating;

  /// No description provided for @labelInvesting.
  ///
  /// In en, this message translates to:
  /// **'Investing Activities'**
  String get labelInvesting;

  /// No description provided for @labelFinancing.
  ///
  /// In en, this message translates to:
  /// **'Financing Activities'**
  String get labelFinancing;

  /// No description provided for @labelNetCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Net Cash Flow'**
  String get labelNetCashFlow;

  /// No description provided for @reportingOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get reportingOverviewTitle;

  /// No description provided for @trialBalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify balance of debits and credits'**
  String get trialBalanceSubtitle;

  /// No description provided for @incomeStatementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of revenues and profitability'**
  String get incomeStatementSubtitle;

  /// No description provided for @balanceSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Assets, liabilities, and equity (Fair Value supported)'**
  String get balanceSheetSubtitle;

  /// No description provided for @cashFlowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cash movement (Operating, Investing, Financing)'**
  String get cashFlowSubtitle;

  /// No description provided for @agingReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze age of customer and vendor balances'**
  String get agingReportsSubtitle;

  /// No description provided for @agingReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Aging Reports'**
  String get agingReportsTitle;

  /// No description provided for @receivablesAgingLabel.
  ///
  /// In en, this message translates to:
  /// **'Accounts Receivable (Customers)'**
  String get receivablesAgingLabel;

  /// No description provided for @payablesAgingLabel.
  ///
  /// In en, this message translates to:
  /// **'Accounts Payable (Suppliers)'**
  String get payablesAgingLabel;

  /// No description provided for @noDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataMessage;

  /// No description provided for @periodCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get periodCurrent;

  /// No description provided for @period1_30.
  ///
  /// In en, this message translates to:
  /// **'1-30 Days'**
  String get period1_30;

  /// No description provided for @period31_60.
  ///
  /// In en, this message translates to:
  /// **'31-60 Days'**
  String get period31_60;

  /// No description provided for @period61_90.
  ///
  /// In en, this message translates to:
  /// **'61-90 Days'**
  String get period61_90;

  /// No description provided for @periodOver90.
  ///
  /// In en, this message translates to:
  /// **'Over 90 Days'**
  String get periodOver90;

  /// No description provided for @labelAssets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get labelAssets;

  /// No description provided for @labelLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get labelLiabilities;

  /// No description provided for @labelEquity.
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get labelEquity;

  /// No description provided for @labelTotalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get labelTotalAssets;

  /// No description provided for @labelTotalLiabilitiesAndEquity.
  ///
  /// In en, this message translates to:
  /// **'Total Liabilities and Equity'**
  String get labelTotalLiabilitiesAndEquity;

  /// No description provided for @msgBalanceBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balance is balanced: Assets equal Liabilities and Equity.'**
  String get msgBalanceBalanced;

  /// No description provided for @msgBalanceUnbalanced.
  ///
  /// In en, this message translates to:
  /// **'Warning: Balance is unbalanced! Difference: {diff}'**
  String msgBalanceUnbalanced(String diff);

  /// No description provided for @treasuryTitle.
  ///
  /// In en, this message translates to:
  /// **'Treasury & Cash'**
  String get treasuryTitle;

  /// No description provided for @cashBalancesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash & Bank Balances'**
  String get cashBalancesTitle;

  /// No description provided for @recentVouchersTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Vouchers'**
  String get recentVouchersTitle;

  /// No description provided for @receiptVoucherAction.
  ///
  /// In en, this message translates to:
  /// **'Receipt Voucher'**
  String get receiptVoucherAction;

  /// No description provided for @paymentVoucherAction.
  ///
  /// In en, this message translates to:
  /// **'Payment Voucher'**
  String get paymentVoucherAction;

  /// No description provided for @newVoucherLabel.
  ///
  /// In en, this message translates to:
  /// **'New Voucher'**
  String get newVoucherLabel;

  /// No description provided for @noVouchersMessage.
  ///
  /// In en, this message translates to:
  /// **'No vouchers recorded'**
  String get noVouchersMessage;

  /// No description provided for @anonymousPerson.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get anonymousPerson;

  /// No description provided for @actionReverse.
  ///
  /// In en, this message translates to:
  /// **'Reverse Entry'**
  String get actionReverse;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionPostNow.
  ///
  /// In en, this message translates to:
  /// **'Post Now'**
  String get actionPostNow;

  /// No description provided for @msgConfirmReverse.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reverse this entry? This will create an automatic reversing entry.'**
  String get msgConfirmReverse;

  /// No description provided for @msgReverseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Entry reversed successfully'**
  String get msgReverseSuccess;

  /// No description provided for @labelBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get labelBalanced;

  /// No description provided for @labelUnbalanced.
  ///
  /// In en, this message translates to:
  /// **'Unbalanced'**
  String get labelUnbalanced;

  /// No description provided for @labelDiff.
  ///
  /// In en, this message translates to:
  /// **'Diff'**
  String get labelDiff;

  /// No description provided for @voucherReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'New Receipt Voucher'**
  String get voucherReceiptTitle;

  /// No description provided for @voucherPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'New Payment Voucher'**
  String get voucherPaymentTitle;

  /// No description provided for @btnSaveAndPostVoucher.
  ///
  /// In en, this message translates to:
  /// **'Save and Post Voucher'**
  String get btnSaveAndPostVoucher;

  /// No description provided for @errInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get errInvalidAmount;

  /// No description provided for @errAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get errAmountRequired;

  /// No description provided for @errDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get errDescriptionRequired;

  /// No description provided for @labelPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get labelPaymentMethod;

  /// No description provided for @methodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get methodCash;

  /// No description provided for @methodBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get methodBank;

  /// No description provided for @methodCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get methodCheck;

  /// No description provided for @labelTreasuryAccount.
  ///
  /// In en, this message translates to:
  /// **'Treasury/Bank Account'**
  String get labelTreasuryAccount;

  /// No description provided for @labelSourceClient.
  ///
  /// In en, this message translates to:
  /// **'Customer (Source)'**
  String get labelSourceClient;

  /// No description provided for @labelBeneficiaryVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor (Beneficiary)'**
  String get labelBeneficiaryVendor;

  /// No description provided for @msgVoucherSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Voucher saved and posted successfully'**
  String get msgVoucherSavedSuccess;

  /// No description provided for @errFormFill.
  ///
  /// In en, this message translates to:
  /// **'Please complete the data'**
  String get errFormFill;

  /// No description provided for @labelAccountSelector.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get labelAccountSelector;

  /// No description provided for @labelRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get labelRequired;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @errorExportingReport.
  ///
  /// In en, this message translates to:
  /// **'Error exporting report'**
  String get errorExportingReport;

  /// No description provided for @labelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get labelAmount;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @labelType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get labelType;

  /// No description provided for @labelRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get labelRevenue;

  /// No description provided for @labelExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get labelExpenses;

  /// No description provided for @labelIncomeTax.
  ///
  /// In en, this message translates to:
  /// **'Income Tax'**
  String get labelIncomeTax;

  /// No description provided for @labelNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit / Loss'**
  String get labelNetProfit;

  /// No description provided for @msgOperationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully'**
  String get msgOperationSuccess;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutAppSubtitle;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @actionAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get actionAddCustomer;

  /// No description provided for @actionAddVendor.
  ///
  /// In en, this message translates to:
  /// **'Add Vendor'**
  String get actionAddVendor;

  /// No description provided for @actionAddInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get actionAddInventoryItem;

  /// No description provided for @actionAddInvoice.
  ///
  /// In en, this message translates to:
  /// **'Add Invoice'**
  String get actionAddInvoice;

  /// No description provided for @actionDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer'**
  String get actionDeleteCustomer;

  /// No description provided for @actionDeleteVendor.
  ///
  /// In en, this message translates to:
  /// **'Delete Vendor'**
  String get actionDeleteVendor;

  /// No description provided for @actionDeleteInvoice.
  ///
  /// In en, this message translates to:
  /// **'Delete Invoice'**
  String get actionDeleteInvoice;

  /// No description provided for @titleAddVendor.
  ///
  /// In en, this message translates to:
  /// **'Add New Vendor'**
  String get titleAddVendor;

  /// No description provided for @titleEditVendor.
  ///
  /// In en, this message translates to:
  /// **'Edit Vendor Details'**
  String get titleEditVendor;

  /// No description provided for @invoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoicesTitle;

  /// No description provided for @privacyAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Analytics'**
  String get privacyAnalyticsTitle;

  /// No description provided for @privacyAnalyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage local usage data and privacy'**
  String get privacyAnalyticsSubtitle;

  /// No description provided for @analyticsEnableTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable Local Analytics'**
  String get analyticsEnableTracking;

  /// No description provided for @analyticsPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy. All analytics are stored locally on your device and we do not collect any personal or financial data. This data helps us improve the user experience and understand most used features.'**
  String get analyticsPrivacyNotice;

  /// No description provided for @analyticsClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear Analytics Data'**
  String get analyticsClearData;

  /// No description provided for @analyticsDataCleared.
  ///
  /// In en, this message translates to:
  /// **'Analytics data cleared successfully'**
  String get analyticsDataCleared;

  /// No description provided for @lastSyncLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get lastSyncLabel;

  /// No description provided for @msgNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity yet.'**
  String get msgNoActivity;

  /// No description provided for @labelJournalEntries.
  ///
  /// In en, this message translates to:
  /// **'Journal Entries'**
  String get labelJournalEntries;

  /// No description provided for @labelExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get labelExchangeRate;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Rate'**
  String get exchangeRate;

  /// No description provided for @labelBaseCurrencyEquivalent.
  ///
  /// In en, this message translates to:
  /// **'Base Currency Equivalent'**
  String get labelBaseCurrencyEquivalent;

  /// No description provided for @titleTreasuryVault.
  ///
  /// In en, this message translates to:
  /// **'The Vault (Treasury)'**
  String get titleTreasuryVault;

  /// No description provided for @labelTotalLiquidity.
  ///
  /// In en, this message translates to:
  /// **'Total Liquidity'**
  String get labelTotalLiquidity;

  /// No description provided for @labelAvailableCashBank.
  ///
  /// In en, this message translates to:
  /// **'Total Available Cash & Bank'**
  String get labelAvailableCashBank;

  /// No description provided for @labelAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get labelAccounts;

  /// No description provided for @labelForecast30Days.
  ///
  /// In en, this message translates to:
  /// **'30-Day Outlook'**
  String get labelForecast30Days;

  /// No description provided for @labelExpectedInflow.
  ///
  /// In en, this message translates to:
  /// **'Expected Inflow'**
  String get labelExpectedInflow;

  /// No description provided for @labelExpectedOutflow.
  ///
  /// In en, this message translates to:
  /// **'Expected Outflow'**
  String get labelExpectedOutflow;

  /// No description provided for @labelNetChange.
  ///
  /// In en, this message translates to:
  /// **'Net Change'**
  String get labelNetChange;

  /// No description provided for @msgNoCashAccounts.
  ///
  /// In en, this message translates to:
  /// **'No cash accounts found'**
  String get msgNoCashAccounts;

  /// No description provided for @msgInitCoa.
  ///
  /// In en, this message translates to:
  /// **'Initialize your COA or add cash accounts.'**
  String get msgInitCoa;

  /// No description provided for @originalAmount.
  ///
  /// In en, this message translates to:
  /// **'Original Amount'**
  String get originalAmount;

  /// No description provided for @labelInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Inventory Item'**
  String get labelInventoryItem;

  /// No description provided for @hintSelectInventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Select an inventory item to auto-fill'**
  String get hintSelectInventoryItem;

  /// No description provided for @labelTaxCategory.
  ///
  /// In en, this message translates to:
  /// **'Tax Category'**
  String get labelTaxCategory;

  /// No description provided for @labelSearchSku.
  ///
  /// In en, this message translates to:
  /// **'Search Barcode / SKU'**
  String get labelSearchSku;

  /// No description provided for @hintSearchSku.
  ///
  /// In en, this message translates to:
  /// **'Enter code and press Enter'**
  String get hintSearchSku;

  /// No description provided for @msgItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get msgItemNotFound;

  /// No description provided for @tooltipPrintReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print Receipt'**
  String get tooltipPrintReceipt;

  /// No description provided for @tooltipReverseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Cancel/Reverse'**
  String get tooltipReverseInvoice;

  /// No description provided for @titleReverseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Reverse Invoice'**
  String get titleReverseInvoice;

  /// No description provided for @msgConfirmReverseInvoice.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reverse this invoice? A reversing journal entry will be created.'**
  String get msgConfirmReverseInvoice;

  /// No description provided for @btnConfirmReverse.
  ///
  /// In en, this message translates to:
  /// **'Yes, Reverse Invoice'**
  String get btnConfirmReverse;

  /// No description provided for @msgInvoiceReversed.
  ///
  /// In en, this message translates to:
  /// **'Invoice reversed successfully'**
  String get msgInvoiceReversed;

  /// No description provided for @receiptTitleTaxInvoice.
  ///
  /// In en, this message translates to:
  /// **'Tax Invoice'**
  String get receiptTitleTaxInvoice;

  /// No description provided for @receiptTitleSimplified.
  ///
  /// In en, this message translates to:
  /// **'Simplified Tax Invoice'**
  String get receiptTitleSimplified;

  /// No description provided for @receiptFooterThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for visiting'**
  String get receiptFooterThanks;

  /// No description provided for @receiptFooterBrand.
  ///
  /// In en, this message translates to:
  /// **'Basir - Basir Accounting'**
  String get receiptFooterBrand;

  /// No description provided for @labelDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get labelDiscount;

  /// No description provided for @labelItemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get labelItemName;

  /// No description provided for @labelIssuedDate.
  ///
  /// In en, this message translates to:
  /// **'Issued Date'**
  String get labelIssuedDate;

  /// No description provided for @errPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action'**
  String get errPermissionDenied;

  /// No description provided for @agentRationaleStandardsPassed.
  ///
  /// In en, this message translates to:
  /// **'Compliance verified: Journal entry adheres to (IFRS/SOCPA) standards.'**
  String get agentRationaleStandardsPassed;

  /// No description provided for @agentRationaleStandardsManualReview.
  ///
  /// In en, this message translates to:
  /// **'Warning: Transaction type ({type}) requires manual review for standards compliance.'**
  String agentRationaleStandardsManualReview(String type);

  /// No description provided for @agentRationaleTaxNoId.
  ///
  /// In en, this message translates to:
  /// **'Warning: No Tax ID provided for this transaction.'**
  String get agentRationaleTaxNoId;

  /// No description provided for @agentRationaleTaxZatcaReject.
  ///
  /// In en, this message translates to:
  /// **'REJECT: Transactions exceeding 10,000 SAR require a valid Tax ID for ZATCA Phase 2 compliance.'**
  String get agentRationaleTaxZatcaReject;

  /// No description provided for @agentRationaleTaxValidated.
  ///
  /// In en, this message translates to:
  /// **'Validated Tax ID: {id}'**
  String agentRationaleTaxValidated(String id);

  /// No description provided for @agentRationaleTaxAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing VAT for {account}'**
  String agentRationaleTaxAnalyzing(String account);

  /// No description provided for @agentRationaleTaxRateMismatch.
  ///
  /// In en, this message translates to:
  /// **'ALERT: Calculated VAT rate ({rate}) deviates from the regional standard (15%).'**
  String agentRationaleTaxRateMismatch(String rate);

  /// No description provided for @agentRationaleTaxRateMatch.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM: VAT rate (15%) matches local regulatory requirements.'**
  String get agentRationaleTaxRateMatch;

  /// No description provided for @agentRationaleTaxNoVatWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: Commercial transaction detected without VAT lines.'**
  String get agentRationaleTaxNoVatWarning;

  /// No description provided for @agentRationaleForensicBalanced.
  ///
  /// In en, this message translates to:
  /// **'Check PASSED: Journal entry is balanced.'**
  String get agentRationaleForensicBalanced;

  /// No description provided for @agentRationaleForensicUnbalanced.
  ///
  /// In en, this message translates to:
  /// **'REJECTION: Proposed journal entry is not balanced.'**
  String get agentRationaleForensicUnbalanced;

  /// No description provided for @agentRationaleForensicHighValue.
  ///
  /// In en, this message translates to:
  /// **'WARNING: Unusually high transaction amount detected ({amount}). Administrative review recommended.'**
  String agentRationaleForensicHighValue(String amount);

  /// No description provided for @agentRationaleForensicDuplicate.
  ///
  /// In en, this message translates to:
  /// **'REJECTION: Duplicate reference number ({ref}) detected in history.'**
  String agentRationaleForensicDuplicate(String ref);

  /// No description provided for @agentRationaleOperationalSufficient.
  ///
  /// In en, this message translates to:
  /// **'Liquidity Analysis: {account} balance is sufficient ({balance}) for this operation.'**
  String agentRationaleOperationalSufficient(String account, String balance);

  /// No description provided for @agentRationaleOperationalInsufficient.
  ///
  /// In en, this message translates to:
  /// **'REJECTION: {account} balance is insufficient ({balance}) for this operation.'**
  String agentRationaleOperationalInsufficient(String account, String balance);

  /// No description provided for @agentRationaleStrategyOutflow.
  ///
  /// In en, this message translates to:
  /// **'Strategy Analysis: This entry represents a cash outflow of {amount}.'**
  String agentRationaleStrategyOutflow(String amount);

  /// No description provided for @agentRationaleStrategyRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation: Review cash flow projections for the coming week to ensure sufficient liquidity for other obligations.'**
  String get agentRationaleStrategyRecommendation;

  /// No description provided for @agentRationaleStrategyInflow.
  ///
  /// In en, this message translates to:
  /// **'Strategy Analysis: Liquidity enhancement of {amount} supports short-term investment capacity.'**
  String agentRationaleStrategyInflow(String amount);

  /// No description provided for @agentRationaleStrategyProfitability.
  ///
  /// In en, this message translates to:
  /// **'Strategic Insight: Increased sales volume positively impacts Return on Assets (ROA) and net margin targets.'**
  String get agentRationaleStrategyProfitability;

  /// No description provided for @agentRationaleSustainabilityFlagged.
  ///
  /// In en, this message translates to:
  /// **'ISSB Analysis: This transaction is flagged for mandatory environmental/social disclosure.'**
  String get agentRationaleSustainabilityFlagged;

  /// No description provided for @agentRationaleSustainabilityReject.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL REJECTION: ISSB S2 standards require carbon footprint metrics for this industry-specific transaction.'**
  String get agentRationaleSustainabilityReject;

  /// No description provided for @agentRationaleSustainabilitySuccess.
  ///
  /// In en, this message translates to:
  /// **'SUCCESS: Integrated {count} compliant sustainability metrics.'**
  String agentRationaleSustainabilitySuccess(int count);

  /// No description provided for @agentRationaleSustainabilityNotRequired.
  ///
  /// In en, this message translates to:
  /// **'Sustainability Assessment: No specific ISSB disclosures required for this transaction tier.'**
  String get agentRationaleSustainabilityNotRequired;

  /// No description provided for @agentRationaleForensicTimeAnomaly.
  ///
  /// In en, this message translates to:
  /// **'WARNING: Transaction recorded during non-standard hours ({time}). Higher forensic weighting applied.'**
  String agentRationaleForensicTimeAnomaly(String time);

  /// No description provided for @agentRationaleForensicSequenceGap.
  ///
  /// In en, this message translates to:
  /// **'NOTICE: Gap detected in reference sequence. Last: {last}, Current: {current}.'**
  String agentRationaleForensicSequenceGap(String last, String current);

  /// No description provided for @agentRationaleForensicZatcaIdentityMissing.
  ///
  /// In en, this message translates to:
  /// **'NOTICE: ZATCA Phase 2 cryptographic identity (UUID/Hash) is missing for this invoice.'**
  String get agentRationaleForensicZatcaIdentityMissing;

  /// No description provided for @auditTrailTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get auditTrailTitle;

  /// No description provided for @auditTrailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Internal system logs and consensus bypasses'**
  String get auditTrailSubtitle;

  /// No description provided for @auditTrailSectionForensic.
  ///
  /// In en, this message translates to:
  /// **'Forensic Integrity Logs'**
  String get auditTrailSectionForensic;

  /// No description provided for @auditTrailNoLogs.
  ///
  /// In en, this message translates to:
  /// **'No audit logs found for the selected period.'**
  String get auditTrailNoLogs;

  /// No description provided for @msgInvoiceCognitiveHint.
  ///
  /// In en, this message translates to:
  /// **'Use this screen to create or edit invoices. Ensure meticulous accuracy with tax rates and item selection.'**
  String get msgInvoiceCognitiveHint;

  /// No description provided for @titleInvoiceCognitiveHint.
  ///
  /// In en, this message translates to:
  /// **'Invoice Mastery'**
  String get titleInvoiceCognitiveHint;

  /// No description provided for @labelReturnsAndDamages.
  ///
  /// In en, this message translates to:
  /// **'Returns & Damages'**
  String get labelReturnsAndDamages;

  /// No description provided for @labelSalesReturn.
  ///
  /// In en, this message translates to:
  /// **'Sales Return'**
  String get labelSalesReturn;

  /// No description provided for @descSalesReturn.
  ///
  /// In en, this message translates to:
  /// **'Return sold items to inventory'**
  String get descSalesReturn;

  /// No description provided for @labelPurchaseReturn.
  ///
  /// In en, this message translates to:
  /// **'Purchase Return'**
  String get labelPurchaseReturn;

  /// No description provided for @descPurchaseReturn.
  ///
  /// In en, this message translates to:
  /// **'Return purchased items to vendor'**
  String get descPurchaseReturn;

  /// No description provided for @labelDamageInvoice.
  ///
  /// In en, this message translates to:
  /// **'Damage Invoice'**
  String get labelDamageInvoice;

  /// No description provided for @descDamageInvoice.
  ///
  /// In en, this message translates to:
  /// **'Record damaged or missing items'**
  String get descDamageInvoice;

  /// No description provided for @labelEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get labelEmailOptional;

  /// No description provided for @labelPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (Optional)'**
  String get labelPhoneOptional;

  /// No description provided for @labelAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (Optional)'**
  String get labelAddressOptional;

  /// No description provided for @labelNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get labelNotesOptional;

  /// No description provided for @msgConfirmDeleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete customer {name}?'**
  String msgConfirmDeleteCustomer(String name);

  /// No description provided for @msgConfirmDeleteInvoice.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this invoice?'**
  String get msgConfirmDeleteInvoice;

  /// No description provided for @dashboardBasirSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Basir Accounting System'**
  String get dashboardBasirSystemTitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get dashboardStatsTitle;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardRecentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashboardRecentActivityTitle;

  /// No description provided for @dashboardMotto.
  ///
  /// In en, this message translates to:
  /// **'Professional Accounting Made Simple'**
  String get dashboardMotto;

  /// No description provided for @saveLabels.
  ///
  /// In en, this message translates to:
  /// **'Save Labels'**
  String get saveLabels;

  /// No description provided for @errInvalidResetLink.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired reset link'**
  String get errInvalidResetLink;

  /// No description provided for @errInvalidResetToken.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired reset token'**
  String get errInvalidResetToken;

  /// No description provided for @msgPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get msgPasswordResetSuccess;

  /// No description provided for @errPasswordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed'**
  String get errPasswordResetFailed;

  /// No description provided for @errPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errPasswordRequired;

  /// No description provided for @errPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get errPasswordTooShort;

  /// No description provided for @errPasswordNeedsUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password needs uppercase letter'**
  String get errPasswordNeedsUppercase;

  /// No description provided for @errPasswordNeedsLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password needs lowercase letter'**
  String get errPasswordNeedsLowercase;

  /// No description provided for @errPasswordNeedsNumber.
  ///
  /// In en, this message translates to:
  /// **'Password needs a number'**
  String get errPasswordNeedsNumber;

  /// No description provided for @errConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get errConfirmPasswordRequired;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password for {email}'**
  String resetPasswordSubtitle(String email);

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get passwordRequirements;

  /// No description provided for @passwordRequirementsList.
  ///
  /// In en, this message translates to:
  /// **'• At least 8 characters\n• One uppercase letter\n• One lowercase letter\n• One number'**
  String get passwordRequirementsList;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @labelVatNumber.
  ///
  /// In en, this message translates to:
  /// **'VAT Number'**
  String get labelVatNumber;

  /// No description provided for @labelRegistrationNumber.
  ///
  /// In en, this message translates to:
  /// **'Registration Number (CR)'**
  String get labelRegistrationNumber;

  /// No description provided for @labelTotalPayables.
  ///
  /// In en, this message translates to:
  /// **'Total Payables to Vendors'**
  String get labelTotalPayables;

  /// No description provided for @msgValueCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Value copied to clipboard'**
  String get msgValueCopiedToClipboard;

  /// No description provided for @labelSourceDocument.
  ///
  /// In en, this message translates to:
  /// **'Source Document'**
  String get labelSourceDocument;

  /// No description provided for @btnViewSource.
  ///
  /// In en, this message translates to:
  /// **'View Source'**
  String get btnViewSource;

  /// No description provided for @msgLoadingSource.
  ///
  /// In en, this message translates to:
  /// **'Loading source document...'**
  String get msgLoadingSource;

  /// No description provided for @errSourceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Source document not found'**
  String get errSourceNotFound;

  /// No description provided for @agentSuggestionIfrs18Category.
  ///
  /// In en, this message translates to:
  /// **'IFRS 18 Category Suggestion'**
  String get agentSuggestionIfrs18Category;

  /// No description provided for @agentSuggestionIfrs18CategoryReason.
  ///
  /// In en, this message translates to:
  /// **'IFRS 18 requires specific classification for sales commissions.'**
  String get agentSuggestionIfrs18CategoryReason;

  /// No description provided for @agentSuggestionVatCorrection.
  ///
  /// In en, this message translates to:
  /// **'VAT Rate Correction'**
  String get agentSuggestionVatCorrection;

  /// No description provided for @agentSuggestionMissingVatLine.
  ///
  /// In en, this message translates to:
  /// **'Missing VAT Line'**
  String get agentSuggestionMissingVatLine;

  /// No description provided for @agentSuggestionMissingVatLineReason.
  ///
  /// In en, this message translates to:
  /// **'Sales transaction usually requires 15% VAT per ZATCA/IFRS.'**
  String get agentSuggestionMissingVatLineReason;

  /// No description provided for @agentSuggestionWarehouseOptimization.
  ///
  /// In en, this message translates to:
  /// **'Warehouse Optimization'**
  String get agentSuggestionWarehouseOptimization;

  /// No description provided for @agentSuggestionWarehouseOptimizationReason.
  ///
  /// In en, this message translates to:
  /// **'Check \"Central Hub\" or \"Riyadh Branch\" for stock transfer.'**
  String get agentSuggestionWarehouseOptimizationReason;

  /// No description provided for @agentSuggestionStrategicDiscount.
  ///
  /// In en, this message translates to:
  /// **'Strategic Discount'**
  String get agentSuggestionStrategicDiscount;

  /// No description provided for @agentSuggestionStrategicDiscountReason.
  ///
  /// In en, this message translates to:
  /// **'Offer a 2% discount for payments within 10 days to maximize liquidity.'**
  String get agentSuggestionStrategicDiscountReason;

  /// No description provided for @agentSuggestionIssbMetrics.
  ///
  /// In en, this message translates to:
  /// **'ISSB Disclosure'**
  String get agentSuggestionIssbMetrics;

  /// No description provided for @agentSuggestionIssbMetricsReason.
  ///
  /// In en, this message translates to:
  /// **'Attach quantitative resource usage metrics (liters/kWh) for compliance.'**
  String get agentSuggestionIssbMetricsReason;

  /// No description provided for @labelAiSmartSuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Smart Suggestions'**
  String get labelAiSmartSuggestions;

  /// No description provided for @labelTarget.
  ///
  /// In en, this message translates to:
  /// **'Target:'**
  String get labelTarget;

  /// No description provided for @msgForensicSequenceClean.
  ///
  /// In en, this message translates to:
  /// **'Sequence verification complete: No anomalies detected.'**
  String get msgForensicSequenceClean;

  /// No description provided for @msgForensicRisksDetected.
  ///
  /// In en, this message translates to:
  /// **'Forensic analysis detected institutional risks.'**
  String get msgForensicRisksDetected;

  /// No description provided for @msgForensicEngineError.
  ///
  /// In en, this message translates to:
  /// **'Forensic scan failed: Internal engine error.'**
  String get msgForensicEngineError;

  /// No description provided for @msgForensicLedgerClean.
  ///
  /// In en, this message translates to:
  /// **'Historical ledger scrutiny complete: No anomalies found.'**
  String get msgForensicLedgerClean;

  /// No description provided for @msgForensicLedgerAnomalies.
  ///
  /// In en, this message translates to:
  /// **'Forensic anomalies detected in historical ledger.'**
  String get msgForensicLedgerAnomalies;

  /// No description provided for @errForensicImbalance.
  ///
  /// In en, this message translates to:
  /// **'Imbalance detected: Entry #{id} is not balanced.'**
  String errForensicImbalance(Object id);

  /// No description provided for @errForensicDiscrepancy.
  ///
  /// In en, this message translates to:
  /// **'Integrity discrepancy: Entry #{id} has total debit/sum mismatch.'**
  String errForensicDiscrepancy(Object id);

  /// No description provided for @errForensicHashBreach.
  ///
  /// In en, this message translates to:
  /// **'Integrity Breach: Hash chain broken between #{prev} and #{curr}'**
  String errForensicHashBreach(Object curr, Object prev);

  /// No description provided for @titleForensicPortal.
  ///
  /// In en, this message translates to:
  /// **'Forensic Integrity Portal'**
  String get titleForensicPortal;

  /// No description provided for @labelIntegrityPulse.
  ///
  /// In en, this message translates to:
  /// **'Integrity Pulse'**
  String get labelIntegrityPulse;

  /// No description provided for @labelLastVerified.
  ///
  /// In en, this message translates to:
  /// **'Last verified:'**
  String get labelLastVerified;

  /// No description provided for @labelBlocksScanned.
  ///
  /// In en, this message translates to:
  /// **'Blocks Scanned:'**
  String get labelBlocksScanned;

  /// No description provided for @labelHealth.
  ///
  /// In en, this message translates to:
  /// **'Health:'**
  String get labelHealth;

  /// No description provided for @labelLedgerMutationTimeline.
  ///
  /// In en, this message translates to:
  /// **'Ledger Mutation Timeline'**
  String get labelLedgerMutationTimeline;

  /// No description provided for @labelHashChain.
  ///
  /// In en, this message translates to:
  /// **'Immutable Hash Chain'**
  String get labelHashChain;

  /// No description provided for @labelVerifiedBy.
  ///
  /// In en, this message translates to:
  /// **'Verified by:'**
  String get labelVerifiedBy;

  /// No description provided for @titleStrategicOutlook.
  ///
  /// In en, this message translates to:
  /// **'Strategic Outlook & Forecasting'**
  String get titleStrategicOutlook;

  /// No description provided for @labelPredictivePnL.
  ///
  /// In en, this message translates to:
  /// **'Predictive P&L Analysis'**
  String get labelPredictivePnL;

  /// No description provided for @labelCashFlowProjection.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Projection'**
  String get labelCashFlowProjection;

  /// No description provided for @labelStrategicInsights.
  ///
  /// In en, this message translates to:
  /// **'Strategic AI Insights'**
  String get labelStrategicInsights;

  /// No description provided for @labelProjectedRevenue.
  ///
  /// In en, this message translates to:
  /// **'Projected Revenue'**
  String get labelProjectedRevenue;

  /// No description provided for @labelProjectedExpense.
  ///
  /// In en, this message translates to:
  /// **'Projected Expenses'**
  String get labelProjectedExpense;

  /// No description provided for @labelProjectedNetIncome.
  ///
  /// In en, this message translates to:
  /// **'Projected Net Income'**
  String get labelProjectedNetIncome;

  /// No description provided for @labelConfidenceScore.
  ///
  /// In en, this message translates to:
  /// **'AI Confidence Score'**
  String get labelConfidenceScore;

  /// No description provided for @msgNoStrategicData.
  ///
  /// In en, this message translates to:
  /// **'Insufficient historical data for accurate forecasting. Please post more transactions.'**
  String get msgNoStrategicData;

  /// No description provided for @actionEmailInvoice.
  ///
  /// In en, this message translates to:
  /// **'Email Invoice'**
  String get actionEmailInvoice;

  /// No description provided for @searchInvoicesHint.
  ///
  /// In en, this message translates to:
  /// **'Search invoices, customers, or numbers'**
  String get searchInvoicesHint;

  /// No description provided for @searchInvoicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Search invoices'**
  String get searchInvoicesLabel;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldest;

  /// No description provided for @sortAmountDesc.
  ///
  /// In en, this message translates to:
  /// **'Highest amount'**
  String get sortAmountDesc;

  /// No description provided for @sortAmountAsc.
  ///
  /// In en, this message translates to:
  /// **'Lowest amount'**
  String get sortAmountAsc;

  /// No description provided for @sortCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get sortCustomer;

  /// No description provided for @sortDueDateAsc.
  ///
  /// In en, this message translates to:
  /// **'Due date (soonest)'**
  String get sortDueDateAsc;

  /// No description provided for @filterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get filterCancelled;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No invoices match your search'**
  String get noSearchResults;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(String count);

  /// No description provided for @resultsCountZero.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get resultsCountZero;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort invoices'**
  String get sortTooltip;

  /// No description provided for @clearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchTooltip;

  /// No description provided for @shellSearchAll.
  ///
  /// In en, this message translates to:
  /// **'Search everything'**
  String get shellSearchAll;

  /// No description provided for @shellSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search invoices, customers, items...'**
  String get shellSearchHint;

  /// No description provided for @shellToggleNav.
  ///
  /// In en, this message translates to:
  /// **'Collapse/expand navigation bar'**
  String get shellToggleNav;

  /// No description provided for @shellOrgLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get shellOrgLabel;

  /// No description provided for @shellBranchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get shellBranchLabel;

  /// No description provided for @shellPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get shellPeriodLabel;

  /// No description provided for @shellCurrentOrg.
  ///
  /// In en, this message translates to:
  /// **'Default Organization'**
  String get shellCurrentOrg;

  /// No description provided for @shellCurrentBranch.
  ///
  /// In en, this message translates to:
  /// **'Main Branch'**
  String get shellCurrentBranch;

  /// No description provided for @shellCurrentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Current Fiscal Period'**
  String get shellCurrentPeriod;

  /// No description provided for @shellNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get shellNotifications;

  /// No description provided for @shellSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get shellSearchResults;

  /// No description provided for @shellNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get shellNoResults;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @shellCloseSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get shellCloseSearch;

  /// No description provided for @workStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get workStatusDraft;

  /// No description provided for @workStatusPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get workStatusPendingApproval;

  /// No description provided for @workStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get workStatusApproved;

  /// No description provided for @workStatusPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get workStatusPosted;

  /// No description provided for @workStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get workStatusCancelled;

  /// No description provided for @workStatusReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get workStatusReversed;

  /// No description provided for @workAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit Trail'**
  String get workAuditTitle;

  /// No description provided for @workAuditEmpty.
  ///
  /// In en, this message translates to:
  /// **'No audit events yet.'**
  String get workAuditEmpty;

  /// No description provided for @workAuditLinkedDoc.
  ///
  /// In en, this message translates to:
  /// **'Linked document: {arg0}'**
  String workAuditLinkedDoc(Object arg0);

  /// No description provided for @workAuditOpenLinked.
  ///
  /// In en, this message translates to:
  /// **'Open linked document {arg0}'**
  String workAuditOpenLinked(Object arg0);

  /// No description provided for @workAuditEventCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get workAuditEventCreated;

  /// No description provided for @workAuditEventModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get workAuditEventModified;

  /// No description provided for @workAuditEventApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get workAuditEventApproved;

  /// No description provided for @workAuditEventReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned for revision'**
  String get workAuditEventReturned;

  /// No description provided for @workAuditEventPosted.
  ///
  /// In en, this message translates to:
  /// **'Posted'**
  String get workAuditEventPosted;

  /// No description provided for @workAuditEventCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get workAuditEventCancelled;

  /// No description provided for @workAuditEventReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get workAuditEventReversed;

  /// No description provided for @workAuditEventAdministrative.
  ///
  /// In en, this message translates to:
  /// **'Administrative action'**
  String get workAuditEventAdministrative;

  /// No description provided for @workGridEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records found.'**
  String get workGridEmpty;

  /// No description provided for @workGridSortableColumn.
  ///
  /// In en, this message translates to:
  /// **'{arg0}, sortable column'**
  String workGridSortableColumn(Object arg0);

  /// No description provided for @workFilterSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search in documents, customers, and items...'**
  String get workFilterSearchHint;

  /// No description provided for @workFilterExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get workFilterExport;

  /// No description provided for @workFilterCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse filters'**
  String get workFilterCollapse;

  /// No description provided for @workGridSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get workGridSelect;

  /// No description provided for @workGridRow.
  ///
  /// In en, this message translates to:
  /// **'Table row'**
  String get workGridRow;

  /// No description provided for @workDocumentSummary.
  ///
  /// In en, this message translates to:
  /// **'Document summary'**
  String get workDocumentSummary;

  /// No description provided for @workDocumentRequestPreview.
  ///
  /// In en, this message translates to:
  /// **'Request preview'**
  String get workDocumentRequestPreview;

  /// No description provided for @workDocumentPreviewImpact.
  ///
  /// In en, this message translates to:
  /// **'Preview impact'**
  String get workDocumentPreviewImpact;

  /// No description provided for @workDocumentSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as draft'**
  String get workDocumentSaveDraft;

  /// No description provided for @workDocumentPost.
  ///
  /// In en, this message translates to:
  /// **'Confirm posting'**
  String get workDocumentPost;

  /// No description provided for @workDocumentPreviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Request an impact preview before posting.'**
  String get workDocumentPreviewRequired;

  /// No description provided for @workDocumentApprovalRequired.
  ///
  /// In en, this message translates to:
  /// **'Additional approval required'**
  String get workDocumentApprovalRequired;

  /// No description provided for @workDocumentNoImpact.
  ///
  /// In en, this message translates to:
  /// **'No movements are expected.'**
  String get workDocumentNoImpact;

  /// No description provided for @workEntityPickerNoOptions.
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get workEntityPickerNoOptions;

  /// No description provided for @workEntityPickerDisabled.
  ///
  /// In en, this message translates to:
  /// **'Not eligible for selection'**
  String get workEntityPickerDisabled;

  /// Generic response shown after requesting password recovery.
  String get msgPasswordResetRequested;

  /// Generic recovery failure message.
  String get msgPasswordResetFailed;
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
