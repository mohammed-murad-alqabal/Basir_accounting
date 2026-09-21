// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';

class SearchVoucherDialog extends StatefulWidget {
  const SearchVoucherDialog({super.key});

  @override
  State<SearchVoucherDialog> createState() => _SearchVoucherDialogState();
}

enum VoucherType {
  receipt,
  payment,
  expense,
  revenue,
  debtToUs,
  debtToHim,
  creditEntry,
  debitEntry,
}

class _SearchVoucherDialogState extends State<SearchVoucherDialog> {
  VoucherType _selectedType = VoucherType.receipt;
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Center(
      child: Text(
        'البحث في رقم القيد',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _numberController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'رقم القيد',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Radii.sm)),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildRadio(VoucherType.receipt, 'المقبوضات'),
                    _buildRadio(VoucherType.payment, 'المدفوعات'),
                    _buildRadio(VoucherType.expense, 'المصاريف'),
                    _buildRadio(VoucherType.revenue, 'إيرادات'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildRadio(VoucherType.debtToUs, 'دين لنا'),
                    _buildRadio(VoucherType.debtToHim, 'دين له'),
                    _buildRadio(VoucherType.creditEntry, 'قيد دائن'),
                    _buildRadio(VoucherType.debitEntry, 'قيد مدين'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
        ),
        onPressed: () {
          Navigator.pop(context);
          AppSnackbar.showInfo(context, 'البحث قيد التطوير');
        },
        child: const Text('بحث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    ],
  );

  Widget _buildRadio(VoucherType type, String title) => RadioListTile<VoucherType>(
    title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    value: type,
    groupValue: _selectedType,
    activeColor: AppColors.primary,
    onChanged: (val) => setState(() => _selectedType = val!),
    contentPadding: EdgeInsets.zero,
    dense: true,
  );
}
