import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/bulk_price_change.dart';

/// خطوة المعالج الحالية في شاشة تغيير الأسعار الجماعي.
enum BulkChangeWizardStep {
  /// خطوة تحديد النطاق (جميع الأصناف أو تحديد معين).
  scope,

  /// خطوة تعريف القاعدة (نسبة/مبلغ ثابت/تعيين/نسخ).
  rule,

  /// خطوة معاينة الأثر قبل الاعتماد.
  preview,

  /// خطوة الاعتماد والتنفيذ.
  approval,
  /// خطوة النجاح مع نافذة الإلغاء.
  success,
}

/// حالة المعالج متعدد الخطوات لتغيير الأسعار الجماعي.
@immutable
class BulkChangeWizardState {
  /// يبني حالة المعالج بمكوناتها.
  const BulkChangeWizardState({
    this.step = BulkChangeWizardStep.scope,
    this.scope = const BulkPriceChangeScope.all(),
    this.target = BulkPriceTarget.sale,
    this.ruleType = BulkPriceChangeRuleType.percentage,
    this.ruleValue = 0,
    this.previewEntries = const [],
    this.previewLoaded = false,
    this.applying = false,
    this.executing = false,
    this.error,
    this.lastRecord,
    this.confirmed = false,
    this.confirmationText,
  });

  /// الخطوة الحالية من خطوات المعالج.
  final BulkChangeWizardStep step;

  /// النطاق المحدد.
  final BulkPriceChangeScope scope;

  /// السعر المستهدف بالتغيير.
  final BulkPriceTarget target;

  /// نوع القاعدة المختارة.
  final BulkPriceChangeRuleType ruleType;

  /// قيمة القاعدة (النسبة أو المبلغ أو السعر الجديد).
  final double ruleValue;

  /// نتائج المعاينة المعروضة.
  final List<BulkPriceChangePreviewEntry> previewEntries;

  /// هل جرت المعاينة؟
  final bool previewLoaded;

  /// هل يجري حاليًا تحديث المعاينة؟
  final bool applying;

  /// هل يجري حاليًا التنفيذ؟
  final bool executing;

  /// رسالة الخطأ الحالية.
  final String? error;

  /// سجل التنفيذ الناتج عن آخر تنفيذ ناجح.
  final BulkChangeExecutionRecord? lastRecord;

  /// هل أكّد المستخدم الإقرار النهائي؟
  final bool confirmed;

  /// نص الإقرار المكتوب.
  final String? confirmationText;

  /// قاعدة محسوبة من المدخلات الحالية.
  BulkPriceChangeRule get rule => BulkPriceChangeRule(
        type: ruleType,
        value: ruleValue,
      );

  /// نسخة جديدة مع تغيير الخطوة فقط.
  BulkChangeWizardState copyWithStep(BulkChangeWizardStep step) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType,
        ruleValue: ruleValue,
        previewEntries: previewEntries,
        previewLoaded: previewLoaded,
        applying: applying,
        executing: executing,
        error: null,
        lastRecord: lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// نسخة جديدة مع تغيير النطاق.
  BulkChangeWizardState copyWithScope(BulkPriceChangeScope scope) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType,
        ruleValue: ruleValue,
        previewLoaded: previewLoaded,
        applying: applying,
        executing: executing,
        error: error,
        lastRecord: lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// نسخة جديدة مع تغيير السعر المستهدف.
  BulkChangeWizardState copyWithTarget(BulkPriceTarget target) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType,
        ruleValue: ruleValue,
        previewLoaded: previewLoaded,
        applying: applying,
        executing: executing,
        error: error,
        lastRecord: lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// نسخة جديدة مع تغيير القاعدة.
  BulkChangeWizardState copyWithRule({
    BulkPriceChangeRuleType? ruleType,
    double? ruleValue,
    bool clearPreview = true,
  }) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType ?? this.ruleType,
        ruleValue: ruleValue ?? this.ruleValue,
        previewLoaded: clearPreview ? false : previewLoaded,
        applying: applying,
        executing: executing,
        error: error,
        lastRecord: lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// نسخة جديدة مع نتائج المعاينة.
  BulkChangeWizardState copyWithPreview({
    required List<BulkPriceChangePreviewEntry> entries,
    bool applying = false,
    String? error,
  }) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType,
        ruleValue: ruleValue,
        previewEntries: entries,
        previewLoaded: true,
        applying: applying,
        executing: executing,
        error: error,
        lastRecord: lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// نسخة جديدة مع الإقرار.
  BulkChangeWizardState copyWithConfirmation({
    required bool confirmed,
    String? confirmationText,
  }) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType,
        ruleValue: ruleValue,
        previewEntries: previewEntries,
        previewLoaded: previewLoaded,
        applying: applying,
        executing: executing,
        error: error,
        lastRecord: lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// نسخة جديدة مع سجل التنفيذ أو التنفيذ الجاري.
  BulkChangeWizardState copyWithExecution({
    BulkChangeExecutionRecord? record,
    bool executing = false,
    String? error,
  }) =>
      BulkChangeWizardState(
        step: step,
        scope: scope,
        target: target,
        ruleType: ruleType,
        ruleValue: ruleValue,
        previewEntries: previewEntries,
        previewLoaded: previewLoaded,
        applying: applying,
        executing: executing,
        error: error,
        lastRecord: record ?? lastRecord,
        confirmed: confirmed,
        confirmationText: confirmationText,
      );

