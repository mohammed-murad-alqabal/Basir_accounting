import 'dart:io';

import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/data/repositories/isar_sales_invoice_posting_gateway.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

late Isar _testIsar;

void main() {
  late Directory temporaryDirectory;
  late Isar isar;
  late IsarSalesInvoicePostingGateway gateway;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'basir_sales_posting_gateway_',
    );
    isar = await Isar.open(
      [
        AccountModelSchema,
        InvoiceModelSchema,
        JournalEntryModelSchema,
      ],
      directory: temporaryDirectory.path,
      name: 'sales_posting_gateway_test',
    );
    _testIsar = isar;
    gateway = IsarSalesInvoicePostingGateway(
      isar: isar,
      accountingService: AccountingService(),
      userId: 'user-1',
      warehouseId: 'warehouse-1',
    );
  });

  tearDownAll(() async {
    await isar.close(deleteFromDisk: true);
    await temporaryDirectory.delete(recursive: true);
  });

  setUp(() async {
    await isar.writeTxn(() async {
      await isar.accountModels.clear();
      await isar.invoiceModels.clear();
      await isar.journalEntryModels.clear();
      await isar.accountModels.putAll(_accounts());
    });
  });

  group('IsarSalesInvoicePostingGateway', () {
    test('يثبت الفاتورة والقيد ويحدث الأرصدة في معاملة واحدة', () async {
      final invoice = _invoice(status: InvoiceStatus.sent);
      final entry = _entryFor(invoice);

      await gateway.commitSalesInvoice(invoice: invoice, journalEntry: entry);

      final storedInvoice = await isar.invoiceModels
          .filter()
          .invoiceIdEqualTo(invoice.id)
          .findFirst();
      final storedEntry = await isar.journalEntryModels
          .filter()
          .idEqualTo(entry.id)
          .findFirst();
      final receivable = await _account('acc-1201');
      final revenue = await _account('acc-4101');
      final tax = await _account('acc-2105');

      expect(storedInvoice?.status, InvoiceStatus.sent);
      expect(storedEntry?.id, entry.id);
      expect(receivable.balance, Decimal.fromInt(115).toString());
      expect(revenue.balance, Decimal.fromInt(100).toString());
      expect(tax.balance, Decimal.fromInt(15).toString());
    });

    test('يلغي كل الأثر إذا تعذر العثور على حساب من القيد', () async {
      final draft = _invoice(status: InvoiceStatus.draft);
      await isar.writeTxn(() async {
        await isar.invoiceModels.put(InvoiceModel.fromEntity(draft));
      });
      final postingInvoice = draft.copyWith(status: InvoiceStatus.sent);
      final invalidEntry = _entryFor(
        postingInvoice,
        taxAccountId: 'missing-tax-account',
      );

      await expectLater(
        gateway.commitSalesInvoice(
          invoice: postingInvoice,
          journalEntry: invalidEntry,
        ),
        throwsA(isA<StateError>()),
      );

      final storedInvoice = await isar.invoiceModels
          .filter()
          .invoiceIdEqualTo(draft.id)
          .findFirst();
      final receivable = await _account('acc-1201');
      final revenue = await _account('acc-4101');
      final journalEntries = await isar.journalEntryModels.where().findAll();

      expect(storedInvoice?.status, InvoiceStatus.draft);
      expect(receivable.balance, Decimal.zero.toString());
      expect(revenue.balance, Decimal.zero.toString());
      expect(journalEntries, isEmpty);
    });

    test('يرفض الترحيل المكرر ولا يكرر تحديث الأرصدة', () async {
      final invoice = _invoice(status: InvoiceStatus.sent);
      final entry = _entryFor(invoice);
      await gateway.commitSalesInvoice(invoice: invoice, journalEntry: entry);

      await expectLater(
        gateway.commitSalesInvoice(invoice: invoice, journalEntry: entry),
        throwsA(isA<StateError>()),
      );

      final receivable = await _account('acc-1201');
      final entries = await isar.journalEntryModels.where().findAll();
      expect(receivable.balance, Decimal.fromInt(115).toString());
      expect(entries, hasLength(1));
    });
  });
}

Future<AccountModel> _account(String id) async =>
    (await _testIsar.accountModels.filter().idEqualTo(id).findFirst())!;

List<AccountModel> _accounts() => [
      _accountModel(
        id: 'acc-1201',
        code: '1201',
        type: AccountType.asset,
        nature: AccountNature.debit,
      ),
      _accountModel(
        id: 'acc-4101',
        code: '4101',
        type: AccountType.revenue,
        nature: AccountNature.credit,
      ),
      _accountModel(
        id: 'acc-2105',
        code: '2105',
        type: AccountType.liability,
        nature: AccountNature.credit,
      ),
    ];

AccountModel _accountModel({
  required String id,
  required String code,
  required AccountType type,
  required AccountNature nature,
}) =>
    AccountModel.fromEntity(
      Account(
        id: id,
        code: code,
        nameAr: code,
        nameEn: code,
        type: type,
        nature: nature,
        balance: Decimal.zero,
        userId: 'user-1',
      ),
    );

Invoice _invoice({required InvoiceStatus status}) => Invoice(
      id: 'invoice-100',
      invoiceNumber: 'INV-100',
      customerId: 'customer-100',
      customerName: 'Customer',
      items: const [],
      issuedDate: DateTime(2026, 8, 14),
      dueDate: DateTime(2026, 9, 14),
      createdAt: DateTime(2026, 8, 14),
      updatedAt: DateTime(2026, 8, 14),
      status: status,
      subtotalAmount: Decimal.fromInt(100),
      taxAmount: Decimal.fromInt(15),
      discountAmount: Decimal.zero,
      totalAmount: Decimal.fromInt(115),
      paidAmount: Decimal.zero,
      taxRate: Decimal.parse('0.15'),
      discountRate: Decimal.zero,
      exchangeRate: Decimal.one,
    );

JournalEntry _entryFor(Invoice invoice, {String taxAccountId = 'acc-2105'}) {
  final recordedAt = DateTime(2026, 8, 14, 9);
  return JournalEntry(
    id: 'entry-${invoice.id}',
    referenceNumber: 'JE-${invoice.invoiceNumber}',
    date: invoice.issuedDate,
    temporal: TemporalJustification(
      transactionDate: invoice.issuedDate,
      effectiveDate: invoice.issuedDate,
      recordingDate: recordedAt,
    ),
    standards: const StandardsJustification(
      standardReference: 'IFRS 15',
      recognitionBasis: 'Accrual',
      measurementBasis: 'Transaction price',
    ),
    description: 'Sales invoice posting',
    status: JournalEntryStatus.posted,
    lines: [
      JournalEntryLine(
        accountId: 'acc-1201',
        accountName: 'Accounts receivable',
        debit: Decimal.fromInt(115),
        credit: Decimal.zero,
      ),
      JournalEntryLine(
        accountId: 'acc-4101',
        accountName: 'Sales revenue',
        debit: Decimal.zero,
        credit: Decimal.fromInt(100),
      ),
      JournalEntryLine(
        accountId: taxAccountId,
        accountName: 'VAT payable',
        debit: Decimal.zero,
        credit: Decimal.fromInt(15),
      ),
    ],
    sourceDocument: 'invoice',
    sourceId: invoice.id,
    createdBy: 'user-1',
    createdAt: recordedAt,
    updatedAt: recordedAt,
    postedAt: recordedAt,
  );
}
