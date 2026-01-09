import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/providers/supabase_auth_provider.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'contra_settlement_service.g.dart';

/// خدمة تسوية الأرصدة المتقابلة (Contra-Settlement Service)
/// مسؤولة عن إجراء مقاصة بين أرصدة العملاء والموردين لنفس الكيان.
@riverpod
class ContraSettlementService extends _$ContraSettlementService {
  @override
  FutureOr<void> build() {}

  /// إجراء تسوية متقابلة (Contra Settlement)
  /// تقوم هذه العملية بإنقاص رصيد العميل مقابل إنقاص رصيد المورد.
  Future<String> performContraSettlement({
    required String customerId,
    required String vendorId,
    required String receivableAccountId,
    required String payableAccountId,
    required Decimal amount,
    required String description,
  }) async {
    final repository = ref.read(accountingRepositoryProvider);
    final user = ref.read(currentUserProvider);
    final now = DateTime.now();

    // التحقق من صحة المبلغ
    if (amount <= Decimal.zero) {
      throw Exception('Settlement amount must be greater than zero');
    }

    final lines = [
      // إنقاص رصيد المورد (مدين)
      // Debit the Payable account (Decrease Liability)
      JournalEntryLine(
        accountId: payableAccountId,
        accountName: 'تسوية مورد - $vendorId',
        debit: amount,
        credit: Decimal.zero,
        description: 'مقاصة: $description',
      ),
      // إنقاص رصيد العميل (دائن)
      // Credit the Receivable account (Decrease Asset)
      JournalEntryLine(
        accountId: receivableAccountId,
        accountName: 'تسوية عميل - $customerId',
        credit: amount,
        debit: Decimal.zero,
        description: 'مقاصة: $description',
      ),
    ];

    final entry = JournalEntry(
      id: const Uuid().v4(),
      referenceNumber: 'CON-${now.millisecondsSinceEpoch}',
      date: now,
      temporal: TemporalJustification(
        transactionDate: now,
        effectiveDate: now,
        recordingDate: now,
      ),
      standards: const StandardsJustification(
        standardReference: 'IFRS 9 / IFRS 15',
        recognitionBasis: 'Settlement',
        measurementBasis: 'Amortized Cost',
      ),
      description: 'تسوية أرصدة متقابلة: $description',
      status: JournalEntryStatus.posted,
      lines: lines,
      sourceDocument: 'contra_settlement',
      sourceId: '${customerId}_${vendorId}_${now.millisecondsSinceEpoch}',
      createdAt: now,
      createdBy: user?.id ?? 'system',
      updatedAt: now,
      postedAt: now,
    );

    await repository.addJournalEntry(entry);
    return entry.id;
  }
}
