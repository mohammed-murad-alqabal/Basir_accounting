import 'dart:convert';
import 'dart:ui' as ui;

import 'package:basir_accounting_system/core/assets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Generate Basir 2.0 PNG Assets on Device', (tester) async {
    // 1. Setup
    final exports = [
      {'name': 'app_icon.png', 'size': 1024.0, 'bg': Colors.white},
      {
        'name': 'splash_logo.png',
        'size': 1024.0,
        'bg': const Color(0xFF003D82),
      },
      {
        'name': 'app_icon_foreground.png',
        'size': 1024.0,
        'bg': Colors.transparent,
      },
    ];

    for (final config in exports) {
      final name = config['name']! as String;
      final size = config['size']! as double;
      final bg = config['bg']! as Color;

      debugPrint('🎨 Generating $name...');

      final boundaryKey = <credential-fixture>();

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: bg,
            body: Center(
              child: OverflowBox(
                minWidth: size,
                maxWidth: size,
                minHeight: size,
                maxHeight: size,
                child: RepaintBoundary(
                  key: <credential-fixture>,
                  child: Container(
                    width: size,
                    height: size,
                    color: bg,
                    alignment: Alignment.center,
                    child: BasirLogo(
                      size: size * 0.8,
                    ), // 80% padding for safe area
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for rendering to settle
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 1000));

      // Capture
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('❌ RenderRepaintBoundary not found for $name via Key');
        continue;
      }

      if (boundary.debugNeedsPaint) {
        debugPrint('⚠️ Boundary needs paint, pumping...');
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      try {
        final image = await boundary.toImage();
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final bytes = byteData!.buffer.asUint8List();

        debugPrint(
          'ℹ️ Captured: ${image.width}x${image.height}, '
          'Bytes: ${bytes.length}',
        );

        final base64String = base64Encode(bytes);
        // Use print for reliability
        debugPrint('BASE64_START:$name');

        const chunkSize = 1000;
        for (var i = 0; i < base64String.length; i += chunkSize) {
          final end = (i + chunkSize < base64String.length)
              ? i + chunkSize
              : base64String.length;
          debugPrint(base64String.substring(i, end));
          await Future<void>.delayed(const Duration(milliseconds: 1));
        }
        debugPrint('BASE64_END:$name');
        debugPrint('✅ Processed $name');
      } on Exception catch (e) {
        debugPrint('❌ Error capturing image for $name: $e');
      }
    }

    debugPrint('✨ All assets generated successfully!');
  });
}
