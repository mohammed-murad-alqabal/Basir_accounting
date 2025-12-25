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

  testWidgets('Generate Mastery 2.0 PNG Assets on Device', (tester) async {
    // 1. Setup
    final exports = [
      {
        'name': 'app_icon.png',
        'size': 1024.0,
        'bg': Colors.white,
      },
      {
        'name': 'splash_logo.png',
        'size': 1024.0,
        // Institutional Blue background for splash matching
        'bg': const Color(0xFF003D82),
      },
      {
        'name': 'app_icon_foreground.png',
        'size': 1024.0,
        'bg': Colors.transparent,
      },
    ];

    final directory = await getApplicationDocumentsDirectory();
    debugPrint('📂 Saving assets to: ${directory.path}');

    for (final config in exports) {
      final name = config['name']! as String;
      final size = config['size']! as double;
      final bg = config['bg']! as Color;

      debugPrint('🎨 Generating $name...');

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: bg, // Background color for the screenshot
            body: Center(
              child: RepaintBoundary(
                child: Container(
                  width: size,
                  height: size,
                  // Ensure logo is centered and sized correctly in container
                  alignment: Alignment.center,
                  child:
                      BasserLogo(size: size * 0.8), // 80% padding for safe area
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
      final boundary = tester.renderObject(find.byType(RepaintBoundary).last)
          as RenderRepaintBoundary;
      final image =
          await boundary.toImage(); // 1:1 pixel ratio for exact 1024x1024
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final file = File('${directory.path}/$name');
      await file.writeAsBytes(bytes);
      debugPrint('✅ Saved $name (${bytes.length} bytes) to ${file.path}');
    }

    debugPrint('✨ All assets generated successfully!');
  });
}
