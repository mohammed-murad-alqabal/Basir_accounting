import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// أداة كشف القص (Overflow) في وضع التطوير.
///
/// تكتشف وتبلغ عن حالات قص النصوص أو العناصر في الواجهة.
/// تعمل فقط في وضع التطوير (debug mode) ولا تؤثر على الأداء في الإنتاج.
///
/// مثال:
/// ```dart
/// OverflowDetector(
///   child: Text('نص طويل جداً قد يسبب overflow'),
/// )
/// ```
class OverflowDetector extends StatefulWidget {
  /// ينشئ كاشف overflow جديد.
  const OverflowDetector({
    required this.child,
    super.key,
    this.name,
    this.showVisualWarning = true,
    this.logWarning = true,
  });

  /// العنصر الفرعي المراد مراقبته
  final Widget child;

  /// اسم العنصر للتعريف في التقارير
  final String? name;

  /// هل يتم عرض تحذير بصري عند اكتشاف overflow
  final bool showVisualWarning;

  /// هل يتم طباعة تحذير في console
  final bool logWarning;

  @override
  State<OverflowDetector> createState() => _OverflowDetectorState();
}

class _OverflowDetectorState extends State<OverflowDetector> {
  bool _hasOverflow = false;

  @override
  Widget build(BuildContext context) {
    // في وضع الإنتاج، نعرض العنصر مباشرة بدون مراقبة
    if (kReleaseMode) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) => _OverflowDetectorRenderObjectWidget(
        constraints: constraints,
        name: widget.name,
        onOverflowDetected: (details) {
          if (!_hasOverflow) {
            setState(() {
              _hasOverflow = true;
            });

            if (widget.logWarning) {
              _logOverflow(details);
            }
          }
        },
        child: Stack(
          children: [
            widget.child,
            if (_hasOverflow && widget.showVisualWarning) _buildVisualWarning(),
          ],
        ),
      ),
    );
  }

  /// يبني تحذير بصري عند اكتشاف overflow.
  Widget _buildVisualWarning() => Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning, size: 12, color: Colors.white),
              SizedBox(width: 2),
              Text(
                'OVERFLOW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  /// يسجل تحذير overflow في console.
  void _logOverflow(String details) {
    final name = widget.name ?? 'Unknown';
    developer.log(
      '⚠️ OVERFLOW DETECTED in "$name":\n$details',
      name: 'OverflowDetector',
      level: 900, // warning
    );
  }
}

/// Widget داخلي لمراقبة overflow.
class _OverflowDetectorRenderObjectWidget
    extends SingleChildRenderObjectWidget {
  const _OverflowDetectorRenderObjectWidget({
    required this.constraints,
    required this.onOverflowDetected,
    required Widget child,
    this.name,
  }) : super(child: child);
  final BoxConstraints constraints;
  final String? name;
  final void Function(String details) onOverflowDetected;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _OverflowDetectorRenderBox(
        constraints: constraints,
        name: name,
        onOverflowDetected: onOverflowDetected,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _OverflowDetectorRenderBox renderObject,
  ) {
    renderObject
      ..constraints = constraints
      ..name = name
      ..onOverflowDetected = onOverflowDetected;
  }
}

/// RenderBox مخصص لكشف overflow.
class _OverflowDetectorRenderBox extends RenderProxyBox {
  _OverflowDetectorRenderBox({
    required this.constraints,
    required this.onOverflowDetected,
    this.name,
  });
  @override
  BoxConstraints constraints;
  String? name;
  void Function(String details) onOverflowDetected;

  @override
  void performLayout() {
    super.performLayout();

    // التحقق من overflow بعد التخطيط
    if (child != null) {
      final childSize = child!.size;
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;

      final hasHorizontalOverflow = childSize.width > maxWidth;
      final hasVerticalOverflow = childSize.height > maxHeight;

      if (hasHorizontalOverflow || hasVerticalOverflow) {
        final details = _buildOverflowDetails(
          childSize: childSize,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          hasHorizontalOverflow: hasHorizontalOverflow,
          hasVerticalOverflow: hasVerticalOverflow,
        );
        onOverflowDetected(details);
      }
    }
  }

