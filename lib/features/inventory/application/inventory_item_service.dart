import 'package:basir_accounting_system/core/domain/contracts/audit_entry.dart';
import 'package:basir_accounting_system/core/domain/contracts/operation_result.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/repositories/inventory_repository.dart';

/// خدمة إدارة البيانات الرئيسية للصنف.
///
/// تفصل هذه الخدمة تعديل تعريف الصنف (الأسماء والأسعار والوحدة والمعرفات) عن
/// تعديل الرصيد. لا يمكن أن ينشئ نموذج الصنف رصيد افتتاحي أو يغير كمية قائمة؛
/// فحركات المخزون والجرد المعتمد هما المساران الوحيدان لذلك.
class InventoryItemService {
  InventoryItemService({
    required InventoryRepository repository,
    DateTime Function()? now,
  })  : _repository = repository,
        _now = now ?? DateTime.now;

  /// رمز فشل عند غياب اسم الصنف العربي.
  static const emptyArabicNameCode = 'inventory_item_name_ar_required';

  /// رمز فشل عند غياب اسم الصنف الإنجليزي.
  static const emptyEnglishNameCode = 'inventory_item_name_en_required';

  /// رمز فشل عند غياب المعرّف الداخلي للصنف.
  static const emptyIdCode = 'inventory_item_id_required';

  /// رمز فشل للأسعار غير الصالحة.
  static const invalidPriceCode = 'inventory_item_invalid_price';

  /// رمز فشل عند محاولة تعديل رصيد من بطاقة الصنف.
  static const quantityMutationForbiddenCode =
      'inventory_item_quantity_must_use_stock_movement';

  /// رمز فشل عند تكرار رمز الصنف.
  static const duplicateSkuCode = 'inventory_item_duplicate_sku';

  /// رمز فشل عند تكرار الباركود.
  static const duplicateBarcodeCode = 'inventory_item_duplicate_barcode';

  /// رمز فشل عند محاولة تعديل صنف غير موجود.
  static const itemNotFoundCode = 'inventory_item_not_found';

  /// رمز فشل عند غياب هوية منفذ العملية القابلة للتدقيق.
  static const operatorRequiredCode = 'inventory_item_operator_required';

  /// رمز فشل ثابت عند تعذر الحفظ.
  static const commitFailedCode = 'inventory_item_commit_failed';

  final InventoryRepository _repository;
  final DateTime Function() _now;

  /// ينشئ صنفًا رئيسيًا برصيد صفري، ويعيد أثر الإنشاء للتدقيق.
  Future<OperationResult<InventoryItem>> create(
    InventoryItem candidate, {
    required String operatorName,
  }) async {
    final prepared = _normalize(candidate);
    final validationCode = _validate(
      prepared,
      operatorName: operatorName,
      expectedQuantity: 0,
    );
    if (validationCode != null) {
      return OperationResult.failure(message: validationCode);
    }

    try {
      final identifiersFailure = await _validateIdentifiers(prepared);
      if (identifiersFailure != null) {
        return OperationResult.failure(message: identifiersFailure);
      }

      final recordedAt = _now();
      final item = prepared.copyWith(
        currentQuantity: 0,
        createdAt: recordedAt,
        updatedAt: recordedAt,
        isDeleted: false,
      );
      await _repository.addItem(item);

      return OperationResult.success(
        value: item,
        auditTrail: [
          AuditEntry(
            type: AuditEventType.created,
            operatorName: operatorName.trim(),
            occurredAt: recordedAt,
            reason: 'تم إنشاء بيانات الصنف الأساسية برصيد صفري.',
            referenceId: item.id,
          ),
        ],
      );
    } on Object catch (error) {
      return OperationResult.failure(
        message: commitFailedCode,
        cause: error,
      );
    }
  }

  /// يعدّل بيانات الصنف الرئيسية فقط ويحافظ على رصيده وتاريخ إنشائه.
  Future<OperationResult<InventoryItem>> update(
    InventoryItem candidate, {
    required String operatorName,
  }) async {
    if (candidate.id.trim().isEmpty) {
      return const OperationResult.failure(message: emptyIdCode);
    }

    try {
      final existing = await _repository.getItemById(candidate.id);
      if (existing == null || existing.isDeleted) {
        return const OperationResult.failure(message: itemNotFoundCode);
      }

      final prepared = _normalize(candidate);
      final validationCode = _validate(
        prepared,
        operatorName: operatorName,
        expectedQuantity: existing.currentQuantity,
      );
      if (validationCode != null) {
        return OperationResult.failure(message: validationCode);
      }

      final identifiersFailure = await _validateIdentifiers(prepared);
      if (identifiersFailure != null) {
        return OperationResult.failure(message: identifiersFailure);
      }

      final recordedAt = _now();
      final item = prepared.copyWith(
        currentQuantity: existing.currentQuantity,
        createdAt: existing.createdAt,
        updatedAt: recordedAt,
      );
      await _repository.updateItem(item);

      return OperationResult.success(
        value: item,
        auditTrail: [
          AuditEntry(
            type: AuditEventType.edited,
            operatorName: operatorName.trim(),
            occurredAt: recordedAt,
            reason: 'تم تعديل بيانات الصنف من دون تغيير رصيده.',
            referenceId: item.id,
          ),
        ],
      );
    } on Object catch (error) {
      return OperationResult.failure(
        message: commitFailedCode,
        cause: error,
      );
    }
  }

  String? _validate(
    InventoryItem item, {
    required String operatorName,
    required double expectedQuantity,
  }) {
    if (item.id.trim().isEmpty) return emptyIdCode;
    if (item.nameAr.trim().isEmpty) return emptyArabicNameCode;
    if (item.nameEn.trim().isEmpty) return emptyEnglishNameCode;
    if (operatorName.trim().isEmpty) return operatorRequiredCode;
    if (!_isValidPrice(item.purchasePrice) || !_isValidPrice(item.salePrice)) {
      return invalidPriceCode;
    }
    if (!_sameQuantity(item.currentQuantity, expectedQuantity)) {
      return quantityMutationForbiddenCode;
    }
    return null;
  }

  bool _isValidPrice(double? value) =>
      value == null || (value.isFinite && value >= 0);

  bool _sameQuantity(double first, double second) =>
      (first - second).abs() < 0.000001;

  Future<String?> _validateIdentifiers(InventoryItem candidate) async {
    final items = await _repository.getAllItems();
    final sku = candidate.sku;
    final barcode = candidate.barcode;

    for (final item in items) {
      if (item.id == candidate.id || item.isDeleted) continue;
      final existingSku = _normalizeIdentifier(item.sku);
      final existingBarcode = _normalizeIdentifier(item.barcode);

      if (sku != null && (sku == existingSku || sku == existingBarcode)) {
        return duplicateSkuCode;
      }
      if (barcode != null &&
          (barcode == existingSku || barcode == existingBarcode)) {
        return duplicateBarcodeCode;
      }
    }
    return null;
  }

  InventoryItem _normalize(InventoryItem item) => item.copyWith(
        nameAr: item.nameAr.trim(),
        nameEn: item.nameEn.trim(),
        sku: _normalizeIdentifier(item.sku),
        barcode: _normalizeIdentifier(item.barcode),
        unit: _nullIfBlank(item.unit),
        description: _nullIfBlank(item.description),
      );

  String? _normalizeIdentifier(String? value) {
    final normalized = _nullIfBlank(value);
    return normalized?.toUpperCase();
  }

  String? _nullIfBlank(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
