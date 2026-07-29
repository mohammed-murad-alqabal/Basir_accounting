import 'package:flutter/material.dart';

/// PatternDrawingWidget - Widget لرسم نمط التحقق
///
/// يوفر واجهة لرسم نمط مكون من 9 نقاط (3x3) مثل نظام Android
/// يدعم:
/// - رسم النمط باللمس
/// - التعرف على النمط
/// - التحقق من النمط
class PatternDrawingWidget extends StatefulWidget {
  const PatternDrawingWidget({
    super.key,
    this.onPatternComplete,
    this.size = 300,
    this.strokeWidth = 10,
    this.strokeColor,
    this.errorColor,
    this.successColor,
    this.radius = 25,
  });

  /// Callback عند اكتمال الرسم
  final void Function(List<int> pattern)? onPatternComplete;

  /// حجم الـ Widget
  final double size;

  /// سماكة الخط
  final double strokeWidth;

  /// لون الخط
  final Color? strokeColor;

  /// لون الخط عند الخطأ
  final Color? errorColor;

  /// لون الخط عند النجاح
  final Color? successColor;

  /// نصف قطر النقاط
  final double radius;

  @override
  State<PatternDrawingWidget> createState() => _PatternDrawingWidgetState();
}

class _PatternDrawingWidgetState extends State<PatternDrawingWidget> {
  late List<int> _currentPattern;
  late List<int> _completedPattern;
  bool _isDrawing = false;

  // إحداثيات النقاط (3x3 grid)
  static const List<Offset> _pointPositions = [
    Offset(0.25, 0.25), // 0
    Offset(0.5, 0.25), // 1
    Offset(0.75, 0.25), // 2
    Offset(0.25, 0.5), // 3
    Offset(0.5, 0.5), // 4
    Offset(0.75, 0.5), // 5
    Offset(0.25, 0.75), // 6
    Offset(0.5, 0.75), // 7
    Offset(0.75, 0.75), // 8
  ];

  // تحويل الإحداثيات من بكسل إلى موضع في الـ Grid
  Offset _getPointPosition(int index) {
    if (index < 0 || index >= _pointPositions.length) {
      return Offset.zero;
    }
    final pos = _pointPositions[index];
    return Offset(
      pos.dx * widget.size,
      pos.dy * widget.size,
    );
  }

  // التحقق مما إذا كان النمط صالحاً
  bool _isValidPattern(List<int> pattern) {
    if (pattern.length < 2) return false;
    if (pattern.length != pattern.toSet().length) return false;
    return true;
  }

  // التحقق مما إذا كانت النقطة متصلة بالسابقة
  bool _isPointConnected(int current, int previous) {
    if (previous == -1) return true;
    if (current == previous) return false;
    return true;
  }

  // التحقق مما إذا كانت النقطة موجودة بالفعل في النمط
  bool _isPointInPattern(int point) => _currentPattern.contains(point);

  // إضافة نقطة إلى النمط
  void _addPoint(int point) {
    if (_isPointInPattern(point)) return;

    final previous = _currentPattern.isEmpty ? -1 : _currentPattern.last;
    if (_isPointConnected(point, previous)) {
      setState(() {
        _currentPattern.add(point);
      });
    }
  }

  // تأكيد النمط
  void _confirmPattern() {
    if (_isValidPattern(_currentPattern)) {
      setState(() {
        _completedPattern = List.from(_currentPattern);
        _currentPattern = [];
      });
      widget.onPatternComplete?.call(_completedPattern);
    }
  }

  // معالجة اللمس
  void _handlePanUpdate(DragUpdateDetails details) {
    final offset = details.localPosition;
    _isDrawing = true;

    // التحقق من النقاط القريبة من الماوس
    for (var i = 0; i < _pointPositions.length; i++) {
      final pos = _getPointPosition(i);
      final distance = (offset.dx - pos.dx).abs() + (offset.dy - pos.dy).abs();
      if (distance < widget.radius) {
        if (!_isPointInPattern(i)) {
          _addPoint(i);
        }
        break;
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _isDrawing = false;
    _confirmPattern();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strokeColor = widget.strokeColor ?? theme.colorScheme.primary;
    final errorColor = widget.errorColor ?? Colors.red;
    final successColor = widget.successColor ?? Colors.green;

    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: PatternPainter(
          points: _pointPositions,
          currentPattern: _currentPattern,
          completedPattern: _completedPattern,
          size: widget.size,
          strokeWidth: widget.strokeWidth,
          strokeColor: strokeColor,
          errorColor: errorColor,
          successColor: successColor,
          radius: widget.radius,
          isDrawing: _isDrawing,
        ),
      ),
    );
  }
}

/// CustomPainter لرسم نمط التحقق
class PatternPainter extends CustomPainter {
  PatternPainter({
    required this.points,
    required this.currentPattern,
    required this.completedPattern,
    required this.size,
    required this.strokeWidth,
    required this.strokeColor,
    required this.errorColor,
    required this.successColor,
    required this.radius,
    required this.isDrawing,
  });

  final List<Offset> points;
  final List<int> currentPattern;
  final List<int> completedPattern;
  final double size;
  final double strokeWidth;
  final Color strokeColor;
  final Color errorColor;
  final Color successColor;
  final double radius;
  final bool isDrawing;

  @override
  void paint(Canvas canvas, Size size) {
    // رسم الخطوط
    if (completedPattern.isNotEmpty) {
      final paint = Paint()
        ..color = successColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (var i = 0; i < completedPattern.length - 1; i++) {
        final start = _getPointPosition(completedPattern[i]);
        final end = _getPointPosition(completedPattern[i + 1]);
        canvas.drawLine(start, end, paint);
      }
    }

    // رسم النمط الحالي
    if (currentPattern.isNotEmpty) {
      final paint = Paint()
        ..color = strokeColor
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // رسم الخطوط المتصلة
      for (var i = 0; i < currentPattern.length - 1; i++) {
        final start = _getPointPosition(currentPattern[i]);
        final end = _getPointPosition(currentPattern[i + 1]);
        canvas.drawLine(start, end, paint);
      }

      // رسم الخط المتصل بالماوس
      if (isDrawing && currentPattern.isNotEmpty) {
        final lastPoint = _getPointPosition(currentPattern.last);
        final secondLastPoint = currentPattern.length > 1
            ? _getPointPosition(currentPattern[currentPattern.length - 2])
            : lastPoint;

        final paintLine = Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawLine(secondLastPoint, lastPoint, paintLine);
      }
    }

    // رسم النقاط
    final pointPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final filledPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    for (var i = 0; i < points.length; i++) {
      final isPartOfPattern = currentPattern.contains(i) || completedPattern.contains(i);

      // رسم النقطة
      canvas.drawCircle(
        points[i],
        radius,
        isPartOfPattern ? filledPaint : pointPaint,
      );
    }
  }

  Offset _getPointPosition(int index) {
    if (index < 0 || index >= points.length) return Offset.zero;
    return points[index];
  }

  @override
  bool shouldRepaint(covariant PatternPainter oldDelegate) =>
      oldDelegate.currentPattern != currentPattern ||
      oldDelegate.completedPattern != completedPattern ||
      oldDelegate.isDrawing != isDrawing;
}
