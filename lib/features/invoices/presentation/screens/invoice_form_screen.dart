import 'dart:async';

import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/core/utils/format_helpers.dart';
import 'package:basir_app/features/customers/domain/entities/customer.dart';
import 'package:basir_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice.dart';
import 'package:basir_app/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_app/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basir_app/shared/widgets/index.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  Customer? _selectedCustomer;
  DateTime _issuedDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(
    const Duration(days: 30),
  );
  double _taxRate = 0.15; // 15% ضريبة افتراضية
  InvoiceStatus _status = InvoiceStatus.draft; // مسودة افتراضياً
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
      // Ensure selected customer logic if needed, but here we just need to
      // bind if we had full list.
      // Since we load customers async, we might not set _selectedCustomer
      // immediately unless we fetch it.
      // For simplicity, we assume the user re-selects or we'd need to fetch
      // the customer by ID.
      // However, the original code didn't pre-populate _selectedCustomer for
      // editing correctly unless the list is loaded.
      // We will leave that logic as is, focusing on type fixes.
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
    final appIcons = ref.watch(appIconsProvider);
    final calendarType =
        ref.watch(calendarProvider).valueOrNull ?? CalendarType.gregorian;

    // Correctly set selected customer if editing and customers are loaded
    if (widget.invoice != null &&
        _selectedCustomer == null &&
        customersAsync.hasValue) {
      try {
        _selectedCustomer = customersAsync.value!
            .firstWhere((c) => c.id == widget.invoice!.customerId);
      } on Object catch (_) {}
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: isEditing
            ? context.l10n.invoiceFormTitleEdit
            : context.l10n.invoiceFormTitleAdd,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: customersAsync.when(
                  data: _buildCustomerSelector,
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Text(
                    context.l10n.errLoadCustomers(
                      error.toString(),
                    ),
                    style: const TextStyle(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              AppCard(
                child: _buildDateField(
                  label: context.l10n.labelIssuedDate,
                  date: _issuedDate,
                  onTap: () => _selectDate(context, true),
                  icon: appIcons.calendar,
                  calendarType: calendarType,
                ),
              ),
              const SizedBox(height: Spacing.md),
              AppCard(
                child: _buildDateField(
                  label: context.l10n.labelDueDate,
                  date: _dueDate,
                  onTap: () => _selectDate(context, false),
                  icon: appIcons.calendar,
                  calendarType: calendarType,
                ),
              ),
              const SizedBox(height: Spacing.md),
              AppCard(
                child: _buildTaxRateField(appIcons),
              ),
              const SizedBox(height: Spacing.md),
              AppCard(
                child: _buildStatusSelector(),
              ),
              const SizedBox(height: Spacing.md),
              _buildItemsSection(appIcons),
              const SizedBox(height: Spacing.md),
              _buildTotalsSection(),
              const SizedBox(height: Spacing.md),
              AppTextField(
                controller: _notesController,
                label: context.l10n.labelNotes,
                hint: context.l10n.hintNotes,
                prefixIcon: Icon(appIcons.note),
                maxLines: 3,
              ),
              const SizedBox(height: Spacing.xl),
              AppButton(
                label: isEditing
                    ? context.l10n.btnUpdateInvoice
                    : context.l10n.btnSaveInvoice,
                onPressed: _isLoading ? null : _saveInvoice,
                isLoading: _isLoading,
                icon: appIcons.save,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSelector(List<Customer> customers) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.labelCustomer,
            style: const TextStyle(
              fontSize: AppTypography.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
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
                      customer.nameAr,
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
      );

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
    required IconData icon,
    required CalendarType calendarType,
  }) =>
      InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: Spacing.md),
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
                    FormatHelpers.formatDate(
                      date,
                      locale: context.l10n.localeName,
                      calendarType: calendarType,
                    ),
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
      );

  Widget _buildTaxRateField(AppIcons appIcons) => Row(
        children: [
          Icon(appIcons.percent, color: AppColors.primary),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.labelTaxRate,
                  style: const TextStyle(
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
            icon: Icon(appIcons.edit, size: 20),
            tooltip: context.l10n.tooltipEditTaxRate,
            onPressed: _showTaxRateDialog,
          ),
        ],
      );

  Widget _buildStatusSelector() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.labelInvoiceStatus,
            style: const TextStyle(
              fontSize: AppTypography.bodyLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          DropdownButtonFormField<InvoiceStatus>(
            initialValue: _status,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              DropdownMenuItem(
                value: InvoiceStatus.draft,
                child: Text(context.l10n.filterDraft),
              ),
              DropdownMenuItem(
                value: InvoiceStatus.sent,
                child: Text(context.l10n.filterIssued),
              ),
              DropdownMenuItem(
                value: InvoiceStatus.paid,
                child: Text(context.l10n.filterPaid),
              ),
              DropdownMenuItem(
                value: InvoiceStatus.overdue,
                child: Text(context.l10n.filterOverdue),
              ),
              DropdownMenuItem(
                value: InvoiceStatus.cancelled,
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
      );

  Widget _buildItemsSection(AppIcons appIcons) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.labelInvoiceItems,
                  style: const TextStyle(
                    fontSize: AppTypography.bodyLarge,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    appIcons.addCircle,
                    color: AppColors.primary,
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
                  final priceStr = FormatHelpers.formatCurrency(
                    item.price,
                    locale: context.l10n.localeName,
                  );
                  final totalStr = FormatHelpers.formatCurrency(
                    item.total,
                    locale: context.l10n.localeName,
                  );
                  final itemSemantics = '${item.name}, '
                      '${context.l10n.labelQuantity}: '
                      '${item.quantity}, '
                      '${context.l10n.labelPrice}: $priceStr, '
                      '${context.l10n.labelTotal}: $totalStr';

                  return Semantics(
                    label: itemSemantics,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: Spacing.sm),
                      child: ListTile(
                        title: Text(
                          item.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${context.l10n.labelQuantity}: ${item.quantity} × '
                          '$priceStr',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              totalStr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                appIcons.delete,
                                color: AppColors.error,
                              ),
                              tooltip: context.l10n.tooltipDeleteItem,
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
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
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          _buildTotalRow(context.l10n.labelSubtotal, subtotal),
          const Divider(),
          _buildTotalRow(
            context.l10n.labelTax(
              '${(_taxRate * 100).toStringAsFixed(0)}%',
            ),
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
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.xs,
        ),
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
              FormatHelpers.formatCurrency(
                amount,
                locale: context.l10n.localeName,
              ),
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
        title: Text(context.l10n.dialogTaxTitle),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: context.l10n.labelPercentage,
            suffixText: '%',
          ),
        ),
        actions: [
          AppButton(
            label: context.l10n.dialogCancel,
            onPressed: () => Navigator.pop(context),
            type: AppButtonType.text,
            size: AppButtonSize.small,
          ),
          AppButton(
            label: context.l10n.btnSave,
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value >= 0 && value <= 100) {
                setState(() => _taxRate = value / 100);
                Navigator.pop(context);
              }
            },
            type: AppButtonType.text,
            size: AppButtonSize.small,
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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.labelQuantity,
                ),
              ),
              const SizedBox(height: Spacing.md),
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.labelPrice,
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            label: context.l10n.dialogCancel,
            onPressed: () => Navigator.pop(context),
            type: AppButtonType.text,
            size: AppButtonSize.small,
          ),
          AppButton(
            label: context.l10n.btnAdd,
            onPressed: () {
              final name = nameController.text.trim();
              final quantity = double.tryParse(quantityController.text);
              final price = double.tryParse(priceController.text);

              if (name.isNotEmpty && quantity != null && price != null) {
                final total = quantity * price;
                setState(() {
                  _items.add(
                    InvoiceItem(
                      id: const Uuid().v4(),
                      name: name,
                      quantity: quantity,
                      price: price,
                      total: total,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            type: AppButtonType.text,
            size: AppButtonSize.small,
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
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errNoItems),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(
      () => _isLoading = true,
    );

    try {
      final subtotal = _items.fold<double>(
        0,
        (sum, item) => sum + item.total,
      );
      final taxTotal = subtotal * _taxRate;
      final grandTotal = subtotal + taxTotal;
      final isNew = widget.invoice == null;
      final invoiceId = isNew ? const Uuid().v4() : widget.invoice!.id;
      final invoiceNumber = isNew
          ? 'INV-${DateTime.now().millisecondsSinceEpoch}'
          : widget.invoice!.invoiceNumber;

      final invoice = Invoice(
        id: invoiceId,
        invoiceNumber: invoiceNumber,
        customerId: _selectedCustomer!.id,
        customerName: _selectedCustomer!.nameAr,
        items: _items,
        issuedDate: _issuedDate,
        dueDate: _dueDate,
        taxRate: _taxRate,
        status: _status,
        subtotalAmount: subtotal,
        taxAmount: taxTotal,
        totalAmount: grandTotal,
        paidAmount: isNew ? 0.0 : widget.invoice!.paidAmount,
        discountAmount: 0,
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
              isEditing
                  ? context.l10n.msgInvoiceUpdated
                  : context.l10n.msgInvoiceAdded,
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
              isEditing
                  ? context.l10n.errInvoiceUpdate
                  : context.l10n.errInvoiceAdd,
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errGeneric(e.toString())),
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
