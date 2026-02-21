import 'dart:convert';

import 'package:basir_accounting_system/features/users/data/models/user_model.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:basir_accounting_system/features/users/domain/repositories/user_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

/// تنفيذ مستودع المستخدمين باستخدام Isar
class UserRepositoryImpl implements UserRepository {
  /// إنشاء خادم مستودع المستخدمين مع قاعدة البيانات [Isar]
  UserRepositoryImpl(this._isar);
  final Isar _isar;

  @override
  Future<List<User>> getAllUsers() async {
    final models = await _isar.userModels.where().findAll();
    return models.map(_toEntity).toList();
  }

  @override
  Future<User?> getUserById(String id) async {
    final model = await _isar.userModels.filter().userIdEqualTo(id).findFirst();
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    final query = _isar.userModels.filter().usernameEqualTo(username);
    final model = await query.findFirst();
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<void> createUser(User user, String password) async {
    final model = _toModel(user, _hashPassword(password));
    await _isar.writeTxn(() async {
      await _isar.userModels.put(model);
    });
  }

  @override
  Future<void> updateUser(User user) async {
    final query = _isar.userModels.filter().userIdEqualTo(user.id);
    final existing = await query.findFirst();
    if (existing != null) {
      final updated = _toModel(user, existing.passwordHash);
      updated.id = existing.id; // Preserve Isar ID
      await _isar.writeTxn(() async {
        await _isar.userModels.put(updated);
      });
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    await _isar.writeTxn(() async {
      await _isar.userModels.filter().userIdEqualTo(id).deleteAll();
    });
  }

  @override
  Future<void> changePassword(String id, String newPassword) async {
    final query = _isar.userModels.filter().userIdEqualTo(id);
    final existing = await query.findFirst();
    if (existing != null) {
      existing.passwordHash = _hashPassword(newPassword);
      existing.updatedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.userModels.put(existing);
      });
    }
  }

  @override
  Future<bool> verifyPassword(String username, String password) async {
    final query = _isar.userModels.filter().usernameEqualTo(username);
    final user = await query.findFirst();
    if (user == null) return false;
    return user.passwordHash == _hashPassword(password);
  }

  // --- Helpers ---

  String _hashPassword(String password) {
    // Simple SHA256 for MVP. In production, use bcrypt/argon2.
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  User _toEntity(UserModel model) => User(
        id: model.userId,
        username: model.username,
        fullName: model.fullName,
        email: model.email,
        role: model.role,
        isActive: model.isActive,
        lastLoginAt: model.lastLoginAt,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );

  UserModel _toModel(User entity, String passwordHash) => UserModel()
    ..userId = entity.id
    ..username = entity.username
    ..fullName = entity.fullName
    ..email = entity.email
    ..role = entity.role
    ..passwordHash = passwordHash
    ..isActive = entity.isActive
    ..lastLoginAt = entity.lastLoginAt
    ..createdAt = entity.createdAt ?? DateTime.now()
    ..updatedAt = DateTime.now();
}
