// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/core/utils/format_helpers.dart';
import 'package:basir_accounting_system/features/accounting/domain/exceptions/cognitive_exceptions.dart';
import 'package:basir_accounting_system/features/auth/domain/models/auth_models.dart';
import 'package:basir_accounting_system/features/auth/presentation/widgets/permission_guard.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/features/inventory/domain/entities/inventory_item.dart';
import 'package:basir_accounting_system/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_status.dart';
import 'package:basir_accounting_system/features/invoices/domain/entities/invoice_type.dart';
import 'package:basir_accounting_system/features/invoices/presentation/providers/invoice_provider.dart';
import 'package:basir_accounting_system/features/onboarding/presentation/widgets/cognitive_overlay.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// ***
/// Cognitive Foundation: InvoiceFormScreen
///
/// Orchestration interface for creating and modifying institutional invoices.
/// Manages customer selection, high-precision line item composition,
/// and automated totalization.
///
/// Uses [Decimal] for all financial calculations to ensure IFRS 18 compliance.
/// ***
class InvoiceFormScreen extends ConsumerStatefulWidget {
  /// Creates an invoice form screen with an optional existing invoice to edit.
  const InvoiceFormScreen({super.key, this.invoice, this.type});

  /// The invoice to edit; if null, a new invoice will be created.
  final Invoice? invoice;

