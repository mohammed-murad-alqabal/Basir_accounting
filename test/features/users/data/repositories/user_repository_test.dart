import 'dart:io';

import 'package:basir_accounting_system/features/users/data/models/user_model.dart';
import 'package:basir_accounting_system/features/users/data/repositories/user_repository_impl.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Isar isar;
  late UserRepositoryImpl repository;
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync();
    isar = await Isar.open(
      [UserModelSchema],
      directory: tempDir.path,
    );
    repository = UserRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  const tUser = User(
    id: 'user1',
    username: 'john_doe',
    fullName: 'John Doe',
    email: 'john@example.com',
    role: UserRole.admin,
  );

  group('UserRepositoryImpl', () {
    test('createUser should insert user with hashed password', () async {
      await repository.createUser(tUser, 'password123');

      final stored =
          await isar.userModels.filter().userIdEqualTo('user1').findFirst();
      expect(stored, isNotNull);
      expect(stored?.username, 'john_doe');
      expect(stored?.passwordHash, isNot('password123')); // Hashed
    });

    test('getUserByUsername should return correct user', () async {
      await repository.createUser(tUser, 'pass');

      final result = await repository.getUserByUsername('john_doe');
      expect(result, isNotNull);
      expect(result?.id, tUser.id);
    });

    test('verifyPassword should return true for correct password', () async {
      await repository.createUser(tUser, 'secret');

      final isValid = await repository.verifyPassword('john_doe', 'secret');
      expect(isValid, isTrue);

      final isInvalid = await repository.verifyPassword('john_doe', 'wrong');
      expect(isInvalid, isFalse);
    });

    test('changePassword should update hash', () async {
      await repository.createUser(tUser, 'oldPass');
      await repository.changePassword(tUser.id, 'newPass');

      final isValidOld = await repository.verifyPassword('john_doe', 'oldPass');
      expect(isValidOld, isFalse);

      final isValidNew = await repository.verifyPassword('john_doe', 'newPass');
      expect(isValidNew, isTrue);
    });

    test('deleteUser should remove user', () async {
      await repository.createUser(tUser, 'pass');
      await repository.deleteUser(tUser.id);

      final result = await repository.getUserByUsername('john_doe');
      expect(result, isNull);
    });
  });
}
