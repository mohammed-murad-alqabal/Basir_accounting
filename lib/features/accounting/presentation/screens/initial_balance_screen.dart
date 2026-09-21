// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/app_snackbar.dart';
import 'package:basir_accounting_system/shared/widgets/glass_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitialBalanceScreen extends ConsumerStatefulWidget {
  const InitialBalanceScreen({super.key});

  @override
  ConsumerState<InitialBalanceScreen> createState() => _InitialBalanceScreenState();
}

class _InitialBalanceScreenState extends ConsumerState<InitialBalanceScreen> {
  int _balanceType = 1; // 0 for "له" (credit), 1 for "عليه" (debit)
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedAccountId;

  // Mock accounts
  final List<Map<String, String>> _accounts = [
    {'id': '1', 'name': 'الصندوق الرئيسي'},
    {'id': '2', 'name': 'البنك'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveBalance() {
    if (_selectedAccountId == null || _amountController.text.isEmpty) {
      AppSnackbar.showError(context, 'الرجاء اختيار الحساب وإدخال المبلغ');
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) {
      AppSnackbar.showError(context, 'المبلغ يجب أن يكون أكبر من صفر');
      return;
    }

    AppSnackbar.showSuccess(context, 'تم حفظ الرصيد الافتتاحي بنجاح');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
    title: 'قيمة الحساب الافتتاحية',
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تاريخ العملية:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                DateTime.now().toString().substring(0, 10),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xl),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'اختر الحساب',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
            ),
            initialValue: _selectedAccountId,
            items: _accounts
                .map((acc) => DropdownMenuItem(value: acc['id'], child: Text(acc['name']!)))
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedAccountId = val;
              });
            },
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'العملة',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                  ),
                  readOnly: true,
                  controller: TextEditingController(text: 'SAR'),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                flex: 4,
                child: TextField(
                  controller: _amountController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  decoration: InputDecoration(
                    labelText: 'المبلغ',
                    hintText: '0.00',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.lg),
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: _balanceType,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _balanceType = val!),
                    ),
                    const Text('عليه (مدين)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Radio<int>(
                      value: 0,
                      groupValue: _balanceType,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _balanceType = val!),
                    ),
                    const Text('له (دائن)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'شرح القيد',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: Spacing.xxl),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
            ),
            onPressed: _saveBalance,
            child: const Text('حفظ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    ),
  );
}
