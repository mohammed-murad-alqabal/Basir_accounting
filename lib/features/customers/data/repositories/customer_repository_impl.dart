import 'package:basser_app/features/customers/data/models/customer_model.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/domain/repositories/customer_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع العملاء (Customer Repository Implementation)
///
/// يوفر التطبيق الفعلي لواجهة [CustomerRepository] باستخدام
/// قاعدة بيانات Isar المحلية للتخزين والاسترجاع.
///
/// **الميزات:**
/// - تخزين محلي آمن باستخدام Isar
/// - معالجة الأخطاء الشاملة
/// - عمليات CRUD كاملة
/// - البحث والاستعلام
/// - معاملات آمنة (Transactions)
///
/// **الاستخدام:**
/// ```dart
/// final isar = await Isar.open([CustomerModelSchema]);
/// final repository = CustomerRepositoryImpl(isar: isar);
///
/// // إضافة عميل
/// final customer = Customer(
///   id: 'customer-1',
///   name: 'أحمد محمد',
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
/// await repository.addCustomer(customer);
///
/// // الحصول على جميع العملاء
/// final customers = await repository.getAllCustomers();
/// ```
///
/// **ملاحظات الأمان:**
/// - جميع عمليات الكتابة تتم داخل معاملات (Transactions)
/// - معالجة شاملة للأخطاء مع رسائل واضحة
/// - التحقق من وجود البيانات قبل الحذف
class CustomerRepositoryImpl implements CustomerRepository {
  /// إنشاء مستودع العملاء
  ///
  /// **Parameters:**
  /// - [isar]: مثيل قاعدة بيانات Isar المفتوحة
  ///
  /// **مثال:**
  /// ```dart
  /// final isar = await Isar.open([CustomerModelSchema]);
  /// final repository = CustomerRepositoryImpl(isar: isar);
  /// ```
  CustomerRepositoryImpl({required this.isar});

  /// مثيل قاعدة البيانات المحلية (Isar)
  ///
  /// يستخدم لجميع عمليات القراءة والكتابة على بيانات العملاء.
  final Isar isar;

  /// {@macro customer_repository.getAllCustomers}
  ///
  /// **التطبيق:**
  /// - يسترجع جميع نماذج العملاء من Isar
  /// - يحول كل نموذج إلى كيان (Entity)
  /// - يعيد قائمة فارغة إذا لم يكن هناك عملاء
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في قاعدة البيانات
  @override
  Future<List<Customer>> getAllCustomers() async {
    try {
      final models = await isar.customerModels.where().findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في جلب العملاء: $e');
    }
  }

  /// {@macro customer_repository.getCustomerById}
  ///
  /// **التطبيق:**
  /// - يبحث في جميع النماذج عن المعرف المطابق
  /// - يحول النموذج إلى كيان إذا وُجد
  /// - يعيد null إذا لم يُعثر على العميل
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في قاعدة البيانات
  @override
  Future<Customer?> getCustomerById(String id) async {
    try {
      final models = await isar.customerModels.where().findAll();
      final model = models.cast<CustomerModel?>().firstWhere(
            (m) => m?.customerId == id,
            orElse: () => null,
          );
      return model?.toEntity();
    } catch (e) {
      throw Exception('خطأ في جلب العميل: $e');
    }
  }

  /// {@macro customer_repository.searchCustomers}
  ///
  /// **التطبيق:**
  /// - يسترجع جميع النماذج
  /// - يفلتر النماذج التي تحتوي أسماؤها على نص البحث
  /// - يحول النماذج المطابقة إلى كيانات
  /// - البحث حساس لحالة الأحرف (Case-sensitive)
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في قاعدة البيانات
  @override
  Future<List<Customer>> searchCustomers(String query) async {
    try {
      final models = await isar.customerModels.where().findAll();
      final filtered = models.where((m) => m.name.contains(query)).toList();
      return filtered.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في البحث عن العملاء: $e');
    }
  }

  /// {@macro customer_repository.addCustomer}
  ///
  /// **التطبيق:**
  /// - يحول الكيان إلى نموذج Isar
  /// - يحفظ النموذج داخل معاملة (Transaction)
  /// - المعاملة تضمن سلامة البيانات
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في الحفظ
  @override
  Future<void> addCustomer(Customer customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      await isar.writeTxn(() async {
        await isar.customerModels.put(model);
      });
    } catch (e) {
      throw Exception('خطأ في إضافة العميل: $e');
    }
  }

  /// {@macro customer_repository.updateCustomer}
  ///
  /// **التطبيق:**
  /// - يحول الكيان المحدث إلى نموذج Isar
  /// - يستبدل النموذج القديم بالجديد داخل معاملة
  /// - يستخدم نفس المعرف للتحديث
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في التحديث
  @override
  Future<void> updateCustomer(Customer customer) async {
    try {
      final model = CustomerModel.fromEntity(customer);
      await isar.writeTxn(() async {
        await isar.customerModels.put(model);
      });
    } catch (e) {
      throw Exception('خطأ في تحديث العميل: $e');
    }
  }

  /// {@macro customer_repository.deleteCustomer}
  ///
  /// **التطبيق:**
  /// - يبحث عن النموذج بالمعرف المحدد
  /// - يحذف النموذج إذا وُجد داخل معاملة
  /// - لا يفعل شيئًا إذا لم يُعثر على العميل
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في الحذف
  @override
  Future<void> deleteCustomer(String id) async {
    try {
      await isar.writeTxn(() async {
        final models = await isar.customerModels.where().findAll();
        final model = models.cast<CustomerModel?>().firstWhere(
              (m) => m?.customerId == id,
              orElse: () => null,
            );
        if (model != null) {
          await isar.customerModels.delete(model.id);
        }
      });
    } catch (e) {
      throw Exception('خطأ في حذف العميل: $e');
    }
  }

  /// {@macro customer_repository.deleteAllCustomers}
  ///
  /// **التطبيق:**
  /// - يحذف جميع النماذج من المجموعة (Collection)
  /// - العملية تتم داخل معاملة لضمان السلامة
  /// - لا يمكن التراجع عن هذه العملية
  ///
  /// **تحذير:** استخدم بحذر - تحذف جميع البيانات!
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في الحذف
  @override
  Future<void> deleteAllCustomers() async {
    try {
      await isar.writeTxn(() async {
        await isar.customerModels.clear();
      });
    } catch (e) {
      throw Exception('خطأ في حذف جميع العملاء: $e');
    }
  }
}
