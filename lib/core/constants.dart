// ملف الثوابت الأساسية للتطبيق

class StorageKeys {
  static const String username = 'username';
  static const String passwordHash = 'password_hash';
  static const String isLoggedIn = 'is_logged_in';
  static const String keepLoggedIn = 'keep_logged_in';
  static const String isGuest = 'is_guest';
  static const String pinCode = 'pin_code';
  static const String pinSalt = 'pin_salt';
  static const String patternLock = 'pattern_lock';
  static const String patternHash = 'pattern_hash';
  static const String patternSalt = 'pattern_salt';
  static const String patternString = 'pattern_string';
  static const String biometricEnabled = 'biometric_enabled';
  static const String authMethod = 'auth_method';
  static const String phoneNumber = 'phone_number';
  static const String phoneVerified = 'phone_verified';
  static const String emailVerified = 'email_verified';
  static const String appLockEnabled = 'app_lock_enabled';
  static const String lockOnResume = 'lock_on_resume';
  static const String cloudMfaRequired = 'cloud_mfa_required';
  static const String mfaLastUnlockAtMs = 'mfa_last_unlock_at_ms';
  static const String taxRate = 'tax_rate';
  static const String companyName = 'company_name';
  static const String companyTaxNumber = 'company_tax_number';
  static const String companyAddress = 'company_address';
  static const String companyPhone = 'company_phone';
  static const String currencySymbol = 'currency_symbol';
  static const String currencyCode = 'currency_code';
  static const String defaultCountryCode = 'default_country_code';
  static const String invoiceStyle = 'invoice_style';
}

class AppConfig {
  static const String appName = 'بصير';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'نظام بصير المحاسبي والمالي الذكي';
  static const double defaultTaxRate = 0.15;
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;
  static const String defaultCurrencySymbol = 'ر.س';
  static const String defaultCurrencyCode = 'SAR';
  static const String defaultCountryCode = '966';
  static const String defaultInvoiceStyle = 'classic';
}
