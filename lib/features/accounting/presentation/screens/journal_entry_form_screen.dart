// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/application/accounting_service.dart';
import 'package:basir_accounting_system/features/accounting/application/orchestrator_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/account.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/accounting_agent.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_accounting_system/features/accounting/domain/exceptions/cognitive_exceptions.dart';
import 'package:basir_accounting_system/features/accounting/presentation/widgets/consensus_report_overlay.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';

/// Transitory data model for an atomic journal line in the entry form.
class _JournalLineDraft {
  _JournalLineDraft({
    this.accountId,
    this.accountName,
    this.description,
    Decimal? debit,
    Decimal? credit,
    this.originalCurrency,
    this.exchangeRate,
    this.originalAmount,
  })  : debit = debit ?? Decimal.zero,
        credit = credit ?? Decimal.zero;

  String? accountId;
  String? accountName;
  String? description;
  Decimal debit;
  Decimal credit;
  String? originalCurrency;
  Decimal? exchangeRate;
  Decimal? originalAmount;
}

/// Advanced form Screen for manual and automated Journal Entry recording.
///
/// Ensures compliance with double-entry principles by enforcing balance checks.
/// Supports multi-currency translations and statutory standard justifications.
class JournalEntryFormScreen extends ConsumerStatefulWidget {
  /// Creates the journal entry form screen.
  const JournalEntryFormScreen({super.key, this.entry});

  /// The optional entry to edit. If null, a new entry is created.
  final JournalEntry? entry;

  @override
  ConsumerState<JournalEntryFormScreen> createState() =>
      _JournalEntryFormScreenState();
}

