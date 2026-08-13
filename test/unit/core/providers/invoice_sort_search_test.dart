// ignore_for_file: lines_longer_than_80_chars, avoid_redundant_argument_values
import 'package:basir_accounting_system/core/extensions/string_extensions.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

/// مولّد فواتير تجريبية لاختبارات الفرز والبحث.
Invoice fakeInvoice({
  required String customerName,
  required String invoiceNumber,
  required DateTime issuedDate,
  required Decimal totalAmount,
  required DateTime? dueDate,
  InvoiceStatus status = InvoiceStatus.sent,
  String? id,
}) =>
    Invoice(
      id: id ?? const Uuid().v4(),
      invoiceNumber: invoiceNumber,
      customerId: const Uuid().v4(),
      customerName: customerName,
      items: const [],
      issuedDate: issuedDate,
      dueDate: dueDate ?? issuedDate.add(const Duration(days: 30)),
      createdAt: issuedDate,
      updatedAt: issuedDate,
      type: InvoiceType.sales,
      status: status,
      subtotalAmount: totalAmount,
      taxAmount: totalAmount * Decimal.parse('0.15'),
      discountAmount: Decimal.zero,
      totalAmount: totalAmount,
      paidAmount: Decimal.zero,
      taxRate: Decimal.parse('0.15'),
      discountRate: Decimal.zero,
      exchangeRate: Decimal.one,
      currency: 'SAR',
    );

/// مزود وهمي لقائمة الفواتير لتجاوز طبقة المستودع في الاختبار.
// ignore: unreachable_from_main
final fakeInvoicesProvider = Provider<List<Invoice>>((ref) => []);

/// يقرأ قيمة AsyncValue كمزامنة في الاختبارات (بما أن المزود الوهمي فوري).
List<Invoice> readInvoices(ProviderContainer container) =>
    container.read(filteredInvoicesProvider).requireValue;

