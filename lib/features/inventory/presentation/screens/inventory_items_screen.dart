import 'package:basir_accounting_system/core/assets/app_illustrations.dart';
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/screens/inventory_item_form_screen.dart';
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
          'قم بإضافة أصناف المخزون هنا لتتمكن من تتبع الكميات والتكاليف بدقة. '
          'يمكنك البدء بإضافة صنف يدويًا.',
          title: 'إدارة المخزون',
        );
      }
    });

    return GlassScaffold(
      title: context.l10n.inventoryItemsScreenTitle,
      actions: [
        IconButton(
          icon: Icon(appIcons.barcodeReader, size: 26),
          tooltip: 'محرك الباركود',
          onPressed: _openBarcodeEngine,
        ),
        IconButton(
          icon: Icon(appIcons.add, size: 26),
          tooltip: context.l10n.tooltipAddInventoryItem,
          onPressed: _addItem,
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
        return Semantics(
          label: '$localizedName, '
              '${item.sku ?? ""}, '
              '${item.currentQuantity} ${item.unit ?? ""}',
          button: true,
          child: AppListCard(
            title: localizedName,
            subtitle: item.sku ?? '',
            trailing: '${item.currentQuantity} ${item.unit ?? ""}',
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
