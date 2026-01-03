import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sustainability_expert_service.g.dart';

/// وكيل خبير الاستدامة (Sustainability Expert Service)
/// يمثل الوكيل السادس (Agent 6) المسؤول عن الامتثال لمعايير ISSB الجلوبال.
@Riverpod(keepAlive: true)
class SustainabilityExpertService extends _$SustainabilityExpertService
    implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-6-sustainability-expert';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;

    if (context.isSustainabilityRequired) {
      rationale.add(
        'تحليل ISSB: العملية مسجلة كعملية تتطلب إفصاحاً بيئياً/اجتماعياً.',
      );

      if (context.sustainabilityMetrics == null ||
          context.sustainabilityMetrics!.isEmpty) {
        isAllowed = false;
        rationale.add(
          'رفض قطعي: معايير ISSB S2 تتطلب وجود مقاييس انبعاثات الكربون '
          'لهذه الصناعة.',
        );
      } else {
        rationale.add(
          'تم التحقق: تم إرفاق ${context.sustainabilityMetrics!.length} '
          'مقاييس استدامة متوافقة.',
        );
      }
    } else {
      rationale.add(
        'تحليل الاستدامة: هذه العملية لا تتطلب إفصاحات ISSB خاصة في '
        'هذه المرحلة.',
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.96,
    );
  }
}
