import 'package:basir_app/features/accounting/domain/entities/issb_ontology.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_agent.freezed.dart';

/// مستويات الصلاحية للوكلاء المحاسبيين.
enum AgentAuthority {
  /// قمة الهيكل: الوكيل المنسق (Master Governor).
  orchestrator,

  /// صلاحية عالية لمراجعة المعايير.
  high,

  /// صلاحية متوسطة.
  medium,

  /// صلاحية منخفضة أو للمراقبة فقط.
  low,
}

/// يمثل نتيجة معالجة الوكيل لعملية معينة.
@freezed
class AgentResult with _$AgentResult {
  /// إنشاء نتيجة الوكيل.
  const factory AgentResult({
    /// معرف الوكيل.
    required String agentId,

    /// هل العملية مسموح بها محاسبياً؟
    required bool isAllowed,

    /// التبرير العلمي أو المحاسبي للقرار.
    required String rationale,

    /// درجة الثقة بالقرار (0.0 إلى 1.0).
    required double confidenceScore,

    /// تعديلات مقترحة على القيد (اختياري).
    Map<String, dynamic>? suggestedAdjustments,
  }) = _AgentResult;
}

/// سياق المحاسبة الممرر بين الوكلاء.
@freezed
class AccountingContext with _$AccountingContext {
  /// إنشاء سياق محاسبي.
  const factory AccountingContext({
    /// القيد المحاسبي المقترح.
    required JournalEntry proposedJournalEntry,

    /// نوع العملية (مبيعات، مشتريات، رواتب، إلخ).
    required String transactionType,

    /// هل يتطلب الأمر مراجعة الاستدامة (ISSB)؟
    @Default(false) bool isSustainabilityRequired,

    /// مقاييس الاستدامة المرتبطة.
    List<SustainabilityMetric>? sustainabilityMetrics,

    /// بيانات إضافية.
    @Default({}) Map<String, dynamic> metadata,
  }) = _AccountingContext;
}

/// الواجهة البرمجية الأساسية لجميع الوكلاء المحاسبيين في نظام "بصير".
abstract class AccountingAgent {
  /// معرف الوكيل الفريد.
  String get agentId;

  /// مستوى صلاحية الوكيل.
  AgentAuthority get authority;

  /// معالجة سياق محاسبي وإرجاع نتيجة.
  /// يجب أن يتضمن القرار "تبريراً" (Rationale) يشرح الاستناد إلى المعايير.
  Future<AgentResult> process(AccountingContext context);
}
