import 'dart:async';

import 'package:basser_app/core/widgets/app_enhanced_button.dart';
import 'package:basser_app/core/widgets/text_scale_factor_tester.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// شاشة اختبار شاملة للأزرار المحسّنة.
///
/// تتيح هذه الشاشة اختبار AppEnhancedButton في سيناريوهات مختلفة:
/// - textScaleFactor مختلفة (0.8x - 2.0x)
/// - نصوص طويلة جداً
/// - أنماط وأحجام مختلفة
/// - حالات خاصة (loading, disabled)
/// - مراقبة overflow warnings
class ButtonTestScreen extends StatefulWidget {
  const ButtonTestScreen({super.key});

  @override
  State<ButtonTestScreen> createState() => _ButtonTestScreenState();
}

class _ButtonTestScreenState extends State<ButtonTestScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final int _overflowCount = 0;
  final List<String> _testResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _logResult('بدء جلسة اختبار الأزرار المحسّنة');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logResult(String result) {
    setState(() {
      _testResults
          .add('${DateTime.now().toString().substring(11, 19)}: $result');
    });
    if (kDebugMode) {
      print('ButtonTest: $result');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('اختبار الأزرار المحسّنة'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'اختبار تفاعلي'),
              Tab(text: 'سيناريوهات متطرفة'),
              Tab(text: 'اختبار الأداء'),
              Tab(text: 'النتائج'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildInteractiveTestTab(),
            _buildExtremeTestTab(),
            _buildPerformanceTestTab(),
            _buildResultsTab(),
          ],
        ),
      );

  /// تبويب الاختبار التفاعلي مع TextScaleFactorTester.
  Widget _buildInteractiveTestTab() => TextScaleFactorTester(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTestSection('أزرار أساسية', [
                AppEnhancedButton(
                  text: 'حفظ',
                  onPressed: () => _logResult('تم الضغط على زر حفظ'),
                  icon: Icons.save,
                ),
                const SizedBox(height: 8),
                AppEnhancedButton(
                  text: 'إضافة عميل جديد للنظام',
                  onPressed: () => _logResult('تم الضغط على زر إضافة عميل'),
                  icon: Icons.add,
                ),
                const SizedBox(height: 8),
                AppEnhancedButton(
                  text: 'نص طويل جداً قد يسبب مشاكل في العرض والتخطيط',
                  onPressed: () => _logResult('تم الضغط على زر النص الطويل'),
                ),
              ]),
              const SizedBox(height: 16),
              _buildTestSection('أنماط مختلفة', [
                AppEnhancedButton(
                  text: 'زر ثانوي',
                  onPressed: () => _logResult('تم الضغط على الزر الثانوي'),
                  style: AppEnhancedButtonStyle.secondary,
                ),
                const SizedBox(height: 8),
                AppEnhancedButton(
                  text: 'زر بحدود',
                  onPressed: () => _logResult('تم الضغط على الزر بحدود'),
                  style: AppEnhancedButtonStyle.outlined,
                ),
                const SizedBox(height: 8),
                AppEnhancedButton(
                  text: 'زر نصي',
                  onPressed: () => _logResult('تم الضغط على الزر النصي'),
                  style: AppEnhancedButtonStyle.text,
                ),
              ]),
              const SizedBox(height: 16),
              _buildTestSection('أحجام مختلفة', [
                Row(
                  children: [
                    Expanded(
                      child: AppEnhancedButton(
                        text: 'صغير',
                        onPressed: () => _logResult('زر صغير'),
                        size: AppEnhancedButtonSize.small,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppEnhancedButton(
                        text: 'متوسط',
                        onPressed: () => _logResult('زر متوسط'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppEnhancedButton(
                        text: 'كبير',
                        onPressed: () => _logResult('زر كبير'),
                        size: AppEnhancedButtonSize.large,
                      ),
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      );

  /// تبويب السيناريوهات المتطرفة.
  Widget _buildExtremeTestTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTestSection('نصوص طويلة جداً', [
              AppEnhancedButton(
                text:
                    'هذا نص طويل جداً جداً جداً يهدف لاختبار قدرة الزر على التعامل مع النصوص الطويلة بدون حدوث قص أو مشاكل في التخطيط والعرض',
                onPressed: () => _logResult('نص طويل جداً - نجح'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              AppEnhancedButton(
                text:
                    'نص طويل مع أيقونة: إضافة عميل جديد إلى النظام مع جميع البيانات المطلوبة والتحقق من صحة المعلومات',
                onPressed: () => _logResult('نص طويل مع أيقونة - نجح'),
                icon: Icons.person_add,
                maxLines: 2,
              ),
            ]),
            const SizedBox(height: 16),
            _buildTestSection('حالات خاصة', [
              AppEnhancedButton(
                text: 'جاري التحميل...',
                onPressed: () => _logResult('زر التحميل'),
                isLoading: true,
              ),
              const SizedBox(height: 8),
              const AppEnhancedButton(
                text: 'زر معطل',
                onPressed: null,
                isEnabled: false,
              ),
              const SizedBox(height: 8),
              AppEnhancedButton(
                text: 'زر مع tooltip طويل',
                onPressed: () => _logResult('زر مع tooltip'),
                tooltip: 'هذا tooltip طويل يوضح وظيفة الزر بالتفصيل',
              ),
            ]),
            const SizedBox(height: 16),
            _buildTestSection('اختبار RTL', [
              AppEnhancedButton(
                text: 'English Text Button',
                onPressed: () => _logResult('English button'),
              ),
              const SizedBox(height: 8),
              AppEnhancedButton(
                text: 'نص عربي مختلط مع English text',
                onPressed: () => _logResult('Mixed text button'),
              ),
              const SizedBox(height: 8),
              AppEnhancedButton(
                text: '١٢٣٤٥ أرقام عربية مع نص',
                onPressed: () => _logResult('Arabic numbers button'),
              ),
            ]),
            const SizedBox(height: 16),
            _buildTestSection('اختبار الأحجام الصغيرة', [
              AppEnhancedButton(
                text: 'نص طويل جداً مع حجم صغير للاختبار المتطرف',
                onPressed: () => _logResult('حجم صغير مع نص طويل'),
                size: AppEnhancedButtonSize.small,
                maxLines: 3,
              ),
            ]),
          ],
        ),
      );

  /// تبويب اختبار الأداء.
  Widget _buildPerformanceTestTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إحصائيات الأداء',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('عدد تحذيرات Overflow: $_overflowCount'),
                    Text('عدد النتائج المسجلة: ${_testResults.length}'),
                    Text(
                      'وقت الجلسة: ${DateTime.now().difference(DateTime.now().subtract(const Duration(minutes: 1))).inMinutes} دقيقة',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTestSection('اختبار الكمية', [
              AppEnhancedButton(
                text: 'تشغيل اختبار 50 زر',
                onPressed: _runBulkTest,
                style: AppEnhancedButtonStyle.secondary,
                icon: Icons.speed,
              ),
              const SizedBox(height: 8),
              AppEnhancedButton(
                text: 'اختبار الضغط (100 زر)',
                onPressed: _runStressTest,
                style: AppEnhancedButtonStyle.outlined,
                icon: Icons.fitness_center,
              ),
            ]),
            const SizedBox(height: 16),
            if (_overflowCount > 0)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade600),
                          const SizedBox(width: 8),
                          Text(
                            'تحذير: تم اكتشاف overflow',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('عدد التحذيرات: $_overflowCount'),
                      const Text('يرجى مراجعة النتائج وإصلاح المشاكل'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );

  /// تبويب النتائج.
  Widget _buildResultsTab() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'سجل النتائج (${_testResults.length} نتيجة)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                AppEnhancedButton(
                  text: 'تصدير النتائج',
                  onPressed: _exportResults,
                  style: AppEnhancedButtonStyle.text,
                  size: AppEnhancedButtonSize.small,
                  icon: Icons.download,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _testResults.length,
              itemBuilder: (context, index) {
                final result = _testResults[_testResults.length - 1 - index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.green.shade100,
                    child: Text(
                      '${_testResults.length - index}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  title: Text(result),
                  dense: true,
                );
              },
            ),
          ),
        ],
      );

  /// يبني قسم اختبار مع عنوان.
  Widget _buildTestSection(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      );

  /// يشغل اختبار كمية (50 زر).
  void _runBulkTest() {
    _logResult('بدء اختبار الكمية (50 زر)');

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('اختبار الكمية'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 50,
              itemBuilder: (context, index) => AppEnhancedButton(
                text: 'زر رقم ${index + 1}',
                onPressed: () => _logResult('زر رقم ${index + 1}'),
                size: AppEnhancedButtonSize.small,
              ),
            ),
          ),
          actions: [
            AppEnhancedButton(
              text: 'إغلاق',
              onPressed: () {
                Navigator.of(context).pop();
                _logResult('انتهاء اختبار الكمية - نجح');
              },
              style: AppEnhancedButtonStyle.text,
              size: AppEnhancedButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }

  /// يشغل اختبار الضغط (100 زر).
  void _runStressTest() {
    _logResult('بدء اختبار الضغط (100 زر)');

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('اختبار الضغط'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 100,
              itemBuilder: (context, index) {
                final texts = [
                  'زر ${index + 1}',
                  'نص طويل للزر ${index + 1}',
                  'اختبار ${index + 1}',
                ];
                return AppEnhancedButton(
                  text: texts[index % 3],
                  onPressed: () => _logResult('اختبار ضغط ${index + 1}'),
                  size: AppEnhancedButtonSize.small,
                );
              },
            ),
          ),
          actions: [
            AppEnhancedButton(
              text: 'إغلاق',
              onPressed: () {
                Navigator.of(context).pop();
                _logResult('انتهاء اختبار الضغط - نجح');
              },
              style: AppEnhancedButtonStyle.text,
              size: AppEnhancedButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }

  /// يصدر النتائج.
  void _exportResults() {
    final results = _testResults.join('\n');
    _logResult('تم تصدير ${_testResults.length} نتيجة');

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تصدير النتائج'),
          content: SingleChildScrollView(
            child: SelectableText(results),
          ),
          actions: [
            AppEnhancedButton(
              text: 'إغلاق',
              onPressed: () => Navigator.of(context).pop(),
              style: AppEnhancedButtonStyle.text,
              size: AppEnhancedButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }
}
