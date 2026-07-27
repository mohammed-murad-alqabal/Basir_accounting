// ignore_for_file: lines_longer_than_80_chars
import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/accounting/application/customer_ledger_service.dart';
import 'package:basir_accounting_system/features/accounting/domain/entities/customer_ledger_entry.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Customer Statement Screen for viewing customer account history
class CustomerStatementScreen extends ConsumerStatefulWidget {
  const CustomerStatementScreen({super.key, this.initialCustomer});

  final Customer? initialCustomer;

  @override
  ConsumerState<CustomerStatementScreen> createState() =>
      _CustomerStatementScreenState();
}

class _CustomerStatementScreenState
    extends ConsumerState<CustomerStatementScreen> {
  Customer? _selectedCustomer;
  DateTimeRange? _dateRange;
  List<CustomerLedgerEntry> _entries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCustomer = widget.initialCustomer;
  }

  Future<void> _loadStatement() async {
    if (_selectedCustomer == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(customerLedgerServiceProvider.notifier);

      final now = DateTime.now();
      final fromDate =
          _dateRange?.start ?? DateTime(now.year - 1, now.month, now.day);
      final toDate = _dateRange?.end ?? now;

      final statement = await service.getCustomerStatement(
        customerId: _selectedCustomer!.id,
        fromDate: fromDate,
        toDate: toDate,
      );

      setState(() {
        _entries = statement.entries;
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading statement: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange = _dateRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month - 3),
          end: now,
        );

    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: initialRange,
    );

    if (selected != null) {
      setState(() {
        _dateRange = selected;
      });
      await _loadStatement();
    }
  }

  Decimal _calculateTotalDebits() => _entries.fold<Decimal>(
        Decimal.zero,
        (sum, entry) => sum + entry.debit,
      );

  Decimal _calculateTotalCredits() => _entries.fold<Decimal>(
        Decimal.zero,
        (sum, entry) => sum + entry.credit,
      );

  Decimal _calculateClosingBalance() {
    if (_entries.isEmpty) return Decimal.zero;
    return _entries.last.balance;
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: 'Customer Statement',
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _entries.isEmpty ? null : _exportToPDF,
            tooltip: 'Export PDF',
          ),
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Customer Selection
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Customer',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedCustomer?.name(isArabic: context.isArabic) ??
                      'Select Customer',
                ),
              ),
              const SizedBox(height: 16),

              // Date Range Selection
              InkWell(
                onTap: () => _selectDateRange(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date Range',
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dateRange == null
                        ? 'Select Date Range (Optional)'
                        : '${_dateRange!.start.toLocal().toString().split(' ')[0]} - ${_dateRange!.end.toLocal().toString().split(' ')[0]}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Load Button
              ElevatedButton(
                onPressed: _selectedCustomer == null ? null : _loadStatement,
                child: const Text('Load Statement'),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              if (_entries.isNotEmpty) ...[
                _buildSummarySection(),
                const SizedBox(height: 24),
              ],

              // Loading Indicator
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_entries.isNotEmpty)
                _buildEntriesTable()
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No entries to display'),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildSummarySection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              _buildSummaryRow('Total Debits', _calculateTotalDebits()),
              _buildSummaryRow('Total Credits', _calculateTotalCredits()),
              const Divider(),
              _buildSummaryRow(
                'Closing Balance',
                _calculateClosingBalance(),
                isBold: true,
              ),
            ],
          ),
        ),
      );

  Widget _buildSummaryRow(
    String label,
    Decimal amount, {
    bool isBold = false,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              '$amount SAR',
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );

  Widget _buildEntriesTable() => Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Debit')),
              DataColumn(label: Text('Credit')),
              DataColumn(label: Text('Balance')),
            ],
            rows: _entries
                .map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          entry.entryDate.toLocal().toString().split(' ')[0],
                        ),
                      ),
                      DataCell(Text(entry.description)),
                      DataCell(
                        Text(
                          entry.debit > Decimal.zero
                              ? entry.debit.toString()
                              : '-',
                        ),
                      ),
                      DataCell(
                        Text(
                          entry.credit > Decimal.zero
                              ? entry.credit.toString()
                              : '-',
                        ),
                      ),
                      DataCell(Text(entry.balance.toString())),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );

  void _exportToPDF() {
    // TODO(developer): Implement PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF export coming soon')),
    );
  }
}
