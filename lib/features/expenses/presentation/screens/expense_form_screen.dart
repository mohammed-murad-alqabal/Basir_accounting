// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/expenses/presentation/providers/expense_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
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
    final l10n = context.isArabic;

    return GlassScaffold(
      title: _isEditing
          ? (l10n ? 'تعديل المصروف' : 'Edit Expense')
          : (l10n ? 'إضافة مصروف' : 'Add Expense'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            AppTextField(
              controller: _descriptionController,
              label: l10n ? 'الوصف' : 'Description',
              prefixIcon: const Icon(Icons.description),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n ? 'مطلوب' : 'Required';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _amountController,
              label: l10n ? 'المبلغ' : 'Amount',
              prefixIcon: const Icon(Icons.attach_money),
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.md),
                child: Center(
                  widthFactor: 1,
                  child: Text(_currencyCode),
                ),
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
            const SizedBox(height: Spacing.md),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(l10n ? 'التاريخ' : 'Date'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: Spacing.md),
            categories.when(
              data: (cats) => DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: l10n ? 'الفئة' : 'Category',
                  prefixIcon: const Icon(Icons.category),
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
                                color: _getCategoryColor(cat.color).withValues(
                                  alpha: 0.2,
                                ),
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
              loading: () => const Center(child: AppLoadingIndicator()),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.invalidate(expenseCategoriesProvider),
              ),
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _vendorController,
              label: l10n ? 'المورد (اختياري)' : 'Vendor (optional)',
              prefixIcon: const Icon(Icons.business),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _notesController,
              label: l10n ? 'ملاحظات (اختياري)' : 'Notes (optional)',
              prefixIcon: const Icon(Icons.notes),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: Spacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: AppEnhancedButton(
          label: _isEditing
              ? (l10n ? 'حفظ التغييرات' : 'Save Changes')
              : (l10n ? 'إضافة المصروف' : 'Add Expense'),
          icon: _isEditing ? Icons.save : Icons.add,
          isLoading: _isLoading,
          onPressed: _isLoading ? null : _submit,
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
        AppSnackbar.showSuccess(
          context,
          context.isArabic
              ? 'تم حفظ المصروف بنجاح'
              : 'Expense saved successfully',
        );
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          context.isArabic
              ? 'تعذر حفظ المصروف: $e'
              : 'Failed to save expense: $e',
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
