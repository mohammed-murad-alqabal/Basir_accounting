// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/features/accounting/application/credit_control_service.dart';
import 'package:basir_accounting_system/features/customers/domain/entities/customer.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Credit Control Dashboard for monitoring customer credit limits
class CreditControlDashboard extends ConsumerStatefulWidget {
  const CreditControlDashboard({super.key});

  @override
  ConsumerState<CreditControlDashboard> createState() => _CreditControlDashboardState();
}

class _CreditControlDashboardState extends ConsumerState<CreditControlDashboard> {
  List<Customer> _customersNearLimit = [];
  List<CreditBreach> _creditBreaches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(creditControlServiceProvider.notifier);

      final nearLimit = await service.getCustomersApproachingLimit();
      final breaches = await service.getCreditBreaches();

      setState(() {
        _customersNearLimit = nearLimit;
        _creditBreaches = breaches;
        _isLoading = false;
      });
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading credit data: $e')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => GlassScaffold(
        title: 'Credit Control Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Summary Cards
                    _buildSummaryCards(),
                    const SizedBox(height: 24),

                    // Customers Near Limit
                    if (_customersNearLimit.isNotEmpty) ...[
                      _buildCustomersNearLimit(),
                      const SizedBox(height: 24),
                    ],

                    // Credit Breaches
                    if (_creditBreaches.isNotEmpty) _buildCreditBreaches(),
                  ],
                ),
              ),
      );

  Widget _buildSummaryCards() => Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              'Near Limit',
              _customersNearLimit.length.toString(),
              Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMetricCard(
              'Breaches',
              _creditBreaches.length.toString(),
              Colors.red,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMetricCard(
              'Total Over Limit',
              _calculateTotalBreachAmount().toString(),
              Colors.redAccent,
            ),
          ),
        ],
      );

  Widget _buildMetricCard(String title, String value, Color color) => Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  Widget _buildCustomersNearLimit() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customers Near Credit Limit (${_customersNearLimit.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...(_customersNearLimit
                  .take(5)
                  .map(
                    (customer) => ListTile(
                      leading: CircleAvatar(
                        child: Text(customer.name(isArabic: context.isArabic).substring(0, 1)),
                      ),
                      title: Text(customer.name(isArabic: context.isArabic)),
                      subtitle: Text('Credit Limit: ${customer.creditLimit}'),
                      trailing: const Icon(Icons.warning, color: Colors.orange),
                    ),
                  )
                  .toList()),
              if (_customersNearLimit.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Showing 5 of ${_customersNearLimit.length} customers',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _buildCreditBreaches() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Credit Breaches (${_creditBreaches.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...(_creditBreaches
                  .take(5)
                  .map(
                    (breach) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getSeverityColor(breach.severity),
                        child: const Icon(Icons.warning, color: Colors.white),
                      ),
                      title: Text(breach.customer.name(isArabic: context.isArabic)),
                      subtitle: Text('Over Limit: ${breach.overLimitAmount} SAR'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(breach.severity),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getSeverityLabel(breach.severity),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () => _showBreachDetails(breach),
                    ),
                  )
                  .toList()),
              if (_creditBreaches.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Showing 5 of ${_creditBreaches.length} breaches',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );

  Decimal _calculateTotalBreachAmount() => _creditBreaches.fold<Decimal>(
        Decimal.zero,
        (sum, breach) => sum + breach.overLimitAmount,
      );

  Color _getSeverityColor(CreditBreachSeverity severity) {
    switch (severity) {
      case CreditBreachSeverity.critical:
        return Colors.red[700]!;
      case CreditBreachSeverity.high:
        return Colors.red;
      case CreditBreachSeverity.medium:
        return Colors.orange;
      case CreditBreachSeverity.low:
        return Colors.green;
    }
  }

  String _getSeverityLabel(CreditBreachSeverity severity) {
    switch (severity) {
      case CreditBreachSeverity.critical:
        return 'Critical';
      case CreditBreachSeverity.high:
        return 'High';
      case CreditBreachSeverity.medium:
        return 'Medium';
      case CreditBreachSeverity.low:
        return 'Low';
    }
  }

  Future<void> _showBreachDetails(CreditBreach breach) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Breach Details - ${breach.customer.name(isArabic: context.isArabic)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Customer', breach.customer.name(isArabic: context.isArabic)),
            _buildDetailRow('Over Limit Amount', '${breach.overLimitAmount} SAR'),
            _buildDetailRow('Days Over Limit', breach.daysOverLimit.toString()),
            _buildDetailRow('Severity', _getSeverityLabel(breach.severity)),
            _buildDetailRow('Breach Date', breach.breachDate.toLocal().toString().split(' ')[0]),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label:'),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