void main() {
  group('StringArabicNormalization', () {
    test('normalizes alef variants to plain alef', () {
      // الهمزة المضمومة في "ؤ" تُوحَّد مع الهمزة المفردة "ء"، والألف
      // المتوسطة "أ" تُوحَّد مع الألف العادية "ا".
      expect('مؤسسة الأمل'.normalizeArabic(), 'مءسسه الامل');
    });

    test('unifies ta marbuta and alef maksura', () {
      expect('زكاة ى '.normalizeArabic(), contains('زكاه'));
    });

    test('removes diacritics (tashkeel)', () {
      // بعد إزالة التشكيل يُطبَّق أيضًا توحيد الهمزات والألف والهاء.
      expect('مُؤَسَّسَة'.normalizeArabic(), 'مءسسه');
    });

    test('unifies hamza forms', () {
      // الهمزة على واو "ؤ" تُوحَّد مع الهمزة المفردة، بينما الهمزة على
      // ياء "ئ" يُقصد بها في هذا التنفيذ البقاء كما هي (تُقرأ حرفًا).
      expect('رؤوس'.normalizeArabic(), 'رءوس');
      expect('مؤسسة'.normalizeArabic(), 'مءسسه');
    });
  });

  group('Invoice search and sort providers', () {
    late ProviderContainer container;
    late List<Invoice> invoices;

    final now = DateTime(2026, 8, 13);
    invoices = [
      fakeInvoice(
        customerName: 'مؤسسة الأمل',
        invoiceNumber: 'INV-001',
        issuedDate: now.subtract(const Duration(days: 5)),
        totalAmount: Decimal.parse('1000'),
        dueDate: now.add(const Duration(days: 10)),
        status: InvoiceStatus.sent,
      ),
      fakeInvoice(
        customerName: 'شركة النور',
        invoiceNumber: 'INV-002',
        issuedDate: now.subtract(const Duration(days: 2)),
        totalAmount: Decimal.parse('2000'),
        dueDate: now.subtract(const Duration(days: 1)),
        status: InvoiceStatus.overdue,
      ),
      fakeInvoice(
        customerName: 'مؤسسة البركة',
        invoiceNumber: 'INV-003',
        issuedDate: now.subtract(const Duration(days: 10)),
        totalAmount: Decimal.parse('500'),
        dueDate: now.add(const Duration(days: 20)),
        status: InvoiceStatus.cancelled,
      ),
      fakeInvoice(
        customerName: 'شركة الأمل',
        invoiceNumber: 'INV-004',
        issuedDate: now.subtract(const Duration(days: 1)),
        totalAmount: Decimal.parse('1500'),
        dueDate: now.add(const Duration(days: 30)),
        status: InvoiceStatus.paid,
      ),
    ];

    setUp(() async {
      container = ProviderContainer(
        overrides: [
          invoicesProvider.overrideWith((ref) => Future.value(invoices)),
        ],
      );
      // إعادة ضبط الحالة الافتراضية بعد كل اختبار
      container.read(invoiceSearchProvider.notifier).state = '';
      container.read(invoiceFilterProvider.notifier).state = 'all';
      container.read(invoiceSortProvider.notifier).state = 'newest';
      // انتظار وصول بيانات المزود الوهمي
      await container.read(invoicesProvider.future);
    });

    tearDown(() {
      container.dispose();
    });

    test('default sort returns newest invoices first', () async {
      final result = readInvoices(container);
      expect(
        result.map((i) => i.invoiceNumber).toList(),
        ['INV-004', 'INV-002', 'INV-001', 'INV-003'],
      );
    });

    test('sort by oldest returns invoices in ascending issued date order',
        () async {
      container.read(invoiceSortProvider.notifier).state = 'oldest';
      final result = readInvoices(container);
      expect(
        result.map((i) => i.invoiceNumber).toList(),
        ['INV-003', 'INV-001', 'INV-002', 'INV-004'],
      );
    });

    test('sort by highest amount desc', () async {
      container.read(invoiceSortProvider.notifier).state = 'amount_desc';
      final result = readInvoices(container);
      expect(result.map((i) => i.totalAmount).toList(), [
        Decimal.parse('2000'),
        Decimal.parse('1500'),
        Decimal.parse('1000'),
        Decimal.parse('500'),
      ]);
    });

    test('sort by lowest amount asc', () async {
      container.read(invoiceSortProvider.notifier).state = 'amount_asc';
      final result = readInvoices(container);
      expect(result.map((i) => i.totalAmount).toList(), [
        Decimal.parse('500'),
        Decimal.parse('1000'),
        Decimal.parse('1500'),
        Decimal.parse('2000'),
      ]);
    });

    test('sort by customer name alphabetically', () async {
      container.read(invoiceSortProvider.notifier).state = 'customer';
      final result = readInvoices(container);
      expect(
        result.map((i) => i.customerName).toList(),
        ['شركة الأمل', 'شركة النور', 'مؤسسة الأمل', 'مؤسسة البركة'],
      );
    });

    test('sort by due date (soonest first)', () async {
      container.read(invoiceSortProvider.notifier).state = 'due_date';
      final result = readInvoices(container);
      expect(
        result.map((i) => i.invoiceNumber).toList(),
        ['INV-002', 'INV-001', 'INV-003', 'INV-004'],
      );
    });

    test('search is case-insensitive and matches number or customer name',
        () async {
      container.read(invoiceSearchProvider.notifier).state = 'الامل';
      final result = readInvoices(container);
      // الترتيب الافتراضي (newest):INV-004 (شركة الأمل) ثم INV-001 (مؤسسة الأمل)
      expect(
        result.map((i) => i.customerName).toSet(),
        {'شركة الأمل', 'مؤسسة الأمل'},
      );

      container.read(invoiceSearchProvider.notifier).state = 'inv-002';
      final result2 = readInvoices(container);
      expect(result2.map((i) => i.invoiceNumber).toList(), ['INV-002']);
    });

    test('search with no matches returns empty list', () async {
      container.read(invoiceSearchProvider.notifier).state = 'nonexistent';
      final result = readInvoices(container);
      expect(result, isEmpty);
    });

    test('filter by cancelled status works together with sort', () async {
      container.read(invoiceFilterProvider.notifier).state = 'cancelled';
      container.read(invoiceSortProvider.notifier).state = 'amount_desc';
      final result = readInvoices(container);
      expect(result.map((i) => i.invoiceNumber).toList(), ['INV-003']);
      expect(result.first.totalAmount, Decimal.parse('500'));
    });

    test('filter by overdue status combined with search', () async {
      container.read(invoiceFilterProvider.notifier).state = 'overdue';
      container.read(invoiceSearchProvider.notifier).state = 'النور';
      final result = readInvoices(container);
      expect(result.map((i) => i.invoiceNumber).toList(), ['INV-002']);
    });

    test('combined search + cancelled filter + oldest sort', () async {
      container.read(invoiceSearchProvider.notifier).state = 'INV';
      container.read(invoiceFilterProvider.notifier).state = 'cancelled';
      container.read(invoiceSortProvider.notifier).state = 'oldest';
      final result = readInvoices(container);
      expect(result.map((i) => i.invoiceNumber).toList(), ['INV-003']);
    });

    test('empty search query resets to full sorted list', () async {
      container.read(invoiceSearchProvider.notifier).state = 'INV-001';
      var result = readInvoices(container);
      expect(result.length, 1);
      container.read(invoiceSearchProvider.notifier).state = '';
      result = readInvoices(container);
      expect(result.length, 4);
    });

    test('unknown sort key falls back to newest first', () async {
      container.read(invoiceSortProvider.notifier).state = 'invalid_key';
      final result = readInvoices(container);
      expect(result.first.invoiceNumber, 'INV-004');
    });
  });
}
