// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/expenses/presentation/providers/expense_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Expense Form Screen for creating/editing expenses.
///
/// Following FORENSIC_ATLAS specifications for expense entry.
class ExpenseFormScreen extends ConsumerStatefulWidget {
  /// Creates the [ExpenseFormScreen].
  const ExpenseFormScreen({super.key, this.expenseId});

  /// The ID of the expense to edit.
  final String? expenseId;

  /// The route name for navigation.
  static const routeName = '/expenses/add';

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategoryId = 'cat_other';
  final String _currencyCode = 'SAR';
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.expenseId != null) {
      _isEditing = true;
      // ignore: discarded_futures
      _loadExpense();
    }
  }

  Future<void> _loadExpense() async {
    // TODO(basir): Load expense for editing.
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(expenseCategoriesProvider);
    final l10n = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? (l10n ? 'تعديل المصروف' : 'Edit Expense')
              : (l10n ? 'إضافة مصروف' : 'Add Expense'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n ? 'الوصف' : 'Description',
                prefixIcon: const Icon(Icons.description),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n ? 'مطلوب' : 'Required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n ? 'المبلغ' : 'Amount',
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: _currencyCode,
                border: const OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n ? 'مطلوب' : 'Required';
                }
                if (double.tryParse(value) == null) {
                  return l10n ? 'رقم غير صالح' : 'Invalid number';
                }
                if (double.parse(value) <= 0) {
                  return l10n
                      ? 'يجب أن يكون أكبر من صفر'
                      : 'Must be greater than 0';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Date Picker
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n ? 'التاريخ' : 'Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            categories.when(
              data: (cats) => DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: l10n ? 'الفئة' : 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: const OutlineInputBorder(),
                ),
                items: cats
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _getCategoryColor(cat.color)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                _getCategoryIcon(cat.icon),
                                size: 14,
                                color: _getCategoryColor(cat.color),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(l10n ? cat.nameAr : cat.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategoryId = value);
                  }
                },
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 16),

            // Vendor
            TextFormField(
              controller: _vendorController,
              decoration: InputDecoration(
                labelText: l10n ? 'المورد (اختياري)' : 'Vendor (optional)',
                prefixIcon: const Icon(Icons.business),
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n ? 'ملاحظات (اختياري)' : 'Notes (optional)',
                prefixIcon: const Icon(Icons.notes),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(
                  _isEditing
                      ? (l10n ? 'حفظ التغييرات' : 'Save Changes')
                      : (l10n ? 'إضافة المصروف' : 'Add Expense'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(expensesNotifierProvider.notifier).addExpense(
            description: _descriptionController.text,
            amount: Decimal.parse(_amountController.text),
            currencyCode: _currencyCode,
            expenseDate: _selectedDate,
            categoryId: _selectedCategoryId,
            vendorName:
                _vendorController.text.isEmpty ? null : _vendorController.text,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'تم إضافة المصروف بنجاح'
                  : 'Expense added successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getCategoryColor(String? colorHex) {
    if (colorHex == null) return Colors.grey;
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } on FormatException {
      return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? iconName) {
    switch (iconName) {
      case 'electric_bolt':
        return Icons.electric_bolt;
      case 'home':
        return Icons.home;
      case 'people':
        return Icons.people;
      case 'inventory':
        return Icons.inventory;
      case 'flight':
        return Icons.flight;
      case 'campaign':
        return Icons.campaign;
      case 'build':
        return Icons.build;
      default:
        return Icons.more_horiz;
    }
  }
}
