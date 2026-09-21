// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabelCustomizationScreen extends ConsumerStatefulWidget {
  const LabelCustomizationScreen({super.key});

  @override
  ConsumerState<LabelCustomizationScreen> createState() => _LabelCustomizationScreenState();
}

class _LabelCustomizationScreenState extends ConsumerState<LabelCustomizationScreen> {
  String _selectedReport = 'الفواتير';
  late SharedPreferences _prefs;
  bool _isLoading = true;

  final List<String> _reportTypes = [
    'الفواتير',
    'فاتورة حرارية',
    'السندات',
    'عروض الأسعار',
    'تروسية التقارير',
    'كشف حساب',
    'كشف حساب المصغر',
    'جرد المستودع',
    'قائمة الديون',
  ];

  final List<String> _labelNames = [
    'له',
    'مُرصد',
    'مجموع ديون علينا',
    'مجموع الديون لنا',
    'المبلغ المتبقي',
    'ملاحظة: أرصدة الحساب',
    'الخصم',
    'دفعة نقدية',
  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (final label in _labelNames) {
      _controllers[label] = TextEditingController();
    }
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadLabelsForReport(_selectedReport);
    setState(() {
      _isLoading = false;
    });
  }

  void _loadLabelsForReport(String reportType) {
    for (final label in _labelNames) {
      final savedValue = _prefs.getString('label_${reportType}_$label');
      _controllers[label]!.text = savedValue ?? label;
    }
  }

  Future<void> _saveLabels() async {
    for (final label in _labelNames) {
      final value = _controllers[label]!.text;
      await _prefs.setString('label_${_selectedReport}_$label', value);
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حفظ التسميات بنجاح ✅')));
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تغيير تسميات التقارير'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                const Text(
                  'اختر التقرير لتغيير تسمياته',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedReport,
                    items: _reportTypes
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedReport = val;
                          _loadLabelsForReport(val);
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.sm),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              itemCount: _labelNames.length,
              itemBuilder: (context, index) {
                final originalLabel = _labelNames[index];
                return _buildLabelEditor(originalLabel);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _saveLabels,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'حفظ الإعدادات',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelEditor(String originalLabel) => Card(
    margin: const EdgeInsets.only(bottom: Spacing.md),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Spacing.sm)),
    child: Padding(
      padding: const EdgeInsets.all(Spacing.md),
      child: Column(
        children: [
          Text(
            'التسمية الاصلية: $originalLabel',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: _controllers[originalLabel],
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Spacing.sm)),
              isDense: true,
            ),
          ),
        ],
      ),
    ),
  );
}
