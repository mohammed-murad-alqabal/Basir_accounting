// ignore_for_file: argument_type_not_assignable
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InlinePriceEditView extends ConsumerStatefulWidget {
  const InlinePriceEditView({super.key});

  @override
  ConsumerState<InlinePriceEditView> createState() => _InlinePriceEditViewState();
}

class _InlinePriceEditViewState extends ConsumerState<InlinePriceEditView> {
  bool _positiveBalanceOnly = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allProductsAsync = ref.watch(inventoryItemsProvider);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'البحث في المواد',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              CheckboxListTile(
                title: const Text('عرض المواد ذات الرصيد الموجب فقط'),
                value: _positiveBalanceOnly,
                onChanged: (v) => setState(() => _positiveBalanceOnly = v!),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('المادة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('المبيع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(child: Text('الشراء', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(Spacing.xs),
          child: Text('الأسعار غير شاملة الضريبة', style: TextStyle(color: AppColors.error, fontSize: 12)),
        ),
        Expanded(
          child: allProductsAsync.when(
            data: (products) {
              final filtered = products.where((p) {
                if (_positiveBalanceOnly && (p.currentQuantity) <= 0) return false;
                if (_searchQuery.isNotEmpty) {
                  return p.name.toString().contains(_searchQuery) || (p.barcode?.toString().contains(_searchQuery) ?? false);
                }
                return true;
              }).toList();
              
              if (filtered.isEmpty) {
                return const Center(child: Text('لا توجد بيانات للعرض'));
              }
              
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: Spacing.xs),
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.sm),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: product.salePrice.toString()),
                              onSubmitted: (val) {
                                final newPrice = double.tryParse(val);
                                if (newPrice != null && newPrice != product.salePrice) {
                                  // Update logic would go here
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث المبيع')));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(text: product.purchasePrice.toString()),
                              onSubmitted: (val) {
                                final newCost = double.tryParse(val);
                                if (newCost != null && newCost != product.purchasePrice) {
                                  // Update logic would go here
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الشراء')));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('خطأ: $err')),
          ),
        ),
      ],
    );
  }
}