  /// يبني تفاصيل overflow.
  String _buildOverflowDetails({
    required Size childSize,
    required double maxWidth,
    required double maxHeight,
    required bool hasHorizontalOverflow,
    required bool hasVerticalOverflow,
  }) {
    final buffer = StringBuffer();

    if (hasHorizontalOverflow) {
      final overflow = childSize.width - maxWidth;
      buffer.writeln(
        '  Horizontal Overflow: ${overflow.toStringAsFixed(1)}px '
        '(child: ${childSize.width.toStringAsFixed(1)}px, '
        'max: ${maxWidth.toStringAsFixed(1)}px)',
      );
    }

    if (hasVerticalOverflow) {
      final overflow = childSize.height - maxHeight;
      buffer.writeln(
        '  Vertical Overflow: ${overflow.toStringAsFixed(1)}px '
        '(child: ${childSize.height.toStringAsFixed(1)}px, '
        'max: ${maxHeight.toStringAsFixed(1)}px)',
      );
    }

    return buffer.toString();
  }
}

/// مساعدات لكشف overflow في سياقات مختلفة.
class OverflowDetectorHelper {
  OverflowDetectorHelper._();

  /// يتحقق من overflow في Text widget.
  ///
  /// [text] النص المراد فحصه.
  /// [style] نمط النص.
  /// [maxWidth] العرض الأقصى المتاح.
  ///
  /// Returns true إذا كان النص سيتجاوز العرض المتاح.
  static bool willTextOverflow({
    required String text,
    required TextStyle style,
    required double maxWidth,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.rtl, // للنصوص العربية
    );

    textPainter.layout(maxWidth: maxWidth);
    final didExceedMaxLines = textPainter.didExceedMaxLines;
    textPainter.dispose();

    return didExceedMaxLines;
  }

  /// يحسب العرض المطلوب لنص معين.
  ///
  /// [text] النص المراد قياسه.
  /// [style] نمط النص.
  ///
  /// Returns العرض المطلوب بالبكسل.
  static double calculateTextWidth({
    required String text,
    required TextStyle style,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.rtl,
    );

    textPainter.layout();
    final width = textPainter.width;
    textPainter.dispose();

    return width;
  }

  /// يحسب الارتفاع المطلوب لنص معين.
  ///
  /// [text] النص المراد قياسه.
  /// [style] نمط النص.
  /// [maxWidth] العرض الأقصى المتاح.
  ///
  /// Returns الارتفاع المطلوب بالبكسل.
  static double calculateTextHeight({
    required String text,
    required TextStyle style,
    required double maxWidth,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
    );

    textPainter.layout(maxWidth: maxWidth);
    final height = textPainter.height;
    textPainter.dispose();

    return height;
  }

  /// يتحقق من أن الأبعاد المعطاة كافية للنص.
  ///
  /// [text] النص المراد فحصه.
  /// [style] نمط النص.
  /// [availableWidth] العرض المتاح.
  /// [availableHeight] الارتفاع المتاح.
  ///
  /// Returns Map يحتوي على نتائج الفحص.
  static Map<String, dynamic> checkTextFit({
    required String text,
    required TextStyle style,
    required double availableWidth,
    required double availableHeight,
    int? maxLines,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
    );

    textPainter.layout(maxWidth: availableWidth);

    final requiredWidth = textPainter.width;
    final requiredHeight = textPainter.height;
    final didExceedMaxLines = textPainter.didExceedMaxLines;

    textPainter.dispose();

    final fitsHorizontally = requiredWidth <= availableWidth;
    final fitsVertically = requiredHeight <= availableHeight;
    final fits = fitsHorizontally && fitsVertically && !didExceedMaxLines;

    return {
      'fits': fits,
      'fitsHorizontally': fitsHorizontally,
      'fitsVertically': fitsVertically,
      'exceedsMaxLines': didExceedMaxLines,
      'requiredWidth': requiredWidth,
      'requiredHeight': requiredHeight,
      'availableWidth': availableWidth,
      'availableHeight': availableHeight,
      'horizontalOverflow': requiredWidth - availableWidth,
      'verticalOverflow': requiredHeight - availableHeight,
    };
  }
}
