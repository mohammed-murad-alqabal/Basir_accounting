import 'package:basir_app/core/extensions/context_extensions.dart';
import 'package:basir_app/core/providers.dart';
import 'package:basir_app/core/theme/tokens/index.dart';
import 'package:basir_app/features/accounting/application/accounting_service.dart';
import 'package:basir_app/features/accounting/domain/entities/account.dart';
import 'package:basir_app/features/accounting/domain/entities/journal_entry.dart';
import 'package:basir_app/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:uuid/uuid.dart';

/// نموذج بيانات لبند القيد في النموذج
class _JournalLineDraft {
  _JournalLineDraft({
    this.accountId,
    this.accountName,
    this.description,
    Decimal? debit,
    Decimal? credit,
  })  : debit = debit ?? Decimal.zero,
        credit = credit ?? Decimal.zero;

  String? accountId;
  String? accountName;
  String? description;
  Decimal debit;
  Decimal credit;
}

/// شاشة إضافة قيد يدوي
class JournalEntryFormScreen extends ConsumerStatefulWidget {
  /// إنشاء الشاشة.
  const JournalEntryFormScreen({super.key, this.entry});

  /// القيد المحاسبي.
  final JournalEntry? entry;

  @override
  ConsumerState<JournalEntryFormScreen> createState() =>
      _JournalEntryFormScreenState();
}

class _JournalEntryFormScreenState
    extends ConsumerState<JournalEntryFormScreen> {
  final _formKey = <credential-fixture><FormState>();
  final _descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  final List<_JournalLineDraft> _lines = [
    _JournalLineDraft(),
    _JournalLineDraft(),
  ];
  bool _isLoading = false;

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
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Decimal get _totalDebit => _lines.fold(Decimal.zero, (s, l) => s + l.debit);
  Decimal get _totalCredit => _lines.fold(Decimal.zero, (s, l) => s + l.credit);
  bool get _isBalanced =>
      _totalDebit == _totalCredit && _totalDebit > Decimal.zero;

  @override
  Widget build(BuildContext context) {
    final appIcons = ref.watch(appIconsProvider);

    return Scaffold(
      appBar: AppAppBar(
        title: widget.entry == null
            ? context.l10n.journalEntryFormTitleAdd
            : context.l10n.journalEntryFormTitleEdit,
      ),
      body: Form(
        key: <credential-fixture>,
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
                    child: AppButton(
                      label: context.l10n.btnSaveEntry,
                      onPressed: _isLoading
                          ? null
                          : () => _saveEntry(JournalEntryStatus.draft),
                      isLoading: _isLoading,
                      type: AppButtonType.secondary,
                      icon: appIcons.save,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: AppButton(
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

  Widget _buildHeader(AppIcons appIcons) => AppCard(
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
          ],
        ),
      );

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

  Widget _buildLineItem(int index, AppIcons appIcons) {
    final line = _lines[index];
    return AppCard(
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
              IconButton(
                icon: Icon(appIcons.delete, color: AppColors.error, size: 20),
                onPressed: () => setState(() => _lines.removeAt(index)),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
        ],
      ),
    );
  }

  Widget _buildSummary() => AppCard(
        backgroundColor: _isBalanced
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.error.withValues(alpha: 0.05),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _saveEntry(JournalEntryStatus status) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isBalanced) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errUnbalancedEntry)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final entry = JournalEntry(
        id: widget.entry?.id ?? const Uuid().v4(),
        referenceNumber: widget.entry?.referenceNumber ??
            'JE-${DateTime.now().millisecondsSinceEpoch}',
        date: _date,
        description: _descriptionController.text.trim(),
        status: status,
        sourceDocument: 'manual',
        sourceId: 'manual',
        createdBy: 'user', // TODO(user): Get current user
        createdAt: widget.entry?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        lines: _lines
            .map(
              (l) => JournalEntryLine(
                accountId: l.accountId!,
                accountName: l.accountName!,
                debit: l.debit,
                credit: l.credit,
                description: l.description,
              ),
            )
            .toList(),
      );

      await ref
          .read(accountingServiceProvider.notifier)
          .postJournalEntry(entry);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == JournalEntryStatus.posted
                ? context.l10n.msgJournalEntryPosted
                : context.l10n.msgJournalEntryDrafted,
          ),
        ),
      );
      Navigator.pop(context, true);
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

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

        // Only show leaf accounts (isParent == false)
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
            final acc = leafAccounts.firstWhere((a) => a.id == id);
            onSelected(acc);
          },
          validator: (v) => v == null ? context.l10n.labelRequired : null,
        );
      },
    );
  }
}
