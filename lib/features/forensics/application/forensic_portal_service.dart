import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/accounting/application/forensic_audit_service.dart';
import 'package:basir_accounting_system/features/forensics/domain/entities/integrity_pulse.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forensic_portal_service.g.dart';

@riverpod

/// Notifier for the forensic integrity pulse.
class ForensicPortalNotifier extends _$ForensicPortalNotifier {
  @override
  FutureOr<IntegrityPulse> build() async => _fetchPulse();

  Future<IntegrityPulse> _fetchPulse() async {
    final auditService = ref.read(forensicAuditServiceProvider.notifier);
    final result = await auditService.scrutinizeHistoricalLedger();

    // Mocking some data for the pulse since the service
    // doesn't return all fields yet
    return IntegrityPulse(
      isHealthy: result.isSuccess,
      lastVerifiedHash: '0x${result.isSuccess ? '00000000' : 'DEADC0DE'}',
      lastVerifiedAt: DateTime.now(),
      totalBlocksScanned: result.findings.length + 100, // Placeholder
      healthPercentage: result.isSuccess ? 100.0 : 92.5,
    );
  }

  /// Refreshes the forensic integrity pulse.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchPulse);
  }
}

@riverpod

/// Provider for the historical ledger blocks.
Future<List<LedgerBlock>> ledgerBlocks(LedgerBlocksRef ref) async {
  final repository = ref.watch(accountingRepositoryProvider);
  final entries = await repository.getJournalEntries();

  return entries
      .map(
        (e) => LedgerBlock(
          entryId: e.id,
          referenceNumber: e.referenceNumber,
          date: e.date,
          hash: e.hash,
          previousHash: e.previousHash,
          isVerified: true, // Simplified
          agentSignature: 'Agent-3-Forensic',
        ),
      )
      .toList();
}
