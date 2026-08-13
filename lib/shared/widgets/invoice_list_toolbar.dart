// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شريط أدوات موحد لقوائم الفواتير (Invoice List Toolbar)
///
/// يجمع بين البحث النصي المباشر في الفواتير/العملاء/الأرقام،
/// وتبديل حالة الترتيب (الأحدث، الأقدم، المبلغ، العميل، الاستحقاق)،
/// مع عرض عدّاد نتائج البحث الحالية.
///
/// يعتمد على مزودات البحث والفرز الموجودة:
/// [invoiceSearchProvider] و[invoiceFilterProvider] و[invoiceSortProvider].
///
/// Features:
/// - حقل بحث مرئي (لم يكن متاحًا من قبل رغم وجود مزود البحث)
/// - فرز زمني/مالي/ابجدي وفق Design Tokens
/// - عدّاد نتائج البحث (إخفاء عند عدم وجود استعلام)
/// - دعم RTL ذكي وامتثال WCAG (Touch target ≥ 44px)
/// - اختبارات وحدة وواجهة مرتبطة
///
/// Example:
/// ```dart
/// const InvoiceListToolbar(totalMatches: 42),
/// ```
class InvoiceListToolbar extends ConsumerStatefulWidget {
  /// إنشاء شريط أدوات جديد لقائمة الفواتير.
  const InvoiceListToolbar({
    super.key,
    this.totalMatches,
  });

  /// إجمالي نتائج المطابقة الحالية لعرض العدّاد.
  /// إذا كان `null` أو 0 ولا يوجد استعلام بحث نشط، لا يظهر العدّاد.
  final int? totalMatches;

  @override
  ConsumerState<InvoiceListToolbar> createState() => _InvoiceListToolbarState();
}

class _InvoiceListToolbarState extends ConsumerState<InvoiceListToolbar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final currentQuery = ref.read(invoiceSearchProvider);
    _searchController = TextEditingController(text: currentQuery);
  }

  @override
  void didUpdateWidget(covariant InvoiceListToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // مزامنة المتحكم مع حالة المزود عند تغيير المزوّد خارجيًا (مثل التنقل)
    final currentQuery = ref.read(invoiceSearchProvider);
    if (_searchController.text != currentQuery) {
      _searchController.text = currentQuery;
      _searchController.selection = TextSelection.collapsed(
        offset: currentQuery.length,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // لا يوجد setter معرّف على StateController؛ التعيين المباشر هو الأسلوب المعياري.
  // ignore: use_setters_to_change_properties
  void _onSearchChanged(String query) {
    ref.read(invoiceSearchProvider.notifier).state = query;
  }

  void _onClearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSearching =
        ref.watch(invoiceSearchProvider.select((value) => value)).isNotEmpty;
    final sortKey = <credential-fixture>(invoiceSortProvider.select((value) => value));

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    hintText: l10n.searchInvoicesHint,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: InputColors.placeholder,
                    ),
                    labelText: l10n.searchInvoicesLabel,
                    labelStyle: AppTextStyles.labelLarge.copyWith(
                      color: InputColors.label,
                      fontWeight: FontWeights.semiBold,
                    ),
                    prefixIcon: const Icon(Icons.search, size: IconSizes.md),
                    suffixIcon: isSearching
                        ? IconButton(
                            icon: const Icon(Icons.cancel, size: IconSizes.sm),
                            tooltip: l10n.clearSearchTooltip,
                            constraints: const BoxConstraints(
                              minWidth: TouchTargets.minimum,
                              minHeight: TouchTargets.minimum,
                            ),
                            onPressed: _onClearSearch,
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              _buildSortMenu(context, sortKey),
            ],
          ),
          if (isSearching && widget.totalMatches != null) ...[
            const SizedBox(height: Spacing.xs),
            Text(
              widget.totalMatches == 0
                  ? l10n.noSearchResults
                  : l10n.resultsCount(widget.totalMatches.toString()),
              style: AppTextStyles.bodySmall.copyWith(
                color: widget.totalMatches == 0
                    ? AppColors.error
                    : AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// قائمة فرز منسدلة بخيارات مرتبة وفق المعايير المحاسبية.
  Widget _buildSortMenu(BuildContext context, String sortKey) {
    final l10n = context.l10n;
    final options = <(String, String)>[
      ('newest', l10n.sortNewest),
      ('oldest', l10n.sortOldest),
      ('amount_desc', l10n.sortAmountDesc),
      ('amount_asc', l10n.sortAmountAsc),
      ('due_date', l10n.sortDueDateAsc),
      ('customer', l10n.sortCustomer),
    ];
    final activeLabel = options
        .where((pair) => pair.$1 == sortKey)
        .map((pair) => pair.$2)
        .firstOrNull;
    return PopupMenuButton<String>(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sort, size: IconSizes.md, color: AppColors.primary),
          if (activeLabel != null)
            Text(
              activeLabel,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeights.bold,
              ),
            ),
        ],
      ),
      tooltip: l10n.sortTooltip,
      constraints: const BoxConstraints(
        minWidth: TouchTargets.minimum,
        minHeight: TouchTargets.minimum,
      ),
      onSelected: (value) =>
          ref.read(invoiceSortProvider.notifier).state = value,
      itemBuilder: (context) => options
          .map(
            (pair) => CheckedPopupMenuItem<String>(
              value: pair.$1,
              checked: pair.$1 == sortKey,
              child: Text(pair.$2),
            ),
          )
          .toList(),
    );
  }
}
