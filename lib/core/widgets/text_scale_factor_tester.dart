import 'package:basser_app/core/widgets/app_enhanced_button.dart';
import 'package:flutter/material.dart';

/// أداة اختبار textScaleFactor للتحقق من عدم قص النصوص.
///
/// تتيح هذه الأداة اختبار الأزرار والعناصر مع قيم textScaleFactor مختلفة
/// للتأكد من عدم حدوث قص أو overflow في أي حالة.
///
/// مثال:
/// ```dart
/// TextScaleFactorTester(
///   child: AppEnhancedButton(
///     text: 'نص طويل للاختبار',
///     onPressed: () {},
///   ),
/// )
/// ```
class TextScaleFactorTester extends StatefulWidget {
  /// ينشئ أداة اختبار textScaleFactor جديدة.
  const TextScaleFactorTester({
    required this.child,
    super.key,
    this.initialScaleFactor = 1.0,
    this.minScaleFactor = 0.8,
    this.maxScaleFactor = 2.0,
    this.stepSize = 0.1,
    this.showControls = true,
    this.showInfo = true,
  });

  /// العنصر المراد اختباره
  final Widget child;

  /// قيمة textScaleFactor الابتدائية
  final double initialScaleFactor;

  /// أقل قيمة textScaleFactor
  final double minScaleFactor;

  /// أكبر قيمة textScaleFactor
  final double maxScaleFactor;

  /// حجم الخطوة في التغيير
  final double stepSize;

  /// هل يتم عرض أدوات التحكم
  final bool showControls;

  /// هل يتم عرض معلومات القيمة الحالية
  final bool showInfo;

  @override
  State<TextScaleFactorTester> createState() => _TextScaleFactorTesterState();
}

class _TextScaleFactorTesterState extends State<TextScaleFactorTester> {
  late double _currentScaleFactor;

  @override
  void initState() {
    super.initState();
    _currentScaleFactor = widget.initialScaleFactor;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (widget.showInfo) _buildInfoPanel(),
          if (widget.showControls) _buildControlPanel(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildTestArea(),
          ),
        ],
      );

  /// يبني لوحة المعلومات.
  Widget _buildInfoPanel() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختبار textScaleFactor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'القيمة الحالية: ${_currentScaleFactor.toStringAsFixed(1)}x',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
              ),
            ),
            Text(
              'النطاق: ${widget.minScaleFactor.toStringAsFixed(1)}x - '
              '${widget.maxScaleFactor.toStringAsFixed(1)}x',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade600,
              ),
            ),
          ],
        ),
      );

  /// يبني لوحة التحكم.
  Widget _buildControlPanel() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${widget.minScaleFactor.toStringAsFixed(1)}x',
                  style: const TextStyle(fontSize: 12),
                ),
                Expanded(
                  child: Slider(
                    value: _currentScaleFactor,
                    min: widget.minScaleFactor,
                    max: widget.maxScaleFactor,
                    divisions:
                        ((widget.maxScaleFactor - widget.minScaleFactor) /
                                widget.stepSize)
                            .round(),
                    label: '${_currentScaleFactor.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      setState(() {
                        _currentScaleFactor = value;
                      });
                    },
                  ),
                ),
                Text(
                  '${widget.maxScaleFactor.toStringAsFixed(1)}x',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickButton('0.8x', 0.8),
                _buildQuickButton('1.0x', 1),
                _buildQuickButton('1.3x', 1.3),
                _buildQuickButton('1.5x', 1.5),
                _buildQuickButton('2.0x', 2),
              ],
            ),
          ],
        ),
      );

  /// يبني زر سريع لقيمة معينة.
  Widget _buildQuickButton(String label, double value) {
    final isActive = (_currentScaleFactor - value).abs() < 0.05;

    return ElevatedButton(
      onPressed:
          value >= widget.minScaleFactor && value <= widget.maxScaleFactor
              ? () {
                  setState(() {
                    _currentScaleFactor = value;
                  });
                }
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : null,
        foregroundColor: isActive ? Colors.white : null,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(50, 32),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  /// يبني منطقة الاختبار.
  Widget _buildTestArea() => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(_currentScaleFactor),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: SingleChildScrollView(
            child: widget.child,
          ),
        ),
      );
}

