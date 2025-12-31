// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Basser';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get companySettingsTitle => 'Company & Billing Settings';

  @override
  String get accountTitle => 'Account';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get appearanceTitle => 'Appearance & Customization';

  @override
  String get helpTitle => 'Help & Support';

  @override
  String get logoutLabel => 'Logout';

  @override
  String get editAccountTitle => 'Edit Account Details';

  @override
  String get editAccountSubtitle => 'Change username and password';

  @override
  String get notificationsEnable => 'Enable Notifications';

  @override
  String get notificationsSubtitle =>
      'Receive notifications for overdue invoices';

  @override
  String get appearanceSettingsTitle => 'Appearance Settings';

  @override
  String get appearanceSettingsSubtitle =>
      'Dark mode, colors, fonts, and icons';

  @override
  String get aboutAppTitle => 'About App';

  @override
  String get aboutAppSubtitle => 'Version 1.0.0';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Read our privacy policy';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get termsOfServiceSubtitle => 'Read our terms of service';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogSave => 'Save';

  @override
  String get dialogOk => 'OK';

  @override
  String get companySettingsDialogTitle => 'Company & Billing Settings';

  @override
  String get labelCompanyName => 'Company Name';

  @override
  String get hintCompanyName => 'Enter your company name';

  @override
  String get labelTaxNumber => 'Tax Number';

  @override
  String get hintTaxNumber => 'Enter tax number (optional)';

  @override
  String get labelTaxRateWithExample => 'Tax Rate (e.g. 0.15)';

  @override
  String get labelCurrencySymbol => 'Currency Symbol';

  @override
  String get hintCurrencySymbol => 'SAR';

  @override
  String get labelCountryCode => 'Country Code';

  @override
  String get labelInvoiceStyle => 'Invoice Style';

  @override
  String get styleStandard => 'Standard';

  @override
  String get styleModern => 'Modern';

  @override
  String get styleCompact => 'Compact';

  @override
  String get msgSettingsSaved => 'Settings saved successfully';

  @override
  String msgSaveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get retryLabel => 'Tap to retry';

  @override
  String get sectionMode => 'Mode';

  @override
  String get modeSystem => 'System';

  @override
  String get modeLight => 'Light';

  @override
  String get modeDark => 'Dark';

  @override
  String get sectionStyle => 'Style';

  @override
  String get appColor => 'App Color';

  @override
  String get colorDefault => 'Default Color';

  @override
  String get colorCustomized => 'Custom Color';

  @override
  String get sectionAccessibility => 'Accessibility';

  @override
  String get highContrast => 'High Contrast';

  @override
  String get highContrastSubtitle => 'Increase text and element clarity';

  @override
  String get reduceMotion => 'Reduce Motion';

  @override
  String get reduceMotionSubtitle => 'Reduce motion effects and transitions';

  @override
  String get sectionCalendar => 'Calendar';

  @override
  String get calendarGregorian => 'Gregorian';

  @override
  String get calendarHijri => 'Hijri';

  @override
  String get calendarSelection => 'Choose your preferred calendar system';

  @override
  String get invoicesTitle => 'Invoices';

  @override
  String get tooltipAddInvoice => 'Add Invoice';

  @override
  String get tooltipExportAll => 'Export All';

  @override
  String get statTotal => 'Total';

  @override
  String get statPaid => 'Paid';

  @override
  String get statOverdue => 'Overdue';

  @override
  String get filterAll => 'All';

  @override
  String get filterDraft => 'Draft';

  @override
  String get filterIssued => 'Issued';

  @override
  String get filterPaid => 'Paid';

  @override
  String get filterOverdue => 'Overdue';

  @override
  String get errorLoadingInvoices => 'Error loading invoices';

  @override
  String invoiceTitle(String id) {
    return 'Invoice $id';
  }

  @override
  String get actionSharePdf => 'Share PDF';

  @override
  String get actionShareWhatsappText => 'Share via WhatsApp (Text)';

  @override
  String get actionShareWhatsappPdf => 'Share via WhatsApp (PDF)';

  @override
  String get actionDeleteInvoice => 'Delete Invoice';

  @override
  String get msgConfirmDeleteInvoice =>
      'Are you sure you want to delete this invoice?';

  @override
  String get btnDelete => 'Delete';

  @override
  String get errorCustomerNotFound => 'Customer data not found';

  @override
  String errorSharePdf(String error) {
    return 'Error sharing PDF: $error';
  }

  @override
  String get errorCustomerPhone => 'Customer phone not available';

  @override
  String errorShareWhatsapp(String error) {
    return 'Error sharing via WhatsApp: $error';
  }

  @override
  String msgInvoiceShare(String name, String id, String total, String symbol) {
    return 'Hello $name, here is invoice #$id:\nTotal: $total $symbol\nThank you.';
  }

  @override
  String get invoiceFormTitleAdd => 'Add New Invoice';

  @override
  String get invoiceFormTitleEdit => 'Edit Invoice';

  @override
  String get labelCustomer => 'Customer';

  @override
  String get hintSelectCustomer => 'Select Customer';

  @override
  String get errSelectCustomer => 'Please select a customer';

  @override
  String errLoadCustomers(String error) {
    return 'Error loading customers: $error';
  }

  @override
  String get labelIssuedDate => 'Issued Date';

  @override
  String get labelDueDate => 'Due Date';

  @override
  String get labelTaxRate => 'Tax Rate';

  @override
  String get tooltipEditTaxRate => 'Edit Tax Rate';

  @override
  String get labelInvoiceStatus => 'Invoice Status';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get labelInvoiceItems => 'Invoice Items';

  @override
  String get tooltipAddItem => 'Add New Item';

  @override
  String get msgNoItems => 'No items. Press + to add.';

  @override
  String get labelQuantity => 'Quantity';

  @override
  String get tooltipDeleteItem => 'Delete Item';

  @override
  String get labelSubtotal => 'Subtotal:';

  @override
  String labelTax(String rate) {
    return 'Tax ($rate):';
  }

  @override
  String get labelGrandTotal => 'Grand Total:';

  @override
  String get labelNotes => 'Notes (Optional)';

  @override
  String get hintNotes => 'Add invoice notes';

  @override
  String get btnSaveInvoice => 'Add Invoice';

  @override
  String get btnUpdateInvoice => 'Save Changes';

  @override
  String get dialogTaxTitle => 'Tax Rate';

  @override
  String get labelPercentage => 'Percentage';

  @override
  String get dialogAddItemTitle => 'Add Item';

  @override
  String get labelItemName => 'Item Name';

  @override
  String get labelPrice => 'Price';

  @override
  String get btnAdd => 'Add';

  @override
  String get btnSave => 'Save';

  @override
  String get errNoItems => 'Please add at least one item';

  @override
  String get msgInvoiceAdded => 'Invoice added successfully';

  @override
  String get msgInvoiceUpdated => 'Invoice updated successfully';

  @override
  String get errInvoiceAdd => 'Failed to add invoice';

  @override
  String get errInvoiceUpdate => 'Failed to update invoice';

  @override
  String errGeneric(String error) {
    return 'Error occurred: $error';
  }

  @override
  String get customersScreenTitle => 'Customers';

  @override
  String get customersAddTooltip => 'Add New Customer';

  @override
  String get customersSearchHint => 'Search for a customer...';

  @override
  String get customerFormTitleAdd => 'Add New Customer';

  @override
  String get customerFormTitleEdit => 'Edit Customer';

  @override
  String get btnSelectFromContacts => 'Select from Contacts';

  @override
  String get labelCustomerName => 'Customer Name';

  @override
  String get hintCustomerName => 'Enter customer name';

  @override
  String get errCustomerNameRequired => 'Customer name is required';

  @override
  String get errCustomerNameLength => 'Name must be at least 2 characters';

  @override
  String get labelEmailOptional => 'Email (Optional)';

  @override
  String get errInvalidEmail => 'Invalid email address';

  @override
  String get errLoginFailed => 'Login failed. Please check your credentials.';

  @override
  String get labelPhoneOptional => 'Phone (Optional)';

  @override
  String get errPhoneStart05 => 'Phone must start with 05';

  @override
  String get errPhoneLength => 'Phone must be 10 digits';

  @override
  String get labelAddressOptional => 'Address (Optional)';

  @override
  String get hintAddress => 'Enter customer address';

  @override
  String get labelNotesOptional => 'Notes (Optional)';

  @override
  String get hintCustomerNotes => 'Add customer notes';

  @override
  String get labelCreditLimit => 'Credit Limit (Optional)';

  @override
  String get errInvalidNumber => 'Please enter a valid number';

  @override
  String get btnAddCustomer => 'Add Customer';

  @override
  String get btnSaveChanges => 'Save Changes';

  @override
  String get msgNoContactsFound => 'No contacts available';

  @override
  String errContactAccess(String error) {
    return 'Contact access error: $error';
  }

  @override
  String get msgCustomerUpdated => 'Customer updated successfully';

  @override
  String get msgCustomerAdded => 'Customer added successfully';

  @override
  String get errCustomerUpdate => 'Failed to update customer';

  @override
  String get errCustomerAdd => 'Failed to add customer';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get navHome => 'Home';

  @override
  String get navInvoices => 'Invoices';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navSettings => 'Settings';

  @override
  String get dashboardStatsTitle => 'Financial Performance';

  @override
  String get dashboardQuickActionsTitle => 'Quick Actions';

  @override
  String get dashboardRecentActivityTitle => 'Recent Activity';

  @override
  String get statTotalInvoices => 'Total Invoices';

  @override
  String get statActiveCustomers => 'Active Customers';

  @override
  String get statTotalSales => 'Total Sales';

  @override
  String get statOverdueInvoices => 'Overdue Invoices';

  @override
  String get actionAddInvoice => 'Add Invoice';

  @override
  String get actionAddCustomer => 'Add Customer';

  @override
  String get labelInvoiceNo => 'Invoice No';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get tooltipBack => 'Back';

  @override
  String get actionDeleteCustomer => 'Delete Customer';

  @override
  String msgConfirmDeleteCustomer(String name) {
    return 'Are you sure you want to delete customer $name?';
  }

  @override
  String get msgCustomerDeleted => 'Customer deleted successfully';

  @override
  String get errCustomerDelete => 'Failed to delete customer';

  @override
  String get customerDetailsTitle => 'Customer Details';

  @override
  String get tooltipEditCustomer => 'Edit Customer';

  @override
  String get sectionContactInfo => 'Contact Information';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelAddress => 'Address';

  @override
  String get sectionAdditionalInfo => 'Additional Information';

  @override
  String get labelCreatedDate => 'Created Date';

  @override
  String get labelLastUpdated => 'Last Updated';

  @override
  String get labelUsername => 'Username';

  @override
  String get hintEnterNewUsername => 'Enter new username';

  @override
  String get labelNewPassword => 'New Password';

  @override
  String get hintEnterNewPassword => 'Enter new password';

  @override
  String get msgAccountUpdated => 'Account details updated successfully';

  @override
  String get msgConfirmLogout => 'Are you sure you want to logout?';

  @override
  String get msgLogoutSuccess => 'Logged out successfully';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Welcome back! Login to continue';

  @override
  String get labelPassword => 'Password';

  @override
  String get hintEnterUsername => 'Please enter username';

  @override
  String get hintEnterPassword => 'Please enter password';

  @override
  String get errEmptyField => 'This field is required';

  @override
  String get labelRememberMe => 'Remember me';

  @override
  String get loginGuest => 'Login as Guest';

  @override
  String get msgGuestWelcome =>
      'Welcome as Guest! You can create an account later';

  @override
  String get msgNoAccount => 'Don\'t have an account?';

  @override
  String get btnCreateAccount => 'Create New Account';

  @override
  String get msgLoginSuccess => 'Login successful';

  @override
  String get msgAccountCreated => 'Account created successfully';

  @override
  String get errUsernameShort => 'Username must be at least 3 characters';

  @override
  String get errPasswordShort => 'Password must be at least 6 characters';

  @override
  String get labelConfirmPassword => 'Confirm Password';

  @override
  String get hintConfirmPassword => 'Re-enter password';

  @override
  String get errPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get setupTitle => 'Create New Account';

  @override
  String get setupSubtitle => 'Create your account to start managing invoices';

  @override
  String get appName => 'Basser';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appCopyright => '© 2025 Basser Development Agents Team';

  @override
  String get aboutDescription =>
      'Basser app is a complete system for managing invoices and customers, designed specifically for small and medium businesses.';

  @override
  String get aboutFeaturesTitle => 'Key Features:';

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
  String get privacyFooter => 'For more information, please visit our website.';

  @override
  String get termsHeader => 'Basser App Terms of Service';

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
  String get termsFooter =>
      'By using the application, you agree to these terms.';

  @override
  String get langArabic => 'Arabic';

  @override
  String get langEnglish => 'English';

  @override
  String get themeColorPickerTitle => 'Choose App Color';

  @override
  String get btnRestoreDefault => 'Restore Default';

  @override
  String get btnDone => 'Done';

  @override
  String get fontSettingsTitle => 'Font Type';

  @override
  String get fontCairo => 'Cairo (Default)';

  @override
  String get fontRoboto => 'Roboto';

  @override
  String get fontSizeLabel => 'Text Size';

  @override
  String get iconSettingsTitle => 'Icon Style';

  @override
  String get iconMaterial => 'Material Design';

  @override
  String get iconCupertino => 'Cupertino (iOS)';

  @override
  String get splashInitializing => 'Initializing...';

  @override
  String get splashCriticalError => 'Critical initialization error';

  @override
  String placeholderComingSoon(String title) {
    return 'Coming soon: $title';
  }

  @override
  String errorScreenNotFound(String name) {
    return 'Screen not found: $name';
  }

  @override
  String get dashboardMasterySystemTitle => 'Basser Developed System';

  @override
  String get dashboardWelcomeMessage => 'Welcome to Mastery Space';

  @override
  String get dashboardMotto =>
      'Basser monitors your business growth precisely (Φ)';

  @override
  String pdfShareSubject(String id) {
    return 'Invoice $id';
  }

  @override
  String pdfShareText(String customerName) {
    return 'Here is the invoice for $customerName';
  }

  @override
  String get actionUpgradeAccount => 'Upgrade Account';

  @override
  String get guestUpgradeDescription =>
      'Convert your guest account to a permanent account to save your data securely.';

  @override
  String get msgAccountUpgraded => 'Account upgraded successfully';

  @override
  String get testButtonsTitle => 'Button Testing';

  @override
  String get testEnhancedButtonsTitle => 'Enhanced Button Testing';

  @override
  String tooltipAdd(String text) {
    return 'Add $text';
  }

  @override
  String get tooltipSave => 'Save Changes';

  @override
  String get tooltipCancel => 'Cancel Operation';

  @override
  String get tooltipDelete => 'Delete Item';

  @override
  String get tooltipEdit => 'Edit Item';

  @override
  String get tooltipSearch => 'Search List';

  @override
  String get btnRetry => 'Retry';

  @override
  String get labelHome => 'Home';

  @override
  String get labelSettings => 'Settings';

  @override
  String get labelProfile => 'Profile';

  @override
  String get labelNotifications => 'Notifications';

  @override
  String get labelPrimary => 'Primary';

  @override
  String get labelSecondary => 'Secondary';

  @override
  String get labelTestText => 'Test Text';

  @override
  String pdfInvoiceTitle(String invoiceId) {
    return 'Invoice No. $invoiceId';
  }

  @override
  String get sectionPrimaryButtons => 'Primary Buttons';

  @override
  String get sectionSecondaryButtons => 'Secondary Buttons';

  @override
  String get sectionTextButtons => 'Text Buttons';

  @override
  String get sectionRowButtons => 'Row Buttons';

  @override
  String get sectionSpecialCases => 'Special Cases';
}