class _JournalEntryFormScreenState
    extends ConsumerState<JournalEntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  final List<_JournalLineDraft> _lines = [
    _JournalLineDraft(),
    _JournalLineDraft(),
  ];
  bool _isLoading = false;
  String _standardReference = 'IAS 1';
  String _recognitionBasis = 'Manual';
  String _measurementBasis = 'Historical Cost';

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _descriptionController.text = widget.entry!.description;
      _date = widget.entry!.date;
      _lines.clear();
      for (final line in widget.entry!.lines) {
        _lines.add(
          _JournalLineDraft(
            accountId: line.accountId,
            accountName: line.accountName,
            description: line.description,
            debit: line.debit,
            credit: line.credit,
            originalCurrency: line.originalCurrency,
            exchangeRate: line.exchangeRate,
            originalAmount: line.originalAmount,
          ),
        );
      }
      _standardReference = widget.entry!.standards.standardReference;
      _recognitionBasis = widget.entry!.standards.recognitionBasis ?? 'Manual';
      _measurementBasis =
          widget.entry!.standards.measurementBasis ?? 'Historical Cost';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Total debit summation across all lines.
  Decimal get _totalDebit => _lines.fold(Decimal.zero, (s, l) => s + l.debit);

  /// Total credit summation across all lines.
  Decimal get _totalCredit => _lines.fold(Decimal.zero, (s, l) => s + l.credit);

  /// Validates the fundamental accounting equation: sum(debit) == sum(credit).
  bool get _isBalanced =>
      _totalDebit == _totalCredit && _totalDebit > Decimal.zero;

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);

    return GlassScaffold(
      title: widget.entry == null
          ? context.l10n.journalEntryFormTitleAdd
          : context.l10n.journalEntryFormTitleEdit,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(appIcons),
              const SizedBox(height: Spacing.md),
              _buildLinesSection(appIcons),
              const SizedBox(height: Spacing.md),
              _buildSummary(),
              const SizedBox(height: Spacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppEnhancedButton(
                      label: context.l10n.btnSaveEntry,
                      onPressed: _isLoading
                          ? null
                          : () => _saveEntry(JournalEntryStatus.draft),
                      isLoading: _isLoading,
                      type: AppEnhancedButtonType.secondary,
                      icon: appIcons.save,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: AppEnhancedButton(
                      label: context.l10n.btnPostEntry,
                      onPressed: _isLoading
                          ? null
                          : () => _saveEntry(JournalEntryStatus.posted),
                      isLoading: _isLoading,
                      icon: appIcons.check,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the metadata header (Date, Description, Standards).
  Widget _buildHeader(AppIcons appIcons) => GlassCard(
        child: Column(
          children: [
            Row(
              children: [
                Icon(appIcons.calendar, color: AppColors.primary),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.labelIssuedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          intl.DateFormat('yyyy-MM-dd').format(_date),
                          style: const TextStyle(
                            fontSize: AppTypography.bodyLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              controller: _descriptionController,
              label: context.l10n.hintJournalDescription,
              prefixIcon: Icon(appIcons.note),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    initialValue: _standardReference,
                    label: context.l10n.labelStandard,
                    onChanged: (v) => _standardReference = v,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: AppTextField(
                    initialValue: _recognitionBasis,
                    label: context.l10n.labelRecognitionBasis,
                    onChanged: (v) => _recognitionBasis = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            AppTextField(
              initialValue: _measurementBasis,
              label: context.l10n.labelMeasurementBasis,
              onChanged: (v) => _measurementBasis = v,
            ),
          ],
        ),
      );

  /// Renders the section for managing double-entry atomic lines.
  Widget _buildLinesSection(AppIcons appIcons) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.labelJournalEntryLines,
                style: const TextStyle(
                  fontSize: AppTypography.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(appIcons.addCircle, color: AppColors.primary),
                onPressed: () =>
                    setState(() => _lines.add(_JournalLineDraft())),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          ...List.generate(
            _lines.length,
            (index) => _buildLineItem(index, appIcons),
          ),
        ],
      );

  /// Renders a single journal line editor with account and currency support.
  Widget _buildLineItem(int index, AppIcons appIcons) {
    final line = _lines[index];
    return GlassCard(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AccountSelector(
                  selectedAccountId: line.accountId,
                  onSelected: (account) {
                    setState(() {
                      line.accountId = account.id;
                      line.accountName = account.nameAr;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  initialValue:
                      line.debit == Decimal.zero ? '' : line.debit.toString(),
                  label: context.l10n.labelDebit,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (v) {
                    setState(() {
                      line.debit = Decimal.tryParse(v) ?? Decimal.zero;
                      if (line.debit > Decimal.zero) line.credit = Decimal.zero;
                    });
                  },
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: AppTextField(
                  initialValue:
                      line.credit == Decimal.zero ? '' : line.credit.toString(),
                  label: context.l10n.labelCredit,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (v) {
                    setState(() {
                      line.credit = Decimal.tryParse(v) ?? Decimal.zero;
                      if (line.credit > Decimal.zero) line.debit = Decimal.zero;
                    });
                  },
                ),
              ),
            ],
          ),
          if (line.originalCurrency != null && line.originalCurrency != 'SAR')
            Padding(
              padding: const EdgeInsets.only(top: Spacing.sm),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppTextField(
                      initialValue: line.originalAmount?.toString() ?? '',
                      label: '${context.l10n.labelAmount} '
                          '(${line.originalCurrency})',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (v) {
                        setState(() {
                          line.originalAmount =
                              Decimal.tryParse(v) ?? Decimal.zero;
                          _updateLineFromCurrency(line);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: AppTextField(
                      initialValue: line.exchangeRate?.toString() ?? '',
                      label: context.l10n.labelExchangeRate,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (v) {
                        setState(() {
                          line.exchangeRate =
                              Decimal.tryParse(v) ?? Decimal.one;
                          _updateLineFromCurrency(line);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: Icon(
                  line.originalCurrency == null
                      ? appIcons.language
                      : appIcons.edit,
                  size: 16,
                ),
                label: Text(
                  line.originalCurrency == null
                      ? context.l10n.labelAddCurrency
                      : '${context.l10n.labelCurrency}: '
                          '${line.originalCurrency}',
                ),
                onPressed: () => _showCurrencyPicker(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateLineFromCurrency(_JournalLineDraft line) {
    if (line.originalAmount != null && line.exchangeRate != null) {
      final lcAmount = line.originalAmount! * line.exchangeRate!;
      if (line.debit > Decimal.zero ||
          (line.debit == Decimal.zero && line.credit == Decimal.zero)) {
        line.debit = lcAmount;
      } else {
        line.credit = lcAmount;
      }
    }
  }

  /// Displays the mathematical summary and balance validation.
  Widget _buildSummary() => GlassCard(
        child: Column(
          children: [
            _buildSummaryRow(context.l10n.labelDebit, _totalDebit),
            _buildSummaryRow(context.l10n.labelCredit, _totalCredit),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isBalanced
                      ? context.l10n.labelBalanced
                      : context.l10n.labelUnbalanced,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isBalanced ? AppColors.success : AppColors.error,
                  ),
                ),
                if (!_isBalanced)
                  Text(
                    '${context.l10n.labelDiff}: '
                    '${(_totalDebit - _totalCredit).abs()}',
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _buildSummaryRow(String label, Decimal amount) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              amount.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  /// Shows the platform-native date picker.
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  /// Validates and persists the entry to the General Ledger.
  Future<void> _saveEntry(JournalEntryStatus status) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isBalanced) {
      AppSnackbar.showError(context, context.l10n.errUnbalancedEntry);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      final user = ref.read(basirUserProvider);

      final entry = JournalEntry(
        id: widget.entry?.id ?? const Uuid().v4(),
        referenceNumber: widget.entry?.referenceNumber ??
            'JE-${DateTime.now().millisecondsSinceEpoch}',
        date: _date,
        temporal: TemporalJustification(
          transactionDate: _date,
          effectiveDate: _date,
          recordingDate: now,
        ),
        standards: StandardsJustification(
          standardReference: _standardReference,
          recognitionBasis: _recognitionBasis,
          measurementBasis: _measurementBasis,
        ),
        description: _descriptionController.text.trim(),
        status: status,
        sourceDocument: 'manual',
        sourceId: 'manual',
        createdBy: user?.id ?? 'user',
        createdAt: widget.entry?.createdAt ?? now,
        updatedAt: now,
        postedAt: status == JournalEntryStatus.posted ? now : null,
        lines: _lines
            .map(
              (l) => JournalEntryLine(
                accountId: l.accountId!,
                accountName: l.accountName!,
                debit: l.debit,
                credit: l.credit,
                description: l.description,
                originalCurrency: l.originalCurrency,
                exchangeRate: l.exchangeRate,
                originalAmount: l.originalAmount,
              ),
            )
            .toList(),
      );

      if (status == JournalEntryStatus.posted) {
        // Pre-orchestrate for Consensus Report
        final orchestrator = ref.read(orchestratorServiceProvider.notifier);
        final currentLocale = Localizations.localeOf(context).languageCode;
        final contextObj = AccountingContext(
          proposedJournalEntry: entry,
          transactionType: 'manual',
          locale: currentLocale,
        );

        final consensus = await orchestrator.orchestrate(contextObj);

        if (!mounted) return;

        final confirmed = await showGeneralDialog<bool>(
          context: context,
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (ctx, anim1, anim2) => ConsensusReportOverlay(
            consensus: consensus,
            onConfirm: () => Navigator.pop(ctx, true),
            onCancel: () => Navigator.pop(ctx, false),
          ),
        );

        if (confirmed != true) {
          setState(() => _isLoading = false);
          return;
        }

        // Proceed with bypass as we already reached consensus/override
        await ref
            .read(accountingServiceProvider.notifier)
            .postJournalEntry(entry, bypassCognitive: true);
      } else {
        await ref
            .read(accountingServiceProvider.notifier)
            .postJournalEntry(entry);
      }

      if (!mounted) return;
      AppSnackbar.showSuccess(
        context,
        status == JournalEntryStatus.posted
            ? context.l10n.msgJournalEntryPosted
            : context.l10n.msgJournalEntryDrafted,
      );
      Navigator.pop(context, true);
    } on CognitiveConsensusException catch (e) {
      if (mounted) await _showCognitiveRejectionDialog(context, e);
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Displays the modal for multi-currency selection and exchange rate setup.
  Future<void> _showCurrencyPicker(int index) async {
    final line = _lines[index];
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
        if (result == 'SAR') {
          line.originalCurrency = null;
          line.exchangeRate = null;
          line.originalAmount = null;
        } else {
          line.originalCurrency = result;
          line.exchangeRate =
              result == 'USD' ? Decimal.parse('3.75') : Decimal.one;
          if (line.debit > Decimal.zero) {
            line.originalAmount = line.debit;
          } else if (line.credit > Decimal.zero) {
            line.originalAmount = line.credit;
          }
        }
      });
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
}

/// Specialized internal selector for filtering leaf accounts from the COA.
class _AccountSelector extends ConsumerWidget {
  const _AccountSelector({
    required this.selectedAccountId,
    required this.onSelected,
  });

  final String? selectedAccountId;
  final ValueChanged<Account> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync =
        ref.watch(accountingServiceProvider.notifier).getAccounts();

    return FutureBuilder<List<Account>>(
      future: accountsAsync,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();

        final leafAccounts = snapshot.data!.where((a) => !a.isParent).toList();

        return DropdownButtonFormField<String>(
          initialValue: selectedAccountId,
          decoration: InputDecoration(
            labelText: context.l10n.labelAccountSelector,
          ),
          items: leafAccounts
              .map(
                (a) => DropdownMenuItem(
                  value: a.id,
                  child: Text('${a.code} - ${a.nameAr}'),
                ),
              )
              .toList(),
          onChanged: (id) {
            if (id != null) {
              final acc = leafAccounts.firstWhere((a) => a.id == id);
              onSelected(acc);
            }
          },
          validator: (v) => v == null ? context.l10n.labelRequired : null,
        );
      },
    );
  }
}
