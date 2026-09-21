// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧾 شاشة تقرير كشف الحساب
///
/// تتيح استعراض كشف حساب مفصل أو مختصر لعميل/مورد/حساب معين
/// خلال فترة زمنية محددة.
class AccountStatementScreen extends ConsumerStatefulWidget {
  const AccountStatementScreen({super.key});

  @override
  ConsumerState<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends ConsumerState<AccountStatementScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isSimplified = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف الحساب'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {
              // TODO(m): استدعاء خدمة الطباعة PdfInvoiceService.generateStatementPdf
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('جاري تجهيز الكشف للطباعة...')));
            },
            tooltip: 'تصدير PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── أدوات الفلترة ──
          Container(
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // اختيار الحساب
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'الحساب',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('مؤسسة الأفق (عميل)')),
                    DropdownMenuItem(value: '2', child: Text('شركة التوريدات (مورد)')),
                  ],
                  onChanged: (v) {},
                  hint: const Text('اختر الحساب...'),
                ),
                const SizedBox(height: Spacing.md),
                // التاريخ
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text('من: ${_formatDate(_startDate)}'),
                        onPressed: () => _selectDate(true),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text('إلى: ${_formatDate(_endDate)}'),
                        onPressed: () => _selectDate(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Checkbox(
                      value: _isSimplified,
                      onChanged: (v) => setState(() => _isSimplified = v!),
                      activeColor: primary,
                    ),
                    const Text('عرض كشف مبسط'),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {}, // TODO(m): جلب البيانات
                      child: const Text('عرض التقرير'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── ملخص الأرصدة ──
          Container(
            color: primary.withValues(alpha: 0.05),
            padding: const EdgeInsets.symmetric(vertical: Spacing.md),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryBox(title: 'رصيد سابق', value: '1,500.00'),
                _SummaryBox(title: 'إجمالي الحركات', value: '3,200.00'),
                _SummaryBox(title: 'الرصيد الحالي', value: '4,700.00', isBold: true),
              ],
            ),
          ),

          // ── الجدول التجريبي ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Spacing.md),
              children: [
                _buildTransactionRow(
                  date: '2023-10-01',
                  desc: 'رصيد افتتاحي',
                  debit: '1500',
                  credit: '0',
                  balance: '1500',
                ),
                _buildTransactionRow(
                  date: '2023-10-05',
                  desc: 'فاتورة مبيعات #1024',
                  debit: '3200',
                  credit: '0',
                  balance: '4700',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow({
    required String date,
    required String desc,
    required String debit,
    required String credit,
    required String balance,
    bool isHeader = false,
  }) {
    final style = isHeader
        ? const TextStyle(fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 12);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: style)),
          Expanded(flex: 3, child: Text(desc, style: style)),
          Expanded(
            flex: 2,
            child: Text(debit, style: style.copyWith(color: Colors.green)),
          ),
          Expanded(
            flex: 2,
            child: Text(credit, style: style.copyWith(color: Colors.red)),
          ),
          Expanded(
            flex: 2,
            child: Text(balance, style: style.copyWith(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({required this.title, required this.value, this.isBold = false});
  final String title;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isBold ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
    ],
  );
}
