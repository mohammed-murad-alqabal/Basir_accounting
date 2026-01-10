import 'package:basir_app/features/settings/data/repositories/profile_repository_impl.dart';
import 'package:basir_app/features/settings/domain/entities/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../../../../../helpers/test_helpers.dart';

void main() {
  group('ProfileRepositoryImpl', () {
    late Isar isar;
    late ProfileRepositoryImpl repository;
    const testUserId = 'user-123';

    setUp(() async {
      isar = await TestHelpers.createTestIsar();
      repository = ProfileRepositoryImpl(isar: isar, userId: testUserId);
    });

    tearDown(() async {
      await TestHelpers.cleanupTestIsar(isar);
    });

    test('should save and retrieve profile successfully', () async {
      // Arrange
      const profile = Profile(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      // Act
      await repository.saveProfile(profile);
      final savedProfile = await repository.getProfile();

      // Assert
      expect(savedProfile, isNotNull);
      expect(savedProfile?.email, 'test@example.com');
      expect(savedProfile?.displayName, 'Test User');
      expect(savedProfile?.userId, testUserId);
    });

    test('should return null when no profile exists for user', () async {
      // Act
      final savedProfile = await repository.getProfile();

      // Assert
      expect(savedProfile, isNull);
    });

    test('should only retrieve profile for specific userId', () async {
      // Arrange
      const profile1 = Profile(id: '1', email: 'user1@test.com');
      const profile2 = Profile(id: '2', email: 'user2@test.com');

      // Save for user1
      final repo1 = ProfileRepositoryImpl(isar: isar, userId: 'user1');
      await repo1.saveProfile(profile1);

      // Save for user2
      final repo2 = ProfileRepositoryImpl(isar: isar, userId: 'user2');
      await repo2.saveProfile(profile2);

      // Act
      final result1 = await repo1.getProfile();
      final result2 = await repo2.getProfile();

      // Assert
      expect(result1?.email, 'user1@test.com');
      expect(result2?.email, 'user2@test.com');
    });

    test('should update existing profile', () async {
      // Arrange
      const profile = Profile(
        id: '1',
        email: 'test@example.com',
        displayName: 'Initial Name',
      );
      await repository.saveProfile(profile);

      // Act
      await repository.saveProfile(
        profile.copyWith(displayName: 'Updated Name'),
      );
      final result = await repository.getProfile();

      // Assert
      expect(result?.displayName, 'Updated Name');
    });

    test('should delete profile', () async {
      // Arrange
      const profile = Profile(id: '1', email: 'test@example.com');
      await repository.saveProfile(profile);

      // Act
      await repository.deleteProfile();
      final result = await repository.getProfile();

      // Assert
      expect(result, isNull);
    });
  });
}
