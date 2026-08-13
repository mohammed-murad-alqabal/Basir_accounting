/// شريط التصفية الموحد لنظام بصير المحاسبي.
///
/// يجمع البحث النصي السريع، فلاتر الحالات، والنطاق الزمني في شريط
/// واحد متجاوب: أيقونات فقط عند ضيق العرض (نقطة كسر 600px) ونصوص كاملة
/// فوقها — وفق المخطط التنفيذي (القسم 7: شريط التصفية والعروض المحفوظة).
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_colors.dart';
import 'package:basir_accounting_system/core/theme/tokens/app_text_styles.dart';
import 'package:basir_accounting_system/core/theme/tokens/border_widths.dart';
import 'package:basir_accounting_system/core/theme/tokens/font_weights.dart';
import 'package:basir_accounting_system/core/theme/tokens/icon_sizes.dart';
import 'package:basir_accounting_system/core/theme/tokens/radii.dart';
import 'package:basir_accounting_system/core/theme/tokens/spacing.dart';
import 'package:basir_accounting_system/core/theme/tokens/touch_targets.dart';
import 'package:basir_accounting_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// خيار فلتر حالة قابل للاختيار داخل [WorkFilterBar].
class WorkFilterOption {
  /// يبني خيارًا بإلزامية الحالة ومعرّف الفلتر.
  const WorkFilterOption({required this.status, required this.id});

  /// معرّف الفلتر.
  final String id;

  /// الحالة الموحدة المعروضة في الخيار.
  final DocumentStatus status;
}

/// شريط التصفية الموحد: بحث نصي + فلاتر حالات + نطاق زمني + عروض محفوظة.
class WorkFilterBar extends StatefulWidget {
  /// يبني الشريط بالخيارات المتاحة.
  const WorkFilterBar({
    required this.options,
    super.key,
    this.selectedOptionId,
    this.onSelectOption,
    this.searchHint,
    this.searchText,
    this.onSearchChanged,
    this.onExportRequested,
    this.narrowBreakpoint = 600,
  });

  /// خيارات الفلتر المعروضة (الحالات الموحدة).
  final List<WorkFilterOption> options;

  /// معرّف الخيار المحدد حاليًا.
  final String? selectedOptionId;

  /// تُستدعى عند اختيار فلتر حالة.
  final ValueChanged<String>? onSelectOption;

  /// نص التلميح داخل حقل البحث.
  final String? searchHint;

  /// نص البحث الحالي.
  final String? searchText;

  /// تُستدعى عند تغيير نص البحث.
  final ValueChanged<String>? onSearchChanged;

  /// تُستدعى عند طلب التصدير (أيقونة تصدير الجدول).
  final VoidCallback? onExportRequested;

  /// عرض الكسر الذي يتحول عنده الشريط إلى وضع الأيقونات فقط.
  final double narrowBreakpoint;

  @override
  State<WorkFilterBar> createState() => _WorkFilterBarState();
}

class _WorkFilterBarState extends State<WorkFilterBar> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchText);
    _searchFocus = FocusNode();
  }

  @override
  void didUpdateWidget(WorkFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchText != oldWidget.searchText &&
        widget.searchText != _searchController.text) {
      _searchController.text = widget.searchText ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  bool get _isNarrow =>
      MediaQuery.sizeOf(context).width < widget.narrowBreakpoint;

  @override
  Widget build(BuildContext context) => Container(
        height: TouchTargets.buttonHeightSm,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(
              color: AppColors.borderLight,
              width: BorderWidths.normal,
            ),
          ),
        ),
        child: Row(
          children: [
            if (widget.options.isNotEmpty) ...[
              _buildFilterChips(),
              const SizedBox(width: Spacing.md),
            ],
            Expanded(child: _buildSearchField()),
            if (widget.onExportRequested != null) ...[
              const SizedBox(width: Spacing.sm),
              _buildExportButton(),
            ],
          ],
        ),
      );

  Widget _buildFilterChips() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.options.asMap().entries.map((entry) {
            final option = entry.value;
            final isSelected = option.id == widget.selectedOptionId;
            return Padding(
              padding: EdgeInsets.only(left: entry.key == 0 ? 0 : Spacing.sm),
              child: Semantics(
                label: option.status.localizedLabelOf(context),
                selected: isSelected,
                button: true,
                child: FilterChip(
                  selected: isSelected,
                  onSelected: (_) => widget.onSelectOption?.call(option.id),
                  label: _isNarrow
                      ? Icon(
                          option.status.semanticIcon,
                          size: IconSizes.xs,
                          color: AppColors.textPrimary,
                        )
                      : Text(
                          option.status.localizedLabelOf(context),
                          style: AppTextStyles.labelMedium
                              .copyWith(fontWeight: FontWeights.medium),
                        ),
                  backgroundColor: AppColors.surfaceVariant,
                  selectedColor:
                      option.status.semanticColor.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.textPrimary,
                  showCheckmark: isSelected,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            );
          }).toList(),
        ),
      );

  Widget _buildSearchField() => TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.searchHint ??
              AppLocalizations.of(context).workFilterSearchHint,
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: IconSizes.sm,
            color: AppColors.textHint,
          ),
          isDense: true,
          filled: true,
          fillColor: AppColors.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.xs,
          ),
          border: const OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.borderLight,
              width: BorderWidths.normal,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: Radii.borderRadiusMd,
            borderSide: BorderSide(
              color: AppColors.borderLight,
              width: BorderWidths.normal,
            ),
          ),
        ),
        style: AppTextStyles.bodyMedium,
      );

  Widget _buildExportButton() => Semantics(
        label: AppLocalizations.of(context).workFilterExport,
        button: true,
        child: IconButton(
          onPressed: widget.onExportRequested,
          icon: const Icon(
            Icons.download_rounded,
            size: IconSizes.sm,
            color: AppColors.textPrimary,
          ),
          tooltip: AppLocalizations.of(context).workFilterExport,
          padding: const EdgeInsets.all(Spacing.xs),
        ),
      );
}
