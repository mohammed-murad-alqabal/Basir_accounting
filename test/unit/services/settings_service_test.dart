/// اختبارات SettingsService
///
/// يختبر جميع عمليات إدارة الإعدادات
library;

import 'package:basir_app/core/constants.dart';
import 'package:basir_app/features/settings/domain/entities/business_settings.dart';
import 'package:basir_app/features/settings/domain/entities/profile.dart';
import 'package:basir_app/features/settings/domain/repositories/business_settings_repository.dart';
import 'package:basir_app/features/settings/domain/repositories/profile_repository.dart';
import 'package:basir_app/services/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_secure_storage.dart';

class MockBusinessSettingsRepository implements BusinessSettingsRepository {
  BusinessSettings? _settings;
  @override
  Future<BusinessSettings?> getSettings() async => _settings;
  @override
  Future<void> saveSettings(BusinessSettings settings) async {
    _settings = settings;
  }
}

class MockProfileRepository implements ProfileRepository {
  Profile? _profile;
  @override
  Future<Profile?> getProfile() async => _profile;
  @override
  Future<void> saveProfile(Profile profile) async {
    _profile = profile;
  }

  @override
  Future<void> deleteProfile() async {
    _profile = null;
  }
}

void main() {
  late MockSecureStorage mockStorage;
  late MockBusinessSettingsRepository mockBusinessRepo;
  late MockProfileRepository mockProfileRepo;
  late SettingsService settingsService;

  setUp(() {
    mockStorage = MockSecureStorage();
    mockBusinessRepo = MockBusinessSettingsRepository();
    mockProfileRepo = MockProfileRepository();
    settingsService = SettingsService(
      secureStorage: mockStorage,
      businessSettingsRepository: mockBusinessRepo,
      profileRepository: mockProfileRepo,
    );
  });

  group('SettingsService - Tax Rate', () {
    test('should return default tax rate when no value is stored', () async {
      // Act
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, AppConfig.defaultTaxRate);
    });

    test('should save and retrieve tax rate successfully', () async {
      // Arrange
      const taxRate = 0.15;

      // Act
      await settingsService.setTaxRate(taxRate);
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, taxRate);
    });

    test('should update tax rate when called multiple times', () async {
      // Arrange
      const firstRate = 0.15;
      const secondRate = 0.20;

      // Act
      await settingsService.setTaxRate(firstRate);
      await settingsService.setTaxRate(secondRate);
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, secondRate);
    });

    test('should handle zero tax rate', () async {
      // Arrange
      const taxRate = 0.0;

      // Act
      await settingsService.setTaxRate(taxRate);
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, taxRate);
    });

    test('should handle high tax rate', () async {
      // Arrange
      const taxRate = 0.99;

      // Act
      await settingsService.setTaxRate(taxRate);
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, taxRate);
    });
  });

  group('SettingsService - Company Name', () {
    test('should return null when no company name is stored', () async {
      // Act
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, null);
    });

    test('should save and retrieve company name successfully', () async {
      // Arrange
      const companyName = 'شركة بصير للتقنية';

      // Act
      await settingsService.setCompanyName(companyName);
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, companyName);
    });

    test('should update company name when called multiple times', () async {
      // Arrange
      const firstName = 'شركة بصير';
      const secondName = 'شركة بصير المحدودة';

      // Act
      await settingsService.setCompanyName(firstName);
      await settingsService.setCompanyName(secondName);
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, secondName);
    });

    test('should handle empty company name', () async {
      // Arrange
      const companyName = '';

      // Act
      await settingsService.setCompanyName(companyName);
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, companyName);
    });

    test('should handle long company name', () async {
      // Arrange
      const companyName =
          'شركة بصير للتقنية والبرمجيات والحلول الرقمية المحدودة';

      // Act
      await settingsService.setCompanyName(companyName);
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, companyName);
    });
  });

  group('SettingsService - Company Tax Number', () {
    test('should return null when no tax number is stored', () async {
      // Act
      final result = await settingsService.getCompanyTaxNumber();

      // Assert
      expect(result, null);
    });

    test('should save and retrieve tax number successfully', () async {
      // Arrange
      const taxNumber = '300123456789003';

      // Act
      await settingsService.setCompanyTaxNumber(taxNumber);
      final result = await settingsService.getCompanyTaxNumber();

      // Assert
      expect(result, taxNumber);
    });

    test('should update tax number when called multiple times', () async {
      // Arrange
      const firstNumber = '300123456789003';
      const secondNumber = '300987654321003';

      // Act
      await settingsService.setCompanyTaxNumber(firstNumber);
      await settingsService.setCompanyTaxNumber(secondNumber);
      final result = await settingsService.getCompanyTaxNumber();

      // Assert
      expect(result, secondNumber);
    });

    test('should handle empty tax number', () async {
      // Arrange
      const taxNumber = '';

      // Act
      await settingsService.setCompanyTaxNumber(taxNumber);
      final result = await settingsService.getCompanyTaxNumber();

      // Assert
      expect(result, taxNumber);
    });
  });

  group('SettingsService - Company Settings (Bulk Operations)', () {
    test('should save all company settings successfully', () async {
      // Arrange
      const companyName = 'شركة بصير';
      const taxNumber = '300123456789003';
      const taxRate = 0.15;

      // Act
      await settingsService.setCompanySettings(
        companyName: companyName,
        taxNumber: taxNumber,
        taxRate: taxRate,
      );

      // Assert
      final savedName = await settingsService.getCompanyName();
      final savedTaxNumber = await settingsService.getCompanyTaxNumber();
      final savedTaxRate = await settingsService.getTaxRate();

      expect(savedName, companyName);
      expect(savedTaxNumber, taxNumber);
      expect(savedTaxRate, taxRate);
    });

    test('should retrieve all company settings successfully', () async {
      // Arrange
      const companyName = 'شركة بصير';
      const taxNumber = '300123456789003';
      const taxRate = 0.15;

      await settingsService.setCompanySettings(
        companyName: companyName,
        taxNumber: taxNumber,
        taxRate: taxRate,
      );

      // Act
      final settings = await settingsService.getCompanySettings();

      // Assert
      expect(settings['companyName'], companyName);
      expect(settings['taxNumber'], taxNumber);
      expect(settings['taxRate'], taxRate.toString());
    });

    test('should return default values when no settings are stored', () async {
      // Act
      final settings = await settingsService.getCompanySettings();

      // Assert
      expect(settings['companyName'], null);
      expect(settings['taxNumber'], null);
      expect(settings['taxRate'], AppConfig.defaultTaxRate.toString());
    });

    test('should update all settings when called multiple times', () async {
      // Arrange
      const firstSettings = (
        nameEn: 'شركة بصير',
        nameAr: 'شركة بصير',
        taxNumber: '300123456789003',
        taxRate: 0.15,
      );
      const secondSettings = (
        nameEn: 'شركة بصير المحدودة',
        nameAr: 'شركة بصير المحدودة',
        taxNumber: '300987654321003',
        taxRate: 0.20,
      );

      // Act
      await settingsService.setCompanySettings(
        companyName: firstSettings.nameAr,
        taxNumber: firstSettings.taxNumber,
        taxRate: firstSettings.taxRate,
      );
      await settingsService.setCompanySettings(
        companyName: secondSettings.nameAr,
        taxNumber: secondSettings.taxNumber,
        taxRate: secondSettings.taxRate,
      );

      final settings = await settingsService.getCompanySettings();

      // Assert
      expect(settings['companyName'], secondSettings.nameAr);
      expect(settings['taxNumber'], secondSettings.taxNumber);
      expect(settings['taxRate'], secondSettings.taxRate.toString());
    });
  });

  group('SettingsService - Edge Cases', () {
    test('should handle special characters in company name', () async {
      // Arrange
      const companyName = 'شركة بصير & الشركاء (المحدودة)';

      // Act
      await settingsService.setCompanyName(companyName);
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, companyName);
    });

    test('should handle numbers in company name', () async {
      // Arrange
      const companyName = 'شركة بصير 2025';

      // Act
      await settingsService.setCompanyName(companyName);
      final result = await settingsService.getCompanyName();

      // Assert
      expect(result, companyName);
    });

    test('should handle decimal tax rates correctly', () async {
      // Arrange
      const taxRate = 0.155; // 15.5%

      // Act
      await settingsService.setTaxRate(taxRate);
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, taxRate);
    });

    test('should handle very small tax rates', () async {
      // Arrange
      const taxRate = 0.001; // 0.1%

      // Act
      await settingsService.setTaxRate(taxRate);
      final result = await settingsService.getTaxRate();

      // Assert
      expect(result, taxRate);
    });
  });
}