/// أداة اختبار شاملة للأزرار المحسّنة.
///
/// تعرض مجموعة من الأزرار بأنماط وأحجام مختلفة لاختبار شامل.
class EnhancedButtonTestSuite extends StatelessWidget {
  /// ينشئ مجموعة اختبار شاملة للأزرار.
  const EnhancedButtonTestSuite({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('اختبار الأزرار المحسّنة'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
        body: TextScaleFactorTester(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection('أزرار أساسية', _buildPrimaryButtons()),
                const SizedBox(height: 24),
                _buildSection('أزرار ثانوية', _buildSecondaryButtons()),
                const SizedBox(height: 24),
                _buildSection('أزرار بحدود', _buildOutlinedButtons()),
                const SizedBox(height: 24),
                _buildSection('أزرار نصية', _buildTextButtons()),
                const SizedBox(height: 24),
                _buildSection('أحجام مختلفة', _buildSizeVariations()),
                const SizedBox(height: 24),
                _buildSection('حالات خاصة', _buildSpecialCases()),
              ],
            ),
          ),
        ),
      );

  /// يبني قسم من الاختبارات.
  Widget _buildSection(String title, Widget content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      );

  /// يبني أزرار أساسية للاختبار.
  Widget _buildPrimaryButtons() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppEnhancedButton(
            text: 'حفظ',
            onPressed: () {},
            icon: Icons.save,
          ),
          AppEnhancedButton(
            text: 'إضافة عميل جديد',
            onPressed: () {},
            icon: Icons.add,
          ),
          AppEnhancedButton(
            text: 'نص طويل جداً قد يسبب مشاكل في العرض',
            onPressed: () {},
          ),
        ],
      );

  /// يبني أزرار ثانوية للاختبار.
  Widget _buildSecondaryButtons() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppEnhancedButton(
            text: 'تعديل',
            onPressed: () {},
            icon: Icons.edit,
            style: AppEnhancedButtonStyle.secondary,
          ),
          AppEnhancedButton(
            text: 'عرض التفاصيل الكاملة للعنصر المحدد',
            onPressed: () {},
            style: AppEnhancedButtonStyle.secondary,
          ),
        ],
      );

  /// يبني أزرار بحدود للاختبار.
  Widget _buildOutlinedButtons() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppEnhancedButton(
            text: 'إلغاء',
            onPressed: () {},
            style: AppEnhancedButtonStyle.outlined,
          ),
          AppEnhancedButton(
            text: 'حذف العنصر المحدد نهائياً',
            onPressed: () {},
            icon: Icons.delete,
            style: AppEnhancedButtonStyle.outlined,
          ),
        ],
      );

  /// يبني أزرار نصية للاختبار.
  Widget _buildTextButtons() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppEnhancedButton(
            text: 'تخطي',
            onPressed: () {},
            style: AppEnhancedButtonStyle.text,
          ),
          AppEnhancedButton(
            text: 'عرض المزيد من الخيارات المتاحة',
            onPressed: () {},
            style: AppEnhancedButtonStyle.text,
          ),
        ],
      );

  /// يبني أحجام مختلفة للاختبار.
  Widget _buildSizeVariations() => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppEnhancedButton(
                  text: 'صغير',
                  onPressed: () {},
                  size: AppEnhancedButtonSize.small,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppEnhancedButton(
                  text: 'متوسط',
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppEnhancedButton(
                  text: 'كبير',
                  onPressed: () {},
                  size: AppEnhancedButtonSize.large,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppEnhancedButton(
            text: 'نص طويل جداً مع حجم صغير للاختبار',
            onPressed: () {},
            size: AppEnhancedButtonSize.small,
            icon: Icons.warning,
          ),
        ],
      );

  /// يبني حالات خاصة للاختبار.
  Widget _buildSpecialCases() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppEnhancedButton(
            text: 'تحميل...',
            onPressed: () {},
            isLoading: true,
          ),
          const AppEnhancedButton(
            text: 'معطل',
            onPressed: null,
            isEnabled: false,
          ),
          AppEnhancedButton(
            text: 'نص متعدد الأسطر يجب أن يظهر بشكل صحيح',
            onPressed: () {},
            maxLines: 2,
          ),
        ],
      );
}
