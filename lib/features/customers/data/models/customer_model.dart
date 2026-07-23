import 'package:basir_accounting_system/core/models/sync_status.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:isar/isar.dart';

part 'customer_model.g.dart';

/// نموذج العميل لـ Isar (Customer Model for Isar)
///
/// يستخدم لتخزين بيانات العملاء محليًا في قاعدة البيانات.
/// هذا النموذج يمثل طبقة البيانات (Data Layer) ويتم تحويله
/// إلى/من كيان العميل (Customer Entity) في طبقة المجال (Domain Layer).
///
/// **الميزات:**
/// - تخزين محلي آمن باستخدام Isar
/// - معرف تلقائي (Auto-increment ID)
/// - تحويل سهل بين النموذج والكيان
/// - دعم الحقول الاختيارية
///
/// **مثال:**
/// ```dart
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   phone: '0501234567',
///   email: 'ahmed@example.com',
/// ,);
///
/// final model = CustomerModel.fromEntity(customer,);
/// await isar.customerModels.put(model,);
/// ```
@collection
class CustomerModel {
  /// Constructor افتراضي (مطلوب لـ Isar)
  CustomerModel();

  /// إنشاء نموذج من كيان (Entity)
  ///
  /// يحول كيان العميل (Customer Entity) إلى نموذج Isar
  /// للتخزين في قاعدة البيانات المحلية.
  ///
  /// **الاستخدام:**
  /// ```dart
  /// final customer = Customer(
  ///   id: 'customer-1',
  ///   name: 'أحمد محمد',
  ///   phone: '0501234567',
  /// ,);
  ///
  /// final model = CustomerModel.fromEntity(customer,);
  /// await isar.customerModels.put(model,);
  /// ```
  ///
  /// **Parameters:**
  /// - [customer]: كيان العميل المراد تحويله
  ///
  /// **Returns:** نموذج Isar جاهز للحفظ
  factory CustomerModel.fromEntity(Customer customer) => CustomerModel()
    ..customerId = customer.id
    ..nameAr = customer.nameAr
    ..nameEn = customer.nameEn
    ..taxNumber = customer.taxNumber
    ..phone = customer.phone
    ..email = customer.email
    ..address = customer.address
    ..notes = customer.notes
    ..createdAt = customer.createdAt
    ..updatedAt = customer.updatedAt
    ..creditLimit = customer.creditLimit
    ..balance = customer.balance
    ..receivableAccountId = customer.receivableAccountId
    ..userId = customer.userId
    ..syncStatus = customer.syncStatus
    ..serverUpdatedAt = customer.serverUpdatedAt
    ..isDeleted = customer.isDeleted;

  /// معرف Isar التلقائي (Auto-increment)
  ///
  /// يتم توليده تلقائيًا بواسطة Isar عند الحفظ.
  /// لا يجب تعيين قيمة له يدويًا.
  Id id = Isar.autoIncrement;

  /// معرف العميل الفريد (UUID)
  ///
  /// معرف فريد للعميل يستخدم في طبقة المجال (Domain Layer).
  /// يتم توليده عند إنشاء عميل جديد.
  @Index(unique: true)
  late String customerId;

  /// اسم العميل بالعربية
  @Index()
  late String nameAr;

  /// اسم العميل بالإنجليزية
  @Index()
  late String nameEn;

  /// الرقم الضريبي للعميل (اختياري)
  String? taxNumber;

  /// رقم هاتف العميل
  ///
  /// **اختياري** - يمكن أن يكون null.
  ///
  /// **التنسيق المتوقع:** '05XXXXXXXX' (السعودية)
  ///
  /// **مثال:** '0501234567'
  String? phone;

  /// البريد الإلكتروني للعميل
  ///
  /// **اختياري** - يمكن أن يكون null.
  ///
  /// **التنسيق المتوقع:** email@domain.com
  ///
  /// **مثال:** 'ahmed@example.com'
  String? email;

  /// عنوان العميل
  ///
  /// **اختياري** - يمكن أن يكون null.
  ///
  /// **مثال:** 'الرياض، حي النخيل، شارع الملك فهد'
  String? address;

  /// ملاحظات عن العميل
  String? notes;

  /// تاريخ إنشاء العميل
  ///
  /// يتم تعيينه تلقائيًا عند إنشاء عميل جديد.
  @Index()
  late DateTime createdAt;

  /// تاريخ آخر تحديث للعميل
  ///
  /// يتم تحديثه تلقائيًا عند تعديل بيانات العميل.
  late DateTime updatedAt;

  /// سقف الرصيد (الائتمان)
  double creditLimit = 0;

  /// الرصيد الحالي
  double balance = 0;

  /// معرف حساب العميل في دليل الحسابات
  String? receivableAccountId;

  /// معرف المستخدم (لعزل البيانات).
  @Index()
  String? userId;

  /// حالة المزامنة
  @enumerated
  late SyncStatus syncStatus;

  /// تاريخ آخر تحديث من السيرفر
  DateTime? serverUpdatedAt;

  /// هل السجل محذوف
  late bool isDeleted;

  /// تحويل النموذج إلى كيان (Entity)
  ///
  /// يحول نموذج Isar إلى كيان العميل (Customer Entity)
  /// المستخدم في طبقة المجال (Domain Layer).
  ///
  /// **الاستخدام:**
  /// ```dart
  /// final model = await isar.customerModels.get(1,);
  /// final customer = model?.toEntity();
  /// ```
  ///
  /// **Returns:** كيان العميل (Customer Entity)
  Customer toEntity() => Customer(
        id: customerId,
        nameAr: nameAr,
        nameEn: nameEn,
        taxNumber: taxNumber,
        phone: phone,
        email: email,
        address: address,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
        creditLimit: creditLimit,
        balance: balance,
        receivableAccountId: receivableAccountId,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