  /// إعادة بناء الحالة الافتراضية دون بيانات.
  BulkChangeWizardState reset() => const BulkChangeWizardState();
}

/// مزود حالة المعالج.
final bulkChangeWizardProvider =
    StateNotifierProvider<BulkChangeWizardNotifier, BulkChangeWizardState>(
  (ref) => BulkChangeWizardNotifier(ref),
);

/// معالج حالة خطوات تغيير الأسعار الجماعي.
class BulkChangeWizardNotifier extends StateNotifier<BulkChangeWizardState> {
  /// يبني المعالج بمرجعRiverpod لخدمة تغيير الأسعار.
  BulkChangeWizardNotifier(this._ref) : super(const BulkChangeWizardState());

  final Ref _ref;

  /// ينتقل إلى الخطوة التالية من خطوات المعالج.
  Future<void> nextStep() async {
    final next = _nextStep(state.step);
    if (next != null) {
      state = state.copyWithStep(next);
    }
    if (next == BulkChangeWizardStep.preview) {
      await refreshPreview();
    }
  }

  /// يرجع خطوة إلى الوراء.
  void previousStep() {
    final previous = _previousStep(state.step);
    if (previous != null) {
      state = state.copyWithStep(previous);
    }
  }

  BulkChangeWizardStep? _nextStep(BulkChangeWizardStep step) {
    switch (step) {
      case BulkChangeWizardStep.scope:
        return BulkChangeWizardStep.rule;
      case BulkChangeWizardStep.rule:
        return BulkChangeWizardStep.preview;
      case BulkChangeWizardStep.preview:
        return BulkChangeWizardStep.approval;
      case BulkChangeWizardStep.approval:
        return BulkChangeWizardStep.success;
      case BulkChangeWizardStep.success:
        return null;
    }
  }

  BulkChangeWizardStep? _previousStep(BulkChangeWizardStep step) {
    switch (step) {
      case BulkChangeWizardStep.scope:
        return null;
      case BulkChangeWizardStep.rule:
        return BulkChangeWizardStep.scope;
      case BulkChangeWizardStep.preview:
        return BulkChangeWizardStep.rule;
      case BulkChangeWizardStep.approval:
        return BulkChangeWizardStep.preview;
      case BulkChangeWizardStep.success:
        return BulkChangeWizardStep.approval;
    }
  }
  /// يحدّث النطاق المحدد ويعيد بناء المعاينة.
  void updateScope(BulkPriceChangeScope scope) {
    state = state.copyWithScope(scope);
    if (state.previewLoaded) {
      refreshPreview();
    }
  }

  /// يحدّث السعر المستهدف.
  void updateTarget(BulkPriceTarget target) {
    state = state.copyWithTarget(target);
    if (state.previewLoaded) {
      refreshPreview();
    }
  }

