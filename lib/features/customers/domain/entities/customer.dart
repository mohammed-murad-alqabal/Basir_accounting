/// كيان العميل
///
/// يمثل بيانات العميل في طبقة Domain
/// هذا الكيان مستقل عن التفاصيل التقنية ويحتوي فقط على منطق الأعمال
///
/// Properties:
/// - [id]: معرف فريد للعميل
/// - [name]: اسم العميل (مطلوب)
/// - [phone]: رقم الهاتف (اختياري)
/// - [email]: البريد الإلكتروني (اختياري)
/// - [address]: العنوان (اختياري)
/// - [createdAt]: تاريخ الإنشاء
/// - [updatedAt]: تاريخ آخر تحديث
///
/// Example:
/// ```dart
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   phone: '0501234567',
///   email: 'ahmed@example.com',
///   address: 'الرياض، السعودية',
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
/// ```
library;

import 'package:flutter/foundation.dart';

@immutable
class Customer {
  /// إنشاء كيان عميل
  ///
  /// Parameters:
  /// - [id]: معرف فريد للعميل (مطلوب)
  /// - [name]: اسم العميل (مطلوب)
  /// - [createdAt]: تاريخ الإنشاء (مطلوب)
  /// - [updatedAt]: تاريخ آخر تحديث (مطلوب)
  /// - [phone]: رقم الهاتف (اختياري)
  /// - [email]: البريد الإلكتروني (اختياري)
  /// - [address]: العنوان (اختياري)
  const Customer({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
    this.email,
    this.address,
  });

  /// معرف فريد للعميل
  final String id;

  /// اسم العميل
  final String name;

  /// رقم هاتف العميل (اختياري)
  final String? phone;

  /// البريد الإلكتروني للعميل (اختياري)
  final String? email;

  /// عنوان العميل (اختياري)
  final String? address;

  /// تاريخ إنشاء العميل
  final DateTime createdAt;

  /// تاريخ آخر تحديث للعميل
  final DateTime updatedAt;

  /// نسخ العميل مع تحديث بعض الحقول
  ///
  /// ينشئ نسخة جديدة من العميل مع تحديث الحقول المحددة فقط
  ///
  /// Parameters: جميع المعاملات اختيارية
  /// - [id]: معرف جديد
  /// - [name]: اسم جديد
  /// - [phone]: رقم هاتف جديد
  /// - [email]: بريد إلكتروني جديد
  /// - [address]: عنوان جديد
  /// - [createdAt]: تاريخ إنشاء جديد
  /// - [updatedAt]: تاريخ تحديث جديد
  ///
  /// Returns: نسخة جديدة من Customer مع التحديثات
  ///
  /// Example:
  /// ```dart
  /// final updatedCustomer = customer.copyWith(
  ///   phone: '0509876543',
  ///   updatedAt: DateTime.now(),
  /// );
  /// ```
  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  String toString() =>
      'Customer(id: $id, name: $name, phone: $phone, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          email == other.email &&
          address == other.address;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      address.hashCode;
}
