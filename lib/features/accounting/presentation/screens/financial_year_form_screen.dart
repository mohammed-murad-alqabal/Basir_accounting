// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/financial_year.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Form screen for creating or editing a Financial Year.
class FinancialYearFormScreen extends ConsumerStatefulWidget {
  /// Creates the [FinancialYearFormScreen].
  const FinancialYearFormScreen({super.key, this.financialYear});

  /// The financial year being edited, or null for a new one.
  final FinancialYear? financialYear;

  @override
  ConsumerState<FinancialYearFormScreen> createState() =>
      _FinancialYearFormScreenState();
}

class _FinancialYearFormScreenState
    extends ConsumerState<FinancialYearFormScreen> {
  final _formKey = <credential-fixture><FormState>();
  late TextEditingController _nameController;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.financialYear?.name ?? '');
    _startDate =
        widget.financialYear?.startDate ?? DateTime(DateTime.now().year);
    _endDate =
        widget.financialYear?.endDate ?? DateTime(DateTime.now().year, 12, 31);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 364));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(financialYearRepositoryProvider);
      final user = ref.read(basirUserProvider);

      final fy = FinancialYear(
        id: widget.financialYear?.id ?? const Uuid().v4(),
        name: _nameController.text,
        startDate: _startDate,
        endDate: _endDate,
        userId: user?.id,
      );

      await repo.saveFinancialYear(fy);

      if (mounted) Navigator.pop(context);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: widget.financialYear == null
            ? 'New Financial Year'
            : 'Edit Financial Year',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Form(
            key: <credential-fixture>,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Year Name',
                  hint: 'e.g. Fiscal Year 2026',
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: Spacing.lg),
                _buildDatePicker(
                  'Start Date',
                  _startDate,
                  () => _selectDate(context, true),
                ),
                const SizedBox(height: Spacing.md),
                _buildDatePicker(
                  'End Date',
                  _endDate,
                  () => _selectDate(context, false),
                ),
                const SizedBox(height: Spacing.xxl),
                AppEnhancedButton(
                  label: 'Save Fiscal Year',
                  onPressed: _save,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildDatePicker(String label, DateTime date, VoidCallback onTap) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: Spacing.xs),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.md),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.md,
              ),
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('MMMM dd, yyyy').format(date)),
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
