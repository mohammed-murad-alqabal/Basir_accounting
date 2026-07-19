// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/inventory/application/barcode_service.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// شاشة إنشاء الباركود (FORENSIC 024)
class BarcodeCreationScreen extends ConsumerStatefulWidget {
  /// Creates the [BarcodeCreationScreen].
  const BarcodeCreationScreen({super.key});

  @override
  ConsumerState<BarcodeCreationScreen> createState() =>
      _BarcodeCreationScreenState();
}

class _BarcodeCreationScreenState extends ConsumerState<BarcodeCreationScreen> {
  InventoryItem? _selectedItem;
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  final _countController = TextEditingController(text: '10');
  bool _isLoading = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    _priceController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _generateRandom() {
    final service = ref.read(barcodeServiceProvider.notifier);
    setState(() {
      _barcodeController.text = service.generateRandomBarcode();
    });
  }

  Future<void> _handlePrint() async {
    if (_selectedItem == null) return;

    final count = int.tryParse(_countController.text) ?? 10;
    setState(() => _isLoading = true);
    try {
      final service = ref.read(barcodeServiceProvider.notifier);
      await service.printLabels(
        item: _selectedItem!,
        count: count,
      );
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الطباعة: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSave() async {
    if (_selectedItem == null || _barcodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار صنف وإدخال الباركود')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      final updatedItem = _selectedItem!.copyWith(
        barcode: _barcodeController.text,
      );
      await repo.updateItem(updatedItem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الباركود بنجاح')),
        );
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('محرك إنشاء الباركود'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.print_outlined,
                size: 80,
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
              const SizedBox(height: Spacing.lg),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    children: [
                      _buildItemPicker(theme),
                      const SizedBox(height: Spacing.md),
                      TextField(
                        controller: _priceController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'السعر الحالي',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _barcodeController,
                              decoration: InputDecoration(
                                labelText: 'رقم الباركود',
                                prefixIcon: const Icon(Icons.qr_code_scanner),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: _generateRandom,
                                  tooltip: 'توليد عشوائي',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: TextField(
                              controller: _countController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'العدد',
                                hintText: 'الكمية',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xl),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Spacing.sm),
                                ),
                              ),
                              child: _isLoading &&
                                      _barcodeController.text.isNotEmpty
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('حفظ'),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _selectedItem == null || _isLoading
                                  ? null
                                  : _handlePrint,
                              icon: const Icon(Icons.print_outlined),
                              label: const Text('طباعة'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Spacing.sm),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء والعودة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemPicker(ThemeData theme) =>
      FutureBuilder<List<InventoryItem>>(
        future: ref.read(inventoryRepositoryProvider).getAllItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();

          return DropdownButtonFormField<InventoryItem>(
            initialValue: _selectedItem,
            decoration: const InputDecoration(
              labelText: 'اختر الصنف',
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
            items: snapshot.data!
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.nameAr),
                  ),
                )
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedItem = val;
                _priceController.text = val?.salePrice?.toString() ?? '0.0';
                _barcodeController.text = val?.barcode ?? '';
              });
            },
          );
        },
      );
}
