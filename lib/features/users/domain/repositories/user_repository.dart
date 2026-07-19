import 'package:basir_accounting_system/features/users/domain/entities/user.dart';

/// واجهة مستودع المستخدمين
abstract class UserRepository {
  /// جلب جميع المستخدمين
  Future<List<User>> getAllUsers();

  /// جلب مستخدم بواسطة المعرف
  Future<User?> getUserById(String id);

  /// جلب مستخدم بواسطة اسم المستخدم
  Future<User?> getUserByUsername(String username);

  /// إنشاء مستخدم جديد
  Future<void> createUser(User user, String password);

  /// تحديث بيانات المستخدم
  Future<void> updateUser(User user);

  /// حذف مستخدم
  Future<void> deleteUser(String id);

  /// تغيير كلمة المرور
  Future<void> changePassword(String id, String newPassword);

  /// التحقق من صحة كلمة المرور
  Future<bool> verifyPassword(String username, String password);
}
