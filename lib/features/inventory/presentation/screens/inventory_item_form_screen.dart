import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/presentation/providers/accounts_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _skuController;
  late TextEditingController _purchasePriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _unitController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late ValuationMethod _valuationMethod;
  String? _assetAccountId;
  String? _cogsAccountId;
  String? _revenueAccountId;

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
    _valuationMethod =
        widget.item?.valuationMethod ?? ValuationMethod.weightedAverage;
    _assetAccountId = widget.item?.assetAccountId;
    _cogsAccountId = widget.item?.cogsAccountId;
    _revenueAccountId = widget.item?.revenueAccountId;
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
        key: _formKey,
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
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: AppTextField(
                    controller: _salePriceController,
                    label: context.l10n.labelSalePrice,
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.number,
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
            _buildIAS2Section(context),
            const SizedBox(height: Spacing.xl),
            const SizedBox(height: Spacing.xl),
            AppEnhancedButton(
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
      valuationMethod: _valuationMethod,
      assetAccountId: _assetAccountId,
      cogsAccountId: _cogsAccountId,
      revenueAccountId: _revenueAccountId,
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

  Widget _buildIAS2Section(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: context.l10n.labelInventoryValuation,
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: Spacing.md),
          DropdownButtonFormField<ValuationMethod>(
            initialValue: _valuationMethod,
            decoration: InputDecoration(
              labelText: context.l10n.labelValuationMethod,
            ),
            items: ValuationMethod.values
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text(v.localizedName(isArabic: context.isArabic)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _valuationMethod = v);
            },
          ),
          const SizedBox(height: Spacing.md),
          accountsAsync.when(
            data: (accounts) => Column(
              children: [
                _buildAccountDropdown(
                  label: context.l10n.labelAssetAccountId,
                  value: _assetAccountId,
                  accounts: accounts
                      .where((a) => a.type == AccountType.asset)
                      .toList(),
                  onChanged: (v) => setState(() => _assetAccountId = v),
                ),
                const SizedBox(height: Spacing.md),
                _buildAccountDropdown(
                  label: context.l10n.labelCogsAccountId,
                  value: _cogsAccountId,
                  accounts: accounts
                      .where((a) => a.type == AccountType.expense)
                      .toList(),
                  onChanged: (v) => setState(() => _cogsAccountId = v),
                ),
                const SizedBox(height: Spacing.md),
                _buildAccountDropdown(
                  label: context.l10n.labelRevenueAccountId,
                  value: _revenueAccountId,
                  accounts: accounts
                      .where((a) => a.type == AccountType.revenue)
                      .toList(),
                  onChanged: (v) => setState(() => _revenueAccountId = v),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Text('Error loading accounts: $e'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDropdown({
    required String label,
    required String? value,
    required List<Account> accounts,
    required ValueChanged<String?> onChanged,
  }) =>
      DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: accounts
            .map(
              (a) => DropdownMenuItem(
                value: a.id,
                child:
                    Text('${a.code} - ${a.name(isArabic: context.isArabic)}'),
              ),
            )
            .toList(),
        onChanged: onChanged,
      );
}
