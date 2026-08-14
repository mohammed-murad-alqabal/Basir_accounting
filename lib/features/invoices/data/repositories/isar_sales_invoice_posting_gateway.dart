import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/data/models/account_model.dart';
import 'package:basir_accounting_system/features/accounting/data/models/journal_entry_model.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/application/sales_invoice_posting_service.dart';
import 'package:basir_accounting_system/features/invoices/data/models/invoice_model.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:isar/isar.dart';

/// تنفيذ محلي لبوابة ترحيل فاتورة البيع.
///
/// ينفذ تثبيت الفاتورة، القيد، وحركة أرصدة الحسابات في [Isar.writeTxn]
/// واحدة. أي خطأ قبل اكتمال المعاملة يلغي جميع الكتابات ولا يترك فاتورة
/// مصدرة بلا قيد أو قيدًا بلا فاتورة.
class IsarSalesInvoicePostingGateway implements SalesInvoicePostingGateway {
  IsarSalesInvoicePostingGateway({
    required Isar isar,
    required AccountingService accountingService,
    required String? userId,
    required String? warehouseId,
  })  : _isar = isar,
        _accountingService = accountingService,
        _userId = userId,
        _warehouseId = warehouseId;

  final Isar _isar;
  final AccountingService _accountingService;
  final String? _userId;
  final String? _warehouseId;

  @override
  Future<JournalEntry> buildSalesJournalEntry({
    required Invoice invoice,
    required String actorId,
    required DateTime recordedAt,
  }) =>
      _accountingService.prepareSalesInvoiceEntry(
        invoice,
        createdBy: actorId,
        recordedAt: recordedAt,
      );

  @override
  Future<void> commitSalesInvoice({
    required Invoice invoice,
    required JournalEntry journalEntry,
  }) async {
    await _isar.writeTxn(() async {
      final existingEntry = await _isar.journalEntryModels
          .filter()
          .idEqualTo(journalEntry.id)
          .findFirst();
      if (existingEntry != null) {
        throw StateError('Sales invoice ${invoice.id} is already posted.');
      }

      final existingInvoice = await _isar.invoiceModels
          .filter()
          .invoiceIdEqualTo(invoice.id)
          .findFirst();
      if (existingInvoice != null &&
          existingInvoice.status != InvoiceStatus.draft) {
        throw StateError('Sales invoice ${invoice.id} is not a draft.');
      }
      if (existingInvoice != null && existingInvoice.userId != _userId) {
        throw StateError(
          'Sales invoice ${invoice.id} belongs to another user.',
        );
      }

      final persistedInvoice = invoice.copyWith(
        userId: _userId ?? invoice.userId,
        warehouseId: _warehouseId ?? invoice.warehouseId,
      );
      final invoiceModel = InvoiceModel.fromEntity(persistedInvoice);
      if (existingInvoice != null) {
        invoiceModel.id = existingInvoice.id;
      }

      for (final line in journalEntry.lines) {
        final accountModel = await _isar.accountModels
            .filter()
            .idEqualTo(line.accountId)
            .and()
            .userIdEqualTo(_userId)
            .findFirst();
        if (accountModel == null) {
          throw StateError('Posting account ${line.accountId} was not found.');
        }
        _applyPostedMovement(accountModel, line);
        await _isar.accountModels.put(accountModel);
      }

      final entryModel = JournalEntryModel.fromEntity(
        journalEntry.copyWith(userId: _userId, warehouseId: _warehouseId),
      );
      await _isar.invoiceModels.put(invoiceModel);
      await _isar.journalEntryModels.put(entryModel);
    });
  }

  void _applyPostedMovement(AccountModel accountModel, JournalEntryLine line) {
    final account = accountModel.toEntity();
    final movement = account.nature == AccountNature.debit
        ? line.debit - line.credit
        : line.credit - line.debit;
    accountModel.balance = (account.balance + movement).toString();
  }
}
