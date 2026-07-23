import 'package:basir_accounting_system/core/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Note: AppAppTypography.and AppFonts have been migrated to Design Tokens
  // in core/theme/tokens/. Tests for those should be in typography_tokens_test.dart

  group('StorageKeys', () {
    test('authentication keys should be defined', () {
      expect(StorageKeys.username, equals('username'));
      expect(StorageKeys.passwordHash, equals('password_hash'));
      expect(StorageKeys.isLoggedIn, equals('is_logged_in'));
      expect(StorageKeys.keepLoggedIn, equals('keep_logged_in'));
      expect(StorageKeys.isGuest, equals('is_guest'));
    });

    test('settings keys should be defined', () {
      expect(StorageKeys.taxRate, equals('tax_rate'));
      expect(StorageKeys.companyName, equals('company_name'));
      expect(StorageKeys.companyTaxNumber, equals('company_tax_number'));
    });

    test('all keys should be non-empty strings', () {
      expect(StorageKeys.username, isNotEmpty);
      expect(StorageKeys.passwordHash, isNotEmpty);
      expect(StorageKeys.isLoggedIn, isNotEmpty);
      expect(StorageKeys.keepLoggedIn, isNotEmpty);
      expect(StorageKeys.isGuest, isNotEmpty);
      expect(StorageKeys.taxRate, isNotEmpty);
      expect(StorageKeys.companyName, isNotEmpty);
      expect(StorageKeys.companyTaxNumber, isNotEmpty);
    });

    test('all keys should be unique', () {
      final keys = [
        StorageKeys.username,
        StorageKeys.passwordHash,
        StorageKeys.isLoggedIn,
        StorageKeys.keepLoggedIn,
        StorageKeys.isGuest,
        StorageKeys.taxRate,
        StorageKeys.companyName,
        StorageKeys.companyTaxNumber,
      ];
      final uniqueKeys = <credential-fixture>();
      expect(keys.length, equals(uniqueKeys.length));
    });
  });

  group('AppConfig', () {
    test('app info should be defined', () {
      expect(AppConfig.appName, equals('بصير'));
      expect(AppConfig.appVersion, equals('1.0.0'));
      expect(
        AppConfig.appDescription,
        equals('نظام بصير المحاسبي والمالي الذكي'),
      );
    });

    test('default values should be defined correctly', () {
      expect(AppConfig.defaultTaxRate, equals(0.15));
      expect(AppConfig.minPasswordLength, equals(6));
      expect(AppConfig.minUsernameLength, equals(3));
    });

    test('app name should be non-empty', () {
      expect(AppConfig.appName, isNotEmpty);
    });

    test('app version should follow semantic versioning', () {
      expect(AppConfig.appVersion, matches(RegExp(r'^\d+\.\d+\.\d+$')));
    });

    test('default tax rate should be between 0 and 1', () {
      expect(AppConfig.defaultTaxRate, greaterThanOrEqualTo(0.0));
      expect(AppConfig.defaultTaxRate, lessThanOrEqualTo(1.0));
    });

    test('minimum lengths should be positive', () {
      expect(AppConfig.minPasswordLength, greaterThan(0));
      expect(AppConfig.minUsernameLength, greaterThan(0));
    });

    test('password should be longer than username minimum', () {
      expect(
        AppConfig.minPasswordLength,
        greaterThanOrEqualTo(AppConfig.minUsernameLength),
      );
    });
  });

  // Note: InvoiceStatus has been migrated to an enum in features/invoices/domain/entities/invoice_status.dart
  // Tests for InvoiceStatus should be in invoice_status_test.dart
}
