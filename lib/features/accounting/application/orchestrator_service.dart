import 'package:basir_app/features/accounting/application/financial_strategy_service.dart';
import 'package:basir_app/features/accounting/application/forensic_audit_service.dart';
import 'package:basir_app/features/accounting/application/operational_intel_service.dart';
import 'package:basir_app/features/accounting/application/standards_engine_service.dart';
import 'package:basir_app/features/accounting/application/sustainability_expert_service.dart';
import 'package:basir_app/features/accounting/application/tax_engine_service.dart';
import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orchestrator_service.g.dart';

/// خدمة التنسيق (Orchestrator Service)
/// تدير تدفق العمل المعتمد على "سداسية بصير الإدراكية" (The Cognitive Hexagon).
@Riverpod(keepAlive: true)
class OrchestratorService extends _$OrchestratorService {
  @override
  FutureOr<void> build() {}

  /// نقطة الدخول الرئيسية لتدفق التنسيق المتعدد الوكلاء.
  /// يتم استدعاء الوكلاء الستة للوصول إلى إجماع إدراكي حول كل عملية مالية.
  Future<AgentConsensus> orchestrate(AccountingContext context) async {
    final results = <AgentResult>[];

    // 1. استدعاء محرك المعايير (Standards - IFRS/ISSB)
    results.add(
      await ref.read(standardsEngineServiceProvider.notifier).process(context),
    );

    // 2. استدعاء محرك الضرائب (Tax - ZATCA/FTA)
    results.add(
      await ref.read(taxEngineServiceProvider.notifier).process(context),
    );

    // 3. استدعاء وكيل التدقيق الجنائي (Forensic Audit)
    results.add(
      await ref.read(forensicAuditServiceProvider.notifier).process(context),
    );

    // 4. استدعاء وكيل الذكاء التشغيلي (Operational Intel)
    results.add(
      await ref.read(operationalIntelServiceProvider.notifier).process(context),
    );

    // 5. استدعاء وكيل الاستراتيجية المالية (Financial Strategy)
    results.add(
      await ref
          .read(financialStrategyServiceProvider.notifier)
          .process(context),
    );

    // 6. استدعاء وكيل خبير الاستدامة (Sustainability Expert)
    results.add(
      await ref
          .read(sustainabilityExpertServiceProvider.notifier)
          .process(context),
    );

    // تجميع النتائج: هل العملية مسموح بها من الجميع؟
    final overallAllowed = results.every((r) => r.isAllowed);

    final aggregateRationale = StringBuffer();
    aggregateRationale.writeln(
      '--- Basir Cognitive Hexagon: Final Consensus Report ---',
    );
    aggregateRationale.writeln(
      'Decision: ${overallAllowed ? "APPROVED ✅" : "REJECTED ❌"}',
    );

    // حساب متوسط درجة الثقة بشكل صحيح
    final totalConfidence = results.fold<double>(
      0,
      (sum, res) => sum + res.confidenceScore,
    );
    final averageConfidence = totalConfidence / results.length;

    aggregateRationale.writeln(
      'Confidence Level: ${averageConfidence.toStringAsFixed(2)}',
    );
    aggregateRationale.writeln('-----------------------------------');

    for (final res in results) {
      aggregateRationale.writeln(
        '[${res.agentId}] ${res.isAllowed ? "PASS" : "FAIL"} | '
        'Confidence: ${res.confidenceScore}',
      );
      aggregateRationale.writeln(res.rationale);
      aggregateRationale.writeln('---');
    }

    return AgentConsensus(
      isApproved: overallAllowed,
      explanation: aggregateRationale.toString(),
      agentResults: results,
      orchestrationTimestamp: DateTime.now(),
    );
  }
}

/// يمثل إجماع الوكلاء على عملية معينة.
class AgentConsensus {
  /// إنشاء إجماع الوكلاء.
  AgentConsensus({
    required this.isApproved,
    required this.explanation,
    required this.agentResults,
    required this.orchestrationTimestamp,
  });

  /// هل تمت الموافقة من جميع الوكلاء؟
  final bool isApproved;

  /// التفسير المجمع للقرار.
  final String explanation;

  /// قائمة بنتائج كل وكيل على حدة.
  final List<AgentResult> agentResults;

  /// طابع زمني لعملية التنسيق.
  final DateTime orchestrationTimestamp;
}
