import 'dart:async';

import 'package:basser_app/core/theme.dart';
import 'package:basser_app/core/widgets/index.dart';
import 'package:basser_app/features/customers/domain/entities/customer.dart';
import 'package:basser_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basser_app/features/invoices/domain/entities/invoice.dart';
import 'package:basser_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// شاشة إضافة/تعديل فاتورة
///
/// تسمح بإضافة فاتورة جديدة أو تعديل فاتورة موجودة.
/// تتضمن اختيار العميل، إضافة بنود، وحساب الإجماليات تلقائياً.
class InvoiceFormScreen extends ConsumerStatefulWidget {
  /// إنشاء شاشة نموذج الفاتورة
  const InvoiceFormScreen({super.key, this.invoice});

  /// الفاتورة المراد تعديلها (null للإضافة)
  final Invoice? invoice;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _formKey = <credential-fixture><FormState>();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  Customer? _selectedCustomer;
  DateTime _issuedDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(
    const Duration(days: 30),
  );
  double _taxRate = 0.15; // 15% ضريبة افتراضية
  String _status = 'draft'; // مسودة افتراضياً
  List<InvoiceItem> _items = [];

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _notesController.text = widget.invoice!.notes ?? '';
      _issuedDate = widget.invoice!.issuedDate;
      _dueDate = widget.invoice!.dueDate;
      _taxRate = widget.invoice!.taxRate;
      _status = widget.invoice!.status;
      _items = List.from(
        widget.invoice!.items,
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.invoice != null;
    final customersAsync = ref.watch(
      customersProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: isEditing ? 'تعديل الفاتورة' : 'إضافة فاتورة جديدة',
      ),
      body: Form(
        key: <credential-fixture>,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اختيار العميل
              customersAsync.when(
                data: _buildCustomerSelector,
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text(
                  'خطأ في تحميل العملاء: $error',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // تاريخ الإصدار
              _buildDateField(
                label: 'تاريخ الإصدار',
                date: _issuedDate,
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: AppSpacing.md),

              // تاريخ الاستحقاق
              _buildDateField(
                label: 'تاريخ الاستحقاق',
                date: _dueDate,
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: AppSpacing.md),

              // نسبة الضريبة
              _buildTaxRateField(),
              const SizedBox(height: AppSpacing.md),

              // حالة الفاتورة
              _buildStatusSelector(),
              const SizedBox(height: AppSpacing.md),

              // البنود
              _buildItemsSection(),
              const SizedBox(height: AppSpacing.md),

              // الإجماليات
              _buildTotalsSection(),
              const SizedBox(height: AppSpacing.md),

              // ملاحظات
              AppTextField(
                controller: _notesController,
                label: 'ملاحظات (اختياري)',
                hint: 'أضف ملاحظات عن الفاتورة',
                prefixIcon: const Icon(Icons.note),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // زر الحفظ
              AppEnhancedButton(
                text: isEditing ? 'حفظ التعديلات' : 'إضافة الفاتورة',
                onPressed: _isLoading ? null : _saveInvoice,
                isLoading: _isLoading,
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSelector(List<Customer> customers) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'العميل',
              style: TextStyle(
                fontSize: AppTypography.bodyLarge,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<Customer>(
              initialValue: _selectedCustomer,
              decoration: const InputDecoration(
                hintText: 'اختر العميل',
                border: OutlineInputBorder(),
              ),
              items: customers
                  .map(
                    (customer) => DropdownMenuItem(
                      value: customer,
                      child: Text(customer.name),
                    ),
                  )
                  .toList(),
              onChanged: (customer) {
                setState(
                  () => _selectedCustomer = customer,
                );
              },
              validator: (value) {
                if (value == null) {
                  return 'يرجى اختيار العميل';
                }
                return null;
              },
            ),
          ],
        ),
      );

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) =>
      Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: AppTypography.bodyMedium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                        fontSize: AppTypography.bodyLarge,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTaxRateField() => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.percent, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نسبة الضريبة',
                    style: TextStyle(
                      fontSize: AppTypography.bodyMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(_taxRate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'تعديل نسبة الضريبة',
              onPressed: _showTaxRateDialog,
            ),
          ],
        ),
      );

  Widget _buildStatusSelector() => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حالة الفاتورة',
              style: TextStyle(
                fontSize: AppTypography.bodyLarge,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'draft', child: Text('مسودة')),
                DropdownMenuItem(value: 'issued', child: Text('مرسلة')),
                DropdownMenuItem(value: 'paid', child: Text('مدفوعة')),
                DropdownMenuItem(value: 'overdue', child: Text('متأخرة')),
                DropdownMenuItem(value: 'cancelled', child: Text('ملغاة')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(
                    () => _status = value,
                  );
                }
              },
            ),
          ],
        ),
      );

  Widget _buildItemsSection() => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'بنود الفاتورة',
                  style: TextStyle(
                    fontSize: AppTypography.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                  tooltip: 'إضافة بند جديد',
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_items.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'لا توجد بنود. اضغط + لإضافة بند',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppTypography.bodyMedium,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        'الكمية: ${item.quantity} × '
                        '${item.price.toStringAsFixed(2)} ر.س',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${item.total.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                            tooltip: 'حذف البند',
                            onPressed: () => _removeItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      );

  Widget _buildTotalsSection() {
    final subtotal = _items.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    final taxTotal = subtotal * _taxRate;
    final grandTotal = subtotal + taxTotal;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildTotalRow('المجموع الفرعي:', subtotal),
          const Divider(),
          _buildTotalRow(
            'الضريبة (${(_taxRate * 100).toStringAsFixed(0)}%):',
            taxTotal,
          ),
          const Divider(thickness: 2),
          _buildTotalRow('الإجمالي الكلي:', grandTotal, isGrandTotal: true),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount, {
    bool isGrandTotal = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isGrandTotal
                    ? AppTypography.bodyLarge
                    : AppTypography.bodyMedium,
                fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${amount.toStringAsFixed(2)} ر.س',
              style: TextStyle(
                fontSize: isGrandTotal
                    ? AppTypography.headlineSmall
                    : AppTypography.bodyLarge,
                fontWeight: FontWeight.bold,
                color: isGrandTotal ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );

  Future<void> _selectDate(BuildContext context, bool isIssuedDate) async {
    final initialDate = isIssuedDate ? _issuedDate : _dueDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isIssuedDate) {
          _issuedDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  Future<void> _showTaxRateDialog() async {
    final controller = TextEditingController(
      text: (_taxRate * 100).toStringAsFixed(0),
    );

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نسبة الضريبة'),
        content: TextField(
          controller: controller,
          keyboardType: <credential-fixture>,
          decoration: const InputDecoration(
            labelText: 'النسبة المئوية',
            suffixText: '%',
          ),
        ),
        actions: [
          AppEnhancedButton(
            text: 'إلغاء',
            onPressed: () => Navigator.pop(context),
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
          AppEnhancedButton(
            text: 'حفظ',
            onPressed: () {
              final value = double.tryParse(
                controller.text,
              );
              if (value != null && value >= 0 && value <= 100) {
                setState(
                  () => _taxRate = value / 100,
                );
                Navigator.pop(
                  context,
                );
              }
            },
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
        ],
      ),
    );

    controller.dispose();
  }

  Future<void> _addItem() async {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(
      text: '1',
    );
    final priceController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة بند'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المنتج/الخدمة',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: quantityController,
                keyboardType: <credential-fixture>,
                decoration: const InputDecoration(labelText: 'الكمية'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: priceController,
                keyboardType: <credential-fixture>,
                decoration: const InputDecoration(
                  labelText: 'السعر',
                  suffixText: 'ر.س',
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppEnhancedButton(
            text: 'إلغاء',
            onPressed: () => Navigator.pop(context),
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
          AppEnhancedButton(
            text: 'إضافة',
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = double.tryParse(
                quantityController.text,
              );
              final price = double.tryParse(
                priceController.text,
              );

              if (name.isNotEmpty && quantity != null && price != null) {
                setState(() {
                  _items.add(
                    InvoiceItem(
                      id: const Uuid().v4(),
                      name: name,
                      quantity: quantity,
                      price: price,
                    ),
                  );
                });
                Navigator.pop(
                  context,
                );
              }
            },
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
        ],
      ),
    );

    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(
        index,
      );
    });
  }

  void _saveInvoice() {
    unawaited(
      _saveInvoiceAsync(),
    );
  }

  Future<void> _saveInvoiceAsync() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار العميل'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إضافة بند واحد على الأقل'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(
      () => _isLoading = true,
    );

    try {
      final invoice = Invoice(
        id: widget.invoice?.id ?? const Uuid().v4(),
        customerId: _selectedCustomer!.id,
        customerName: _selectedCustomer!.name,
        items: _items,
        issuedDate: _issuedDate,
        dueDate: _dueDate,
        taxRate: _taxRate,
        status: _status,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.invoice?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final isEditing = widget.invoice != null;
      final result = isEditing
          ? await ref.read(updateInvoiceProvider(invoice).future)
          : await ref.read(
              addInvoiceProvider(invoice).future,
            );

      if (!mounted) return;

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'تم تحديث الفاتورة بنجاح' : 'تم إضافة الفاتورة بنجاح',
            ),
            backgroundColor: AppColors.secondary,
          ),
        );
        Navigator.pop(
          context,
          true,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'فشل تحديث الفاتورة' : 'فشل إضافة الفاتورة',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(
          () => _isLoading = false,
        );
      }
    }
  }
}
