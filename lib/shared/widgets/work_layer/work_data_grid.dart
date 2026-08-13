/// جدول العمل الموحّد لنظام بصير المحاسبي.
///
/// يعرض كيانات/تقارير بأعمدة معرّفة، مع دعم الفرز والاختيار المتعدد
/// والأرقام بمحاذاة جدولية وفصل آلالاف.
///
/// المرجع: مخطط UI/UX التنفيذي — القسم 7 (الجداول والقوائم).
library;

import 'package:basir_accounting_system/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_text_styles.dart';
import 'package:basir_accounting_system/core/theme/tokens/font_weights.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing.dart';
import 'package:basir_accounting_system/core/theme/tokens/border_widths.dart';

/// عمود واحد داخل [WorkDataGrid].
///
/// [format] تحدد محاذاة وتهيئة القيمة: [DataGridCellFormat.text] للنصوص
/// (محاذاة يمين في RTL)، [DataGridCellFormat.number] للأرقام (جدولية)،
/// و[DataGridCellFormat.date] للتواريخ.
class WorkDataGridColumn<T> {
  /// يبني عمودًا بإلزامية المعرّف والعنوان ودالة العرض.
  const WorkDataGridColumn({
    required this.key,
    required this.label,
    required this.builder,
    this.format = DataGridCellFormat.text,
    this.flex = 1,
    this.sortable = true,
    this.semanticsLabel,
  });

  /// معرّف العمود الفريد (يُستخدم أيضًا في الفرز والاختيار).
  final String key;

  /// عنوان العمود المعرَّب.
  final String label;

  /// دالة بناء خلية من كيان من نوع [T].
  final Widget Function(T entity) builder;

  /// تنسيق الخلية (نص/رقم/تاريخ).
  final DataGridCellFormat format;

  /// مرونة العمود داخل الشبكة.
  final int flex;

  /// هل يُسمح بفرز العمود؟
  final bool sortable;

  /// تسمية دلالية بديلة (للاختبارات الصوتية عند تعقيد الخلية).
  final String? semanticsLabel;
}

/// تنسيق خلية الجدول.
enum DataGridCellFormat {
  /// نص عادي — محاذاة وفق اتجاه النص.
  text,

  /// رقم بمحاذاة جدولية وفصل آلالاف (يعتمد لغة الواجهة).
  number,

  /// تاريخ بتنسيق محلي.
  date;
}

/// وصف كيان في صف الجدول مع إمكانية التحديد.
class WorkDataGridEntity<T> {
  /// يبني صفًا بإلزامية المعرّف والكيان.
  const WorkDataGridEntity(
      {required this.id, required this.entity, this.selected = false});

  /// معرّف الصف الفريد.
  final String id;

  /// الكيان المعروض في الصف.
  final T entity;

  /// هل الصف محدد حاليًا؟
  final bool selected;
}

/// جدولة العمل الموحدة: أعمدة، صفوف قابلة للفرز والاختيار، وصف حالة الفراغ.
class WorkDataGrid<T> extends StatefulWidget {
  /// يبني الجدول بإلزامية الأعمدة والكيانات.
  const WorkDataGrid({
    super.key,
    required this.columns,
    required this.entities,
    this.onSelect,
    this.onSort,
    this.sortKey,
    this.sortAscending = true,
    this.showSelection = false,
    this.emptyLabel,
    this.rowHeight = 52,
  });

  /// أعمدة الجدول.
  final List<WorkDataGridColumn<T>> columns;

  /// صفوف الجدول.
  final List<WorkDataGridEntity<T>> entities;

  /// تُستدعى عند تغيير تحديد الصف.
  final ValueChanged<WorkDataGridEntity<T>>? onSelect;

  /// تُستدعى عند طلب تغيير ترتيب الفرز.
  final ValueChanged<(String, bool)>? onSort;

  /// عمود الفرز الحالي (معرّف العمود).
  final String? sortKey;

  /// اتجاه الفرز الحالي.
  final bool sortAscending;

  /// هل يُعرض عمود اختيار متعدد؟
  final bool showSelection;

  /// نص وصف حالة الفراغ عند غياب الصفوف.
  final String? emptyLabel;

  /// ارتفاع صف الجدول.
  final double rowHeight;

  @override
  State<WorkDataGrid<T>> createState() => _WorkDataGridState<T>();
}