  /// The type of invoice to create (used when [invoice] is null).
  final InvoiceType? type;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  Customer? _selectedCustomer;
  DateTime _issuedDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));
  Decimal _taxRate = Decimal.parse('0.15');
  InvoiceStatus _status = InvoiceStatus.draft;
  InvoiceType _type = InvoiceType.sales;
  List<InvoiceItem> _items = [];
  String _currency = 'SAR';
  late TextEditingController _exchangeRateController;

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _notesController.text = widget.invoice!.notes ?? '';
      _issuedDate = widget.invoice!.issuedDate;
      _dueDate = widget.invoice!.dueDate;
      _taxRate = widget.invoice!.taxRate;
      _status = widget.invoice!.status;
      _type = widget.invoice!.type;
      _items = List.from(widget.invoice!.items);
      _currency = widget.invoice!.currency;
      _exchangeRateController = TextEditingController(
        text: widget.invoice!.exchangeRate.toString(),
      );
    } else {
      if (widget.type != null) {
        _type = widget.type!;
      }
      _exchangeRateController = TextEditingController(text: '1.0');
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _exchangeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.invoice != null;
    final customersAsync = ref.watch(customersProvider);
    final appIcons = ref.watch(appIconsProvider);
    final calendarType =
        ref.watch(calendarProvider).value ?? CalendarType.gregorian;

    if (widget.invoice != null &&
        _selectedCustomer == null &&
        customersAsync.hasValue) {
      try {
        _selectedCustomer = customersAsync.value!.firstWhere(
          (c) => c.id == widget.invoice!.customerId,
        );
      } on Object catch (_) {}
    }

    // Trigger Cognitive Hint on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isEditing && _items.isEmpty) {
        showCognitiveHint(
          context,
          context.l10n.msgInvoiceCognitiveHint,
          title: context.l10n.titleInvoiceCognitiveHint,
        );
      }
    });

    return GlassScaffold(
      title: _getLocalizedTitle(context, isEditing),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassCard(
                child: customersAsync.when(
                  data: _buildCustomerSelector,
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Text(
                    context.l10n.errLoadCustomers(error.toString()),
                    style: const TextStyle(color: AppColors.error),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              GlassCard(
                child: _buildDateField(
                  label: context.l10n.labelIssuedDate,
                  date: _issuedDate,
                  onTap: () => _selectDate(context, true),
                  icon: appIcons.calendar,
                  calendarType: calendarType,
                ),
              ),
              const SizedBox(height: Spacing.md),
              GlassCard(
                child: _buildDateField(
                  label: context.l10n.labelDueDate,
                  date: _dueDate,
                  onTap: () => _selectDate(context, false),
                  icon: appIcons.calendar,
                  calendarType: calendarType,
                ),
              ),
              const SizedBox(height: Spacing.md),
              GlassCard(child: _buildTaxRateField(appIcons)),
              const SizedBox(height: Spacing.md),
              GlassCard(child: _buildStatusSelector()),
              const SizedBox(height: Spacing.md),
              GlassCard(child: _buildCurrencySelector(appIcons)),
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
              PermissionGuard(
                permission: Permission.postJournalEntry,
                fallback: Center(
                  child: Text(
                    context.l10n.errPermissionDenied,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                child: AppEnhancedButton(
                  label: isEditing
                      ? context.l10n.btnUpdateInvoice
                      : context.l10n.btnSaveInvoice,
                  onPressed: _isLoading ? null : _saveInvoice,
                  isLoading: _isLoading,
                  icon: appIcons.save,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedTitle(BuildContext context, bool isEditing) {
    if (isEditing) {
      return context.l10n.invoiceFormTitleEdit;
    }

    switch (_type) {
      case InvoiceType.sales:
        return context.l10n.invoiceFormTitleAdd;
      case InvoiceType.purchase:
        return context.l10n.invoiceFormTitleAddPurchase;
      case InvoiceType.salesReturn:
        return context.l10n.labelSalesReturn;
      case InvoiceType.purchaseReturn:
        return context.l10n.labelPurchaseReturn;
      case InvoiceType.damage:
        return context.l10n.labelDamageInvoice;
    }
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
              setState(() => _selectedCustomer = customer);
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

  Widget _buildCurrencySelector(AppIcons appIcons) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(appIcons.currencyExchange, color: AppColors.primary),
              const SizedBox(width: Spacing.md),
              Text(
                context.l10n.labelCurrency,
                style: const TextStyle(
                  fontSize: AppTypography.bodyLarge,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          DropdownButtonFormField<String>(
            initialValue: _currency,
            items: ['SAR', 'USD', 'EUR']
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currency = value;
                  if (value == 'SAR') {
                    _exchangeRateController.text = '1.0';
                  } else if (value == 'USD') {
                    _exchangeRateController.text = '3.75';
                  } else if (value == 'EUR') {
                    _exchangeRateController.text = '4.10';
                  }
                });
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          if (_currency != 'SAR') ...[
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _exchangeRateController,
              label: context.l10n.labelExchangeRate,
              hint: '1.0',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icon(appIcons.numbers),
              onChanged: (value) => setState(() {}),
            ),
          ],
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
                  '${(_taxRate * Decimal.fromInt(100)).toStringAsFixed(0)}%',
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
                setState(() => _status = value);
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
                  icon: Icon(appIcons.addCircle, color: AppColors.primary),
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
                        title: Text(item.name, overflow: TextOverflow.ellipsis),
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
    final subtotal = _items.fold<Decimal>(
      Decimal.zero,
      (sum, item) => sum + item.total,
    );
    final taxTotal = subtotal * _taxRate;
    final grandTotal = subtotal + taxTotal;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _buildTotalRow(context.l10n.labelSubtotal, subtotal),
          const Divider(),
          _buildTotalRow(
            context.l10n.labelTaxTotal,
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
    Decimal amount, {
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
      text: (_taxRate * Decimal.fromInt(100)).toStringAsFixed(0),
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
          AppEnhancedButton(
            label: context.l10n.dialogCancel,
            onPressed: () => Navigator.pop(context),
            type: AppEnhancedButtonType.text,
            height: 36,
          ),
          AppEnhancedButton(
            label: context.l10n.btnSave,
            onPressed: () {
              final value = Decimal.tryParse(controller.text);

              if (value != null &&
                  value >= Decimal.zero &&
                  value <= Decimal.fromInt(100)) {
                setState(
                  () => _taxRate = (value / Decimal.fromInt(100)).toDecimal(),
                );
                Navigator.pop(context);
              }
            },
            type: AppEnhancedButtonType.text,
            height: 36,
          ),
        ],
      ),
    );

    controller.dispose();
  }

  Future<void> _addItem() async {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController();
    var selectedTaxCategory = 'S';
    var selectedTaxRate = _taxRate;
    final inventoryItemsAsync = ref.read(inventoryItemsProvider);

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.dialogAddItemTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (inventoryItemsAsync.hasValue &&
                    inventoryItemsAsync.value!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.md),
                    child: DropdownButtonFormField<InventoryItem>(
                      decoration: InputDecoration(
                        labelText: context.l10n.labelInventoryItem,
                        hintText: context.l10n.hintSelectInventoryItem,
                      ),
                      items: inventoryItemsAsync.value!
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.name(
                                  isArabic: context.l10n.localeName == 'ar',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (item) {
                        if (item != null) {
                          setDialogState(() {
                            nameController.text = item.name(
                              isArabic: context.l10n.localeName == 'ar',
                            );
                            priceController.text =
                                (item.salePrice ?? 0.0).toString();
                            selectedTaxCategory = item.taxCategory;
                            // Update rate based on category
                            if (selectedTaxCategory == 'S') {
                              selectedTaxRate = Decimal.parse('0.15');
                            } else {
                              selectedTaxRate = Decimal.zero;
                            }
                          });
                        }
                      },
                    ),
                  ),
                TextField(
                  decoration: InputDecoration(
                    labelText: context.l10n.labelSearchSku,
                    hintText: context.l10n.hintSearchSku,
                    prefixIcon: const Icon(Icons.qr_code_scanner),
                  ),
                  onSubmitted: (sku) async {
                    if (sku.isEmpty) return;
                    final item = await ref.read(
                      itemBySkuProvider(sku).future,
                    );
                    if (item != null) {
                      setDialogState(() {
                        nameController.text = item.name(
                          isArabic: context.l10n.localeName == 'ar',
                        );
                        priceController.text =
                            (item.salePrice ?? 0.0).toString();
                        selectedTaxCategory = item.taxCategory;
                      });
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.msgItemNotFound),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: Spacing.md),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: context.l10n.labelItemName,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.labelQuantity,
                        ),
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: context.l10n.labelPrice,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                DropdownButtonFormField<String>(
                  initialValue: selectedTaxCategory,
                  decoration: InputDecoration(
                    labelText: context.l10n.labelTaxCategory,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'S',
                      child: Text('Standard (15%)'),
                    ),
                    DropdownMenuItem(
                      value: 'Z',
                      child: Text('Zero Rated (0%)'),
                    ),
                    DropdownMenuItem(
                      value: 'E',
                      child: Text('Exempt (0%)'),
                    ),
                    DropdownMenuItem(
                      value: 'O',
                      child: Text('Out of Scope'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedTaxCategory = val;
                        if (val == 'S') {
                          selectedTaxRate = Decimal.parse('0.15');
                        } else {
                          selectedTaxRate = Decimal.zero;
                        }
                      });
                    }
                  },
                ),
                if (selectedTaxCategory == 'S') ...[
                  const SizedBox(height: Spacing.md),
                  AppTextField(
                    label: context.l10n.labelTaxRate,
                    controller:
                        TextEditingController(text: selectedTaxRate.toString()),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      selectedTaxRate =
                          Decimal.tryParse(val) ?? Decimal.parse('0.15');
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            AppEnhancedButton(
              label: context.l10n.dialogCancel,
              onPressed: () => Navigator.pop(context),
              type: AppEnhancedButtonType.text,
              height: 36,
            ),
            AppEnhancedButton(
              label: context.l10n.btnAdd,
              onPressed: () {
                final name = nameController.text.trim();
                final quantity = Decimal.tryParse(
                  quantityController.text,
                );
                final price = Decimal.tryParse(priceController.text);

                if (name.isNotEmpty && quantity != null && price != null) {
                  final total = quantity * price;
                  // Calculate tax based on category
                  // Note: rate is determined by selection in dialog
                  setState(() {
                    _items.add(
                      InvoiceItem(
                        id: const Uuid().v4(),
                        name: name,
                        quantity: quantity,
                        price: price,
                        total: total,
                        taxAmount: total * selectedTaxRate,
                        taxRate: selectedTaxRate,
                        taxCategory: selectedTaxCategory,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              type: AppEnhancedButtonType.text,
              height: 36,
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _saveInvoice() {
    unawaited(_saveInvoiceAsync());
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

    setState(() => _isLoading = true);

    try {
      final subtotal = _items.fold<Decimal>(
        Decimal.zero,
        (sum, item) => sum + item.total,
      );
      final taxTotal = _items.fold<Decimal>(
        Decimal.zero,
        (sum, item) => sum + item.taxAmount,
      );
      final grandTotal = subtotal + taxTotal;

      final invoice = Invoice(
        id: widget.invoice?.id ?? const Uuid().v4(),
        invoiceNumber: widget.invoice?.invoiceNumber ??
            'INV-${DateTime.now().millisecondsSinceEpoch}',
        customerId: _selectedCustomer!.id,
        customerName: _selectedCustomer!.name(isArabic: context.isArabic),
        items: _items,
        issuedDate: _issuedDate,
        dueDate: _dueDate,
        createdAt: widget.invoice?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        status: _status,
        type: _type,
        currency: _currency,
        exchangeRate: Decimal.parse(_exchangeRateController.text),
        subtotalAmount: subtotal,
        taxAmount: taxTotal,
        discountAmount: Decimal.zero,
        totalAmount: grandTotal,
        paidAmount: _status == InvoiceStatus.paid ? grandTotal : Decimal.zero,
        taxRate: _taxRate,
        discountRate: Decimal.zero,
        notes: _notesController.text,
      );

      final isEditing = widget.invoice != null;
      final result = isEditing
          ? await ref.read(updateInvoiceProvider(invoice).future)
          : await ref.read(addInvoiceProvider(invoice).future);

      if (!mounted) return;

      if (result) {
        // Diamond Experience: Haptic Feedback and Success Celebration
        await HapticFeedback.mediumImpact();

        if (mounted) {
          await showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const _SuccessDialog(),
          );
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
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
    } on CognitiveConsensusException catch (e) {
      if (!mounted) return;
      await _showCognitiveRejectionDialog(context, e);
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
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showCognitiveRejectionDialog(
    BuildContext context,
    CognitiveConsensusException exception,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        title: Row(
          children: [
            const Icon(Icons.gpp_bad, color: AppColors.error),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                context.l10n.dialogCognitiveRejectionTitle,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.dialogCognitiveRejectionMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.md),
              ...exception.consensus.agentResults.map((result) {
                if (result.isAllowed) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: Spacing.sm),
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: Radii.borderRadiusSm,
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            size: 16,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            result.agentId,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        result.rationale,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          AppEnhancedButton(
            label: context.l10n.btnDone,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _SuccessDialog extends StatefulWidget {
  const _SuccessDialog();

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    unawaited(_controller.forward());

    // Auto close after 2 seconds
    unawaited(
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context).pop();
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(Spacing.xl),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 48,
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  context.l10n.msgOperationSuccess,
                  style: const TextStyle(
                    fontSize: AppTypography.headlineMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
