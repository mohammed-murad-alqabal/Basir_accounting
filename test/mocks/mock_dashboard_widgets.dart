import 'package:flutter/material.dart';

/// Mock widget for DashboardBasirHeader
class MockDashboardBasirHeader extends StatelessWidget {
  const MockDashboardBasirHeader({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 100,
        child: Center(
          child: Text('مرحباً بك في نظام بصير المحاسبي'),
        ),
      );
}

/// Mock widget for FinancialSummaryCard
class MockFinancialSummaryCard extends StatelessWidget {
  const MockFinancialSummaryCard({super.key});

  @override
  Widget build(BuildContext context) => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('الملخص المالي'),
        ),
      );
}
