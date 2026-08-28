import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_item_form_screen.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/bulk_price_change_screen.dart';
import 'package:basir_accounting_system/features/onboarding/presentation/widgets/cognitive_overlay.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إدارة المخزون (Inventory Items Screen)
class InventoryItemsScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة أصناف المخزون
  const InventoryItemsScreen({super.key});

  @override
  ConsumerState<InventoryItemsScreen> createState() =>
      _InventoryItemsScreenState();
}

class _InventoryItemsScreenState extends ConsumerState<InventoryItemsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(filteredInventoryItemsProvider);
    final appIcons = ref.watch(appIconsProvider);

    // Trigger Cognitive Hint on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (itemsAsync.hasValue &&
          itemsAsync.value!.isEmpty &&
          _searchController.text.isEmpty) {
        showCognitiveHint(
          context,
          context.l10n.inventoryEmptyHintDescription,
          title: context.l10n.inventoryEmptyHintTitle,
        );
      }
    });

    return GlassScaffold(
      title: context.l10n.inventoryItemsScreenTitle,
      actions: [
        IconButton(
          icon: Icon(appIcons.barcodeReader, size: IconSizes.md),
          tooltip: context.l10n.labelSearchSku,
          constraints: const BoxConstraints(
            minWidth: TouchTargets.minimum,
            minHeight: TouchTargets.minimum,
          ),
          padding: EdgeInsets.zero,
          onPressed: _openBarcodeEngine,
        ),
        IconButton(
          icon: Icon(appIcons.add, size: IconSizes.md),
          tooltip: context.l10n.tooltipAddInventoryItem,
          constraints: const BoxConstraints(
            minWidth: TouchTargets.minimum,
            minHeight: TouchTargets.minimum,
          ),
          padding: EdgeInsets.zero,
          onPressed: _addItem,
        ),
        IconButton(
          icon: Icon(appIcons.priceTag, size: IconSizes.md),
          tooltip: context.l10n.bulkWizardTitle,
          constraints: const BoxConstraints(
            minWidth: TouchTargets.minimum,
            minHeight: TouchTargets.minimum,
          ),
          padding: EdgeInsets.zero,
          onPressed: _openBulkPriceChange,
        ),
      ],
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: AppSearchField(
              controller: _searchController,
              hint: context.l10n.inventoryItemsSearchHint,
              onChanged: (value) {
                ref.read(inventorySearchProvider.notifier).state = value;
              },
              onClear: () {
                _searchController.clear();
                ref.read(inventorySearchProvider.notifier).state = '';
              },
            ),
          ),

          // قائمة الأصناف
          Expanded(
            child: itemsAsync.when(
              data: _buildItemsList,
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (error, stack) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(inventoryItemsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<InventoryItem> items) {
    if (items.isEmpty) {
      return const Center(child: EmptyStateIllustration());
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final localizedName = item.name(isArabic: context.isArabic);
        final identifiers = [
          if (item.sku != null) '${context.l10n.labelSKU}: ${item.sku}',
          if (item.barcode != null)
            '${context.l10n.labelBarcode}: ${item.barcode}',
        ].join(' • ');
        final quantityLabel = _quantityLabel(item);
        return Semantics(
          label: '$localizedName, $identifiers, $quantityLabel',
          button: true,
          child: AppListCard(
            title: localizedName,
            subtitle: identifiers,
            trailing: quantityLabel,
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                localizedName.isNotEmpty ? localizedName[0] : '؟',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            onTap: () => _viewItemDetails(item),
          ),
        );
      },
    );
  }

  String _quantityLabel(InventoryItem item) {
    final quantity = item.currentQuantity;
    final value = quantity == quantity.truncateToDouble()
        ? quantity.toInt().toString()
        : quantity.toString();
    final unit = item.unit?.trim();
    return unit == null || unit.isEmpty ? value : '$value $unit';
  }

  Future<void> _openBulkPriceChange() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => const BulkPriceChangeScreen(),
      ),
    );
    if (result ?? false) ref.invalidate(inventoryItemsProvider);
  }

  Future<void> _addItem() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => const InventoryItemFormScreen(),
      ),
    );
    if (result ?? false) ref.invalidate(inventoryItemsProvider);
  }

  Future<void> _viewItemDetails(InventoryItem item) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => InventoryItemFormScreen(item: item),
      ),
    );
    if (result ?? false) ref.invalidate(inventoryItemsProvider);
  }

  Future<void> _openBarcodeEngine() async {
    await Navigator.pushNamed(context, '/barcode-creation');
  }
}
