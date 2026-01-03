import 'package:basir_app/core/providers.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forensic_audit_service.g.dart';

/// نتيجة فحص التدقيق الجنائي
class AuditResult {
  const AuditResult({
    required this.isSuccess,
    required this.message,
    this.findings = const [],
  });
  final bool isSuccess;
  final String message;
  final List<String> findings;
}

/// خدمة التدقيق الجنائي المحاسبي (Forensic Audit Service)
/// تضمن سلامة البيانات وتراقب التغييرات غير المصرح بها.
@riverpod
class ForensicAuditService extends _$ForensicAuditService
    implements AccountingAgent {
  AccountingRepository get _repository =>
      ref.read(accountingRepositoryProvider);

  @override
  void build() {}

  @override
  String get agentId => 'agent-3-forensic-audit';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;

    // 1. Verify Entry Balance
    if (!context.proposedJournalEntry.isBalanced) {
      isAllowed = false;
      rationale.add('REJECTION: Proposed journal entry is not balanced.');
    } else {
      rationale.add('Check PASSED: Journal entry is balanced.');
    }

    // 2. Anomaly Detection (Simple Threshold)
    final threshold = Decimal.fromInt(1000000);
    if (context.proposedJournalEntry.totalDebit > threshold) {
      rationale.add(
        'WARNING: Unusually high transaction amount detected '
        '(${context.proposedJournalEntry.totalDebit}).',
      );
      // In some forensics, we might still allow but flag it.
      // For now, we allow but warn.
    }

    // 3. Duplicate Reference Check
    final entries = await _repository.getJournalEntries();
    final isDuplicate = entries.any(
      (e) => e.referenceNumber == context.proposedJournalEntry.referenceNumber,
    );
    if (isDuplicate) {
      isAllowed = false;
      rationale.add(
        'REJECTION: Duplicate reference number '
        '(${context.proposedJournalEntry.referenceNumber}) detected.',
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 1,
    );
  }

  /// فحص توازن كافة القيود المحاسبية (FR-ACC-002)
  Future<AuditResult> verifyAllEntriesBalanced() async {
    final entries = await _repository.getJournalEntries();
    final unbalanced = <String>[];

    for (final entry in entries) {
      if (!entry.isBalanced) {
        unbalanced.add('القيد رقم ${entry.referenceNumber} غير متزن');
      }
    }

    if (unbalanced.isEmpty) {
      return const AuditResult(
        isSuccess: true,
        message: 'جميع القيود متزنة بنجاح.',
      );
    }

    return AuditResult(
      isSuccess: false,
      message: 'تم العثور على قيود غير متزنة!',
      findings: unbalanced,
    );
  }

  /// فحص مطابقة أرصدة الحسابات مع مجموع القيود (Data Integrity)
  Future<AuditResult> verifyBalancesIntegrity() async {
    final accounts = await _repository.getAccounts();
    final entries = await _repository.getJournalEntries();
    final discrepancies = <String>[];

    for (final account in accounts) {
      if (account.isParent) continue;

      // حساب الرصيد من القيود يدوياً للمقارنة
      var calculatedBalance = Decimal.zero;
      for (final entry in entries) {
        if (entry.status != JournalEntryStatus.posted) continue;

        for (final line in entry.lines) {
          if (line.accountId == account.id) {
            calculatedBalance += line.debit - line.credit;
          }
        }
      }

      // تحويل الرصيد المحسوب ليتناسب مع طبيعة الحساب
      final absoluteCalculated = account.nature == AccountNature.debit
          ? calculatedBalance
          : -calculatedBalance;

      final storedBalance = await _repository.getAccountBalance(account.id);

      if (absoluteCalculated != storedBalance) {
        discrepancies.add(
          'حساب ${account.nameAr}: الرصيد المخزن ($storedBalance) لا يطابق المحسوب ($absoluteCalculated)',
        );
      }
    }

    if (discrepancies.isEmpty) {
      return const AuditResult(
        isSuccess: true,
        message: 'جميع أرصدة الحسابات مطابقة لسجل القيود.',
      );
    }

    return AuditResult(
      isSuccess: false,
      message: 'تم العثور على عدم تطابق في الأرصدة!',
      findings: discrepancies,
    );
  }

  /// الكشف عن معاملات مشبوهة (Anomaly Detection)
  Future<AuditResult> detectAnomalies() async {
    final entries = await _repository.getJournalEntries();
    final findings = <String>[];

    // مثال: قيود بمبالغ ضخمة جداً (أكثر من مليون)
    final threshold = Decimal.fromInt(1000000);

    for (final entry in entries) {
      if (entry.totalDebit > threshold) {
        findings.add(
          'تنبيه: قيد رقم ${entry.referenceNumber} بمبلغ ضخم (${entry.totalDebit})',
        );
      }

      // مثال: قيود في أوقات غير معتادة (إذا كان لدينا تاريخ إنشاء دقيق)
      // (مستقبلاً يمكن إضافة المزيد من القواعد)
    }

    return AuditResult(
      isSuccess: findings.isEmpty,
      message: findings.isEmpty
          ? 'لم يتم العثور على نشاط مشبوه.'
          : 'تم العثور على تنبيهات تستوجب المراجعة.',
      findings: findings,
    );
  }
}
