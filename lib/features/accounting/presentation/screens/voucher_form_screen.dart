// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/treasury_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_voucher.dart';
import 'package:basir_accounting_system/features/accounting/domain/exceptions/cognitive_exceptions.dart';
import 'package:basir_accounting_system/features/customers/presentation/providers/customer_provider.dart';
import 'package:basir_accounting_system/features/invoices/application/ocr_service.dart';
import 'package:basir_accounting_system/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';

/// Screen for issuing Receipt and Payment vouchers.
///
/// Automates the creation of specialized journal entries for treasury
/// operations, supporting OCR-based data entry and multi-currency conversion.
class VoucherFormScreen extends ConsumerStatefulWidget {
  /// Creates a voucher form screen.
  const VoucherFormScreen({required this.type, super.key});

  /// The classification of the voucher (Receipt vs Payment).
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
  String? _selectedCurrency;
  Decimal? _exchangeRate;
  Decimal? _originalAmount;

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
      appBar: AppAppBar(
        title: title,
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner),
            onPressed: _scanReceipt,
            tooltip: 'مسح إيصال (OCR)',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: AppLoadingIndicator())
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
                    _buildCurrencySelector(),
                    const SizedBox(height: 16),
                    _buildAmountField(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 32),
                    AppEnhancedButton(
                      label: context.l10n.btnSaveAndPostVoucher,
                      onPressed: _saveVoucher,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Amount field with integrated currency conversion support.
  Widget _buildAmountField() => AppCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText:
                      (_selectedCurrency != null && _selectedCurrency != 'SAR')
                          ? '${context.l10n.labelAmount} (SAR)'
                          : context.l10n.labelAmount,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (v) {
                  if (_selectedCurrency != null &&
                      _selectedCurrency != 'SAR' &&
                      _exchangeRate != null) {
                    final sarAmount = Decimal.tryParse(v);
                    if (sarAmount != null) {
                      setState(() {
                        _originalAmount =
                            (sarAmount / (_exchangeRate ?? Decimal.one))
                                .toDecimal();
                      });
                    }
                  }
                },
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
              if (_selectedCurrency != null && _selectedCurrency != 'SAR') ...[
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _originalAmount?.toString() ?? '',
                        decoration: InputDecoration(
                          labelText: '${context.l10n.labelAmount} '
                              '($_selectedCurrency)',
                          border: InputBorder.none,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (v) {
                          _originalAmount = Decimal.tryParse(v);
                          if (_originalAmount != null &&
                              _exchangeRate != null) {
                            setState(() {
                              _amountController.text =
                                  (_originalAmount! * _exchangeRate!)
                                      .toString();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: _exchangeRate?.toString() ?? '',
                        decoration: InputDecoration(
                          labelText: context.l10n.labelExchangeRate,
                          border: InputBorder.none,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (v) {
                          _exchangeRate = Decimal.tryParse(v);
                          if (_originalAmount != null &&
                              _exchangeRate != null) {
                            setState(() {
                              _amountController.text =
                                  (_originalAmount! * _exchangeRate!)
                                      .toString();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );

  /// Integrated currency picker and exchange rate manager.
  Widget _buildCurrencySelector() => AppCard(
        child: ListTile(
          leading: const Icon(Icons.language),
          title: Text(context.l10n.labelCurrency),
          subtitle: Text(_selectedCurrency ?? 'SAR'),
          onTap: _showCurrencyPicker,
        ),
      );

  Future<void> _showCurrencyPicker() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.labelAddCurrency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('SAR'),
              onTap: () => Navigator.pop(context, 'SAR'),
            ),
            ListTile(
              title: const Text('USD'),
              onTap: () => Navigator.pop(context, 'USD'),
            ),
            ListTile(
              title: const Text('EUR'),
              onTap: () => Navigator.pop(context, 'EUR'),
            ),
            ListTile(
              title: const Text('GBP'),
              onTap: () => Navigator.pop(context, 'GBP'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCurrency = result == 'SAR' ? null : result;
        if (_selectedCurrency != null) {
          _exchangeRate = (_selectedCurrency == 'USD')
              ? Decimal.parse('3.75')
              : Decimal.one;
          final currentAmount =
              Decimal.tryParse(_amountController.text) ?? Decimal.zero;
          if (currentAmount > Decimal.zero) {
            _originalAmount =
                (currentAmount / (_exchangeRate ?? Decimal.one)).toDecimal();
          }
        } else {
          _exchangeRate = null;
          _originalAmount = null;
        }
      });
    }
  }

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
          final val = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
          );
          if (val != null) {
            setState(() => _selectedDate = val);
          }
        },
        child: ListTile(
          leading: const Icon(Icons.calendar_today),
          title: Text(context.l10n.labelDate),
          trailing: Text(intl.DateFormat('yyyy/MM/dd').format(_selectedDate)),
        ),
      );

  /// Selects the payment instrument (Cash/Bank/Check) which filters treasury accounts.
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

  /// Context-aware selector for Treasury and Bank accounts.
  Widget _buildTreasuryAccountSelector() {
    final accountsAsync = ref.watch(accountingServiceProvider);

    return accountsAsync.when(
      data: (_) => FutureBuilder<List<Account>>(
        future: ref.read(accountingServiceProvider.notifier).getAccounts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();

          final filterCode =
              (_paymentMethod == PaymentMethod.cash) ? '1101' : '1102';
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
                  (a) => DropdownMenuItem(value: a.id, child: Text(a.nameAr)),
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

  /// Selects the counterpart participant (Customer or Vendor).
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
              _personNameController.text = c.name(
                isArabic: context.isArabic,
              );
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
              _personNameController.text = v.name(
                isArabic: context.isArabic,
              );
            });
          },
          validator: (val) => val == null ? context.l10n.errFormFill : null,
        ),
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      );
    }
  }

  /// Validates and saves the financial voucher.
  Future<void> _saveVoucher() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTreasuryAccountId == null ||
        _selectedOppositeAccountId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.errFormFill)));
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
        originalCurrency: _selectedCurrency,
        exchangeRate: _exchangeRate,
        originalAmount: _originalAmount,
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
    } on CognitiveConsensusException catch (e) {
      if (mounted) await _showCognitiveRejectionDialog(context, e);
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

  /// Displays a detailed dialog explaining why the Cognitive Hexagon
  /// rejected the transaction.
  Future<void> _showCognitiveRejectionDialog(
    BuildContext context,
    CognitiveConsensusException exception,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        title: Row(
          children: [
            const Icon(Icons.gpp_bad, color: AppColors.error),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                ctx.l10n.dialogCognitiveRejectionTitle,
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
                ctx.l10n.dialogCognitiveRejectionMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Spacing.md),
              ...exception.consensus.agentResults.map(
                (result) => Container(
                  margin: const EdgeInsets.only(bottom: Spacing.sm),
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: result.isAllowed
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: Radii.borderRadiusSm,
                    border: Border.all(
                      color: result.isAllowed
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            result.isAllowed ? Icons.check : Icons.close,
                            size: 16,
                            color: result.isAllowed
                                ? AppColors.success
                                : AppColors.error,
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
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppEnhancedButton(
            label: ctx.l10n.btnDone,
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  /// Invokes the intelligent OCR agent to extract data from camera/gallery imagery.
  Future<void> _scanReceipt() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() => _isLoading = true);
      try {
        final ocrService = ref.read(ocrServiceProvider.notifier);
        final results = await ocrService.processReceipt(image.path);

        if (results['total'] != null) {
          _amountController.text = results['total'].toString();
        }
        if (results['date'] != null) {
          _selectedDate = results['date'] as DateTime;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم استخراج البيانات من الإيصال بنجاح'),
            ),
          );
        }
      } on Exception catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('فشل في تحليل الإيصال: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
