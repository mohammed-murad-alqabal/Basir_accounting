// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/features/accounting/application/payment_receipt_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/payment_receipt.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Payment Receipt Screen for creating and managing payment receipts
class PaymentReceiptScreen extends ConsumerStatefulWidget {
  const PaymentReceiptScreen({super.key, this.receipt});

  final PaymentReceipt? receipt;

  @override
  ConsumerState<PaymentReceiptScreen> createState() =>
      _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends ConsumerState<PaymentReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _receiptNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedCustomerId;
  String? _selectedCustomerName;
  DateTime _selectedDate = DateTime.now();
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  PaymentStatus _selectedStatus = PaymentStatus.cleared;
  String? _selectedAccountId;
  late Decimal _amount;

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      _initializeFromReceipt(widget.receipt!);
    } else {
      _receiptNumberController.text =
          'PR-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  void dispose() {
    _receiptNumberController.dispose();
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeFromReceipt(PaymentReceipt receipt) {
    _selectedCustomerId = receipt.customerId;
    _selectedCustomerName = receipt.customerName;
    _selectedDate = receipt.receiptDate;
    _selectedMethod = receipt.paymentMethod;
    _selectedStatus = receipt.status;
    _amount = receipt.amount;
    _selectedAccountId = receipt.accountId;

    _receiptNumberController.text = receipt.receiptNumber;
    _amountController.text = receipt.amount.toString();
    _referenceController.text = receipt.reference ?? '';
    _notesController.text = receipt.notes ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveReceipt() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null || _selectedCustomerName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cash/bank account')),
      );
      return;
    }

    try {
      final service = ref.read(paymentReceiptServiceProvider.notifier);

      await service.createReceipt(
        customerId: _selectedCustomerId!,
        amount: _amount,
        paymentMethod: _selectedMethod,
        accountId: _selectedAccountId!,
        reference: _referenceController.text.trim().isNotEmpty
            ? _referenceController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment receipt saved successfully')),
        );
        Navigator.of(context).pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving receipt: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: widget.receipt == null
            ? 'New Payment Receipt'
            : 'Edit Payment Receipt',
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveReceipt,
            tooltip: 'Save',
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Receipt Number
                TextFormField(
                  controller: _receiptNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Receipt Number',
                    prefixIcon: Icon(Icons.receipt),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter receipt number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      '${_selectedDate.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (SAR)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter amount';
                    }
                    try {
                      final amount = Decimal.parse(value);
                      if (amount <= Decimal.zero) {
                        return 'Amount must be greater than zero';
                      }
                      _amount = amount;
                    } on Exception {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Customer Selection (Simplified - would normally show a dialog)
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedCustomerName ?? 'Select Customer (Tap to select)',
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method
                DropdownButtonFormField<PaymentMethod>(
                  initialValue: _selectedMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    prefixIcon: Icon(Icons.payment),
                    border: OutlineInputBorder(),
                  ),
                  items: PaymentMethod.values
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(_getPaymentMethodLabel(method)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMethod = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Status
                DropdownButtonFormField<PaymentStatus>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.info),
                    border: OutlineInputBorder(),
                  ),
                  items: PaymentStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(_getPaymentStatusLabel(status)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Reference
                TextFormField(
                  controller: _referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Reference Number (Optional)',
                    prefixIcon: Icon(Icons.tag),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Save Button
                ElevatedButton(
                  onPressed: _saveReceipt,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Save Payment Receipt'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  String _getPaymentMethodLabel(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.online:
        return 'Online Payment';
    }
  }

  String _getPaymentStatusLabel(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.cleared:
        return 'Cleared';
      case PaymentStatus.bounced:
        return 'Bounced';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }
}
