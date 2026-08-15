library;

import 'package:flutter/foundation.dart';

import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';

/// نطاق تغيير الأسعار الجماعي.
///
/// لا يوجد كيان فئات مستقل بعد، لذلك يعتمد النطاق إما الأصناف كافة أو
/// قائمة معرّفات محددة، وهو قابل للتمديد عند ظهور كيان الفئات.
@immutable
class BulkPriceChangeScope {
  /// يبني نطاقًا يُطبَّق على جميع الأصناف غير المحذوفة.
  const BulkPriceChangeScope.all()
      : specificItemIds = const [],
        isSpecific = false;

  /// يبني نطاقًا محدودًا بأصناف معرّفة بمعرّفاتها فقط.
  ///
  /// يجب أن يحمل النطاق المحدد معرّفًا واحدًا على الأقل؛ النطاق الفارغ
  /// يُرفض لاحقًا عند المعاينة أو التنفيذ برمز النطاق الفارغ.
  const BulkPriceChangeScope.items(List<String> itemIds)
      : specificItemIds = itemIds,
        isSpecific = true;

  /// معرّفات الأصناف المحددة (فارغة عند تطبيق التغيير على الكل).
  final List<String>? specificItemIds;

  /// هل النطاق محدود بأصناف معينة؟
  final bool isSpecific;

  /// عدد الأصناف المشمولة عند معرفته، وإلا صفر دلالةً على الكل.
  int get count => specificItemIds?.length ?? 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulkPriceChangeScope &&
          runtimeType == other.runtimeType &&
          isSpecific == other.isSpecific &&
          listEquals(specificItemIds, other.specificItemIds);

  @override
  int get hashCode => Object.hash(isSpecific, specificItemIds);

  @override
  String toString() => isSpecific
      ? 'BulkPriceChangeScope.items(${specificItemIds!.length})'
      : 'BulkPriceChangeScope.all()';

  /// تمثيل السلسلةية لاستخدام التخزين والعرض.
  Map<String, dynamic> toJson() => {
        'isSpecific': isSpecific,
        'specificItemIds': specificItemIds ?? const [],
      };

  /// يبني النطاق من تمثيله السلسلةي.
  factory BulkPriceChangeScope.fromJson(Map<String, dynamic> json) {
    final isSpecific = json['isSpecific'] == true;
    final ids = (json['specificItemIds'] as List? ?? const [])
        .cast<String>()
        .toList(growable: false);
    if (!isSpecific) {
      return const BulkPriceChangeScope.all();
    }
    return BulkPriceChangeScope.items(ids);
  }
}

/// نوع قاعدة تغيير السعر.
enum BulkPriceChangeRuleType {
  /// رفع أو خفض السعر بنسبة مئوية.
  percentage,

  /// إضافة أو طرح مبلغ ثابت.
  fixedAmount,

  /// تعيين السعر إلى قيمة محددة.
  setTo,

  /// نسخ سعر الشراء إلى سعر البيع.
  copyFromPurchase,
}

/// قاعدة حساب السعر الجديد.
@immutable
class BulkPriceChangeRule {
  /// يبني قاعدة تغيير سعر مع تاريخ سريان اختياري.
  const BulkPriceChangeRule({
    required this.type,
    required this.value,
    this.effectiveAt,
    this.sourcePrice,
  });

  /// نوع القاعدة.
  final BulkPriceChangeRuleType type;

  /// قيمة القاعدة (النسبة/المبلغ/السعر الجديد). صفر صالح للتعيين المباشر.
  final double value;

  /// سعر المصدر عند النسخ من سعر الشراء إلى البيع أو العكس.
  final BulkPriceSource? sourcePrice;

  /// تاريخ سريان السعر الجديد (اختياري، الافتراضي عند التنفيذ).
  final DateTime? effectiveAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulkPriceChangeRule &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          (value - other.value).abs() < 0.000001 &&
          sourcePrice == other.sourcePrice &&
          effectiveAt == other.effectiveAt;

  @override
  int get hashCode => Object.hash(type, value, sourcePrice, effectiveAt);

  @override
  String toString() => 'BulkPriceChangeRule($type: $value)';

  /// تمثيل السلسلةية لاستخدام التخزين.
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'value': value,
        if (sourcePrice != null) 'sourcePrice': sourcePrice!.name,
        if (effectiveAt != null) 'effectiveAt': effectiveAt!.toIso8601String(),
      };

  /// يبني القاعدة من تمثيلها السلسلةي.
  factory BulkPriceChangeRule.fromJson(Map<String, dynamic> json) =>
      BulkPriceChangeRule(
        type: BulkPriceChangeRuleType.values.firstWhere(
          (type) => type.name == json['type'],
        ),
        value: (json['value'] as num).toDouble(),
        sourcePrice: json['sourcePrice'] == null
            ? null
            : BulkPriceSource.values.firstWhere(
                (source) => source.name == json['sourcePrice'],
              ),
        effectiveAt: json['effectiveAt'] == null
            ? null
            : DateTime.parse(json['effectiveAt'] as String),
      );
}

