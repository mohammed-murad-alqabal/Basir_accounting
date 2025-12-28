import 'dart:io';
import 'dart:ui' as ui;

import 'package:basser_app/core/assets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Generate Mastery 2.0 PNG Assets to External Storage',
      (tester) async {
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
      {
        'name': 'splash_logo_transparent.png',
        'size': 1024.0,
        'bg': Colors.transparent, // Transparent for native splash overlay
      },
    ];

    // Use app-scoped storage (no permissions needed)
    final directory = await getApplicationDocumentsDirectory();
    final outputDir = '${directory.path}/basser_assets';
    final dir = Directory(outputDir);
    // ignore: avoid_slow_async_io
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    debugPrint('📂 Output directory: $outputDir');

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
                    child: BasserLogo(size: size * 0.8),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(milliseconds: 1000));

      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint('❌ RenderRepaintBoundary not found for $name');
        continue;
      }

      try {
        final image = await boundary.toImage();
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final bytes = byteData!.buffer.asUint8List();

        debugPrint(
          'ℹ️ Captured: ${image.width}x${image.height}, '
          'Bytes: ${bytes.length}',
        );

        // Write directly to external storage
        final file = File('$outputDir/$name');
        await file.writeAsBytes(bytes);

        debugPrint('✅ Saved $name to ${file.path}');
      } on Exception catch (e) {
        debugPrint('❌ Error capturing image for $name: $e');
      }
    }

    debugPrint('✨ All assets saved to $outputDir');
    debugPrint(
      '📱 Pull with: adb pull /sdcard/Download/basser_assets assets/icons/',
    );
  });
}
