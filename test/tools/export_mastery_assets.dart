import 'dart:io';
import 'dart:ui' as ui;

import 'package:basser_app/core/assets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Export Mastery 2.0 PNG Assets', (tester) async {
    // Setup for high-quality rendering
    const size = Size(1024, 1024);

    await tester.binding.setSurfaceSize(size);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    // Export configuration
    final exports = [
      {
        'path': 'assets/icons/app_icon.png',
        'size': 800.0,
        'bg': Colors.white,
      },
      {
        'path': 'assets/icons/splash_logo.png',
        'size': 600.0,
        'bg': const Color(0xFF003D82), // Institutional Blue background
      },
      {
        'path': 'assets/icons/app_icon_foreground.png',
        'size': 800.0,
        'bg': Colors.transparent, // Transparent for adaptive icon
      },
    ];

    for (final config in exports) {
      debugPrint('🎨 Exporting: ${config['path']}...');

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: config['bg']! as Color,
            body: Center(
              child: RepaintBoundary(
                child: BasserLogo(size: config['size']! as double),
              ),
            ),
          ),
        ),
      );

      // Allow rendering to complete
      await tester.pump();

      // Capture as PNG
      final boundary = tester.renderObject(find.byType(RepaintBoundary).first)
          as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save PNG file
      final file = File(config['path']! as String);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(pngBytes);

      debugPrint(
        '✅ Saved ${config['path']} (${pngBytes.length} bytes, PNG format)',
      );
    }

    debugPrint('✨ All Mastery 2.0 PNG assets generated successfully!');
  });
}
