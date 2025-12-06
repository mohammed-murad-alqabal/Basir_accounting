import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// أداة لاختبار الأزرار والنصوص مع textScaleFactor مختلفة.
///
/// توفر هذه الأداة واجهة تفاعلية لاختبار كيفية تكيف الأزرار والنصوص
/// مع textScaleFactor من 1.0 إلى 2.0، مما يساعد في التحقق من عدم وجود
/// قص للنصوص في جميع الحالات.
///
/// **الميزات:**
/// - شريط تحكم تفاعلي مع slider
/// - أزرار مسبقة للقيم الشائعة (1.0x, 1.2x, 1.5x, 1.8x, 2.0x)
/// - يظهر فقط في debug mode
/// - تحديث فوري للمحتوى
///
/// **مثال:**
/// ```dart
/// TextScaleFactorTester(
///   child: Scaffold(
///     body: Column(
///       children: [
///         AppEnhancedButton(text: 'اختبار', onPressed: () {}),
///       ],
///     ),
///   ),
/// )
/// ```
class TextScaleFactorTester extends StatefulWidget {
  /// ينشئ أداة اختبار text scale factor جديدة.
  ///
  /// [child] الـ widget الذي سيتم اختباره.
  /// [showControls] إظهار أزرار التحكم (افتراضي: true).
  /// [initialScale] القيمة الابتدائية للـ scale (افتراضي: 1.0).
  const TextScaleFactorTester({
    required this.child,
    super.key,
    this.showControls = true,
    this.initialScale = 1.0,
  });

  /// المحتوى الذي سيتم اختباره
  final Widget child;

  /// هل يتم عرض شريط التحكم؟ (افتراضي: true)
  final bool showControls;

  /// قيمة textScaleFactor الأولية (افتراضي: 1.0)
  final double initialScale;

  @override
  State<TextScaleFactorTester> createState() => _TextScaleFactorTesterState();
}

class _TextScaleFactorTesterState extends State<TextScaleFactorTester> {
  late double _textScaleFactor;

  @override
  void initState() {
    super.initState();
    _textScaleFactor = widget.initialScale;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // شريط التحكم (يظهر فقط في debug mode)
          if (widget.showControls && kDebugMode) _buildControlBar(),

          // المحتوى مع textScaleFactor المخصص
          Expanded(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(_textScaleFactor),
              ),
              child: widget.child,
            ),
          ),
        ],
      );

  /// بناء شريط التحكم
  Widget _buildControlBar() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.2),
          border: Border(
            bottom: BorderSide(
              color: Colors.amber.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // عنوان وقيمة textScaleFactor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Text Scale Factor:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_textScaleFactor.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Slider
            Slider(
              value: _textScaleFactor,
              min: 1,
              max: 2,
              divisions: 10,
              label: '${_textScaleFactor.toStringAsFixed(1)}x',
              activeColor: Colors.amber.shade700,
              inactiveColor: Colors.amber.shade200,
              onChanged: (value) {
                setState(() => _textScaleFactor = value);
              },
            ),

            const SizedBox(height: 8),

            // أزرار القيم المسبقة
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPresetButton('1.0x', 1),
                  _buildPresetButton('1.2x', 1.2),
                  _buildPresetButton('1.5x', 1.5),
                  _buildPresetButton('1.8x', 1.8),
                  _buildPresetButton('2.0x', 2),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ملاحظة
            const Text(
              '⚠️ هذه الأداة تظهر فقط في debug mode',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  /// بناء زر قيمة مسبقة
  Widget _buildPresetButton(String label, double value) {
    final isSelected = (_textScaleFactor - value).abs() < 0.01;

    return ElevatedButton(
      onPressed: () {
        setState(() => _textScaleFactor = value);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.amber.shade700 : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.amber.shade700,
            width: 2,
          ),
        ),
        elevation: isSelected ? 4 : 1,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