/// مصدر السعر عند قواعد النسخ.
enum BulkPriceSource {
  /// السعر الذي يُنسخ منه.
  purchase,

  /// السعر الذي يُنسخ منه.
  sale,
}

/// سعر المصدر المطلوب تعديله في المعالجة الجماعية.
enum BulkPriceTarget {
  /// سعر البيع فقط.
  sale,

  /// سعر الشراء فقط.
  purchase,

  /// السعران معًا.
  both,
}

/// معاينة أثر تغيير السعر على صنف واحد قبل التنفيذ.
@immutable
class BulkPriceChangePreviewEntry {
  /// يبني معاينة صنف بوضع سعره قبل وبعد.
  const BulkPriceChangePreviewEntry({
    required this.itemId,
    required this.itemName,
    required this.target,
    this.previousSalePrice,
    this.newSalePrice,
    this.previousPurchasePrice,
    this.newPurchasePrice,
    this.isBlocked,
    this.blockReason,
  });

  /// معرّف الصنف المشمول بالمعاينة.
  final String itemId;

  /// اسم الصنف للعرض.
  final String itemName;

  /// السعر المستهدف.
  final BulkPriceTarget target;

  /// سعر البيع الحالي.
  final double? previousSalePrice;

  /// سعر البيع بعد التغيير.
  final double? newSalePrice;

  /// سعر الشراء الحالي.
  final double? previousPurchasePrice;

  /// سعر الشراء بعد التغيير.
  final double? newPurchasePrice;

  /// هل منع الحارس تطبيق القاعدة على هذا الصنف؟
  final bool? isBlocked;

  /// سبب المنع عند وجوده.
  final String? blockReason;

  /// هل ينتج عن القاعدة سعر سلبي في أي من السعرين المستهدفين؟
  bool get hasNegativeResult {
    if (newSalePrice != null && newSalePrice! < 0) return true;
    if (newPurchasePrice != null && newPurchasePrice! < 0) return true;
    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulkPriceChangePreviewEntry &&
          runtimeType == other.runtimeType &&
          itemId == other.itemId &&
          itemName == other.itemName &&
          target == other.target &&
          previousSalePrice == other.previousSalePrice &&
          newSalePrice == other.newSalePrice &&
          previousPurchasePrice == other.previousPurchasePrice &&
          newPurchasePrice == other.newPurchasePrice &&
          isBlocked == other.isBlocked &&
          blockReason == other.blockReason;

  @override
  int get hashCode => Object.hash(
        itemId,
        itemName,
        target,
        previousSalePrice,
        newSalePrice,
        previousPurchasePrice,
        newPurchasePrice,
        isBlocked,
        blockReason,
      );

  @override
  String toString() =>
      'BulkPriceChangePreviewEntry($itemId: ${previousSalePrice ?? 0} -> ${newSalePrice ?? 0})';

  /// تمثيل السلسلةية لتخزين القيمة السابقة لكل صنف.
  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': itemName,
        'target': target.name,
        if (previousSalePrice != null) 'previousSalePrice': previousSalePrice,
        if (newSalePrice != null) 'newSalePrice': newSalePrice,
        if (previousPurchasePrice != null)
          'previousPurchasePrice': previousPurchasePrice,
        if (newPurchasePrice != null) 'newPurchasePrice': newPurchasePrice,
        if (isBlocked != null) 'isBlocked': isBlocked,
        if (blockReason != null) 'blockReason': blockReason,
      };

  /// يبني المعاينة من تمثيلها السلسلةي.
  factory BulkPriceChangePreviewEntry.fromJson(Map<String, dynamic> json) =>
      BulkPriceChangePreviewEntry(
        itemId: json['itemId'] as String,
        itemName: json['itemName'] as String,
        target: BulkPriceTarget.values.firstWhere(
          (target) => target.name == json['target'],
        ),
        previousSalePrice: json['previousSalePrice'] as double?,
        newSalePrice: json['newSalePrice'] as double?,
        previousPurchasePrice: json['previousPurchasePrice'] as double?,
        newPurchasePrice: json['newPurchasePrice'] as double?,
        isBlocked: json['isBlocked'] as bool?,
        blockReason: json['blockReason'] as String?,
      );
}

