// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget.dart';
import 'package:basir_accounting_system/features/budget/domain/entities/budget_category.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة أو تعديل ميزانية (PRD BUD-*)
class BudgetFormScreen extends ConsumerStatefulWidget {
  /// Creates the [BudgetFormScreen].
  const BudgetFormScreen({super.key, this.budget});

  /// The budget to edit, or null to create a new one.
  final Budget? budget;

  @override
  ConsumerState<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends ConsumerState<BudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _limitController;
  BudgetCategory _category = BudgetCategory.other;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _isRollover = false;
  double _alertThreshold = 0.8;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.budget?.name ?? '');
    _limitController = TextEditingController(
      text: widget.budget?.limitAmount.toString() ?? '',
    );
    if (widget.budget != null) {
      _category = widget.budget!.category;
      _startDate = widget.budget!.startDate;
      _endDate = widget.budget!.endDate;
      _isRollover = widget.budget!.isRollover;
      _alertThreshold = widget.budget!.alertThreshold;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final budget = Budget(
      id: widget.budget?.id ?? const Uuid().v4(),
      name: _nameController.text,
      category: _category,
      limitAmount: Decimal.parse(_limitController.text),
      spentAmount: widget.budget?.spentAmount ?? Decimal.zero,
      startDate: _startDate,
      endDate: _endDate,
      alertThreshold: _alertThreshold,
      isRollover: _isRollover,
      userId: ref.read(basirUserProvider)?.id,
    );

    await ref.read(budgetServiceProvider).createOrUpdateBudget(budget);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title:
              Text(widget.budget == null ? 'إضافة ميزانية' : 'تعديل ميزانية'),
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
                decoration:
                    _inputDecoration('اسم الميزانية', Icons.label_outline),
                validator: (v) => v!.isEmpty ? 'يرجى إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _limitController,
                decoration: _inputDecoration(
                  'المبلغ المستهدف',
                  Icons.account_balance_wallet_outlined,
                ),
                keyboardType: TextInputType.number,
                validator: (v) => Decimal.tryParse(v ?? '') == null
                    ? 'يرجى إدخال مبلغ صحيح'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<BudgetCategory>(
                initialValue: _category,
                decoration:
                    _inputDecoration('التصنيف', Icons.category_outlined),
                items: BudgetCategory.values
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
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('تبدأ من'),
                      subtitle: Text(
                        '${_startDate.year}-${_startDate.month}-${_startDate.day}',
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _startDate = picked);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('تنتهي في'),
                      subtitle: Text(
                        '${_endDate.year}-${_endDate.month}-${_endDate.day}',
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _endDate = picked);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('ترحيل الفائض (Rollover)'),
                subtitle: const Text('نقل المبالغ غير المستخدمة للشهر التالي'),
                value: _isRollover,
                activeThumbColor: const Color(0xFF008080),
                onChanged: (v) => setState(() => _isRollover = v),
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
                  'حفظ الميزانية',
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

  String _getCategoryName(BudgetCategory category) {
    switch (category) {
      case BudgetCategory.food:
        return 'طعام وشراب';
      case BudgetCategory.transportation:
        return 'مواصلات';
      case BudgetCategory.housing:
        return 'سكن';
      case BudgetCategory.utilities:
        return 'خدمات';
      case BudgetCategory.savings:
        return 'ادخار';
      case BudgetCategory.health:
        return 'صحة';
      case BudgetCategory.insurance:
        return 'تأمين';
      case BudgetCategory.personal:
        return 'شخصي';
      case BudgetCategory.entertainment:
        return 'ترفيه';
      case BudgetCategory.education:
        return 'تعليم';
      case BudgetCategory.debt:
        return 'ديون';
      case BudgetCategory.other:
        return 'أخرى';
    }
  }
}
