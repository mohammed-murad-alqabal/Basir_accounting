import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/users/domain/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_service.g.dart';

/// خدمة إدارة المستخدمين
@riverpod
class UserService extends _$UserService {
  @override
  FutureOr<List<User>> build() async {
    final repo = ref.watch(userRepositoryProvider);
    return repo.getAllUsers();
  }

  /// إنشاء مستخدم جديد
  Future<void> createUser(User user, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.createUser(user, password);
      ref.invalidateSelf();
    } on Exception catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// تحديث بيانات المستخدم
  Future<void> updateUser(User user) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.updateUser(user);
      ref.invalidateSelf();
    } on Exception {
      rethrow;
    }
  }

  /// حذف مستخدم
  Future<void> deleteUser(String id) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.deleteUser(id);
      ref.invalidateSelf();
    } on Exception {
      rethrow;
    }
  }

  /// تغيير كلمة المرور
  Future<void> changePassword(String id, String newPassword) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.changePassword(id, newPassword);
    } on Exception {
      rethrow;
    }
  }
}
