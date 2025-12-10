import 'package:basser_app/core/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFontSizes', () {
    test('heading sizes should be defined correctly', () {
      expect(AppFontSizes.headingLarge, equals(32.0));
      expect(AppFontSizes.headingMedium, equals(24.0));
      expect(AppFontSizes.headingSmall, equals(20.0));
    });

    test('body sizes should be defined correctly', () {
      expect(AppFontSizes.bodyLarge, equals(16.0));
      expect(AppFontSizes.bodyMedium, equals(14.0));
      expect(AppFontSizes.bodySmall, equals(12.0));
    });

    test('label sizes should be defined correctly', () {
      expect(AppFontSizes.labelLarge, equals(14.0));
      expect(AppFontSizes.labelSmall, equals(12.0));
    });

    test('heading sizes should be in descending order', () {
      expect(
        AppFontSizes.headingLarge,
        greaterThan(AppFontSizes.headingMedium),
      );
      expect(
        AppFontSizes.headingMedium,
        greaterThan(AppFontSizes.headingSmall),
      );
    });

    test('body sizes should be in descending order', () {
      expect(AppFontSizes.bodyLarge, greaterThan(AppFontSizes.bodyMedium));
      expect(AppFontSizes.bodyMedium, greaterThan(AppFontSizes.bodySmall));
    });

    test('label sizes should be in descending order', () {
      expect(AppFontSizes.labelLarge, greaterThan(AppFontSizes.labelSmall));
    });
  });

  group('AppFonts', () {
    test('arabic font should be Tajawal', () {
      expect(AppFonts.arabicFont, equals('Tajawal'));
    });

    test('english font should be Roboto', () {
      expect(AppFonts.englishFont, equals('Roboto'));
    });

    test('fonts should be non-empty strings', () {
      expect(AppFonts.arabicFont, isNotEmpty);
      expect(AppFonts.englishFont, isNotEmpty);
    });
  });

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

  group('AppMessages', () {
    group('Success Messages', () {
      test('success messages should be defined', () {
        expect(AppMessages.loginSuccess, equals('تم تسجيل الدخول بنجاح'));
        expect(AppMessages.setupSuccess, equals('تم إعداد التطبيق بنجاح'));
        expect(
          AppMessages.invoiceCreatedSuccess,
          equals('تم إنشاء الفاتورة بنجاح'),
        );
        expect(
          AppMessages.customerAddedSuccess,
          equals('تم إضافة العميل بنجاح'),
        );
        expect(AppMessages.dataSavedSuccess, equals('تم حفظ البيانات بنجاح'));
      });

      test('all success messages should be non-empty', () {
        expect(AppMessages.loginSuccess, isNotEmpty);
        expect(AppMessages.setupSuccess, isNotEmpty);
        expect(AppMessages.invoiceCreatedSuccess, isNotEmpty);
        expect(AppMessages.customerAddedSuccess, isNotEmpty);
        expect(AppMessages.dataSavedSuccess, isNotEmpty);
      });
    });

    group('Error Messages', () {
      test('error messages should be defined', () {
        expect(
          AppMessages.invalidCredentials,
          equals('بيانات الاعتماد غير صحيحة'),
        );
        expect(AppMessages.emptyField, equals('هذا الحقل مطلوب'));
        expect(AppMessages.invalidEmail, equals('البريد الإلكتروني غير صحيح'));
        expect(AppMessages.passwordTooShort, equals('كلمة المرور قصيرة جدًا'));
        expect(AppMessages.usernameTaken, equals('اسم المستخدم مستخدم بالفعل'));
        expect(
          AppMessages.errorOccurred,
          equals('حدث خطأ ما. يرجى المحاولة لاحقًا'),
        );
        expect(
          AppMessages.noInternetConnection,
          equals('لا توجد اتصالية إنترنت'),
        );
        expect(AppMessages.databaseError, equals('خطأ في قاعدة البيانات'));
      });

      test('all error messages should be non-empty', () {
        expect(AppMessages.invalidCredentials, isNotEmpty);
        expect(AppMessages.emptyField, isNotEmpty);
        expect(AppMessages.invalidEmail, isNotEmpty);
        expect(AppMessages.passwordTooShort, isNotEmpty);
        expect(AppMessages.usernameTaken, isNotEmpty);
        expect(AppMessages.errorOccurred, isNotEmpty);
        expect(AppMessages.noInternetConnection, isNotEmpty);
        expect(AppMessages.databaseError, isNotEmpty);
      });
    });
  });

  group('AppConfig', () {
    test('app info should be defined', () {
      expect(AppConfig.appName, equals('بصير'));
      expect(AppConfig.appVersion, equals('1.0.0'));
      expect(
        AppConfig.appDescription,
        equals('نظام إدارة الفواتير والعملاء الذكي'),
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

  group('InvoiceStatus', () {
    test('all statuses should be defined', () {
      expect(InvoiceStatus.draft, equals('draft'));
      expect(InvoiceStatus.issued, equals('issued'));
      expect(InvoiceStatus.paid, equals('paid'));
      expect(InvoiceStatus.overdue, equals('overdue'));
      expect(InvoiceStatus.cancelled, equals('cancelled'));
    });

    test('all statuses should be non-empty strings', () {
      expect(InvoiceStatus.draft, isNotEmpty);
      expect(InvoiceStatus.issued, isNotEmpty);
      expect(InvoiceStatus.paid, isNotEmpty);
      expect(InvoiceStatus.overdue, isNotEmpty);
      expect(InvoiceStatus.cancelled, isNotEmpty);
    });

    test('all statuses should be unique', () {
      final statuses = [
        InvoiceStatus.draft,
        InvoiceStatus.issued,
        InvoiceStatus.paid,
        InvoiceStatus.overdue,
        InvoiceStatus.cancelled,
      ];
      final uniqueStatuses = statuses.toSet();
      expect(statuses.length, equals(uniqueStatuses.length));
    });

    test('all statuses should be lowercase', () {
      expect(InvoiceStatus.draft, equals(InvoiceStatus.draft.toLowerCase()));
      expect(InvoiceStatus.issued, equals(InvoiceStatus.issued.toLowerCase()));
      expect(InvoiceStatus.paid, equals(InvoiceStatus.paid.toLowerCase()));
      expect(
        InvoiceStatus.overdue,
        equals(InvoiceStatus.overdue.toLowerCase()),
      );
      expect(
        InvoiceStatus.cancelled,
        equals(InvoiceStatus.cancelled.toLowerCase()),
      );
    });
  });

  group('InvoiceStatusLabels', () {
    test('labels map should contain all statuses', () {
      expect(InvoiceStatusLabels.labels, containsPair('draft', 'مسودة'));
      expect(InvoiceStatusLabels.labels, containsPair('issued', 'مُصدرة'));
      expect(InvoiceStatusLabels.labels, containsPair('paid', 'مدفوعة'));
      expect(InvoiceStatusLabels.labels, containsPair('overdue', 'مستحقة'));
      expect(InvoiceStatusLabels.labels, containsPair('cancelled', 'ملغاة'));
    });

    test('labels map should have 5 entries', () {
      expect(InvoiceStatusLabels.labels.length, equals(5));
    });

    test('all labels should be non-empty', () {
      InvoiceStatusLabels.labels.forEach((key, value) {
        expect(key, isNotEmpty);
        expect(value, isNotEmpty);
      });
    });

    test('labels should match InvoiceStatus constants', () {
      expect(InvoiceStatusLabels.labels.keys, contains(InvoiceStatus.draft));
      expect(InvoiceStatusLabels.labels.keys, contains(InvoiceStatus.issued));
      expect(InvoiceStatusLabels.labels.keys, contains(InvoiceStatus.paid));
      expect(InvoiceStatusLabels.labels.keys, contains(InvoiceStatus.overdue));
      expect(
        InvoiceStatusLabels.labels.keys,
        contains(InvoiceStatus.cancelled),
      );
    });

    test('should be able to get label for each status', () {
      expect(InvoiceStatusLabels.labels[InvoiceStatus.draft], equals('مسودة'));
      expect(
        InvoiceStatusLabels.labels[InvoiceStatus.issued],
        equals('مُصدرة'),
      );
      expect(InvoiceStatusLabels.labels[InvoiceStatus.paid], equals('مدفوعة'));
      expect(
        InvoiceStatusLabels.labels[InvoiceStatus.overdue],
        equals('مستحقة'),
      );
      expect(
        InvoiceStatusLabels.labels[InvoiceStatus.cancelled],
        equals('ملغاة'),
      );
    });
  });
}
