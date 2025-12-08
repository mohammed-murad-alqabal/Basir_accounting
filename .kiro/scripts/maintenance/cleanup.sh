#!/bin/bash
set -e
echo "🧹 Cleaning up..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
echo "✅ Cleanup complete!"
