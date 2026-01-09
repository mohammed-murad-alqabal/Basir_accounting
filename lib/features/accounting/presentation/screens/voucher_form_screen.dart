import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/application/treasury_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_app/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_app/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';

/// شاشة إنشاء سند مالي (Voucher Form)
class VoucherFormScreen extends ConsumerStatefulWidget {
  /// Creates a voucher form screen.
  const VoucherFormScreen({
    required this.type,
    super.key,
  });

  /// The type of voucher to create.
  final VoucherType type;

  @override
  ConsumerState<VoucherFormScreen> createState() => _VoucherFormScreenState();
}

class _VoucherFormScreenState extends ConsumerState<VoucherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _personNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  String? _selectedTreasuryAccountId;
  String? _selectedOppositeAccountId;
  String? _selectedEntityId;

  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _personNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == VoucherType.receipt
        ? context.l10n.voucherReceiptTitle
        : context.l10n.voucherPaymentTitle;

    return Scaffold(
      appBar: AppAppBar(title: title),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDatePicker(),
                    const SizedBox(height: 16),
                    _buildPaymentMethodSelector(),
                    const SizedBox(height: 16),
                    _buildTreasuryAccountSelector(),
                    const SizedBox(height: 16),
                    _buildEntitySelector(),
                    const SizedBox(height: 16),
                    _buildAmountField(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 32),
                    AppButton(
                      label: context.l10n.btnSaveAndPostVoucher,
                      onPressed: _saveVoucher,
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAmountField() => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: context.l10n.labelAmount,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.money),
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.errAmountRequired;
              }
              if (Decimal.tryParse(value) == null) {
                return context.l10n.errInvalidAmount;
              }
              return null;
            },
          ),
        ),
      );

  Widget _buildDescriptionField() => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: context.l10n.labelDescription,
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.description),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.errDescriptionRequired;
              }
              return null;
            },
          ),
        ),
      );

  Widget _buildDatePicker() => AppCard(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (date != null) {
            setState(() => _selectedDate = date);
          }
        },
        child: ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text(context.l10n.labelDate),
          trailing: Text(
            intl.DateFormat('yyyy/MM/dd').format(_selectedDate),
          ),
        ),
      );

  Widget _buildPaymentMethodSelector() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.labelPaymentMethod,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<PaymentMethod>(
            segments: [
              ButtonSegment(
                value: PaymentMethod.cash,
                label: Text(context.l10n.methodCash),
                icon: const Icon(Icons.payments),
              ),
              ButtonSegment(
                value: PaymentMethod.bank,
                label: Text(context.l10n.methodBank),
                icon: const Icon(Icons.account_balance),
              ),
              ButtonSegment(
                value: PaymentMethod.check,
                label: Text(context.l10n.methodCheck),
                icon: const Icon(Icons.document_scanner),
              ),
            ],
            selected: {_paymentMethod},
            onSelectionChanged: (set) {
              setState(() {
                _paymentMethod = set.first;
                _selectedTreasuryAccountId = null;
              });
            },
          ),
        ],
      );

  Widget _buildTreasuryAccountSelector() {
    final accountsAsync = ref.watch(accountingServiceProvider);

    return accountsAsync.when(
      data: (_) => FutureBuilder<List<Account>>(
        future: ref.read(accountingServiceProvider.notifier).getAccounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          final filterCode =
              _paymentMethod == PaymentMethod.cash ? '1101' : '1102';
          final treasuryAccounts = snapshot.data!
              .where(
                (a) =>
                    a.code.startsWith(filterCode) ||
                    (_paymentMethod == PaymentMethod.cash &&
                        a.subType == 'cash'),
              )
              .toList();

          return DropdownButtonFormField<String>(
            initialValue: _selectedTreasuryAccountId,
            decoration: InputDecoration(
              labelText: context.l10n.labelTreasuryAccount,
            ),
            items: treasuryAccounts
                .map(
                  (a) => DropdownMenuItem(
                    value: a.id,
                    child: Text(a.nameAr),
                  ),
                )
                .toList(),
            onChanged: (val) {
              setState(() => _selectedTreasuryAccountId = val);
            },
            validator: (val) => val == null ? context.l10n.errFormFill : null,
          );
        },
      ),
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }

  Widget _buildEntitySelector() {
    if (widget.type == VoucherType.receipt) {
      final customersAsync = ref.watch(customersProvider);
      return customersAsync.when(
        data: (customers) => DropdownButtonFormField<String>(
          initialValue: _selectedEntityId,
          decoration: InputDecoration(
            labelText: context.l10n.labelSourceClient,
          ),
          items: customers
              .map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name(isArabic: context.isArabic)),
                ),
              )
              .toList(),
          onChanged: (val) {
            final c = customers.firstWhere((e) => e.id == val);
            setState(() {
              _selectedEntityId = val;
              _selectedOppositeAccountId = c.receivableAccountId ?? 'acc-1201';
              _personNameController.text = c.name(isArabic: context.isArabic);
            });
          },
          validator: (val) => val == null ? context.l10n.errFormFill : null,
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      );
    } else {
      final vendorsAsync = ref.watch(vendorsProvider);
      return vendorsAsync.when(
        data: (vendors) => DropdownButtonFormField<String>(
          initialValue: _selectedEntityId,
          decoration: InputDecoration(
            labelText: context.l10n.labelBeneficiaryVendor,
          ),
          items: vendors
              .map(
                (v) => DropdownMenuItem(
                  value: v.id,
                  child: Text(v.name(isArabic: context.isArabic)),
                ),
              )
              .toList(),
          onChanged: (val) {
            final v = vendors.firstWhere((e) => e.id == val);
            setState(() {
              _selectedEntityId = val;
              _selectedOppositeAccountId = v.payableAccountId ?? 'acc-2101';
              _personNameController.text = v.name(isArabic: context.isArabic);
            });
          },
          validator: (val) => val == null ? context.l10n.errFormFill : null,
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      );
    }
  }

  Future<void> _saveVoucher() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTreasuryAccountId == null ||
        _selectedOppositeAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errFormFill)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final treasuryService = ref.read(treasuryServiceProvider.notifier);
      final refNum = widget.type == VoucherType.receipt ? 'RE' : 'PY';
      final dateStr = intl.DateFormat('yyyyMMdd-HHmm').format(DateTime.now());

      final voucher = FinancialVoucher(
        id: const Uuid().v4(),
        referenceNumber: '$refNum-$dateStr',
        date: _selectedDate,
        type: widget.type,
        paymentMethod: _paymentMethod,
        amount: Decimal.parse(_amountController.text),
        accountId: _selectedOppositeAccountId!,
        treasuryAccountId: _selectedTreasuryAccountId!,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        personName: _personNameController.text,
      );

      if (widget.type == VoucherType.receipt) {
        await treasuryService.issueReceipt(voucher);
      } else {
        await treasuryService.issuePayment(voucher);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.msgVoucherSavedSuccess)),
        );
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.errorLoadingAccounts}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
