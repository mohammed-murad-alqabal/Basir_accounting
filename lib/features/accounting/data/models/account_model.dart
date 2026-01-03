import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/ifrs18_ontology.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

part 'account_model.g.dart';

/// نموذج بيانات الحساب للتخزين في Isar.
@collection
class AccountModel {
  /// مُنشئ افتراضي.
  AccountModel();

  /// إنشاء نموذج من كيان.
  AccountModel.fromEntity(Account entity) {
    id = entity.id;
    code = entity.code;
    nameAr = entity.nameAr;
    nameEn = entity.nameEn;
    type = entity.type;
    nature = entity.nature;
    balance = entity.balance.toString();
    subType = entity.subType;
    ifrs18Category = entity.ifrs18Category ?? Ifrs18Category.none;
    isParent = entity.isParent;
    parentId = entity.parentId;
    isActive = entity.isActive;
    isSystem = entity.isSystem;
    userId = entity.userId;
    syncStatus = entity.syncStatus;
    serverUpdatedAt = entity.serverUpdatedAt;
    isDeleted = entity.isDeleted;
  }

  /// المعرف الداخلي لـ Isar.
  Id? isarId;

  /// المعرف الفريد (GUID).
  @Index(unique: true, replace: true)
  late String id;

  /// رمز الحساب (مثلاً: 1101).
  @Index(unique: true)
  late String code;

  /// الاسم بالعربية.
  late String nameAr;

  /// الاسم بالإنجليزية.
  late String nameEn;

  /// نوع الحساب.
  @enumerated
  late AccountType type;

  /// طبيعة الحساب (مدين/دائن).
  @enumerated
  late AccountNature nature;

  /// الرصيد الحالي (مخزن كـ String للـ Decimal).
  late String balance;

  /// التصنيف الفرعي.
  String subType = '';

  /// تصنيف IFRS 18.
  @enumerated
  Ifrs18Category ifrs18Category = Ifrs18Category.none;

  /// هل هو حساب أب.
  bool isParent = false;

  /// معرف الأب.
  String? parentId;

  /// هل الحساب نشط.
  bool isActive = true;

  /// هل هو حساب نظامي.
  bool isSystem = false;

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? serverUpdatedAt;

  /// هل الحساب محذوف (حذف ناعم)
  late bool isDeleted;

  /// تحويل النموذج إلى كيان.
  Account toEntity() => Account(
        id: id,
        code: code,
        nameAr: nameAr,
        nameEn: nameEn,
        type: type,
        nature: nature,
        balance: Decimal.parse(balance),
        subType: subType,
        ifrs18Category:
            ifrs18Category == Ifrs18Category.none ? null : ifrs18Category,
        isParent: isParent,
        parentId: parentId,
        isActive: isActive,
        isSystem: isSystem,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
