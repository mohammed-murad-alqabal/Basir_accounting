library;

import 'package:flutter/foundation.dart';

/// مسودة وثيقة موحدة لنظام بصير المحاسبي.
///
/// تمثل وثيقة غير مكتملة أو قابلة للتعديل لا أثر لها على الدفاتر أو المخزون.
/// المرجع: مخطط UI/UX التنفيذي — القسم 6 (حالات الوثائق) + العقود الموحدة.

import 'package:basir_accounting_system/core/domain/contracts/document_status.dart';

/// بند واحد داخل مسودة الوثيقة.
@immutable
class DraftLineItem {
  /// يبني بندًا بإلزامية المعرّف والوصف والكمية وسعر الوحدة.
  const DraftLineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.taxRate = 0.15,
    this.discount = 0,
  });

  /// معرّف فريد للبند داخل المسودة.
  final String id;

  /// وصف البند (صنف/خدمة).
  final String description;

  /// الكمية (موجبة دائمًا).
  final double quantity;

  /// سعر الوحدة قبل الضريبة.
  final double unitPrice;

  /// نسبة الضريبة بصيغة كسرية (0.15 = 15%).
  final double taxRate;

  /// الخصم على البند قبل الضريبة.
  final double discount;

  /// صافي البند قبل الضريبة.
  double get netAmount => (quantity * unitPrice) - discount;

  /// قيمة الضريبة على البند.
  double get taxAmount => netAmount * taxRate;

  /// إجمالي البند شامل الضريبة.
  double get grossAmount => netAmount + taxAmount;

  @override
  String toString() => 'DraftLineItem($description × $quantity = $grossAmount)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftLineItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description &&
          quantity == other.quantity &&
          unitPrice == other.unitPrice &&
          taxRate == other.taxRate &&
          discount == other.discount;

  @override
  int get hashCode =>
      Object.hash(id, description, quantity, unitPrice, taxRate, discount);
}

/// مسودة وثيقة قابلة للمتابعة أو الحذف دون أثر محاسبي.
///
/// حالة المسودة دائمًا [DocumentStatus.draft]؛ ولا يمكن ترحيلها
/// قبل استكمال بنودها وإجمالياتها عبر الطبقة الخدمية.
@immutable
class DocumentDraft {
  /// يبني مسودة بإلزامية المعرّف والنوع والعملة.
  const DocumentDraft._({
    required this.id,
    required this.documentType,
    required this.currencyCode,
    required this.lines,
    required this.headerNote,
    required this.updatedAt,
  });

  /// يبني مسودة جديدة بزمن تعديل تلقائي (الحالي).
  factory DocumentDraft({
    required String id,
    required String documentType,
    required String currencyCode,
    List<DraftLineItem> lines = const <DraftLineItem>[],
    String? headerNote,
    DateTime? updatedAt,
  }) =>
      DocumentDraft._(
        id: id,
        documentType: documentType,
        currencyCode: currencyCode,
        lines: lines,
        headerNote: headerNote,
        updatedAt: updatedAt ?? DateTime.now(),
      );

  /// معرّف المسودة الفريد.
  final String id;

  /// نوع الوثيقة (invoice/purchase/credit_note...).
  final String documentType;

  /// رمز العملة (SAR/USD...).
  final String currencyCode;

  /// بنود المسودة.
  final List<DraftLineItem> lines;

  /// ملاحظة رأس الوثيقة (اختيارية).
  final String? headerNote;

  /// زمن آخر تعديل على المسودة.
  final DateTime updatedAt;

  /// حالة المسودة دائمًا [DocumentStatus.draft].
  DocumentStatus get status => DocumentStatus.draft;

  /// صافي المجموع قبل الضريبة.
  double get subTotal =>
      lines.fold<double>(0, (total, line) => total + line.netAmount);

  /// إجمالي الضريبة على البنود.
  double get taxTotal =>
      lines.fold<double>(0, (total, line) => total + line.taxAmount);

  /// الإجمالي النهائي شامل الضريبة.
  double get grandTotal => subTotal + taxTotal;

  /// هل المسودة قابلة للحفظ (تحتوي بنودًا صالحة وإجماليًا موجبًا)؟
  bool get isSaveable =>
      lines.isNotEmpty &&
      grandTotal > 0 &&
      lines.every((line) => line.quantity > 0 && line.unitPrice >= 0);

  /// نسخة محدثة من المسودة ببنود جديدة وزمن تعديل جديد.
  DocumentDraft copyWithLines(List<DraftLineItem> lines) => DocumentDraft._(
        id: id,
        documentType: documentType,
        currencyCode: currencyCode,
        lines: lines,
        headerNote: headerNote,
        updatedAt: DateTime.now(),
      );

  @override
  String toString() =>
      'DocumentDraft($id: $documentType, $currencyCode, ${lines.length} lines)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentDraft &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          documentType == other.documentType &&
          currencyCode == other.currencyCode &&
          lines.length == other.lines.length;

  @override
  int get hashCode => Object.hash(id, documentType, currencyCode, lines.length);
}
