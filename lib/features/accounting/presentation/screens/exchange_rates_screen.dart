import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeRatesScreen extends ConsumerStatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  ConsumerState<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends ConsumerState<ExchangeRatesScreen> {
  String selectedBaseCurrency = 'ل.س';
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> currencies = [
    {'name': 'ريال يمني', 'symbol': 'YER', 'rate': '270'},
    {'name': 'دولار', 'symbol': 'USD', 'rate': '1'},
    {'name': 'يورو', 'symbol': 'EUR', 'rate': '0.92'},
    {'name': 'ريال سعودي', 'symbol': 'SAR', 'rate': '3.75'},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('أسعار الصرف')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'اختر العملة لتحديد سعر الصرف',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBaseCurrency,
                      isExpanded: true,
                      items: ['ل.س', 'دولار', 'يورو']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, textAlign: TextAlign.center),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => selectedBaseCurrency = v);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                flex: 3,
                child: Text(
                  'العملة الرئيسية للتعادل هي:',
                  style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_circle_right, color: AppColors.primary, size: 32),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_circle_left, color: AppColors.primary, size: 32),
                onPressed: () {},
              ),
            ],
          ),
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 8),
          for (final currency in currencies) ...[
            _buildCurrencyRow(currency['name'] as String, currency['rate'].toString()),
            const SizedBox(height: 8),
          ],
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حفظ التغييرات')));
            },
            icon: const Icon(Icons.save, color: AppColors.primary),
            label: const Text(
              'حفظ التغييرات',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade400,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    'يتم ربط العملات بالعملة المختارة في الاعلى',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    ),
  );

  Widget _buildCurrencyRow(String currencyName, String value) => Row(
    children: [
      Expanded(
        flex: 2,
        child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            currencyName,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 3,
        child: TextFormField(
          initialValue: value,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(isDense: true),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 2,
        child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            selectedBaseCurrency,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}
