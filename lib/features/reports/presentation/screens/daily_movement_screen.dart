// ignore_for_file: directives_ordering
// ignore_for_file: argument_type_not_assignable
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';

class DailyMovementScreen extends ConsumerStatefulWidget {
  const DailyMovementScreen({super.key});

  @override
  ConsumerState<DailyMovementScreen> createState() => _DailyMovementScreenState();
}

class _DailyMovementScreenState extends ConsumerState<DailyMovementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('الحركة اليومية'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'اليوم'),
            Tab(text: 'أمس'),
            Tab(text: 'هذا الشهر'),
            Tab(text: 'مخصص'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovementView(),
          _buildMovementView(),
          _buildMovementView(),
          _buildMovementView(isCustom: true),
        ],
      ),
    );

  Widget _buildMovementView({bool isCustom = false}) {
    // TODO(m): Use ref.watch(accountingServiceProvider) when available
    // Placeholder data
    const receipts = 0;
    const payments = 0;
    const netCash = receipts - payments;

    const cashSales = 0;
    const creditSales = 0;
    const cashPurchases = 0;
    const creditPurchases = 0;
    const cashSalesReturn = 0;
    const creditSalesReturn = 0;
    const cashPurchaseReturn = 0;
    const creditPurchaseReturn = 0;

    const totalSales = cashSales + creditSales;
    const totalPurchases = cashPurchases + creditPurchases;
    const expenses = 0;
    const netProfit = totalSales - totalPurchases - expenses;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isCustom)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.date_range),
                label: const Text('تحديد فترة مخصصة'),
              ),
            ),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('بطاقة التدفق النقدي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCashColumn('مقبوضات', receipts.toStringAsFixed(2), AppColors.success),
                      _buildCashColumn('مدفوعات', payments.toStringAsFixed(2), AppColors.error),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text('الصافي', style: TextStyle(color: Colors.grey)),
                  Text(
                    netCash.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: netCash >= 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('جدول المبيعات/المشتريات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('', textAlign: TextAlign.center)),
                          Padding(padding: EdgeInsets.all(8), child: Text('نقدي', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('آجل', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8), child: Text('الإجمالي', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      _buildTableRow('مبيعات', cashSales, creditSales),
                      _buildTableRow('مشتريات', cashPurchases, creditPurchases),
                      _buildTableRow('مردودات بيع', cashSalesReturn, creditSalesReturn),
                      _buildTableRow('مردودات شراء', cashPurchaseReturn, creditPurchaseReturn),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('بطاقة الأرباح', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ربح المبيعات'),
                      Text((totalSales - totalPurchases).toStringAsFixed(2)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('مصاريف'),
                      Text(expenses.toStringAsFixed(2)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('صافي الربح', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        netProfit.toStringAsFixed(2),
                        style: TextStyle(fontWeight: FontWeight.bold, color: netProfit >= 0 ? AppColors.success : AppColors.error),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashColumn(String title, String amount, Color color) => Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
      ],
    );

  TableRow _buildTableRow(String title, double cash, double credit) => TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(cash.toStringAsFixed(2), textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(credit.toStringAsFixed(2), textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text((cash + credit).toStringAsFixed(2), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
}
