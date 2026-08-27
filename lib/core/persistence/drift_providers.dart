import 'dart:async';

import 'package:basir_accounting_system/core/persistence/drift_customers_vendors_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_goals_budgets_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_inventory_shadow_read.dart';
import 'package:basir_accounting_system/core/persistence/drift_settings_shadow_read.dart';
import 'package:basir_accounting_system/features/budget/data/repositories/drift_budget_repository.dart';
import 'package:basir_accounting_system/features/budget/domain/repositories/budget_repository.dart';
import 'package:basir_accounting_system/features/goals/data/repositories/drift_goal_repository.dart';
import 'package:basir_accounting_system/features/goals/domain/repositories/goal_repository.dart';
import 'package:basir_accounting_system/features/reports/data/repositories/drift_market_price_repository.dart';
import 'package:basir_accounting_system/features/reports/domain/repositories/market_price_repository.dart';
import 'package:basir_accounting_system/features/settings/data/repositories/drift_barcode_config_repository.dart';
import 'package:basir_accounting_system/features/settings/domain/repositories/barcode_config_repository.dart';
import 'package:basir_drift_storage/basir_drift_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// مراحل تفعيل Drift. لا يتغير مسار المستودعات النشطة تلقائيًا بناءً على هذه
/// القيمة؛ يستخدم كل repository مرحلة مستقلة بعد بوابة قبول خاصة به.
enum DriftRolloutStage {
  /// Isar هو المسار الوحيد. هذه هي القيمة الإنتاجية الافتراضية.
  isarPrimary,

  /// مقارنة قراءات Drift تشخيصيًا من دون التأثير على مخرجات Isar.
  shadowRead,

  /// يسمح بقراءة Drift في بيئات canary المعتمدة فقط.
  canaryRead,

  /// يصبح Drift المصدر المحلي الأساسي للشريحة المعتمدة فقط.
  driftPrimary,
}

/// الحالة العامة الآمنة للطرح. تبقى [DriftRolloutStage.isarPrimary] حتى يُعتمد
/// تبديل repository محدد في PR ومراجعة منفصلين.
final driftRolloutStageProvider = Provider<DriftRolloutStage>(
  (ref) => DriftRolloutStage.isarPrimary,
);

/// نقطة حقن لاختبارات الجاهزية فقط؛ يبقى إنشاء قاعدة Drift خارج طبقات domain.
typedef DriftConnectionVerifier = Future<void> Function();

class _DatabaseDriftConnectionVerifier {
  const _DatabaseDriftConnectionVerifier(this._database);

  final BasirDatabase _database;

  Future<void> call() async {
    await _database.customSelect('SELECT 1').get();
  }
}

