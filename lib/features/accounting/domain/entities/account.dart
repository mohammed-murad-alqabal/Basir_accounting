import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

/// أنواع الحسابات المحاسبية الأساسية
/// (FR-ACC-012: تصنيف الحسابات)
enum AccountType {
  /// أصول
  asset,

  /// خصوم (التزامات)
  liability,

  /// حقوق ملكية
  equity,

  /// إيرادات
  revenue,

  /// مصروفات
  expense,
}

/// طبيعة الحساب (مدين/دائن).
enum AccountNature {
  /// طبيعته مدين (مثل الأصول والمصروفات).
  debit,

  /// طبيعته دائن (مثل الخصوم والإيرادات وحقوق الملكية).
  credit,
}

/// كيان الحساب في دليل الحسابات.
@freezed
class Account with _$Account {
  /// إنشاء حساب جديد.
  const factory Account({
    /// معرف فريد للحساب
    /// رمز تعريف الحساب الفريد.
    required String id,

    /// رمز الحساب (مثال: 1101)
    required String code,

    /// اسم الحساب (عربي)
    required String nameAr,

    /// اسم الحساب (نجليزي)
    required String nameEn,

    /// نوع الحساب الرئيسي
    required AccountType type,

    /// طبيعة الحساب (مدين/دائن)
    required AccountNature nature,

    /// الرصيد الحالي (High-precision decimal)
    required Decimal balance,

    /// التصنيف الفرعي (مثال: نقدية، بنك، عملاء)
    @Default('') String subType,

    /// IFRS 18 Category for Profit & Loss presentation
    Ifrs18Category? ifrs18Category,

    /// هل هو حساب رئيسي (تجميعي) أم فرعي (حركة)
    @Default(false) bool isParent,

    /// معرف الحساب الأب (للهيكلة الشجرية)
    String? parentId,

    /// هل الحساب نشط
    @Default(true) bool isActive,

    /// هل الحساب نظامي (لا يمكن حذفه)
    @Default(false) bool isSystem,

    /// معرف المستخدم صاحب الحساب (لعزل البيانات)
    String? userId,

    /// حالة المزامنة
    @Default(SyncStatus.synced) SyncStatus syncStatus,

    /// تاريخ آخر تحديث من السيرفر
    DateTime? serverUpdatedAt,

    /// هل السجل محذوف (حذف ناعم)
    @Default(false) bool isDeleted,
  }) = _Account;

  /// إنشاء حساب من JSON
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  const Account._();

  /// الاسم حسب اللغة
  String name({required bool isArabic}) => isArabic ? nameAr : nameEn;
}
