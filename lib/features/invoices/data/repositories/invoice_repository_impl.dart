import 'package:basir_app/features/invoices/data/models/invoice_model.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع الفواتير (Invoice Repository Implementation)
///
/// يتعامل مع التخزين المحلي للفواتير باستخدام Isar
class InvoiceRepositoryImpl implements InvoiceRepository {
  /// إنشاء مستودع الفواتير
  InvoiceRepositoryImpl({
    required this.isar,
    required this.userId,
    this.warehouseId,
  });

  /// قاعدة البيانات المحلية
  final Isar isar;

  /// معرف المستخدم لعزل البيانات.
  final String? userId;

  /// معرف المستودع الحالي (لعزل البيانات)
  final String? warehouseId;

  @override
  Future<List<Invoice>> getAllInvoices() async {
    try {
      final models = await isar.invoiceModels
          .filter()
          .userIdEqualTo(userId)
          .and()
          .group(
            (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
          )
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (e) {
      throw Exception('خطأ في جلب الفواتير: $e');
    }
  }

  @override
  Future<Invoice?> getInvoiceById(String id) async {
    try {
      final model = await isar.invoiceModels
          .filter()
          .invoiceIdEqualTo(id)
          .and()
          .userIdEqualTo(userId)
          .and()
          .group(
            (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
          )
          .findFirst();
      return model?.toEntity();
    } on Exception catch (e) {
      throw Exception('خطأ في جلب الفاتورة: $e');
    }
  }

  @override
  Future<List<Invoice>> getInvoicesByCustomerId(String customerId) async {
    try {
      final models = await isar.invoiceModels
          .filter()
          .customerIdEqualTo(customerId)
          .and()
          .userIdEqualTo(userId)
          .and()
          .group(
            (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
          )
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (e) {
      throw Exception('خطأ في جلب فواتير العميل: $e');
    }
  }

  @override
  Future<List<Invoice>> getInvoicesByStatus(InvoiceStatus status) async {
    try {
      final models = await isar.invoiceModels
          .filter()
          .statusEqualTo(status)
          .and()
          .userIdEqualTo(userId)
          .and()
          .group(
            (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
          )
          .findAll();
      return models.map((model) => model.toEntity()).toList();
    } on Exception catch (e) {
      throw Exception('خطأ في جلب الفواتير حسب الحالة: $e');
    }
  }

  @override
  Future<void> addInvoice(Invoice invoice) async {
    try {
      final model = InvoiceModel.fromEntity(
        invoice.copyWith(
          userId: userId,
          warehouseId: invoice.warehouseId ?? warehouseId,
        ),
      );
      await isar.writeTxn(() async {
        await isar.invoiceModels.put(model);
      });
    } on Exception catch (e) {
      throw Exception('خطأ في إضافة الفاتورة: $e');
    }
  }

  @override
  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await isar.writeTxn(() async {
        // البحث عن الفاتورة الموجودة
        final existingModel = await isar.invoiceModels
            .filter()
            .invoiceIdEqualTo(invoice.id)
            .and()
            .userIdEqualTo(userId)
            .and()
            .group(
              (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
            )
            .findFirst();

        if (existingModel == null) {
          throw Exception('الفاتورة غير موجودة');
        }

        // تحديث الفاتورة مع الاحتفاظ بنفس id
        final updatedModel = InvoiceModel.fromEntity(
          invoice.copyWith(
            userId: userId,
            warehouseId: invoice.warehouseId ?? warehouseId,
          ),
        )..id = existingModel.id;
        await isar.invoiceModels.put(updatedModel);
      });
    } on Exception catch (e) {
      throw Exception('خطأ في تحديث الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteInvoice(String id) async {
    try {
      await isar.writeTxn(() async {
        final model = await isar.invoiceModels
            .filter()
            .invoiceIdEqualTo(id)
            .and()
            .userIdEqualTo(userId)
            .and()
            .group(
              (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
            )
            .findFirst();
        if (model != null) {
          await isar.invoiceModels.delete(model.id);
        }
      });
    } on Exception catch (e) {
      throw Exception('خطأ في حذف الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteAllInvoices() async {
    try {
      await isar.writeTxn(() async {
        await isar.invoiceModels
            .filter()
            .userIdEqualTo(userId)
            .and()
            .group(
              (q) => q.warehouseIdIsNull().or().warehouseIdEqualTo(warehouseId),
            )
            .deleteAll();
      });
    } on Exception catch (e) {
      throw Exception('خطأ في حذف جميع الفواتير: $e');
    }
  }

  @override
  Future<InvoiceStatistics> getInvoiceStatistics() async {
    try {
      final allInvoices = await getAllInvoices();

      final paidInvoices =
          allInvoices.where((invoice) => invoice.status == InvoiceStatus.paid).toList();

      final overdueInvoices =
          allInvoices.where((invoice) => invoice.status == InvoiceStatus.overdue).toList();

      final totalRevenue = allInvoices.fold<Decimal>(
        Decimal.zero,
        (sum, invoice) => sum + invoice.totalAmount,
      );
      final paidRevenue = paidInvoices.fold<Decimal>(
        Decimal.zero,
        (sum, invoice) => sum + invoice.totalAmount,
      );

      return InvoiceStatistics(
        totalInvoices: allInvoices.length,
        paidInvoices: paidInvoices.length,
        overdueInvoices: overdueInvoices.length,
        totalRevenue: totalRevenue,
        paidRevenue: paidRevenue,
      );
    } on Exception catch (e) {
      throw Exception('خطأ في حساب إحصائيات الفواتير: $e');
    }
  }

  @override
  Future<Invoice> duplicateInvoice(String id) async {
    try {
      final original = await getInvoiceById(id);
      if (original == null) {
        throw Exception('الفاتورة الأصلية غير موجودة');
      }

      // إنشاء معرف فريد جديد (بسيط لغرض العرض، يفضل استخدام UUID)
      final newId = 'inv-${DateTime.now().millisecondsSinceEpoch}';

      final duplicated = original.copyWith(
        id: newId,
        issuedDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: InvoiceStatus.draft, // النسخة تبدأ دائماً كمسودة
      );

      await addInvoice(duplicated);
      return duplicated;
    } on Exception catch (e) {
      throw Exception('فشل في مضاعفة الفاتورة: $e');
    }
  }
}
