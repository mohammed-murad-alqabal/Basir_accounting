/// سكريبت لتوليد أيقونة التطبيق برمجياً
///
/// يقوم بإنشاء أيقونة احترافية لتطبيق بصير
/// باستخدام Flutter's CustomPainter

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🎨 بدء توليد أيقونة التطبيق...');

  // إنشاء المجلدات
  final iconsDir = Directory('assets/icons');
  if (!iconsDir.existsSync()) {
    iconsDir.createSync(recursive: true);
  }

  // توليد الأيقونات بأحجام مختلفة
  await _generateIcon(1024, 'app_icon.png');
  await _generateIcon(512, 'app_icon_foreground.png');
  await _generateIcon(512, 'splash_logo.png');

  print('✅ تم توليد جميع الأيقونات بنجاح!');
  print('📁 الموقع: assets/icons/');
  print('');
  print('الخطوات التالية:');
  print('1. flutter pub run flutter_launcher_icons');
  print('2. dart run flutter_native_splash:create');
}

Future<void> _generateIcon(int size, String filename) async {
  print('  📝 توليد $filename (${size}x$size)...');

  // إنشاء canvas
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..isAntiAlias = true;

  // رسم الخلفية
  paint.color = const Color(0xFF0056B3);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    paint,
  );

  // رسم الشعار
  _drawLogo(canvas, size.toDouble());

  // تحويل إلى صورة
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  // حفظ الملف
  final file = File('assets/icons/$filename');
  await file.writeAsBytes(bytes);

  print('  ✅ تم حفظ $filename');
}

void _drawLogo(Canvas canvas, double size) {
  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.04
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final fillPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  // رسم الفاتورة (مستطيل مع حواف مدورة)
  final invoiceRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      size * 0.2,
      size * 0.15,
      size * 0.6,
      size * 0.7,
    ),
    Radius.circular(size * 0.05),
  );
  canvas.drawRRect(invoiceRect, paint);

  // رسم خطوط الفاتورة (3 خطوط أفقية)
  final lineY1 = size * 0.35;
  final lineY2 = size * 0.5;
  final lineY3 = size * 0.65;
  final lineStartX = size * 0.3;
  final lineEndX = size * 0.7;

  canvas
    ..drawLine(
      Offset(lineStartX, lineY1),
      Offset(lineEndX, lineY1),
      paint,
    )
    ..drawLine(
      Offset(lineStartX, lineY2),
      Offset(lineEndX * 0.95, lineY2),
      paint,
    )
    ..drawLine(
      Offset(lineStartX, lineY3),
      Offset(lineEndX * 0.9, lineY3),
      paint,
    );

  // رسم دائرة خلف علامة الصح
  canvas.drawCircle(
    Offset(size * 0.7, size * 0.75),
    size * 0.12,
    fillPaint,
  );

  // رسم علامة الصح (✓)
  final checkPaint = Paint()
    ..color = const Color(0xFF0056B3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.05
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final checkPath = Path()
    ..moveTo(size * 0.62, size * 0.75)
    ..lineTo(size * 0.68, size * 0.81)
    ..lineTo(size * 0.78, size * 0.69);

  canvas.drawPath(checkPath, checkPaint);
}
