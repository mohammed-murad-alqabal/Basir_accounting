import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';

/// Exception thrown when the "Cognitive Hexagon" (Multi-Agent System)
/// refuses to certify a transaction.
///
/// This is a high-level "Gatekeeper" exception that prevents data corruption
/// or policy violation before it touches the ledger.
class CognitiveConsensusException implements Exception {
  /// Creates a cognitive exception with the full consensus report.
  CognitiveConsensusException(this.consensus);

  /// The full rejection report from the AI agents.
  final AgentConsensus consensus;

  @override
  String toString() => 'CognitiveConsensusException: Transaction REJECTED by '
      'Cognitive Hexagon.\nReasons:\n${consensus.explanation}';
}
