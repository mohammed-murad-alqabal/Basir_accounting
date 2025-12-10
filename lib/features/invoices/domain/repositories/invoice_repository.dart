import 'package:basser_app/features/invoices/domain/entities/invoice.dart';

/// واجهة مستودع الفواتير (Invoice Repository Interface)
///
/// تحدد العقد (Contract) لجميع العمليات المتعلقة بإدارة الفواتير
/// في طبقة Domain. التطبيق الفعلي يكون في طبقة Data.
///
/// **العمليات:**
/// - CRUD كامل للفواتير
/// - البحث والاستعلام
/// - إحصائيات الفواتير
///
/// **مثال:**
/// ```dart
/// class InvoiceRepositoryImpl implements InvoiceRepository {
///   @override
///   Future<List<Invoice>> getAllInvoices() async {
///     // التطبيق الفعلي
///   }
/// }
/// ```
abstract class InvoiceRepository {
  /// الحصول على جميع الفواتير
  ///
  /// يسترجع قائمة بجميع الفواتير المسجلة في النظام.
  ///
  /// **Returns:** قائمة بجميع الفواتير، قائمة فارغة إذا لم يكن هناك فواتير
  ///
  /// **مثال:**
  /// ```dart
  /// final invoices = await repository.getAllInvoices();
  /// print('عدد الفواتير: ${invoices.length}');
  /// ```
  Future<List<Invoice>> getAllInvoices();

  /// الحصول على فاتورة بواسطة المعرف
  ///
  /// يبحث عن فاتورة محددة باستخدام معرفها الفريد.
  ///
  /// **Parameters:**
  /// - [id]: معرف الفاتورة المطلوبة
  ///
  /// **Returns:** الفاتورة إذا وُجدت، null إذا لم تُعثر عليها
  ///
  /// **مثال:**
  /// ```dart
  /// final invoice = await repository.getInvoiceById('inv-001');
  /// if (invoice != null) {
  ///   print('الفاتورة: ${invoice.id}');
  /// }
  /// ```
  Future<Invoice?> getInvoiceById(String id);

  /// الحصول على فواتير عميل معين
  ///
  /// يسترجع جميع الفواتير المرتبطة بعميل محدد.
  ///
  /// **Parameters:**
  /// - [customerId]: معرف العميل
  ///
  /// **Returns:** قائمة بفواتير العميل، قائمة فارغة إذا لم يكن له فواتير
  ///
  /// **مثال:**
  /// ```dart
  /// final invoices = await repository.getInvoicesByCustomerId('customer-1');
  /// print('عدد فواتير العميل: ${invoices.length}');
  /// ```
  Future<List<Invoice>> getInvoicesByCustomerId(String customerId);

  /// الحصول على فواتير حسب الحالة
  ///
  /// يسترجع جميع الفواتير التي لها حالة معينة.
  ///
  /// **Parameters:**
  /// - [status]: حالة الفاتورة (draft, issued, paid, overdue, cancelled)
  ///
  /// **Returns:** قائمة بالفواتير المطابقة، قائمة فارغة إذا لم توجد
  ///
  /// **مثال:**
  /// ```dart
  /// final paidInvoices = await repository.getInvoicesByStatus('paid');
  /// print('الفواتير المدفوعة: ${paidInvoices.length}');
  /// ```
  Future<List<Invoice>> getInvoicesByStatus(String status);

  /// إضافة فاتورة جديدة
  ///
  /// يضيف فاتورة جديدة إلى النظام.
  ///
  /// **Parameters:**
  /// - [invoice]: بيانات الفاتورة الجديدة
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في الحفظ
  ///
  /// **مثال:**
  /// ```dart
  /// final invoice = Invoice(...);
  /// await repository.addInvoice(invoice);
  /// ```
  Future<void> addInvoice(Invoice invoice);

