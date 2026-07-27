import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/warehouse_transfer.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/warehouse_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة تحويل المخزون بين المستودعات
class WarehouseTransferScreen extends ConsumerStatefulWidget {
  /// إنشاء الشاشة
  const WarehouseTransferScreen({super.key});

  @override
  ConsumerState<WarehouseTransferScreen> createState() => _WarehouseTransferScreenState();
}

class _WarehouseTransferScreenState extends ConsumerState<WarehouseTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _remarksController = TextEditingController();

  Warehouse? _sourceWarehouse;
  Warehouse? _destinationWarehouse;
  final DateTime _date = DateTime.now();
  final List<TransferItem> _items = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _saveTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_sourceWarehouse == null || _destinationWarehouse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errFormFill)),
      );
      return;
    }

    if (_sourceWarehouse!.id == _destinationWarehouse!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errSameWarehouse)),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errNoItems)),
      );
      return;
    }

    setState(() => _isLoading = true);

    final transfer = WarehouseTransfer(
      id: const Uuid().v4(),
      transferNumber: 'TRF-${DateTime.now().millisecondsSinceEpoch}',
      sourceWarehouseId: _sourceWarehouse!.id,
      destinationWarehouseId: _destinationWarehouse!.id,
      date: _date,
      items: _items,
      remarks: _remarksController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await ref.read(transferActionProvider.notifier).executeTransfer(transfer);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
      } else {
        final error = ref.read(transferActionProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final warehousesAsync = ref.watch(warehousesProvider);
    final appIcons = ref.watch(appIconsProvider);

    return GlassScaffold(
      title: context.l10n.warehouseTransferTitleAdd,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: warehousesAsync.when(
                  data: (warehouses) => Column(
                    children: [
                      _buildWarehouseSelector(
                        label: context.l10n.labelSourceWarehouse,
                        value: _sourceWarehouse,
                        onChanged: (val) => setState(() => _sourceWarehouse = val),
                        items: warehouses,
                      ),
                      const SizedBox(height: Spacing.md),
                      _buildWarehouseSelector(
                        label: context.l10n.labelDestinationWarehouse,
                        value: _destinationWarehouse,
                        onChanged: (val) => setState(() => _destinationWarehouse = val),
                        items: warehouses,
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Text(e.toString()),
                ),
              ),
              const SizedBox(height: Spacing.md),
              _buildItemsSection(appIcons),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _remarksController,
                label: context.l10n.labelNotes,
                prefixIcon: Icon(appIcons.note),
                maxLines: 2,
              ),
              const SizedBox(height: Spacing.xl),
              AppEnhancedButton(
                label: context.l10n.btnSaveTransfer,
                onPressed: _isLoading ? null : _saveTransfer,
                isLoading: _isLoading,
                icon: appIcons.save,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarehouseSelector({
    required String label,
    required Warehouse? value,
    required ValueChanged<Warehouse?> onChanged,
    required List<Warehouse> items,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          DropdownButtonFormField<Warehouse>(
            initialValue: value,
            items: items
                .map(
                  (w) => DropdownMenuItem(
                    value: w,
                    child: Text(
                      w.name(isArabic: context.l10n.localeName == 'ar'),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      );

  Widget _buildItemsSection(AppIconsBase appIcons) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.labelInvoiceItems,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(appIcons.addCircle, color: AppColors.primary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _addItem,
                ),
              ],
            ),
            const Divider(),
            if (_items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Center(child: Text(context.l10n.msgNoItems)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.itemName),
                    subtitle: Text(
                      '${context.l10n.labelQuantity}: ${item.quantity}',
                    ),
                    trailing: IconButton(
                      icon: Icon(appIcons.delete, color: AppColors.error),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _items.removeAt(index)),
                    ),
                  );
                },
              ),
          ],
        ),
      );

  Future<void> _addItem() async {
    final inventoryItemsAsync = ref.read(inventoryItemsProvider);
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    InventoryItem? selectedItem;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.dialogAddItemTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inventoryItemsAsync.when(
                data: (items) => DropdownButtonFormField<InventoryItem>(
                  decoration: InputDecoration(
                    labelText: context.l10n.labelInventoryItem,
                  ),
                  items: items
                      .map(
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(
                            i.name(isArabic: context.l10n.localeName == 'ar'),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (i) {
                    if (i != null) {
                      setDialogState(() {
                        selectedItem = i;
                        nameController.text = i.name(isArabic: context.l10n.localeName == 'ar');
                      });
                    }
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text(e.toString()),
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                controller: quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.labelQuantity,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.dialogCancel),
            ),
            TextButton(
              onPressed: () {
                final qty = Decimal.tryParse(quantityController.text);
                if (selectedItem != null && qty != null && qty > Decimal.zero) {
                  setState(() {
                    _items.add(
                      TransferItem(
                        itemId: selectedItem!.id,
                        itemName: selectedItem!.name(
                          isArabic: context.l10n.localeName == 'ar',
                        ),
                        quantity: qty.toDouble(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(context.l10n.btnAdd),
            ),
          ],
        ),
      ),
    );
  }
}
