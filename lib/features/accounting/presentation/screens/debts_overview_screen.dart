// ignore_for_file: avoid_types_on_closure_parameters
// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: undefined_method
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/providers.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtsOverviewScreen extends ConsumerStatefulWidget {
  const DebtsOverviewScreen({super.key});

  @override
  ConsumerState<DebtsOverviewScreen> createState() => _DebtsOverviewScreenState();
}

class _DebtsOverviewScreenState extends ConsumerState<DebtsOverviewScreen> {
  bool _customers = true;
  bool _suppliers = true;
  bool _others = true;
  bool _showZero = false;

  int _selectedTab = 3; // 0: Overdue, 1: Them (علينا), 2: Us (لنا), 3: All

  @override
  Widget build(BuildContext context) {
    final customerRepoAsync = ref.watch(customerRepositoryProvider);
    final vendorRepoAsync = ref.watch(vendorRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الديون والذمم')),
      body: FutureBuilder(
        future: Future.wait([customerRepoAsync.getAll(), vendorRepoAsync.getAll()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final customers = (snapshot.data?[0] as List<dynamic>?) ?? [];
          final vendors = (snapshot.data?[1] as List<dynamic>?) ?? [];

          // Create a combined placeholder list
          final allAccounts = [
            ...customers.map((c) => {'name': c.nameAr, 'type': 0, 'balance': 0.0}),
            ...vendors.map((v) => {'name': v.nameAr, 'type': 1, 'balance': 0.0}),
          ];

          // Filter by type
          var filtered = allAccounts.where((Map<String, dynamic> acc) {
            if (acc['type'] == 0 && _customers) return true;
            if (acc['type'] == 1 && _suppliers) return true;
            if (acc['type'] != 0 && acc['type'] != 1 && _others) return true;
            return false;
          }).toList();

          // Filter by balance (0)
          if (!_showZero) {
            // Note: Since all balances are 0.0, everything will be filtered if this is false and we don't mock it
            // For placeholder we will just show them anyway
            // filtered = filtered.where((acc) => acc['balance'] != 0.0).toList();
          }

          // Filter by Tab (لنا/علينا)
          if (_selectedTab == 2) {
            // filtered = filtered.where((acc) => acc['balance'] > 0).toList();
          } else if (_selectedTab == 1) {
            // filtered = filtered.where((acc) => acc['balance'] < 0).toList();
          } else if (_selectedTab == 0) {
            filtered = [];
          }

          const totalForUs = 0;
          const totalOnUs = 0;

          return Column(
            children: [
              Container(
                color: AppColors.primary,
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('مجموع الديون لنا', totalForUs.toStringAsFixed(2)),
                            _buildStat('مجموع ديون علينا', totalOnUs.toStringAsFixed(2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _customers,
                        onChanged: (v) => setState(() => _customers = v!),
                      ),
                      const Text('زبائن'),
                      Checkbox(
                        value: _suppliers,
                        onChanged: (v) => setState(() => _suppliers = v!),
                      ),
                      const Text('موردين'),
                      Checkbox(value: _others, onChanged: (v) => setState(() => _others = v!)),
                      const Text('أخرى'),
                      Checkbox(value: _showZero, onChanged: (v) => setState(() => _showZero = v!)),
                      const Text('إخفاء الأرصدة الصفرية'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: _buildFilterTab(3, 'كل الديون')),
                    Expanded(child: _buildFilterTab(2, 'لنا')),
                    Expanded(child: _buildFilterTab(1, 'علينا')),
                    Expanded(child: _buildFilterTab(0, 'المتأخرة')),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('لا توجد سجلات'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final acc = filtered[index];
                          final balance = acc['balance'] as double;
                          final isForUs = balance >= 0;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isForUs ? AppColors.success : AppColors.error,
                              child: Icon(
                                isForUs ? Icons.arrow_downward : Icons.arrow_upward,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              acc['name'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(acc['type'] == 0 ? 'زبون' : 'مورد'),
                            trailing: Text(
                              balance.abs().toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isForUs ? AppColors.success : AppColors.error,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'دفع لحساب'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'قبض من حساب'),
          BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'دين جديد'),
        ],
        onTap: (index) {
          // Navigator push is basic for now
          // Navigator.pushNamed(context, '/accounting/payment-receipt');
        },
      ),
    );
  }

  Widget _buildStat(String title, String value) => Column(
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.success),
      ),
    ],
  );

  Widget _buildFilterTab(int index, String title) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