/// قاعدة Drift المشتركة. لا تُفتح أو تُستخدم عبر أي provider نشط تلقائيًا؛
/// مزودات المستودعات التالية مخصصة للتحقق والـcanary فقط في هذه الموجة.
final driftDatabaseProvider = Provider<BasirDatabase>((ref) {
  final database = BasirDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

/// منفذ اختبار الاتصال، مع قابلية override في الاختبارات من دون الحاجة إلى
/// فتح SQLite أو WASM.
final driftConnectionVerifierProvider = Provider<DriftConnectionVerifier>(
  (ref) => _DatabaseDriftConnectionVerifier(
    ref.watch(driftDatabaseProvider),
  ).call,
);

/// نتيجة تحقق صريحة بدل تحويل أخطاء فتح Drift إلى fallback صامت.
sealed class DriftReadiness {
  const DriftReadiness();
}

class DriftReady extends DriftReadiness {
  const DriftReady();
}

class DriftUnavailable extends DriftReadiness {
  const DriftUnavailable(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

/// يفحص القدرة على تنفيذ استعلام محلي بسيط. لا يغيّر هذا الفحص أي provider
/// إنتاجي ولا ينفذ ترحيلًا أو كتابة بيانات.
final driftReadinessProvider = FutureProvider<DriftReadiness>((ref) async {
  try {
    await ref.watch(driftConnectionVerifierProvider)();
    return const DriftReady();
  } on Object catch (error, stackTrace) {
    return DriftUnavailable(error, stackTrace);
  }
});

/// مسار Drift المرشح للأهداف؛ لا يستخدمه `goalRepositoryProvider` النشط.
final driftGoalRepositoryProvider = Provider<GoalRepository>(
  (ref) => DriftGoalRepository(ref.watch(driftDatabaseProvider)),
);

/// مسار Drift المرشح للميزانيات؛ لا يستخدمه `budgetRepositoryProvider` النشط.
final driftBudgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => DriftBudgetRepository(ref.watch(driftDatabaseProvider)),
);

/// مسار Drift المرشح لأسعار السوق. لا يستخدمه `marketPriceRepositoryProvider`
/// النشط حتى اجتياز shadow-read وقرار cutover مستقل.
final driftMarketPriceRepositoryProvider = Provider<MarketPriceRepository>(
  (ref) => DriftMarketPriceRepository(ref.watch(driftDatabaseProvider)),
);

/// مسار Drift المرشح لإعدادات الباركود. لا يستخدمه
/// `barcodeConfigRepositoryProvider` النشط في هذه الموجة.
final driftBarcodeConfigRepositoryProvider = Provider<BarcodeConfigRepository>(
  (ref) => DriftBarcodeConfigRepository(ref.watch(driftDatabaseProvider)),
);

/// Feature flag مستقل لـGoals shadow-read. يبقى مغلقًا حتى اعتماد parity.
final driftGoalsShadowReadEnabledProvider = Provider<bool>((ref) => false);

/// Feature flag مستقل لـBudgets shadow-read. يبقى مغلقًا حتى اعتماد parity.
final driftBudgetsShadowReadEnabledProvider = Provider<bool>((ref) => false);

/// Comparator قابل للحقن لـGoals وBudgets؛ sink الذاكراتي للاختبارات فقط.
final driftGoalsBudgetsShadowReadComparatorProvider =
    Provider<DriftGoalsBudgetsShadowReadComparator>(
  (ref) {
    final sink = InMemoryDriftShadowReadSink();
    return DriftGoalsBudgetsShadowReadComparator(recorder: sink.record);
  },
);

/// Feature flag مستقل لـProfile shadow-read. يبقى مغلقًا حتى اعتماد لقطة
/// parity ومراجعة telemetry؛ لا يبدل Provider النشط عند تغييره.
final driftProfileShadowReadEnabledProvider = Provider<bool>((ref) => false);

/// Feature flag مستقل لـBusinessSettings shadow-read. يبقى مغلقًا حتى اعتماد
/// لقطة parity ومراجعة telemetry؛ لا يبدل Provider النشط عند تغييره.
final driftBusinessSettingsShadowReadEnabledProvider =
    Provider<bool>((ref) => false);

/// Comparator قابل للحقن في اختبارات shadow-read. لا يُربط تلقائيًا بمراقبة
/// خارجية، ويظل sink الذاكراتي مناسبًا للاختبارات فقط.
final driftSettingsShadowReadComparatorProvider =
    Provider<DriftSettingsShadowReadComparator>(
  (ref) {
    final sink = InMemoryDriftShadowReadSink();
    return DriftSettingsShadowReadComparator(recorder: sink.record);
  },
);

/// Feature flag مستقل لـCustomer shadow-read. يبقى مغلقًا حتى اعتماد parity
/// على لقطة فعلية ومراجعة telemetry؛ لا يبدل Provider النشط.
final driftCustomerShadowReadEnabledProvider = Provider<bool>((ref) => false);

/// Feature flag مستقل لـVendor shadow-read. يبقى مغلقًا حتى اعتماد parity
/// على لقطة فعلية ومراجعة telemetry؛ لا يبدل Provider النشط.
final driftVendorShadowReadEnabledProvider = Provider<bool>((ref) => false);

/// Comparator قابل للحقن لـCustomers وVendors؛ sink الذاكراتي للاختبارات فقط.
final driftCustomersVendorsShadowReadComparatorProvider =
    Provider<DriftCustomersVendorsShadowReadComparator>(
  (ref) {
    final sink = InMemoryDriftShadowReadSink();
    return DriftCustomersVendorsShadowReadComparator(recorder: sink.record);
  },
);

/// Feature flags مستقلة لشريحة المخزون؛ تبقى مغلقة افتراضيًا.
final driftWarehousesShadowReadEnabledProvider = Provider<bool>((ref) => false);
final driftInventoryItemsShadowReadEnabledProvider =
    Provider<bool>((ref) => false);
final driftStockMovementsShadowReadEnabledProvider =
    Provider<bool>((ref) => false);

/// Comparator لشريحة المخزون؛ sink الذاكراتي للاختبار فقط حتى اعتماد telemetry.
final driftInventoryShadowReadComparatorProvider =
    Provider<DriftInventoryShadowReadComparator>(
  (ref) {
    final sink = InMemoryDriftShadowReadSink();
    return DriftInventoryShadowReadComparator(recorder: sink.record);
  },
);
