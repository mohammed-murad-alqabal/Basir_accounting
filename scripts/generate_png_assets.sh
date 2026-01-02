#!/bin/bash
# PNG Asset Generator using Flutter's native rendering
# This script uses Flutter test infrastructure to render CustomPainter to PNG

set -e

echo "🎨 Generating Basir 2.0 PNG Assets..."

# Use flutter test to render the CustomPainter
flutter test test/tools/export_basir_assets.dart --timeout=60s

# Verify PNG format
echo ""
echo "✅ Verifying asset formats:"
file assets/icons/app_icon.png
file assets/icons/splash_logo.png
file assets/icons/app_icon_foreground.png

echo ""
echo "📊 Asset sizes:"
ls -lh assets/icons/*.png

echo ""
echo "✨ PNG generation complete!"
