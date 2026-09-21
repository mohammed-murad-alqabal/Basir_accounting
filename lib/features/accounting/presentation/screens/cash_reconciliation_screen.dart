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

class CashReconciliationScreen extends ConsumerStatefulWidget {
  const CashReconciliationScreen({super.key});

  @override
  ConsumerState<CashReconciliationScreen> createState() => _CashReconciliationScreenState();
}

class _CashReconciliationScreenState extends ConsumerState<CashReconciliationScreen> {
  final TextEditingController _actualAmountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Mock current system balance
  final double currentBalance = 1000;
  double _difference = -1000;

  @override
  void initState() {
    super.initState();
    _actualAmountController.addListener(_calculateDifference);
  }

  void _calculateDifference() {
    final actual = double.tryParse(_actualAmountController.text) ?? 0.0;
    setState(() {
      _difference = actual - currentBalance;
    });
  }

  @override
  void dispose() {
    _actualAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_actualAmountController.text.isEmpty) {
      AppSnackbar.showError(context, 'الرجاء إدخال المبلغ الفعلي');
      return;
    }

    AppSnackbar.showSuccess(context, 'تم إضافة قيد التسوية بنجاح');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
    title: 'تسوية الصندوق (جرد)',
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.adjust, color: AppColors.primary, size: 64),
          const SizedBox(height: Spacing.md),
          Text(
            'سيتم وضع الفرق في حساب\nتسوية الصندوق الرئيسي',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: AppTextStyles.titleMediumSize,
            ),
          ),
          const SizedBox(height: Spacing.xl),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'رصيد النظام الحالي:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$currentBalance',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const Divider(height: Spacing.xl),
                  Text(
                    'أدخل قيمة الصندوق الحقيقية الفعّلية',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: Spacing.sm),
                  TextField(
                    controller: _actualAmountController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
                      contentPadding: const EdgeInsets.symmetric(vertical: Spacing.md),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الفرق (العجز أو الزيادة):',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _difference > 0
                            ? '+${_difference.toStringAsFixed(2)}'
                            : _difference.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _difference == 0
                              ? AppColors.success
                              : (_difference > 0 ? AppColors.info : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'ملاحظات (اختياري)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: Spacing.xl),
          Text(
            'لتعديل القيمة لاحقاً، يمكنكم عمل كشف حساب لحساب تسوية الصندوق الرئيسي',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: Spacing.xl),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
            ),
            onPressed: _submit,
            child: Text(
              'اعتماد التسوية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
