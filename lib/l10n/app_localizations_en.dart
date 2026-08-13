// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Basir';

  @override
  String get labelStandard => 'Accounting Standard';

  @override
  String get labelRecognitionBasis => 'Recognition Basis';

  @override
  String get labelMeasurementBasis => 'Measurement Basis';

  @override
  String get labelCurrency => 'Currency';

  @override
  String get labelAddCurrency => 'Add Currency';

  @override
  String get labelPartner => 'Partner';

  @override
  String get labelAccountCode => 'Account Code';

  @override
  String get labelAccountName => 'Account Name';

  @override
  String get labelFairValueAdjustment => 'Fair Value Adjustment (IFRS 13)';

  @override
  String get subtitleFairValueAdjustment =>
      'Use latest market prices for inventory';

  @override
  String get labelTotalAmount => 'Total Amount';

  @override
  String get msgBalanceBalancedTB => 'Balance is balanced (Balanced)';

  @override
  String get msgBalanceUnbalancedTB => 'Balance is unbalanced! Please review.';

  @override
  String get sectionBasicReports => 'Basic Reports';

  @override
  String get sectionFinancialStatements => 'Financial Statements (IAS 1/IFRS)';

  @override
  String get sectionAgingAnalysis => 'Aging Analysis';

  @override
  String get receivablesAgingTitle => 'Receivables Aging';

  @override
  String get payablesAgingTitle => 'Payables Aging';

  @override
  String get labelGeneralLedger => 'General Ledger';

  @override
  String get labelPeriod => 'Period';

  @override
  String get msgNoTransactionsFound => 'No transactions found';

  @override
  String get msgExportComingSoon => 'Export feature coming soon';

  @override
  String get appearanceTitle => 'Appearance & Customization';

  @override
  String get companySettingsTitle => 'Company & Billing Settings';

  @override
  String errContactAccess(String error) {
    return 'Contact access error: $error';
  }

  @override
  String get errCustomerAdd => 'Failed to add customer';

  @override
  String get errCustomerDelete => 'Failed to delete customer';

  @override
  String get errCustomerNameLength => 'Name must be at least 2 characters';

  @override
  String get errCustomerNameRequired => 'Customer name is required';

  @override
  String get errCustomerUpdate => 'Failed to update customer';

  @override
  String get errEmptyField => 'This field is required';

  @override
  String errGeneric(String error) {
    return 'Error occurred: $error';
  }

  @override
  String get errInvalidEmail => 'Invalid email address';

  @override
  String get errInvalidNumber => 'Please enter a valid number';

  @override
  String get errInvoiceAdd => 'Failed to add invoice';

  @override
  String get errInvoiceUpdate => 'Failed to update invoice';

  @override
  String errLoadCustomers(String error) {
    return 'Error loading customers: $error';
  }

  @override
  String get errLoginFailed => 'Login failed. Please check your credentials.';

  @override
  String get errNoItems => 'Please add at least one item';

  @override
  String get errPasswordShort => 'Password must be at least 6 characters';

  @override
  String get errPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errPhoneLength => 'Phone must be 10 digits';

  @override
  String get errPhoneStart05 => 'Phone must start with 05';

  @override
  String get errSelectCustomer => 'Please select a customer';

  @override
  String get errUsernameShort => 'Username must be at least 3 characters';

  @override
  String get errorCustomerNotFound => 'Customer data not found';

  @override
  String get errorCustomerPhone => 'Customer phone not available';

  @override
  String get errorLoadingInvoices => 'Error loading invoices';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String errorScreenNotFound(String name) {
    return 'Screen not found: $name';
  }

  @override
  String errorSharePdf(String error) {
    return 'Error sharing PDF: $error';
  }

  @override
  String errorShareWhatsapp(String error) {
    return 'Error sharing via WhatsApp: $error';
  }

  @override
  String get filterAll => 'All';

  @override
  String get filterDraft => 'Draft';

  @override
  String get filterIssued => 'Issued';

  @override
  String get filterOverdue => 'Overdue';

  @override
  String get filterPaid => 'Paid';

  @override
  String get fontCairo => 'Cairo (Default)';

  @override
  String get fontRoboto => 'Roboto';

  @override
  String get fontSettingsTitle => 'Font Type';

  @override
  String get fontSizeLabel => 'Text Size';

  @override
  String get taxConfigTitle => 'Tax & E-Invoicing';

  @override
  String get zatcaPhase2Title => 'ZATCA E-Invoicing (Phase 2)';

  @override
  String get zatcaPhase2Description =>
      'Configure your settings for compliance with Saudi ZATCA Phase 2 (Integration Phase).';

  @override
  String get enableTax => 'Enable Tax on Invoices';

  @override
  String get priceIncludesTax => 'Price includes tax by default';

  @override
  String get vatNumber => 'Tax ID / VAT Number';

  @override
  String get defaultTaxRate => 'Default Tax Value (%)';

  @override
  String get b2cSimplifiedLabel => 'B2C Simplified Invoice Label';

  @override
  String get b2bStandardLabel => 'B2B Standard Invoice Label';

  @override
  String get taxName => 'Tax Name';

  @override
  String get taxPercentage => 'Percentage (%)';

  @override
  String get taxShow => 'Show';

  @override
  String get taxDefault => 'Default';

  @override
  String get printSettingsTitle => 'Printing & Templates';

  @override
  String get printSettingsSubtitle =>
      'Manage your printing formats and templates';

  @override
  String get templateSelection => 'Template Selection';

  @override
  String get paperSize => 'Paper Size';

  @override
  String get fontSize => 'Font Size';

  @override
  String get paddingBottom => 'Empty lines at end';

  @override
  String get printCopies => 'Number of copies';

  @override
  String get printItemUnit => 'Show item unit in print';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get guestUpgradeDescription =>
      'Convert your guest account to a permanent account to save your data securely.';

  @override
  String get helpTitle => 'Help & Support';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get highContrastSubtitle => 'Increase text and element clarity';

  @override
  String get hintAddress => 'Enter customer address';

  @override
  String get hintCompanyName => 'Enter your company name';

  @override
  String get hintConfirmPassword => 'Re-enter password';

  @override
  String get hintCurrencySymbol => 'SAR';

  @override
  String get hintCustomerName => 'Enter customer name';

  @override
  String get hintCustomerNotes => 'Add customer notes';

  @override
  String get hintEnterNewPassword => 'Enter new password';

  @override
  String get hintEnterNewUsername => 'Enter new username';

  @override
  String get hintEnterPassword => 'Please enter password';

  @override
  String get hintEnterUsername => 'Please enter username';

  @override
  String get hintNotes => 'Add invoice notes';

  @override
  String get hintSelectCustomer => 'Select Customer';

  @override
  String get hintTaxNumber => 'Enter tax number (optional)';

  @override
  String get iconCupertino => 'Cupertino (iOS)';

  @override
  String get iconMaterial => 'Material Design';

  @override
  String get iconSettingsTitle => 'Icon Style';

  @override
  String get journalEntryFormTitleAdd => 'Add Journal Entry';

  @override
  String get journalEntryFormTitleEdit => 'Edit Journal Entry';

  @override
  String get invoiceFormTitleAdd => 'Add New Invoice';

  @override
  String get invoiceFormTitleAddPurchase => 'Add Purchase Invoice';

  @override
  String get invoiceFormTitleEdit => 'Edit Invoice';

  @override
  String invoiceTitle(String id) {
    return 'Invoice $id';
  }

  @override
  String get calculatorTitle => 'Financial Calculator';

  @override
  String get convertToCurrencies => 'Convert to currencies';

  @override
  String get clear => 'Clear';

  @override
  String get labelTermsAndConditions => 'Terms and Conditions';

  @override
  String get labelPaidDate => 'Paid Date';

  @override
  String get labelDiscountAmount => 'Discount Amount';

  @override
  String get labelZatcaQrCode => 'QR Code (ZATCA)';

  @override
  String get labelZatcaUuid => 'ZATCA UUID';

  @override
  String get labelZatcaHash => 'Invoice Hash';

  @override
  String get labelTaxTotal => 'Total Tax';

  @override
  String get labelVatRate => 'VAT Rate';

  @override
  String get zatcaComplianceText =>
      'This invoice is compliant with ZATCA electronic invoicing requirements.';

  @override
  String get actionCreateFirstInvoice => 'Create Your First Invoice';

  @override
  String get noInvoicesTitle => 'No Invoices Found';

  @override
  String get noInvoicesDescription =>
      'Start by adding your first invoice to manage your sales professionally.';

  @override
  String get labelFromDate => 'From Date';

  @override
  String get labelToDate => 'To Date';

  @override
  String get labelAsOfDate => 'As of Date';

  @override
  String get tooltipUpdateReport => 'Update Report';

  @override
  String get labelCogsAccountId => 'COGS Account';

  @override
  String get labelRevenueAccountId => 'Revenue Account';

  @override
  String get labelValuationMethod => 'Valuation Method';

  @override
  String get labelInventoryValuation => 'Inventory Valuation (IAS 2)';

  @override
  String get logoutLabel => 'Logout';

  @override
  String msgInvoiceShare(String name, String id, String total, String symbol) {
    return 'Hello $name, here is invoice #$id:\nTotal: $total $symbol\nThank you.';
  }

  @override
  String msgSaveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navInvoices => 'Invoices';

  @override
  String get navSettings => 'Settings';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String pdfShareSubject(String id) {
    return 'Invoice $id';
  }

  @override
  String pdfShareText(String customerName) {
    return 'Here is the invoice for $customerName';
  }

  @override
  String placeholderComingSoon(String title) {
    return 'Coming soon: $title';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutAppTitle => 'About App';

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
  String get aboutFeaturesTitle => 'Key Features:';

  @override
  String get titleAddInventoryItem => 'Add New Item';

  @override
  String get titleEditInventoryItem => 'Edit Item Details';

  @override
  String get vendorsScreenTitle => 'Vendors';

  @override
  String get vendorsSearchHint => 'Search vendors...';

  @override
  String get navVendors => 'Vendors';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navAssets => 'Assets';

  @override
  String get labelNameAr => 'Name (Arabic)';

  @override
  String get labelNameEn => 'Name (English)';

  @override
  String get tooltipAddVendor => 'Add New Vendor';

  @override
  String get tooltipEditVendor => 'Edit Vendor';

  @override
  String get tooltipDeleteVendor => 'Delete Vendor';

  @override
  String msgConfirmDeleteVendor(String name) {
    return 'Are you sure you want to delete vendor $name?';
  }

  @override
  String msgConfirmDeleteItem(String name) {
    return 'Are you sure you want to delete item $name?';
  }

  @override
  String get dialogDelete => 'Delete';

  @override
  String get inventoryItemsScreenTitle => 'Inventory';

  @override
  String get assetsScreenTitle => 'Fixed Assets';

  @override
  String get assetsSearchHint => 'Search assets...';

  @override
  String get actionAddAsset => 'Add Asset';

  @override
  String get tooltipAddAsset => 'Add New Asset';

  @override
  String get titleAddAsset => 'Add New Asset';

  @override
  String get titleEditAsset => 'Edit Asset Details';

  @override
  String get labelCode => 'Asset Code';

  @override
  String get labelPurchaseDate => 'Purchase Date';

  @override
  String get labelCost => 'Purchase Cost';

  @override
  String get labelSalvageValue => 'Salvage Value';

  @override
  String get labelUsefulLife => 'Useful Life (Years)';

  @override
  String get labelDepreciationMethod => 'Depreciation Method';

  @override
  String get labelDepreciationAccountId => 'Depreciation Expense Account';

  @override
  String get labelAccumDepreciationAccountId =>
      'Accumulated Depreciation Account';

  @override
  String get labelAssetAccountId => 'Inventory Account (Assets)';

  @override
  String get inventoryItemsSearchHint => 'Search inventory...';

  @override
  String get labelSKU => 'SKU';

  @override
  String get labelPurchasePrice => 'Purchase Price';

  @override
  String get labelSalePrice => 'Sale Price';

  @override
  String get labelUnit => 'Unit';

  @override
  String get labelCategoryId => 'Category';

  @override
  String get tooltipAddInventoryItem => 'Add New Item';

  @override
  String get actionSharePdf => 'Share PDF';

  @override
  String get actionShareWhatsappPdf => 'Share via WhatsApp (PDF)';

  @override
  String get actionShareWhatsappText => 'Share via WhatsApp (Text)';

  @override
  String get actionShare => 'Share';

  @override
  String get actionExportPdf => 'Export PDF';

  @override
  String get actionUpgradeAccount => 'Upgrade Account';

  @override
  String get appColor => 'App Color';

  @override
  String get appCopyright => '© 2025 Basir Development Agents Team';

  @override
  String get appName => 'Basir';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appearanceSettingsSubtitle =>
      'Dark mode, colors, fonts, and icons';

  @override
  String get appearanceSettingsTitle => 'Appearance Settings';

  @override
  String get btnAdd => 'Add';

  @override
  String get btnAddCustomer => 'Add Customer';

  @override
  String get btnCreateAccount => 'Create New Account';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnEdit => 'Edit';

  @override
  String get btnDone => 'Done';

  @override
  String get btnRestoreDefault => 'Restore Default';

  @override
  String get btnSave => 'Save';

  @override
  String get btnSaveChanges => 'Save Changes';

  @override
  String get btnSaveInvoice => 'Add Invoice';

  @override
  String get btnSelectFromContacts => 'Select from Contacts';

  @override
  String get btnUpdateInvoice => 'Save Changes';

  @override
  String get calendarGregorian => 'Gregorian';

  @override
  String get calendarHijri => 'Hijri';

  @override
  String get calendarSelection => 'Choose your preferred calendar system';

  @override
  String get colorCustomized => 'Custom Color';

  @override
  String get colorDefault => 'Default Color';

  @override
  String get companySettingsDialogTitle => 'Company & Billing Settings';

  @override
  String get customerDetailsTitle => 'Customer Details';

  @override
  String get customerFormTitleAdd => 'Add New Customer';

  @override
  String get customerFormTitleEdit => 'Edit Customer';

  @override
  String get customersAddTooltip => 'Add New Customer';

  @override
  String get customersScreenTitle => 'Customers';

  @override
  String get customersSearchHint => 'Search for a customer...';

  @override
  String get customersTitle => 'Customers';

  @override
  String get dashboardWelcomeMessage => 'Welcome to your Insightful Dashboard';

  @override
  String get dialogAddItemTitle => 'Add Item';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogOk => 'OK';

  @override
  String get dialogCognitiveRejectionTitle => 'Transaction Rejected';

  @override
  String get dialogCognitiveRejectionMessage =>
      'The Cognitive Hexagon has rejected this transaction. Review the agent consensus below:';

  @override
  String get dialogSave => 'Save';

  @override
  String get dialogTaxTitle => 'Tax Rate';

  @override
  String get editAccountSubtitle => 'Change username and password';

  @override
  String get editAccountTitle => 'Edit Account Details';

  @override
  String get labelAddress => 'Address';

  @override
  String get labelCompanyName => 'Company Name';

  @override
  String get labelConfirmPassword => 'Confirm Password';

  @override
  String get labelCountryCode => 'Country Code';

  @override
  String get labelCreatedDate => 'Created Date';

  @override
  String get labelCreditLimit => 'Credit Limit (Optional)';

  @override
  String get labelCurrencySymbol => 'Currency Symbol';

  @override
  String get labelCustomer => 'Customer';

  @override
  String get labelCustomerName => 'Customer Name';

  @override
  String get labelDueDate => 'Due Date';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelGrandTotal => 'Grand Total:';

  @override
  String get labelInvoiceItems => 'Invoice Items';

  @override
  String get labelInvoiceNo => 'Invoice No';

  @override
  String get labelInvoiceStatus => 'Invoice Status';

  @override
  String get labelInvoiceStyle => 'Invoice Style';

  @override
  String get labelLastUpdated => 'Last Updated';

  @override
  String get labelNewPassword => 'New Password';

  @override
  String get labelNotes => 'Notes (Optional)';

  @override
  String get labelPassword => 'Password';

  @override
  String get labelPercentage => 'Percentage';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelSourceWarehouse => 'Source Warehouse';

  @override
  String get labelDestinationWarehouse => 'Destination Warehouse';

  @override
  String get errSameWarehouse =>
      'Source and destination warehouses cannot be the same';

  @override
  String get errSelectSourceWarehouse => 'Please select source warehouse';

  @override
  String get errSelectDestinationWarehouse =>
      'Please select destination warehouse';

  @override
  String get btnSaveTransfer => 'Save Transfer';

  @override
  String get warehouseTransferTitleAdd => 'New Warehouse Transfer';

  @override
  String get labelPrice => 'Price';

  @override
  String get labelQuantity => 'Quantity';

  @override
  String get labelRememberMe => 'Remember me';

  @override
  String get labelSubtotal => 'Subtotal:';

  @override
  String labelTax(String rate) {
    return 'Tax ($rate):';
  }

  @override
  String get labelTaxNumber => 'Tax Number';

  @override
  String get labelTaxRate => 'Tax Rate';

  @override
  String get labelTaxRateWithExample => 'Tax Rate (e.g. 0.15)';

  @override
  String get labelUsername => 'Username';

  @override
  String get langArabic => 'Arabic';

  @override
  String get langEnglish => 'English';

  @override
  String get languageTitle => 'Language';

  @override
  String get loginGuest => 'Login as Guest';

  @override
  String get loginSubtitle => 'Welcome back! Login to continue';

  @override
  String get loginTitle => 'Login';

  @override
  String get modeDark => 'Dark';

  @override
  String get modeLight => 'Light';

  @override
  String get modeSystem => 'System';

  @override
  String get msgAccountCreated => 'Account created successfully';

  @override
  String get msgAccountUpdated => 'Account details updated successfully';

  @override
  String get msgConfirmLogout => 'Are you sure you want to logout?';

  @override
  String get msgCustomerAdded => 'Customer added successfully';

  @override
  String get msgCustomerDeleted => 'Customer deleted successfully';

  @override
  String get msgCustomerUpdated => 'Customer updated successfully';

  @override
  String get msgGuestWelcome =>
      'Welcome as Guest! You can create an account later';

  @override
  String get msgInvoiceAdded => 'Invoice added successfully';

  @override
  String get msgInvoiceUpdated => 'Invoice updated successfully';

  @override
  String get msgLoginSuccess => 'Login successful';

  @override
  String get msgLogoutSuccess => 'Logged out successfully';

  @override
  String get msgNoAccount => 'Don\'t have an account?';

  @override
  String get msgNoContactsFound => 'No contacts available';

  @override
  String get msgNoItems => 'No items. Press + to add.';

  @override
  String get msgSettingsSaved => 'Settings saved successfully';

  @override
  String get navCustomers => 'Customers';

  @override
  String get notificationsEnable => 'Enable Notifications';

  @override
  String get notificationsSubtitle =>
      'Receive notifications for overdue invoices';

  @override
  String get privacyFooter => 'For more information, please visit our website.';

  @override
  String get privacyHeader => 'We respect your privacy';

  @override
  String get privacyPoint1 =>
      '1. All your data is stored locally on your device';

  @override
  String get privacyPoint2 =>
      '2. We do not collect or share any personal information';

  @override
  String get privacyPoint3 => '3. Your data is encrypted and secure';

  @override
  String get privacyPoint4 =>
      '4. We do not use third-party tracking or analytics services';

  @override
  String get privacyPoint5 => '5. You are the sole owner of your data';

  @override
  String get privacyPolicySubtitle => 'Read our privacy policy';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get reduceMotion => 'Reduce Motion';

  @override
  String get reduceMotionSubtitle => 'Reduce motion effects and transitions';

  @override
  String get retryLabel => 'Tap to retry';

  @override
  String get sectionAccessibility => 'Accessibility';

  @override
  String get sectionAdditionalInfo => 'Additional Information';

  @override
  String get sectionCalendar => 'Calendar';

  @override
  String get sectionContactInfo => 'Contact Information';

  @override
  String get sectionMode => 'Mode';

  @override
  String get sectionStyle => 'Style';

  @override
  String get setupSubtitle => 'Create your account to start managing invoices';

  @override
  String get setupTitle => 'Create New Account';

  @override
  String get splashCriticalError => 'Critical initialization error';

  @override
  String get splashInitializing => 'Initializing...';

  @override
  String get statActiveCustomers => 'Active Customers';

  @override
  String get statOverdue => 'Overdue';

  @override
  String get statOverdueInvoices => 'Overdue Invoices';

  @override
  String get statPaid => 'Paid';

  @override
  String get statTotal => 'Total';

  @override
  String get statTotalInvoices => 'Total Invoices';

  @override
  String get statTotalSales => 'Total Sales';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusRefunded => 'Refunded';

  @override
  String get styleCompact => 'Compact';

  @override
  String get styleModern => 'Modern';

  @override
  String get styleStandard => 'Standard';

  @override
  String get termsFooter =>
      'By using the application, you agree to these terms.';

  @override
  String get termsHeader => 'Basir App Terms of Service';

  @override
  String get termsOfServiceSubtitle => 'Read our terms of service';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get termsPoint1 =>
      '1. The application is free for personal and commercial use';

  @override
  String get termsPoint2 =>
      '2. You are responsible for the accuracy of entered data';

  @override
  String get termsPoint3 => '3. You must keep a backup of your data';

  @override
  String get termsPoint4 =>
      '4. The application is provided \'as is\' without warranties';

  @override
  String get termsPoint5 =>
      '5. We are not liable for any losses resulting from app use';

  @override
  String get themeColorPickerTitle => 'Choose App Color';

  @override
  String get tooltipAddInvoice => 'Add Invoice';

  @override
  String get tooltipAddItem => 'Add New Item';

  @override
  String get tooltipBack => 'Back';

  @override
  String get tooltipDeleteItem => 'Delete Item';

  @override
  String get tooltipEditCustomer => 'Edit Customer';

  @override
  String get tooltipEditTaxRate => 'Edit Tax Rate';

  @override
  String get tooltipExportAll => 'Export All';

  @override
  String get btnRetry => 'Retry';

  @override
  String get testEnhancedButtonsTitle => 'Enhanced Buttons Test';

  @override
  String get msgAccountUpgraded => 'Account upgraded successfully';

  @override
  String get labelHome => 'Home';

  @override
  String get labelSettings => 'Settings';

  @override
  String get labelPrimary => 'Primary';

  @override
  String get labelSecondary => 'Secondary';

  @override
  String get labelTestText => 'Test Text';

  @override
  String get testButtonsTitle => 'Button Tests';

  @override
  String get sectionPrimaryButtons => 'Primary Buttons';

  @override
  String get sectionSecondaryButtons => 'Secondary Buttons';

  @override
  String get sectionTextButtons => 'Text Buttons';

  @override
  String get sectionRowButtons => 'Button Row';

  @override
  String get sectionSpecialCases => 'Special Cases';

  @override
  String get msgResetConfirmation =>
      'Resetting all appearance settings to default. Are you sure?';

  @override
  String get errorTitle => 'Oops, an unexpected error occurred';

  @override
  String get errorDescription =>
      'We are working on fixing it. Please try restarting the app.';

  @override
  String get labelCurrencySAR => 'SAR';

  @override
  String get labelAccounting => 'Accounting';

  @override
  String get labelChartOfAccounts => 'Chart of Accounts';

  @override
  String get financialSummaryTitle => 'Financial Summary (Beta)';

  @override
  String get statAssets => 'Assets';

  @override
  String get statLiabilities => 'Liabilities';

  @override
  String get statNetIncome => 'Net Income';

  @override
  String get tooltipRefresh => 'Refresh';

  @override
  String get emptyAccountsMessage =>
      'No accounts found. Click refresh to seed default data.';

  @override
  String get errorLoadingAccounts => 'Error loading accounts';

  @override
  String get labelBalance => 'Balance';

  @override
  String get labelTotal => 'Total';

  @override
  String get statusPosted => 'Posted';

  @override
  String get statusDraft => 'Draft';

  @override
  String get emptyJournalEntriesMessage => 'No journal entries found.';

  @override
  String get labelDebit => 'Debit';

  @override
  String get labelCredit => 'Credit';

  @override
  String get labelReference => 'Reference / ID';

  @override
  String get msgColorPickerHint =>
      'Pick a custom primary color for the application';

  @override
  String get msgJournalEntryAdded => 'Journal entry saved successfully';

  @override
  String get errUnbalancedEntry =>
      'Entry is unbalanced! Debits must equal credits.';

  @override
  String get btnSaveEntry => 'Save as Draft';

  @override
  String get btnPostEntry => 'Post Entry';

  @override
  String get msgJournalEntryPosted => 'Journal entry posted successfully';

  @override
  String get msgJournalEntryDrafted => 'Journal entry saved as draft';

  @override
  String get hintJournalDescription => 'Enter transaction description';

  @override
  String get labelJournalEntryLines => 'Entry Lines';

  @override
  String get expenseDistributionTitle => 'Expense Distribution';

  @override
  String get noExpenseDataMessage => 'No expense data available';

  @override
  String get otherExpensesLabel => 'Other Expenses';

  @override
  String get trialBalanceTitle => 'Trial Balance';

  @override
  String get btnExport => 'Export';

  @override
  String get labelAccount => 'Account';

  @override
  String get labelExportPdf => 'Export PDF';

  @override
  String get labelExportCsv => 'Export CSV (Excel)';

  @override
  String get cashFlowTitle => 'Cash Flow Statement';

  @override
  String get incomeStatementTitle => 'Income Statement';

  @override
  String get balanceSheetTitle => 'Balance Sheet';

  @override
  String get labelOperating => 'Operating Activities';

  @override
  String get labelInvesting => 'Investing Activities';

  @override
  String get labelFinancing => 'Financing Activities';

  @override
  String get labelNetCashFlow => 'Net Cash Flow';

  @override
  String get reportingOverviewTitle => 'Financial Reports';

  @override
  String get trialBalanceSubtitle => 'Verify balance of debits and credits';

  @override
  String get incomeStatementSubtitle => 'Summary of revenues and profitability';

  @override
  String get balanceSheetSubtitle =>
      'Assets, liabilities, and equity (Fair Value supported)';

  @override
  String get cashFlowSubtitle =>
      'Cash movement (Operating, Investing, Financing)';

  @override
  String get agingReportsSubtitle =>
      'Analyze age of customer and vendor balances';

  @override
  String get agingReportsTitle => 'Aging Reports';

  @override
  String get receivablesAgingLabel => 'Accounts Receivable (Customers)';

  @override
  String get payablesAgingLabel => 'Accounts Payable (Suppliers)';

  @override
  String get noDataMessage => 'No data available';

  @override
  String get periodCurrent => 'Current';

  @override
  String get period1_30 => '1-30 Days';

  @override
  String get period31_60 => '31-60 Days';

  @override
  String get period61_90 => '61-90 Days';

  @override
  String get periodOver90 => 'Over 90 Days';

  @override
  String get labelAssets => 'Assets';

  @override
  String get labelLiabilities => 'Liabilities';

  @override
  String get labelEquity => 'Equity';

  @override
  String get labelTotalAssets => 'Total Assets';

  @override
  String get labelTotalLiabilitiesAndEquity => 'Total Liabilities and Equity';

  @override
  String get msgBalanceBalanced =>
      'Balance is balanced: Assets equal Liabilities and Equity.';

  @override
  String msgBalanceUnbalanced(String diff) {
    return 'Warning: Balance is unbalanced! Difference: $diff';
  }

  @override
  String get treasuryTitle => 'Treasury & Cash';

  @override
  String get cashBalancesTitle => 'Cash & Bank Balances';

  @override
  String get recentVouchersTitle => 'Recent Vouchers';

  @override
  String get receiptVoucherAction => 'Receipt Voucher';

  @override
  String get paymentVoucherAction => 'Payment Voucher';

  @override
  String get newVoucherLabel => 'New Voucher';

  @override
  String get noVouchersMessage => 'No vouchers recorded';

  @override
  String get anonymousPerson => 'No name';

  @override
  String get actionReverse => 'Reverse Entry';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionPostNow => 'Post Now';

  @override
  String get msgConfirmReverse =>
      'Are you sure you want to reverse this entry? This will create an automatic reversing entry.';

  @override
  String get msgReverseSuccess => 'Entry reversed successfully';

  @override
  String get labelBalanced => 'Balanced';

  @override
  String get labelUnbalanced => 'Unbalanced';

  @override
  String get labelDiff => 'Diff';

  @override
  String get voucherReceiptTitle => 'New Receipt Voucher';

  @override
  String get voucherPaymentTitle => 'New Payment Voucher';

  @override
  String get btnSaveAndPostVoucher => 'Save and Post Voucher';

  @override
  String get errInvalidAmount => 'Invalid amount';

  @override
  String get errAmountRequired => 'Please enter amount';

  @override
  String get errDescriptionRequired => 'Please enter description';

  @override
  String get labelPaymentMethod => 'Payment Method';

  @override
  String get methodCash => 'Cash';

  @override
  String get methodBank => 'Bank';

  @override
  String get methodCheck => 'Check';

  @override
  String get labelTreasuryAccount => 'Treasury/Bank Account';

  @override
  String get labelSourceClient => 'Customer (Source)';

  @override
  String get labelBeneficiaryVendor => 'Vendor (Beneficiary)';

  @override
  String get msgVoucherSavedSuccess => 'Voucher saved and posted successfully';

  @override
  String get errFormFill => 'Please complete the data';

  @override
  String get labelAccountSelector => 'Select Account';

  @override
  String get labelRequired => 'Required';

  @override
  String get labelStatus => 'Status';

  @override
  String get labelDescription => 'Description';

  @override
  String get errorExportingReport => 'Error exporting report';

  @override
  String get labelAmount => 'Amount';

  @override
  String get labelDate => 'Date';

  @override
  String get labelType => 'Type';

  @override
  String get labelRevenue => 'Revenue';

  @override
  String get labelExpenses => 'Expenses';

  @override
  String get labelIncomeTax => 'Income Tax';

  @override
  String get labelNetProfit => 'Net Profit / Loss';

  @override
  String get msgOperationSuccess => 'Operation completed successfully';

  @override
  String get aboutAppSubtitle => 'Version 1.0.0';

  @override
  String get accountTitle => 'Account';

  @override
  String get actionAddCustomer => 'Add Customer';

  @override
  String get actionAddVendor => 'Add Vendor';

  @override
  String get actionAddInventoryItem => 'Add Item';

  @override
  String get actionAddInvoice => 'Add Invoice';

  @override
  String get actionDeleteCustomer => 'Delete Customer';

  @override
  String get actionDeleteVendor => 'Delete Vendor';

  @override
  String get actionDeleteInvoice => 'Delete Invoice';

  @override
  String get titleAddVendor => 'Add New Vendor';

  @override
  String get titleEditVendor => 'Edit Vendor Details';

  @override
  String get invoicesTitle => 'Invoices';

  @override
  String get privacyAnalyticsTitle => 'Privacy & Analytics';

  @override
  String get privacyAnalyticsSubtitle => 'Manage local usage data and privacy';

  @override
  String get analyticsEnableTracking => 'Enable Local Analytics';

  @override
  String get analyticsPrivacyNotice =>
      'We respect your privacy. All analytics are stored locally on your device and we do not collect any personal or financial data. This data helps us improve the user experience and understand most used features.';

  @override
  String get analyticsClearData => 'Clear Analytics Data';

  @override
  String get analyticsDataCleared => 'Analytics data cleared successfully';

  @override
  String get lastSyncLabel => 'Last Sync';

  @override
  String get msgNoActivity => 'No recent activity yet.';

  @override
  String get labelJournalEntries => 'Journal Entries';

  @override
  String get labelExchangeRate => 'Exchange Rate';

  @override
  String get exchangeRate => 'Exchange Rate';

  @override
  String get labelBaseCurrencyEquivalent => 'Base Currency Equivalent';

  @override
  String get titleTreasuryVault => 'The Vault (Treasury)';

  @override
  String get labelTotalLiquidity => 'Total Liquidity';

  @override
  String get labelAvailableCashBank => 'Total Available Cash & Bank';

  @override
  String get labelAccounts => 'Accounts';

  @override
  String get labelForecast30Days => '30-Day Outlook';

  @override
  String get labelExpectedInflow => 'Expected Inflow';

  @override
  String get labelExpectedOutflow => 'Expected Outflow';

  @override
  String get labelNetChange => 'Net Change';

  @override
  String get msgNoCashAccounts => 'No cash accounts found';

  @override
  String get msgInitCoa => 'Initialize your COA or add cash accounts.';

  @override
  String get originalAmount => 'Original Amount';

  @override
  String get labelInventoryItem => 'Inventory Item';

  @override
  String get hintSelectInventoryItem => 'Select an inventory item to auto-fill';

  @override
  String get labelTaxCategory => 'Tax Category';

  @override
  String get labelSearchSku => 'Search Barcode / SKU';

  @override
  String get hintSearchSku => 'Enter code and press Enter';

  @override
  String get msgItemNotFound => 'Item not found';

  @override
  String get tooltipPrintReceipt => 'Print Receipt';

  @override
  String get tooltipReverseInvoice => 'Cancel/Reverse';

  @override
  String get titleReverseInvoice => 'Reverse Invoice';

  @override
  String get msgConfirmReverseInvoice =>
      'Are you sure you want to reverse this invoice? A reversing journal entry will be created.';

  @override
  String get btnConfirmReverse => 'Yes, Reverse Invoice';

  @override
  String get msgInvoiceReversed => 'Invoice reversed successfully';

  @override
  String get receiptTitleTaxInvoice => 'Tax Invoice';

  @override
  String get receiptTitleSimplified => 'Simplified Tax Invoice';

  @override
  String get receiptFooterThanks => 'Thanks for visiting';

  @override
  String get receiptFooterBrand => 'Basir - Basir Accounting';

  @override
  String get labelDiscount => 'Discount';

  @override
  String get labelItemName => 'Item Name';

  @override
  String get labelIssuedDate => 'Issued Date';

  @override
  String get errPermissionDenied =>
      'You do not have permission to perform this action';

  @override
  String get agentRationaleStandardsPassed =>
      'Compliance verified: Journal entry adheres to (IFRS/SOCPA) standards.';

  @override
  String agentRationaleStandardsManualReview(String type) {
    return 'Warning: Transaction type ($type) requires manual review for standards compliance.';
  }

  @override
  String get agentRationaleTaxNoId =>
      'Warning: No Tax ID provided for this transaction.';

  @override
  String get agentRationaleTaxZatcaReject =>
      'REJECT: Transactions exceeding 10,000 SAR require a valid Tax ID for ZATCA Phase 2 compliance.';

  @override
  String agentRationaleTaxValidated(String id) {
    return 'Validated Tax ID: $id';
  }

  @override
  String agentRationaleTaxAnalyzing(String account) {
    return 'Analyzing VAT for $account';
  }

  @override
  String agentRationaleTaxRateMismatch(String rate) {
    return 'ALERT: Calculated VAT rate ($rate) deviates from the regional standard (15%).';
  }

  @override
  String get agentRationaleTaxRateMatch =>
      'CONFIRM: VAT rate (15%) matches local regulatory requirements.';

  @override
  String get agentRationaleTaxNoVatWarning =>
      'WARNING: Commercial transaction detected without VAT lines.';

  @override
  String get agentRationaleForensicBalanced =>
      'Check PASSED: Journal entry is balanced.';

  @override
  String get agentRationaleForensicUnbalanced =>
      'REJECTION: Proposed journal entry is not balanced.';

  @override
  String agentRationaleForensicHighValue(String amount) {
    return 'WARNING: Unusually high transaction amount detected ($amount). Administrative review recommended.';
  }

  @override
  String agentRationaleForensicDuplicate(String ref) {
    return 'REJECTION: Duplicate reference number ($ref) detected in history.';
  }

  @override
  String agentRationaleOperationalSufficient(String account, String balance) {
    return 'Liquidity Analysis: $account balance is sufficient ($balance) for this operation.';
  }

  @override
  String agentRationaleOperationalInsufficient(String account, String balance) {
    return 'REJECTION: $account balance is insufficient ($balance) for this operation.';
  }

  @override
  String agentRationaleStrategyOutflow(String amount) {
    return 'Strategy Analysis: This entry represents a cash outflow of $amount.';
  }

  @override
  String get agentRationaleStrategyRecommendation =>
      'Recommendation: Review cash flow projections for the coming week to ensure sufficient liquidity for other obligations.';

  @override
  String agentRationaleStrategyInflow(String amount) {
    return 'Strategy Analysis: Liquidity enhancement of $amount supports short-term investment capacity.';
  }

  @override
  String get agentRationaleStrategyProfitability =>
      'Strategic Insight: Increased sales volume positively impacts Return on Assets (ROA) and net margin targets.';

  @override
  String get agentRationaleSustainabilityFlagged =>
      'ISSB Analysis: This transaction is flagged for mandatory environmental/social disclosure.';

  @override
  String get agentRationaleSustainabilityReject =>
      'CRITICAL REJECTION: ISSB S2 standards require carbon footprint metrics for this industry-specific transaction.';

  @override
  String agentRationaleSustainabilitySuccess(int count) {
    return 'SUCCESS: Integrated $count compliant sustainability metrics.';
  }

  @override
  String get agentRationaleSustainabilityNotRequired =>
      'Sustainability Assessment: No specific ISSB disclosures required for this transaction tier.';

  @override
  String agentRationaleForensicTimeAnomaly(String time) {
    return 'WARNING: Transaction recorded during non-standard hours ($time). Higher forensic weighting applied.';
  }

  @override
  String agentRationaleForensicSequenceGap(String last, String current) {
    return 'NOTICE: Gap detected in reference sequence. Last: $last, Current: $current.';
  }

  @override
  String get agentRationaleForensicZatcaIdentityMissing =>
      'NOTICE: ZATCA Phase 2 cryptographic identity (UUID/Hash) is missing for this invoice.';

  @override
  String get auditTrailTitle => 'Audit Trail';

  @override
  String get auditTrailSubtitle =>
      'Internal system logs and consensus bypasses';

  @override
  String get auditTrailSectionForensic => 'Forensic Integrity Logs';

  @override
  String get auditTrailNoLogs => 'No audit logs found for the selected period.';

  @override
  String get msgInvoiceCognitiveHint =>
      'Use this screen to create or edit invoices. Ensure meticulous accuracy with tax rates and item selection.';

  @override
  String get titleInvoiceCognitiveHint => 'Invoice Mastery';

  @override
  String get labelReturnsAndDamages => 'Returns & Damages';

  @override
  String get labelSalesReturn => 'Sales Return';

  @override
  String get descSalesReturn => 'Return sold items to inventory';

  @override
  String get labelPurchaseReturn => 'Purchase Return';

  @override
  String get descPurchaseReturn => 'Return purchased items to vendor';

  @override
  String get labelDamageInvoice => 'Damage Invoice';

  @override
  String get descDamageInvoice => 'Record damaged or missing items';

  @override
  String get labelEmailOptional => 'Email (Optional)';

  @override
  String get labelPhoneOptional => 'Phone (Optional)';

  @override
  String get labelAddressOptional => 'Address (Optional)';

  @override
  String get labelNotesOptional => 'Notes (Optional)';

  @override
  String msgConfirmDeleteCustomer(String name) {
    return 'Are you sure you want to delete customer $name?';
  }

  @override
  String get msgConfirmDeleteInvoice =>
      'Are you sure you want to delete this invoice?';

  @override
  String get dashboardBasirSystemTitle => 'Basir Accounting System';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardStatsTitle => 'Statistics';

  @override
  String get dashboardQuickActionsTitle => 'Quick Actions';

  @override
  String get dashboardRecentActivityTitle => 'Recent Activity';

  @override
  String get dashboardMotto => 'Professional Accounting Made Simple';

  @override
  String get saveLabels => 'Save Labels';

  @override
  String get errInvalidResetLink => 'Invalid or expired reset link';

  @override
  String get errInvalidResetToken => 'Invalid or expired reset token';

  @override
  String get msgPasswordResetSuccess => 'Password reset successfully';

  @override
  String get errPasswordResetFailed => 'Password reset failed';

  @override
  String get errPasswordRequired => 'Password is required';

  @override
  String get errPasswordTooShort => 'Password is too short';

  @override
  String get errPasswordNeedsUppercase => 'Password needs uppercase letter';

  @override
  String get errPasswordNeedsLowercase => 'Password needs lowercase letter';

  @override
  String get errPasswordNeedsNumber => 'Password needs a number';

  @override
  String get errConfirmPasswordRequired => 'Confirm password is required';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String resetPasswordSubtitle(String email) {
    return 'Enter your new password for $email';
  }

  @override
  String get newPassword => 'New Password';

  @override
  String get passwordHint => 'Enter your new password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get passwordRequirements => 'Password Requirements:';

  @override
  String get passwordRequirementsList =>
      '• At least 8 characters\n• One uppercase letter\n• One lowercase letter\n• One number';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get labelVatNumber => 'VAT Number';

  @override
  String get labelRegistrationNumber => 'Registration Number (CR)';

  @override
  String get labelTotalPayables => 'Total Payables to Vendors';

  @override
  String get msgValueCopiedToClipboard => 'Value copied to clipboard';

  @override
  String get labelSourceDocument => 'Source Document';

  @override
  String get btnViewSource => 'View Source';

  @override
  String get msgLoadingSource => 'Loading source document...';

  @override
  String get errSourceNotFound => 'Source document not found';

  @override
  String get agentSuggestionIfrs18Category => 'IFRS 18 Category Suggestion';

  @override
  String get agentSuggestionIfrs18CategoryReason =>
      'IFRS 18 requires specific classification for sales commissions.';

  @override
  String get agentSuggestionVatCorrection => 'VAT Rate Correction';

  @override
  String get agentSuggestionMissingVatLine => 'Missing VAT Line';

  @override
  String get agentSuggestionMissingVatLineReason =>
      'Sales transaction usually requires 15% VAT per ZATCA/IFRS.';

  @override
  String get agentSuggestionWarehouseOptimization => 'Warehouse Optimization';

  @override
  String get agentSuggestionWarehouseOptimizationReason =>
      'Check \"Central Hub\" or \"Riyadh Branch\" for stock transfer.';

  @override
  String get agentSuggestionStrategicDiscount => 'Strategic Discount';

  @override
  String get agentSuggestionStrategicDiscountReason =>
      'Offer a 2% discount for payments within 10 days to maximize liquidity.';

  @override
  String get agentSuggestionIssbMetrics => 'ISSB Disclosure';

  @override
  String get agentSuggestionIssbMetricsReason =>
      'Attach quantitative resource usage metrics (liters/kWh) for compliance.';

  @override
  String get labelAiSmartSuggestions => 'AI Smart Suggestions';

  @override
  String get labelTarget => 'Target:';

  @override
  String get msgForensicSequenceClean =>
      'Sequence verification complete: No anomalies detected.';

  @override
  String get msgForensicRisksDetected =>
      'Forensic analysis detected institutional risks.';

  @override
  String get msgForensicEngineError =>
      'Forensic scan failed: Internal engine error.';

  @override
  String get msgForensicLedgerClean =>
      'Historical ledger scrutiny complete: No anomalies found.';

  @override
  String get msgForensicLedgerAnomalies =>
      'Forensic anomalies detected in historical ledger.';

  @override
  String errForensicImbalance(Object id) {
    return 'Imbalance detected: Entry #$id is not balanced.';
  }

  @override
  String errForensicDiscrepancy(Object id) {
    return 'Integrity discrepancy: Entry #$id has total debit/sum mismatch.';
  }

  @override
  String errForensicHashBreach(Object curr, Object prev) {
    return 'Integrity Breach: Hash chain broken between #$prev and #$curr';
  }

  @override
  String get titleForensicPortal => 'Forensic Integrity Portal';

  @override
  String get labelIntegrityPulse => 'Integrity Pulse';

  @override
  String get labelLastVerified => 'Last verified:';

  @override
  String get labelBlocksScanned => 'Blocks Scanned:';

  @override
  String get labelHealth => 'Health:';

  @override
  String get labelLedgerMutationTimeline => 'Ledger Mutation Timeline';

  @override
  String get labelHashChain => 'Immutable Hash Chain';

  @override
  String get labelVerifiedBy => 'Verified by:';

  @override
  String get titleStrategicOutlook => 'Strategic Outlook & Forecasting';

  @override
  String get labelPredictivePnL => 'Predictive P&L Analysis';

  @override
  String get labelCashFlowProjection => 'Cash Flow Projection';

  @override
  String get labelStrategicInsights => 'Strategic AI Insights';

  @override
  String get labelProjectedRevenue => 'Projected Revenue';

  @override
  String get labelProjectedExpense => 'Projected Expenses';

  @override
  String get labelProjectedNetIncome => 'Projected Net Income';

  @override
  String get labelConfidenceScore => 'AI Confidence Score';

  @override
  String get msgNoStrategicData =>
      'Insufficient historical data for accurate forecasting. Please post more transactions.';

  @override
  String get actionEmailInvoice => 'Email Invoice';

  @override
  String get searchInvoicesHint => 'Search invoices, customers, or numbers';

  @override
  String get searchInvoicesLabel => 'Search invoices';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortLabel => 'Sort';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortAmountDesc => 'Highest amount';

  @override
  String get sortAmountAsc => 'Lowest amount';

  @override
  String get sortCustomer => 'Customer name';

  @override
  String get sortDueDateAsc => 'Due date (soonest)';

  @override
  String get filterCancelled => 'Cancelled';

  @override
  String get noSearchResults => 'No invoices match your search';

  @override
  String resultsCount(String count) {
    return '$count results';
  }

  @override
  String get resultsCountZero => 'No results';

  @override
  String get searchTooltip => 'Search';

  @override
  String get sortTooltip => 'Sort invoices';

  @override
  String get clearSearchTooltip => 'Clear search';
}
