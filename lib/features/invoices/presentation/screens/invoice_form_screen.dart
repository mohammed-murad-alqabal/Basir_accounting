import 'dart:async';

import 'package:basser_app/core/extensions/context_extensions.dart'; // Added
import 'package:basser_app/core/providers.dart';
import 'package:basser_app/core/theme/services/icon_customization_service.dart';
import 'package:basser_app/core/theme/tokens/index.dart';
import 'package:basser_app/core/utils/format_helpers.dart';
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
    final appIcons = ref.watch(appIconsProvider); // Get icons
    final calendarType =
        ref.watch(calendarProvider).valueOrNull ?? CalendarType.gregorian;

    return Scaffold(
      backgroundColor: SemanticColors.background,
      appBar: AppAppBar(
        title: isEditing
            ? context.l10n.invoiceFormTitleEdit
            : context.l10n.invoiceFormTitleAdd,
      ),
      body: Form(
        key: <credential-fixture>,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اختيار العميل
              customersAsync.when(
                data: _buildCustomerSelector,
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text(
                  context.l10n.errLoadCustomers(error.toString()),
                  style: const TextStyle(color: SemanticColors.error),
                ),
              ),
              const SizedBox(height: Spacing.md),

              // تاريخ الإصدار
              _buildDateField(
                label: context.l10n.labelIssuedDate,
                date: _issuedDate,
                onTap: () => _selectDate(context, true),
                icon: appIcons.calendar, // Dynamic
                calendarType: calendarType,
              ),
              const SizedBox(height: Spacing.md),

              // تاريخ الاستحقاق
              _buildDateField(
                label: context.l10n.labelDueDate,
                date: _dueDate,
                onTap: () => _selectDate(context, false),
                icon: appIcons.calendar, // Dynamic
                calendarType: calendarType,
              ),
              const SizedBox(height: Spacing.md),

              // نسبة الضريبة
              _buildTaxRateField(appIcons), // Pass icons
              const SizedBox(height: Spacing.md),

              // حالة الفاتورة
              _buildStatusSelector(),
              const SizedBox(height: Spacing.md),

              // البنود
              _buildItemsSection(appIcons), // Pass icons
              const SizedBox(height: Spacing.md),

              // الإجماليات
              _buildTotalsSection(),
              const SizedBox(height: Spacing.md),

              // ملاحظات
              AppTextField(
                controller: _notesController,
                label: context.l10n.labelNotes,
                hint: context.l10n.hintNotes,
                prefixIcon: Icon(appIcons.note), // Dynamic
                maxLines: 3,
              ),
              const SizedBox(height: Spacing.xl),

              // زر الحفظ
              AppEnhancedButton(
                // ignore: lines_longer_than_80_chars
                text: isEditing
                    ? context.l10n.btnUpdateInvoice
                    : context.l10n.btnSaveInvoice,
                onPressed: _isLoading ? null : _saveInvoice,
                isLoading: _isLoading,
                icon: appIcons.save, // Dynamic
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSelector(List<Customer> customers) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: SemanticColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: SemanticColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.labelCustomer,
              style: const TextStyle(
                fontSize: FontSizes.bodyLarge,
                fontWeight: FontWeight.w600,
                color: SemanticColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<Customer>(
              initialValue: _selectedCustomer,
              decoration: InputDecoration(
                hintText: context.l10n.hintSelectCustomer,
                border: const OutlineInputBorder(),
              ),
              items: customers
                  .map(
                    (customer) => DropdownMenuItem(
                      value: customer,
                      child: Text(
                        customer.name,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  return context.l10n.errSelectCustomer;
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
    required IconData icon, // Added parameter
    required CalendarType calendarType,
  }) =>
      Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: SemanticColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: SemanticColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: SemanticColors.primary), // Use dynamic icon
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: FontSizes.bodyMedium,
                        color: SemanticColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatHelpers.formatDate(
                        date,
                        locale: context.l10n.localeName,
                        calendarType: calendarType,
                      ),
                      style: const TextStyle(
                        fontSize: FontSizes.bodyLarge,
                        fontWeight: FontWeight.w600,
                        color: SemanticColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTaxRateField(AppIconsData appIcons) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: SemanticColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: SemanticColors.border),
        ),
        child: Row(
          children: [
            Icon(appIcons.percent, color: SemanticColors.primary), // Dynamic
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.labelTaxRate,
                    style: const TextStyle(
                      fontSize: FontSizes.bodyMedium,
                      color: SemanticColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(_taxRate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: FontSizes.bodyLarge,
                      fontWeight: FontWeight.w600,
                      color: SemanticColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(appIcons.edit, size: 20), // Dynamic
              tooltip: context.l10n.tooltipEditTaxRate,
              onPressed: _showTaxRateDialog,
            ),
          ],
        ),
      );

  Widget _buildStatusSelector() => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: SemanticColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: SemanticColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.labelInvoiceStatus,
              style: const TextStyle(
                fontSize: FontSizes.bodyLarge,
                fontWeight: FontWeight.w600,
                color: SemanticColors.textPrimary,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(
                  value: 'draft',
                  child: Text(context.l10n.filterDraft),
                ),
                DropdownMenuItem(
                  value: 'issued',
                  child: Text(context.l10n.filterIssued),
                ),
                DropdownMenuItem(
                  value: 'paid',
                  child: Text(context.l10n.filterPaid),
                ),
                DropdownMenuItem(
                  value: 'overdue',
                  child: Text(context.l10n.filterOverdue),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text(context.l10n.statusCancelled),
                ),
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

  Widget _buildItemsSection(AppIconsData appIcons) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: SemanticColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: SemanticColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.labelInvoiceItems,
                  style: const TextStyle(
                    fontSize: FontSizes.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: SemanticColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    appIcons.addCircle, // Dynamic
                    color: SemanticColors.primary,
                  ),
                  tooltip: context.l10n.tooltipAddItem,
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            if (_items.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.lg),
                  child: Text(
                    context.l10n.msgNoItems,
                    style: const TextStyle(
                      color: SemanticColors.textSecondary,
                      fontSize: FontSizes.bodyMedium,
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
                    margin: const EdgeInsets.only(bottom: Spacing.sm),
                    child: ListTile(
                      title: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${context.l10n.labelQuantity}: ${item.quantity} × '
                        '${item.price.toStringAsFixed(2)} ر.س',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${item.total.toStringAsFixed(2)} ر.س',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: SemanticColors.primary,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              appIcons.delete, // Dynamic
                              color: SemanticColors.error,
                            ),
                            tooltip: context.l10n.tooltipDeleteItem,
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
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: SemanticColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: SemanticColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _buildTotalRow(context.l10n.labelSubtotal, subtotal),
          const Divider(),
          _buildTotalRow(
            context.l10n.labelTax('${(_taxRate * 100).toStringAsFixed(0)}%'),
            taxTotal,
          ),
          const Divider(thickness: 2),
          _buildTotalRow(
            context.l10n.labelGrandTotal,
            grandTotal,
            isGrandTotal: true,
          ),
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
        padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                // ignore: lines_longer_than_80_chars
                fontSize:
                    isGrandTotal ? FontSizes.bodyLarge : FontSizes.bodyMedium,
                fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.w500,
                color: SemanticColors.textPrimary,
              ),
            ),
            Text(
              '${amount.toStringAsFixed(2)} ر.س',
              style: TextStyle(
                // ignore: lines_longer_than_80_chars
                fontSize: isGrandTotal
                    ? FontSizes.headlineSmall
                    : FontSizes.bodyLarge,
                fontWeight: FontWeight.bold,
                // ignore: lines_longer_than_80_chars
                color: isGrandTotal
                    ? SemanticColors.primary
                    : SemanticColors.textPrimary,
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
        title: Text(context.l10n.dialogTaxTitle),
        content: TextField(
          controller: controller,
          keyboardType: <credential-fixture>,
          decoration: InputDecoration(
            labelText: context.l10n.labelPercentage,
            suffixText: '%',
          ),
        ),
        actions: [
          AppEnhancedButton(
            text: context.l10n.dialogCancel,
            onPressed: () => Navigator.pop(context),
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
          AppEnhancedButton(
            text: context.l10n.btnSave,
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
        title: Text(context.l10n.dialogAddItemTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.labelItemName,
                ),
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                controller: quantityController,
                keyboardType: <credential-fixture>,
                decoration: InputDecoration(
                  labelText: context.l10n.labelQuantity,
                ),
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                controller: priceController,
                keyboardType: <credential-fixture>,
                decoration: InputDecoration(
                  labelText: context.l10n.labelPrice,
                  suffixText: 'ر.س',
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppEnhancedButton(
            text: context.l10n.dialogCancel,
            onPressed: () => Navigator.pop(context),
            style: AppEnhancedButtonStyle.text,
            size: AppEnhancedButtonSize.small,
          ),
          AppEnhancedButton(
            text: context.l10n.btnAdd,
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
        SnackBar(
          content: Text(context.l10n.errSelectCustomer),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errNoItems),
          backgroundColor: SemanticColors.error,
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
        // ignore: lines_longer_than_80_chars
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
              // ignore: lines_longer_than_80_chars
              isEditing
                  ? context.l10n.msgInvoiceUpdated
                  : context.l10n.msgInvoiceAdded,
            ),
            backgroundColor: SemanticColors.secondary,
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
              // ignore: lines_longer_than_80_chars
              isEditing
                  ? context.l10n.errInvoiceUpdate
                  : context.l10n.errInvoiceAdd,
            ),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errGeneric(e.toString())),
          backgroundColor: SemanticColors.error,
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
