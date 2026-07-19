import 'package:basir_accounting_system/features/settings/data/repositories/business_settings_repository_impl.dart';
import 'package:basir_accounting_system/features/settings/domain/entities/business_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../../../helpers/test_helpers.dart';

void main() {
  group('BusinessSettingsRepositoryImpl', () {
    late Isar isar;
    late BusinessSettingsRepositoryImpl repository;
    const testUserId = 'user-123';

    setUp(() async {
      isar = await TestHelpers.createTestIsar();
      repository = BusinessSettingsRepositoryImpl(
        isar: isar,
        userId: testUserId,
      );
    });

    tearDown(() async {
      await TestHelpers.cleanupTestIsar(isar);
    });

    test('should save and retrieve business settings successfully', () async {
      // Arrange
      const settings = BusinessSettings(
        id: '1',
        companyName: 'Basir Corp',
        taxNumber: '123456789',
      );

      // Act
      await repository.saveSettings(settings);
      final savedSettings = await repository.getSettings();

      // Assert
      expect(savedSettings, isNotNull);
      expect(savedSettings?.companyName, 'Basir Corp');
      expect(savedSettings?.taxNumber, '123456789');
      expect(savedSettings?.currencyCode, 'SAR');
      expect(savedSettings?.userId, testUserId);
    });

    test('should return null when no settings exist', () async {
      // Act
      final savedSettings = await repository.getSettings();

      // Assert
      expect(savedSettings, isNull);
    });

    test('should only retrieve settings for specific userId', () async {
      // Arrange
      const settings1 = BusinessSettings(id: '1', companyName: 'Company 1');
      const settings2 = BusinessSettings(id: '2', companyName: 'Company 2');

      // Save for user1
      final repo1 = BusinessSettingsRepositoryImpl(isar: isar, userId: 'user1');
      await repo1.saveSettings(settings1);

      // Save for user2
      final repo2 = BusinessSettingsRepositoryImpl(isar: isar, userId: 'user2');
      await repo2.saveSettings(settings2);

      // Act
      final result1 = await repo1.getSettings();
      final result2 = await repo2.getSettings();

      // Assert
      expect(result1?.companyName, 'Company 1');
      expect(result2?.companyName, 'Company 2');
    });

    test('should update existing settings', () async {
      // Arrange
      const settings = BusinessSettings(id: '1', companyName: 'Old Name');
      await repository.saveSettings(settings);

      // Act
      await repository.saveSettings(settings.copyWith(companyName: 'New Name'));
      final result = await repository.getSettings();

      // Assert
      expect(result?.companyName, 'New Name');
    });
  });
}