  /// يحدّث نوع القاعدة.
  void updateRuleType(BulkPriceChangeRuleType ruleType) {
    state = state.copyWithRule(ruleType: ruleType);
  }

  /// يحدّث قيمة القاعدة.
  void updateRuleValue(double value) {
    state = state.copyWithRule(ruleValue: value);
  }

  /// يحدث المعاينة من جديد وفق القاعدة والنطاق الحاليين.
  Future<void> refreshPreview() async {
    final service = _ref.read(bulkPriceChangeServiceProvider);
    state = state.copyWithPreview(entries: state.previewEntries, applying: true);
    final result = await service.preview(
      scope: state.scope,
      rule: state.rule,
      target: state.target,
    );
    if (result.success) {
      state = state.copyWithPreview(entries: result.getOrThrow());
    } else {
      state = state.copyWithPreview(
        entries: state.previewEntries,
        error: result.message,
      );
    }
  }

  /// يحدّث حالة الإقرار النهائي قبل التنفيذ.
  void updateConfirmation({required bool confirmed, String? text}) {
    state = state.copyWithConfirmation(confirmed: confirmed, confirmationText: text);
  }

  /// ينفذ التغيير الجماعي المعتمد ويوثق السبب والمنفذ.
  Future<void> execute({
    required String operatorName,
    required String reason,
  }) async {
    state = state.copyWithExecution(executing: true);
    final service = _ref.read(bulkPriceChangeServiceProvider);
    final result = await service.execute(
      preview: state.previewEntries,
      rule: state.rule,
      scope: state.scope,
      target: state.target,
      operatorName: operatorName,
      reason: reason,
    );
    if (result.success) {
      state = state.copyWithExecution(record: result.getOrThrow());
      state = state.copyWithStep(BulkChangeWizardStep.success);
    } else {
      state = state.copyWithExecution(error: result.message);
    }
  }

  /// يلغي آخر تنفيذ ناجح إن كانت نافذة الإلغاء مفتوحة.
  Future<void> cancelLastExecution({
    required String operatorName,
    required String reason,
  }) async {
    final record = state.lastRecord;
    if (record == null) return;

    final service = _ref.read(bulkPriceChangeServiceProvider);
    final result = await service.cancel(
      recordId: record.id,
      operatorName: operatorName,
      reason: reason,
    );
    if (result.success) {
      final cancellation = result.auditTrail?.first ??
          AuditEntry(
            type: AuditEventType.cancelled,
            operatorName: operatorName,
            occurredAt: DateTime.now(),
            reason: reason,
            referenceId: record.id,
          );
      state = state.copyWithExecution(
        record: record.copyWithCancellation(cancellation),
      );
    } else {
      state = state.copyWithExecution(error: result.message);
    }
  }


  /// يفتح نافذة الإلغاء داخل شاشة النجاح (24 ساعة من التنفيذ).
  Future<bool> isExecutionCancellable() async {
    final record = state.lastRecord;
    if (record == null || record.isCancelled) return false;
    final now = _ref.read(bulkChangeNowProvider);
    return record.isCancellableAt(now());
  }

  /// يعيد تهيئة المعالج من البداية.
  void reset() {
    state = const BulkChangeWizardState();
  }
}

/// مزود دالة الزمن الحالية لأغراض الإلغاء القابل للاختبار.
final bulkChangeNowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// ملحق سجل التنفيذ لإنتاج نسخة بإحداث إلغاء موثق.
extension BulkChangeRecordCancellation on BulkChangeExecutionRecord {
  /// يبني نسخة من السجل تحمل حدث الإلغاء الموثق.
  BulkChangeExecutionRecord copyWithCancellation(AuditEntry entry) =>
      BulkChangeExecutionRecord(
        id: id,
        operatorName: operatorName,
        executedAt: executedAt,
        reason: reason,
        rule: rule,
        scopeItemIds: scopeItemIds,
        affectedItemIds: affectedItemIds,
        previousValues: previousValues,
        auditTrail: [...auditTrail, entry],
        effectiveAt: effectiveAt,
        cancellationDeadline: cancellationDeadline,
        cancellation: entry,
      );
}
