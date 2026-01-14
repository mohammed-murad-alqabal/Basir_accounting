import 'package:basir_accounting_system/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:flutter/material.dart';

/// Mock DashboardCharts widget for testing
/// Eliminates complex async dependencies from chart widgets
class MockDashboardCharts extends StatelessWidget {
  /// Creates a mock dashboard charts widget
  const MockDashboardCharts({required this.data, super.key});

  /// Dashboard data (not used in mock, but maintains interface)
  final DashboardData data;

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          // Simple mock content that doesn't create timers
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Mock Sales Performance Chart'),
                  SizedBox(height: 100),
                  Text('Chart data would be displayed here'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Mock Revenue Distribution Chart'),
                  SizedBox(height: 100),
                  Text('Chart data would be displayed here'),
                ],
              ),
            ),
          ),
        ],
      );
}
