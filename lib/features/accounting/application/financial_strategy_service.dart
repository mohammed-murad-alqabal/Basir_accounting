import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_strategy_service.g.dart';

/// يمثل الوكيل الخامس (Agent 5) المسؤول عن التخطيط المالي بعيد المدى
/// وتحليل السيولة.
@Riverpod(keepAlive: true)
class FinancialStrategyService extends _$FinancialStrategyService
    implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-5-financial-strategy';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];

    // 1. تحليل تأثير السيولة (Liquidity Impact)
    // نبحث عن حركات الصندوق أو البنك (acc-11 branch)
    final cashImpactLines = context.proposedJournalEntry.lines.where(
      (l) => l.accountId.startsWith('acc-11'),
    );

    if (cashImpactLines.isNotEmpty) {
      for (final line in cashImpactLines) {
        if (line.credit > line.debit) {
          rationale.add(
            'تحليل الاستراتيجية: هذا القيد يمثل خروج سيولة نقدية بقيمة '
            '${line.credit}.',
          );
          rationale.add(
            'توصية: يرجى مراجعة تدفقاتك النقدية للأسبوع القادم لضمان '
            'تغطية الالتزامات الأخرى.',
          );
        } else {
          rationale.add(
            'تحليل الاستراتيجية: تعزيز السيولة بقيمة ${line.debit} يدعم '
            'الخطط الاستثمارية قصيرة الأجل.',
          );
        }
      }
    }

    // 2. تحليل الأثر على الربحية
    if (context.transactionType == 'sales') {
      rationale.add(
        'استراتيجية: زيادة المبيعات تساهم في تحسين نسبة العائد '
        'على الأصول (ROA).',
      );
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: true,
      rationale: rationale.join('\n'),
      confidenceScore: 0.88,
    );
  }
}
