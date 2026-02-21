// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة أو تعديل هدف مالي (PRD GOL-*)
class GoalFormScreen extends ConsumerStatefulWidget {
  /// Creates the [GoalFormScreen].
  const GoalFormScreen({super.key, this.goal});

  /// The goal to edit, or null for a new one.
  final Goal? goal;

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _targetAmountController;
  late TextEditingController _currentAmountController;
  late TextEditingController _descController;
  GoalCategory _category = GoalCategory.savings;
  DateTime _startDate = DateTime.now();
  DateTime _targetDate = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal?.name ?? '');
    _targetAmountController =
        TextEditingController(text: widget.goal?.targetAmount.toString() ?? '');
    _currentAmountController = TextEditingController(
      text: widget.goal?.currentAmount.toString() ?? '0',
    );
    _descController =
        TextEditingController(text: widget.goal?.description ?? '');
    if (widget.goal != null) {
      _category = widget.goal!.category;
      _startDate = widget.goal!.startDate;
      _targetDate = widget.goal!.targetDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final goal = Goal(
      id: widget.goal?.id ?? const Uuid().v4(),
      name: _nameController.text,
      category: _category,
      targetAmount: Decimal.parse(_targetAmountController.text),
      currentAmount: Decimal.parse(_currentAmountController.text),
      startDate: _startDate,
      targetDate: _targetDate,
      description: _descController.text.isEmpty ? null : _descController.text,
      userId: ref.read(basirUserProvider)?.id,
    );

    await ref.read(goalServiceProvider).saveGoal(goal);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.goal == null ? 'إضافة هدف مالي' : 'تعديل الهدف'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('اسم الهدف', Icons.flag_outlined),
                validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم الهدف' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                decoration:
                    _inputDecoration('المبلغ المستهدف', Icons.track_changes),
                keyboardType: TextInputType.number,
                validator: (v) => Decimal.tryParse(v ?? '') == null
                    ? 'يرجى إدخال مبلغ صحيح'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentAmountController,
                decoration: _inputDecoration(
                  'المبلغ المتوفر حالياً',
                  Icons.account_balance_wallet_outlined,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => Decimal.tryParse(v ?? '') == null
                    ? 'يرجى إدخال مبلغ صحيح'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GoalCategory>(
                initialValue: _category,
                decoration:
                    _inputDecoration('تصنيف الهدف', Icons.category_outlined),
                items: GoalCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(_getCategoryName(c)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('تاريخ الإنجاز المستهدف'),
                subtitle: Text(
                  '${_targetDate.year}-${_targetDate.month}-${_targetDate.day}',
                ),
                trailing:
                    const Icon(Icons.calendar_month, color: Color(0xFF008080)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _targetDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _targetDate = picked);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: _inputDecoration(
                  'وصف (اختياري)',
                  Icons.description_outlined,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008080),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'حفظ الهدف',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF008080)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF008080), width: 2),
        ),
      );

  String _getCategoryName(GoalCategory category) => switch (category) {
        GoalCategory.emergencyFund => 'صندوق الطوارئ',
        GoalCategory.savings => 'ادخار',
        GoalCategory.investment => 'استثمار',
        GoalCategory.bigPurchase => 'شراء كبير',
        GoalCategory.debtRepayment => 'سداد ديون',
        GoalCategory.travel => 'سفر وترفيه',
        GoalCategory.other => 'أخرى',
      };
}
