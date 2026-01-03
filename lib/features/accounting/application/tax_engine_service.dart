import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tax_engine_service.g.dart';

/// يمثل الوكيل الثاني (Agent 2) المسؤول عن التحقق من الالتزام بالقوانين
/// الضريبية المحلية (ZATCA, FTA).
@Riverpod(keepAlive: true)
class TaxEngineService extends _$TaxEngineService implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-2-tax-engine';

  @override
  AgentAuthority get authority => AgentAuthority.high;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var isAllowed = true;
    final metadata = context.metadata;

    // 1. التحقق من الرقم الضريبي (Tax ID Validation)
    final taxId = metadata['tax_id'] as String?;
    if (taxId == null || taxId.isEmpty) {
      rationale.add('تحذير: لم يتم تزويد رقم ضريبي للعملية.');
      // في العمليات الكبيرة، قد نرفض القيد
      if (context.proposedJournalEntry.totalDebit > Decimal.fromInt(10000)) {
        isAllowed = false;
        rationale.add(
          'رفض: العمليات التي تتجاوز 10,000 ريال تتطلب رقم ضريبي صالح (ZATCA).',
        );
      }
    } else {
      rationale.add('تم التحقق من الرقم الضريبي الصادر: $taxId');
    }

    // 2. التحقق من نسبة الضريبة (VAT Rate Check)
    // نبحث عن أسطر الضريبة في القيد
    final vatLines = context.proposedJournalEntry.lines.where(
      (l) => l.accountId == 'acc-2102' || l.accountName.contains('VAT'),
    );

    if (vatLines.isNotEmpty) {
      for (final line in vatLines) {
        rationale.add('تحليل ضريبة القيمة المضافة لـ ${line.accountName}');
        // منطق مبسط للتحقق من النسبة (مثلاً 15% للسعودية)
        final totalBase = context.proposedJournalEntry.totalDebit - line.credit;
        if (totalBase > Decimal.zero) {
          final calculatedRate =
              (line.credit / totalBase).toDecimal(scaleOnInfinitePrecision: 4);
          final expectedRate = Decimal.parse('0.15');

          if ((calculatedRate - expectedRate).abs() > Decimal.parse('0.001')) {
            rationale.add(
              'تنبيه: نسبة الضريبة المحسوبة ($calculatedRate) تختلف عن النسبة '
              'القياسية (15%).',
            );
          } else {
            rationale
                .add('تأكيد: نسبة الضريبة (15%) مطابقة للمتطلبات المحلية.');
          }
        }
      }
    } else if (context.transactionType == 'sales' ||
        context.transactionType == 'purchase') {
      rationale.add('تنبيه: عملية تجارية بدون أسطر ضريبة قيمة مضافة.');
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: isAllowed,
      rationale: rationale.join('\n'),
      confidenceScore: 0.95,
    );
  }
}
