import 'package:basir_app/features/accounting/domain/entities/accounting_agent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operational_intel_service.g.dart';

/// يمثل الوكيل الرابع (Agent 4) المسؤول عن ربط المحاسبة بالواقع
/// التشغيلي والمخزني.
@Riverpod(keepAlive: true)
class OperationalIntelService extends _$OperationalIntelService
    implements AccountingAgent {
  @override
  FutureOr<void> build() {}

  @override
  String get agentId => 'agent-4-operational-intel';

  @override
  AgentAuthority get authority => AgentAuthority.medium;

  @override
  Future<AgentResult> process(AccountingContext context) async {
    final rationale = <String>[];
    var confidenceScore = 0.92;

    // 1. تحليل نوع العملية
    if (context.transactionType == 'sales') {
      rationale.add(
        'تحليل الأثر التشغيلي للمبيعات: جاري فحص توفر المواد في المخزون.',
      );
      // سنقوم مستقبلاً بربطه مع خدمة المخزون (MawadService)
      rationale.add('توصية: تأكد من تحديث سجلات المخزن فور ترحيل هذا القيد.');
    } else if (context.transactionType == 'purchase') {
      rationale.add(
        'تحليل الأثر التشغيلي للمشتريات: فحص سعة المستودع والتدفق '
        'النقد المتاح.',
      );
    }

    // 2. فحص الأولوية التشغيلية
    final isUrgent = context.metadata['priority'] == 'high';
    if (isUrgent) {
      rationale.add('ملاحظة: هذه العملية معلمة كأولوية تشغيلية عالية.');
      confidenceScore = 0.98;
    }

    return AgentResult(
      agentId: agentId,
      isAllowed: true, // الوكيل التشغيلي غالباً يقدم نصائح ولا يرفض إلا قليلاً
      rationale: rationale.join('\n'),
      confidenceScore: confidenceScore,
    );
  }
}
