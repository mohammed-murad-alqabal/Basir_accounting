import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:isar/isar.dart';

part 'user_model.g.dart';

/// نموذج بيانات المستخدم لقاعدة البيانات
@Collection()
class UserModel {
  /// المعرف الداخلي لقاعدة البيانات
  Id id = Isar.autoIncrement;

  /// معرف المستخدم الفريد (UUID)
  @Index(unique: true, replace: true)
  late String userId;

  /// اسم المستخدم (فريد)
  @Index(unique: true, replace: true, caseSensitive: false)
  late String username;

  /// الاسم الكامل
  late String fullName;

  /// البريد الإلكتروني
  late String email;

  /// الدور الوظيفي
  @Enumerated(EnumType.name)
  late UserRole role;

  /// تجزئة كلمة المرور
  late String passwordHash;

  /// حالة الحساب (نشط/غير نشط)
  bool isActive = true;

  /// تاريخ الإنشاء
  late DateTime createdAt;

  /// تاريخ التحديث
  late DateTime updatedAt;

  /// آخر تسجيل دخول
  DateTime? lastLoginAt;
}