class _WorkDataGridState<T> extends State<WorkDataGrid<T>> {
  @override
  Widget build(BuildContext context) {
    final effectiveColumns = [
      if (widget.showSelection) _selectionColumn,
      ...widget.columns,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(effectiveColumns),
        if (widget.entities.isEmpty)
          _buildEmptyState()
        else
          ...widget.entities
              .map((entity) => _buildRow(effectiveColumns, entity)),
      ],
    );
  }

  WorkDataGridColumn<T> get _selectionColumn => WorkDataGridColumn<T>(
        key: '__selection__',
        label: AppLocalizations.of(context).workGridSelect,
        builder: (_) => const SizedBox.shrink(),
        format: DataGridCellFormat.text,
        flex: 0,
        sortable: false,
      );

  Widget _buildHeader(List<WorkDataGridColumn<T>> columns) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md, vertical: Spacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(
            bottom: BorderSide(
                color: AppColors.borderLight, width: BorderWidths.normal)),
      ),
      child: Row(
        children: [
          ...columns.asMap().entries.map((entry) {
            final column = entry.value;
            return Expanded(
              flex: column.flex + (column.key == '__selection__' ? 1 : 0),
              child: column.sortable && column.key != '__selection__'
                  ? Semantics(
                      label: AppLocalizations.of(context)
                          .workGridSortableColumn(column.label),
                      button: true,
                      child: InkWell(
                        onTap: () => widget.onSort?.call((
                          column.key,
                          widget.sortKey == column.key
                              ? !widget.sortAscending
                              : true
                        )),
                        child: Row(
                          mainAxisAlignment: _alignmentFor(column),
                          children: [
                            Text(
                              column.label,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeights.semiBold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            _sortIndicator(column),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: _alignmentFor(column),
                      children: [
                        Text(
                          column.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeights.semiBold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            );
          }),
        ],
      ),
    );
  }

  Widget _sortIndicator(WorkDataGridColumn<T> column) {
    if (widget.sortKey != column.key) {
      return const Icon(Icons.keyboard_arrow_up_outlined,
          size: 14, color: AppColors.textDisabled);
    }
    return Icon(
      widget.sortAscending
          ? Icons.keyboard_arrow_up
          : Icons.keyboard_arrow_down,
      size: 14,
      color: AppColors.primary,
    );
  }

  Widget _buildRow(
      List<WorkDataGridColumn<T>> columns, WorkDataGridEntity<T> entity) {
    return Semantics(
      label: AppLocalizations.of(context).workGridRow,
      child: GestureDetector(
        onTap: widget.onSelect != null
            ? () => widget.onSelect?.call(entity)
            : null,
        child: Container(
          height: widget.rowHeight,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          decoration: BoxDecoration(
            color:
                entity.selected ? AppColors.selectedOverlay : AppColors.surface,
            border: const Border(
                bottom: BorderSide(
                    color: AppColors.borderLight, width: BorderWidths.normal)),
          ),
          child: Row(
            children: [
              ...columns.asMap().entries.map((entry) {
                final column = entry.value;
                if (column.key == '__selection__') {
                  return _selectionCell(entity);
                }
                return Expanded(
                  flex: column.flex,
                  child: Align(
                    alignment: _cellAlignmentFor(column),
                    child: column.semanticsLabel != null
                        ? Semantics(
                            label: column.semanticsLabel,
                            child: column.builder(entity.entity))
                        : column.builder(entity.entity),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectionCell(WorkDataGridEntity<T> entity) {
    return const Expanded(
      flex: 1,
      child: Checkbox(
        value: false,
        onChanged: null,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Alignment _cellAlignmentFor(WorkDataGridColumn<T> column) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    switch (column.format) {
      case DataGridCellFormat.number:
        return isLtr ? Alignment.centerLeft : Alignment.centerRight;
      case DataGridCellFormat.date:
        return isLtr ? Alignment.centerRight : Alignment.centerLeft;
      case DataGridCellFormat.text:
        return Alignment.center;
    }
  }

  MainAxisAlignment _alignmentFor(WorkDataGridColumn<T> column) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    switch (column.format) {
      case DataGridCellFormat.number:
        return isLtr ? MainAxisAlignment.start : MainAxisAlignment.end;
      case DataGridCellFormat.date:
        return isLtr ? MainAxisAlignment.end : MainAxisAlignment.start;
      case DataGridCellFormat.text:
        return MainAxisAlignment.center;
    }
  }

  Widget _buildEmptyState() {
    final empty =
        widget.emptyLabel ?? AppLocalizations.of(context).workGridEmpty;
    return Padding(
      padding: const EdgeInsets.all(Spacing.xl),
      child: Semantics(
        label: empty,
        child: Text(
          empty,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        ),
      ),
    );
  }
}
