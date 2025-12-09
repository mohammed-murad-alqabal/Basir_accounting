import 'package:basser_app/features/invoices/data/models/invoice_model.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/domain/repositories/invoice_repository.dart';
import 'package:isar/isar.dart';

/// تطبيق مستودع الفواتير (Invoice Repository Implementation)
///
/// يتعامل مع التخزين المحلي للفواتير باستخدام Isar
class InvoiceRepositoryImpl implements InvoiceRepository {
  /// إنشاء مستودع الفواتير
  InvoiceRepositoryImpl({required this.isar});

  /// قاعدة البيانات المحلية
  final Isar isar;

  @override
  Future<List<Invoice>> getAllInvoices() async {
    try {
      final models = await isar.invoiceModels.where().findAll();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في جلب الفواتير: $e');
    }
  }

  @override
  Future<Invoice?> getInvoiceById(String id) async {
    try {
      final models = await isar.invoiceModels.where().findAll();
      final model = models.cast<InvoiceModel?>().firstWhere(
        (m) => m?.invoiceId == id,
        orElse: () => null,
      );
      return model?.toEntity();
    } catch (e) {
      throw Exception('خطأ في جلب الفاتورة: $e');
    }
  }

  @override
  Future<List<Invoice>> getInvoicesByCustomerId(String customerId) async {
    try {
      final models = await isar.invoiceModels.where().findAll();
      final filtered = models.where((m) => m.customerId == customerId).toList();
      return filtered.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في جلب فواتير العميل: $e');
    }
  }

  @override
  Future<List<Invoice>> getInvoicesByStatus(String status) async {
    try {
      final models = await isar.invoiceModels.where().findAll();
      final filtered = models.where((m) => m.status == status).toList();
      return filtered.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('خطأ في جلب الفواتير حسب الحالة: $e');
    }
  }

  @override
  Future<void> addInvoice(Invoice invoice) async {
    try {
      final model = InvoiceModel.fromEntity(invoice);
      await isar.writeTxn(() async {
        await isar.invoiceModels.put(model);
      });
    } catch (e) {
      throw Exception('خطأ في إضافة الفاتورة: $e');
    }
  }

  @override
  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await isar.writeTxn(() async {
        // البحث عن الفاتورة الموجودة
        final models = await isar.invoiceModels.where().findAll();
        final existingModel = models.cast<InvoiceModel?>().firstWhere(
          (m) => m?.invoiceId == invoice.id,
          orElse: () => null,
        );

        if (existingModel == null) {
          throw Exception('الفاتورة غير موجودة');
        }

        // تحديث الفاتورة مع الاحتفاظ بنفس id
        final updatedModel = InvoiceModel.fromEntity(invoice)
          ..id = existingModel.id;
        await isar.invoiceModels.put(updatedModel);
      });
    } catch (e) {
      throw Exception('خطأ في تحديث الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteInvoice(String id) async {
    try {
      await isar.writeTxn(() async {
        final models = await isar.invoiceModels.where().findAll();
        final model = models.cast<InvoiceModel?>().firstWhere(
          (m) => m?.invoiceId == id,
          orElse: () => null,
        );
        if (model != null) {
          await isar.invoiceModels.delete(model.id);
        }
      });
    } catch (e) {
      throw Exception('خطأ في حذف الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteAllInvoices() async {
    try {
      await isar.writeTxn(() async {
        await isar.invoiceModels.clear();
      });
    } catch (e) {
      throw Exception('خطأ في حذف جميع الفواتير: $e');
    }
  }

  @override
  Future<InvoiceStatistics> getInvoiceStatistics() async {
    try {
      final allInvoices = await getAllInvoices();

      final paidInvoices = allInvoices
          .where((invoice) => invoice.status == 'paid')
          .toList();

      final overdueInvoices = allInvoices
          .where((invoice) => invoice.status == 'overdue')
          .toList();

      final totalRevenue = allInvoices.fold<double>(
        0,
        (sum, invoice) => sum + invoice.grandTotal,
      );
      final paidRevenue = paidInvoices.fold<double>(
        0,
        (sum, invoice) => sum + invoice.grandTotal,
      );

      return InvoiceStatistics(
        totalInvoices: allInvoices.length,
        paidInvoices: paidInvoices.length,
        overdueInvoices: overdueInvoices.length,
        totalRevenue: totalRevenue,
        paidRevenue: paidRevenue,
      );
    } catch (e) {
      throw Exception('خطأ في حساب إحصائيات الفواتير: $e');
    }
  }
}
