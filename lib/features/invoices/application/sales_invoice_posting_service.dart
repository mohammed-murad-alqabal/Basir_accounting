import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';

/// بوابة الترحيل التي تفصل قرار خدمة التطبيق عن التخزين الفعلي.
///
/// يجب أن ينفذ [commitSalesInvoice] كتابة الفاتورة والقيد وتحديث الأرصدة في
/// معاملة تخزين واحدة. لا يسمح للخدمة باستدعاء أي عملية حفظ جزئية منفصلة.
abstract interface class SalesInvoicePostingGateway {
  /// يبني القيد النهائي المحضّر لترحيل [invoice] دون حفظه.
  Future<JournalEntry> buildSalesJournalEntry({
    required Invoice invoice,
    required String actorId,
    required DateTime recordedAt,
  });

  /// يثبت [invoice] و[journalEntry] كعملية ذرية واحدة.
  Future<void> commitSalesInvoice({
    required Invoice invoice,
    required JournalEntry journalEntry,
  });
}

/// طلب الترحيل الصريح لفاتورة بيع بعد عرض معاينة الأثر.
class SalesInvoicePostingRequest {
  const SalesInvoicePostingRequest({
    required this.invoice,
    required this.preview,
    required this.hasExplicitConfirmation,
    required this.canPost,
    required this.operatorId,
    required this.operatorName,
  });

  /// الفاتورة المراد تثبيت أثرها المحاسبي.
  final Invoice invoice;

  /// الأثر الذي عُرض للمستخدم قبل إقراره.
  final PostingPreview preview;

  /// لا يرحل المستند إلا بعد إقرار واضح من المستخدم للمعاينة.
  final bool hasExplicitConfirmation;

  /// صلاحية الترحيل المحسوبة من هوية المستخدم الحالية.
  final bool canPost;

  /// معرف منفذ العملية للأثر الداخلي غير المعروض.
  final String operatorId;

  /// الاسم القابل للعرض في سجل التدقيق.
  final String operatorName;
}

/// ناتج ناجح لعملية ترحيل البيع.
class SalesInvoicePostingReceipt {
  const SalesInvoicePostingReceipt({
    required this.invoice,
    required this.journalEntry,
  });

  /// الفاتورة بعد تثبيت حالة الإصدار.
  final Invoice invoice;

  /// القيد المرحّل والمتزن المثبت معها.
  final JournalEntry journalEntry;
}

/// يطبّق سياسة ترحيل فاتورة البيع قبل تفويض التخزين الذري إلى البوابة.
///
/// هذه الخدمة هي نقطة الحراسة الوحيدة لمسار الواجهة: تتحقق من الصلاحية،
/// الإقرار الصريح، تطابق المعاينة، وحالة الفاتورة قبل أن يسمح بأي كتابة.
class SalesInvoicePostingService {
  SalesInvoicePostingService({
    required SalesInvoicePostingGateway gateway,
    DateTime Function()? now,
  })  : _gateway = gateway,
        _now = now ?? DateTime.now;

  static const unauthorizedCode = 'invoice_posting_unauthorized';
  static const confirmationRequiredCode =
      'invoice_posting_confirmation_required';
  static const previewMismatchCode = 'invoice_posting_preview_mismatch';
  static const invalidStateCode = 'invoice_posting_invalid_state';
  static const invalidJournalCode = 'invoice_posting_invalid_journal';
  static const commitFailedCode = 'invoice_posting_commit_failed';

  final SalesInvoicePostingGateway _gateway;
  final DateTime Function() _now;

  /// يرحّل [request] عند استيفاء ضوابط السلامة؛ ولا يرمي أخطاء تنفيذ للمستوى
  /// المعروض بل يعيد [OperationResult] موحدًا قابلاً للاختبار.
  Future<OperationResult<SalesInvoicePostingReceipt>> post(
    SalesInvoicePostingRequest request,
  ) async {
    if (!request.canPost) {
      return const OperationResult.failure(message: unauthorizedCode);
    }

    if (!request.hasExplicitConfirmation) {
      return const OperationResult.failure(
        message: confirmationRequiredCode,
      );
    }

    if (request.invoice.status != InvoiceStatus.draft) {
      return const OperationResult.failure(message: invalidStateCode);
    }

    if (request.preview.documentId != request.invoice.id ||
        request.preview.lines.isEmpty ||
        !request.preview.isImmediate) {
      return const OperationResult.failure(message: previewMismatchCode);
    }

    final recordedAt = _now();
    final postedInvoice = request.invoice.copyWith(
      status: InvoiceStatus.sent,
      updatedAt: recordedAt,
    );
    final approvalEvent = request.preview.buildApprovalEvent(
      approverName: request.operatorName,
      reason: 'تم الإقرار الصريح بمعاينة أثر ترحيل فاتورة البيع.',
      occurredAt: recordedAt,
    );

    try {
      final proposedEntry = await _gateway.buildSalesJournalEntry(
        invoice: postedInvoice,
        actorId: request.operatorId,
        recordedAt: recordedAt,
      );

      if (!proposedEntry.isBalanced ||
          proposedEntry.status != JournalEntryStatus.posted ||
          proposedEntry.sourceId != postedInvoice.id ||
          !_matchesApprovedPreview(
            preview: request.preview,
            journalEntry: proposedEntry,
          )) {
        return const OperationResult.failure(message: invalidJournalCode);
      }

      final postedEntry = proposedEntry.copyWith(
        auditLogs: [
          ...proposedEntry.auditLogs,
          AuditLogEntry(
            timestamp: recordedAt,
            action: 'INVOICE_POSTED',
            rationale: 'Confirmed sales invoice posting after impact preview.',
            actor: request.operatorId,
          ),
        ],
        postedAt: recordedAt,
        updatedAt: recordedAt,
      );
      await _gateway.commitSalesInvoice(
        invoice: postedInvoice,
        journalEntry: postedEntry,
      );

      final postedEvent = AuditEntry(
        type: AuditEventType.posted,
        operatorName: request.operatorName,
        occurredAt: recordedAt,
        reason: 'تم تثبيت فاتورة البيع وقيدها المتزن بصورة ذرية.',
        referenceId: postedInvoice.id,
      );
      return OperationResult.success(
        value: SalesInvoicePostingReceipt(
          invoice: postedInvoice,
          journalEntry: postedEntry,
        ),
        auditTrail: [approvalEvent, postedEvent],
      );
    } on Object catch (error) {
      return OperationResult.failure(
        message: commitFailedCode,
        cause: error,
      );
    }
  }

  bool _matchesApprovedPreview({
    required PostingPreview preview,
    required JournalEntry journalEntry,
  }) {
    final previewDebit = preview.lines
        .where((line) => line.direction == PostingDirection.debit)
        .fold<double>(0, (total, line) => total + line.amount);
    final previewCredit = preview.lines
        .where((line) => line.direction == PostingDirection.credit)
        .fold<double>(0, (total, line) => total + line.amount);
    final entryDebit = journalEntry.lines.fold<double>(
      0,
      (total, line) => total + line.debit.toDouble(),
    );
    final entryCredit = journalEntry.lines.fold<double>(
      0,
      (total, line) => total + line.credit.toDouble(),
    );

    return _sameAmount(previewDebit, entryDebit) &&
        _sameAmount(previewCredit, entryCredit);
  }

  bool _sameAmount(double first, double second) =>
      (first - second).abs() < 0.000001;
}