/// سجل تنفيذ تغيير أسعار جماعي معتمد، ويحمل أحداث التدقيق وصلاحية الإلغاء.
@immutable
class BulkChangeExecutionRecord {
  /// يبني سجل تنفيذ معتمدًا.
  BulkChangeExecutionRecord({
    required this.id,
    required this.operatorName,
    required this.executedAt,
    required this.reason,
    required this.rule,
    required this.scopeItemIds,
    required this.affectedItemIds,
    required this.previousValues,
    required this.auditTrail,
    this.effectiveAt,
    DateTime? cancellationDeadline,
    this.cancellation,
  }) : cancellationDeadline =
            cancellationDeadline ?? executedAt.add(const Duration(hours: 24));

  /// المعرف الفريد لسجل التنفيذ.
  final String id;

  /// منفذ العملية القابل للتدقيق.
  final String operatorName;

  /// زمن التنفيذ.
  final DateTime executedAt;

  /// سبب الاعتماد الموثق.
  final String reason;

  /// القاعدة المعتمدة.
  final BulkPriceChangeRule rule;

  /// معرّفات الأصناف المشمولة بالنطاق.
  final List<String> scopeItemIds;

  /// معرّفات الأصناف التي تغير سعرها فعليًا.
  final List<String> affectedItemIds;

  /// القيم السابقة لكل صنف للرجوع عند الإلغاء.
  final List<BulkPriceChangePreviewEntry> previousValues;

  /// أحداث التدقيق المرتبطة بالتنفيذ.
  final List<AuditEntry> auditTrail;

  /// تاريخ السريان المعلن عند الإقرار.
  final DateTime? effectiveAt;

  /// نافذة الإلغاء التلقائية الافتراضية: 24 ساعة من التنفيذ.
  final DateTime cancellationDeadline;

  /// حدث الإلغاء الموثق عند استرجاع الأسعار داخل النافذة الزمنية.
  final AuditEntry? cancellation;

  /// هل استُرجعت الأسعار داخل نافذة الإلغاء؟
  bool get isCancelled => cancellation != null;

  /// هل لا تزال نافذة الإلغاء مفتوحة؟
  bool isCancellableAt(DateTime now) => now.isBefore(cancellationDeadline);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BulkChangeExecutionRecord &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          operatorName == other.operatorName &&
          executedAt == other.executedAt &&
          reason == other.reason &&
          listEquals(scopeItemIds, other.scopeItemIds) &&
          listEquals(affectedItemIds, other.affectedItemIds) &&
          listEquals(previousValues, other.previousValues);

  @override
  int get hashCode => Object.hash(id, operatorName, executedAt, reason);

  @override
  String toString() =>
      'BulkChangeExecutionRecord($id: ${affectedItemIds.length} items)';

  /// تمثيل السلسلةية لاستخدام التخزين في Isar.
  Map<String, dynamic> toJson() => {
        'id': id,
        'operatorName': operatorName,
        'executedAt': executedAt.toIso8601String(),
        'reason': reason,
        'rule': rule.toJson(),
        'scopeItemIds': scopeItemIds,
        'affectedItemIds': affectedItemIds,
        'previousValues':
            previousValues.map((entry) => entry.toJson()).toList(),
        'auditTrail': auditTrail.map((entry) => entry.toJson()).toList(),
        if (effectiveAt != null) 'effectiveAt': effectiveAt!.toIso8601String(),
        'cancellationDeadline': cancellationDeadline.toIso8601String(),
        if (cancellation != null) 'cancellation': cancellation!.toJson(),
      };

  /// يبني سجل التنفيذ من تمثيله السلسلةي.
  factory BulkChangeExecutionRecord.fromJson(Map<String, dynamic> json) =>
      BulkChangeExecutionRecord(
        id: json['id'] as String,
        operatorName: json['operatorName'] as String,
        executedAt: DateTime.parse(json['executedAt'] as String),
        reason: json['reason'] as String,
        rule: BulkPriceChangeRule.fromJson(
            Map<String, dynamic>.from(json['rule'] as Map)),
        scopeItemIds: (json['scopeItemIds'] as List).cast<String>().toList(),
        affectedItemIds:
            (json['affectedItemIds'] as List).cast<String>().toList(),
        previousValues: (json['previousValues'] as List)
            .map((raw) => BulkPriceChangePreviewEntry.fromJson(
                Map<String, dynamic>.from(raw as Map)))
            .toList(),
        auditTrail: (json['auditTrail'] as List)
            .map((raw) =>
                AuditEntry.fromJson(Map<String, dynamic>.from(raw as Map)))
            .toList(),
        effectiveAt: json['effectiveAt'] == null
            ? null
            : DateTime.parse(json['effectiveAt'] as String),
        cancellationDeadline:
            DateTime.parse(json['cancellationDeadline'] as String),
        cancellation: json['cancellation'] == null
            ? null
            : AuditEntry.fromJson(
                Map<String, dynamic>.from(json['cancellation'] as Map,),),
      );
}
