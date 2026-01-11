import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

/// كيان العميل
///
/// يمثل بيانات العميل في طبقة Domain
/// هذا الكيان مستقل عن التفاصيل التقنية ويحتوي فقط على منطق الأعمال
///
/// Properties:
/// - معرف فريد للعميل
/// - اسم العميل (مطلوب)
/// - رقم الهاتف (اختياري)
/// - البريد الإلكتروني (اختياري)
/// - العنوان (اختياري)
/// - تاريخ الإنشاء
/// - تاريخ آخر تحديث
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
///,);
/// ```
@freezed
class Customer with _$Customer {
  /// إنشاء كيان عميل جديد
  ///
  /// Parameters:
  /// - [id]: معرف فريد للعميل (مطلوب)
  /// - [name]: اسم العميل (مطلوب)
  /// - [createdAt]: تاريخ الإنشاء (مطلوب)
  /// - [updatedAt]: تاريخ آخر تحديث (مطلوب)
  /// - [phone]: رقم الهاتف (اختياري)
  /// - [email]: البريد الإلكتروني (اختياري)
  /// - [address]: العنوان (اختياري)
  ///
  /// Example:
  /// ```dart
  /// final customer = Customer(
  ///   id: 'customer-1',
  ///   name: 'أحمد محمد',
  ///   createdAt: DateTime.now(),
  ///   updatedAt: DateTime.now(),
  ///,);
  /// ```
  const factory Customer({
    /// معرف فريد للعميل
    required String id,

    /// اسم العميل بالعربية
    required String nameAr,

    /// اسم العميل بالإنجليزية
    required String nameEn,

    /// تاريخ إنشاء العميل
    required DateTime createdAt,

    /// تاريخ آخر تحديث للعميل
    required DateTime updatedAt,

    /// الرقم الضريبي (مطلوب للفواتير الضريبية)
    String? taxNumber,

    /// رقم هاتف العميل (اختياري)
    String? phone,

    /// البريد الإلكتروني للعميل (اختياري)
    String? email,

    /// عنوان العميل (اختياري)
    String? address,

    /// ملاحظات عن العميل (اختياري)
    String? notes,

    /// سقف الرصيد (الائتمان) المسموح به
    @Default(0.0) double creditLimit,

    /// الرصيد الحالي للعميل
    @Default(0.0) double balance,

    /// معرف حساب العميل في دليل الحسابات (AR Account)
    String? receivableAccountId,

    /// معرف المستخدم صاحب العميل (لعزل البيانات)
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _Customer;

  /// إنشاء كيان من JSON
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  const Customer._();

  /// الحصول على الاسم المناسب حسب اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
