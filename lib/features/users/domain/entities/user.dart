import 'package:basir_accounting_system/features/users/domain/entities/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// كائن المستخدم في النظام
@freezed
class User with _$User {
  /// إنشاء مستخدم جديد
  const factory User({
    /// المعرف الفريد للمستخدم
    required String id,

    /// اسم المستخدم لتسجيل الدخول
    required String username,

    /// الاسم الكامل
    required String fullName,

    /// البريد الإلكتروني
    required String email,

    /// دور المستخدم وصلاحيات
    required UserRole role,

    /// حالة تفعيل الحساب
    @Default(true) bool isActive,

    /// آخر تسجيل دخول
    DateTime? lastLoginAt,

    /// تاريخ إنشاء الحساب
    DateTime? createdAt,

    /// تاريخ آخر تحديث
    DateTime? updatedAt,
  }) = _User;

  /// تحويل من JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
