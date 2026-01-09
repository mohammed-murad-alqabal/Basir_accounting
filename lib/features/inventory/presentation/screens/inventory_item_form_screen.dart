import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_app/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة/تعديل صنف مخزون
class InventoryItemFormScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة نموذج صنف المخزون
  const InventoryItemFormScreen({super.key, this.item});

  /// الصنف المراد تعديله (إن وجد)
  final InventoryItem? item;

  @override
  ConsumerState<InventoryItemFormScreen> createState() =>
      _InventoryItemFormScreenState();
}

class _InventoryItemFormScreenState
    extends ConsumerState<InventoryItemFormScreen> {
  final _formKey = <credential-fixture><FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _skuController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _unitController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.item?.nameAr ?? '');
    _nameEnController = TextEditingController(text: widget.item?.nameEn ?? '');
    _skuController = TextEditingController(text: widget.item?.sku ?? '');
    _purchasePriceController = TextEditingController(
      text: widget.item?.purchasePrice?.toString() ?? '',
    );
    _salePriceController = TextEditingController(
      text: widget.item?.salePrice?.toString() ?? '',
    );
    _unitController = TextEditingController(text: widget.item?.unit ?? '');
    _quantityController = TextEditingController(
      text: widget.item?.currentQuantity.toString() ?? '0',
    );
    _descriptionController = TextEditingController(
      text: widget.item?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _skuController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(inventoryActionProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: widget.item == null
            ? context.l10n.titleAddInventoryItem
            : context.l10n.titleEditInventoryItem,
      ),
      body: Form(
        key: <credential-fixture>,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            AppTextField(
              controller: _nameArController,
              label: context.l10n.labelNameAr,
              validator: (v) =>
                  v?.isEmpty ?? true ? context.l10n.errEmptyField : null,
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _nameEnController,
              label: context.l10n.labelNameEn,
              validator: (v) =>
                  v?.isEmpty ?? true ? context.l10n.errEmptyField : null,
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _skuController,
              label: context.l10n.labelSKU,
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _purchasePriceController,
                    label: context.l10n.labelPurchasePrice,
                    keyboardType: <credential-fixture>,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _salePriceController,
                    label: context.l10n.labelSalePrice,
                    keyboardType: <credential-fixture>,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _unitController,
                    label: context.l10n.labelUnit,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _quantityController,
                    label: context.l10n.labelQuantity,
                    keyboardType: <credential-fixture>,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _descriptionController,
              label: context.l10n.labelDescription,
              maxLines: 3,
            ),
            const SizedBox(height: Spacing.xl),
            AppButton(
              label: context.l10n.btnSave,
              isLoading: isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final item = InventoryItem(
      id: widget.item?.id ?? const Uuid().v4(),
      nameAr: _nameArController.text,
      nameEn: _nameEnController.text,
      sku: _skuController.text.isEmpty ? null : _skuController.text,
      purchasePrice: double.tryParse(_purchasePriceController.text),
      salePrice: double.tryParse(_salePriceController.text),
      unit: _unitController.text.isEmpty ? null : _unitController.text,
      currentQuantity: double.tryParse(_quantityController.text) ?? 0,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      createdAt: widget.item?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (widget.item == null) {
      await ref.read(inventoryActionProvider.notifier).addItem(item);
    } else {
      await ref.read(inventoryActionProvider.notifier).updateItem(item);
    }

    if (mounted && !ref.read(inventoryActionProvider).hasError) {
      Navigator.pop(context, true);
    }
  }
}