  /// تحديث بيانات فاتورة
  ///
  /// يحدث بيانات فاتورة موجودة في النظام.
  ///
  /// **Parameters:**
  /// - [invoice]: بيانات الفاتورة المحدثة
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في التحديث
  ///
  /// **مثال:**
  /// ```dart
  /// final updatedInvoice = invoice.copyWith(status: 'paid');
  /// await repository.updateInvoice(updatedInvoice);
  /// ```
  Future<void> updateInvoice(Invoice invoice);

  /// حذف فاتورة
  ///
  /// يحذف فاتورة من النظام باستخدام معرفها.
  ///
  /// **Parameters:**
  /// - [id]: معرف الفاتورة المراد حذفها
  ///
  /// **Throws:** [Exception] إذا حدث خطأ في الحذف
  ///
  /// **مثال:**
  /// ```dart
  /// await repository.deleteInvoice('inv-001');
  /// ```
  Future<void> deleteInvoice(String id);

  /// حذف جميع الفواتير
  ///
  /// يحذف جميع الفواتير من النظام.
  ///
  /// **Warning:** هذه العملية لا يمكن التراجع عنها
  ///
  /// **Note:** تُستخدم فقط لأغراض الاختبار أو إعادة تعيين النظام
  ///
  /// **مثال:**
  /// ```dart
  /// await repository.deleteAllInvoices();
  /// ```
  Future<void> deleteAllInvoices();

  /// الحصول على إحصائيات الفواتير
  ///
  /// يحسب ويسترجع إحصائيات شاملة عن جميع الفواتير.
  ///
  /// **Returns:** كائن [InvoiceStatistics] يحتوي على الإحصائيات
  ///
  /// **مثال:**
  /// ```dart
  /// final stats = await repository.getInvoiceStatistics();
  /// print('إجمالي الإيرادات: ${stats.totalRevenue}');
  /// ```
  Future<InvoiceStatistics> getInvoiceStatistics();
}

/// إحصائيات الفواتير (Invoice Statistics)
///
/// كائن يحتوي على إحصائيات شاملة عن جميع الفواتير في النظام.
///
/// **الإحصائيات المتوفرة:**
/// - عدد الفواتير (الإجمالي، المدفوعة، المتأخرة)
/// - الإيرادات (الإجمالية، المدفوعة)
///
/// **مثال:**
/// ```dart
/// final stats = InvoiceStatistics(
///   totalInvoices: 100,
///   paidInvoices: 75,
///   overdueInvoices: 10,
///   totalRevenue: 50000.0,
///   paidRevenue: 37500.0,
/// );
/// print('نسبة الدفع: ${(stats.paidInvoices / stats.totalInvoices) * 100}%');
/// ```
class InvoiceStatistics {
  /// إنشاء كائن إحصائيات الفواتير
  ///
  /// **Parameters:**
  /// - [totalInvoices]: إجمالي عدد الفواتير
  /// - [paidInvoices]: عدد الفواتير المدفوعة
  /// - [overdueInvoices]: عدد الفواتير المتأخرة
  /// - [totalRevenue]: إجمالي الإيرادات (جميع الفواتير)
  /// - [paidRevenue]: الإيرادات المدفوعة فعلياً
  const InvoiceStatistics({
    required this.totalInvoices,
    required this.paidInvoices,
    required this.overdueInvoices,
    required this.totalRevenue,
    required this.paidRevenue,
  });

  /// إجمالي عدد الفواتير في النظام
  final int totalInvoices;

  /// عدد الفواتير المدفوعة
  final int paidInvoices;

  /// عدد الفواتير المتأخرة (تجاوزت تاريخ الاستحقاق)
  final int overdueInvoices;

  /// إجمالي الإيرادات من جميع الفواتير
  ///
  /// يشمل جميع الفواتير بغض النظر عن حالتها.
  final double totalRevenue;

  /// الإيرادات المدفوعة فعلياً
  ///
  /// يشمل فقط الفواتير ذات حالة 'paid'.
  final double paidRevenue;
}
