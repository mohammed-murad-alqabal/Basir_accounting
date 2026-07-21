// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal.dart';
import 'package:basir_accounting_system/features/goals/domain/entities/goal_category.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
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

    try {
      await ref.read(goalServiceProvider).saveGoal(goal);
      if (mounted) {
        AppSnackbar.showSuccess(context, 'تم حفظ الهدف بنجاح');
        Navigator.pop(context);
      }
    } on Exception {
      if (mounted) {
        AppSnackbar.showError(context, 'حدث خطأ أثناء حفظ الهدف');
      }
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: widget.goal == null ? 'إضافة هدف مالي' : 'تعديل الهدف',
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              AppTextField(
                controller: _nameController,
                label: 'اسم الهدف',
                prefixIcon: const Icon(Icons.flag_outlined),
                validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم الهدف' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _targetAmountController,
                label: 'المبلغ المستهدف',
                prefixIcon: const Icon(Icons.track_changes),
                keyboardType: TextInputType.number,
                validator: (v) => Decimal.tryParse(v ?? '') == null
                    ? 'يرجى إدخال مبلغ صحيح'
                    : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _currentAmountController,
                label: 'المبلغ المتوفر حالياً',
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
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
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('تاريخ الإنجاز المستهدف'),
                  subtitle: Text(
                    '${_targetDate.year}-${_targetDate.month}-${_targetDate.day}',
                  ),
                  trailing: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _targetDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => _targetDate = picked);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descController,
                label: 'وصف (اختياري)',
                prefixIcon: const Icon(Icons.description_outlined),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              AppEnhancedButton(
                onPressed: _save,
                label: 'حفظ الهدف',
              ),
            ],
          ),
        ),
      );

  InputDecoration _inputDecoration(String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
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
