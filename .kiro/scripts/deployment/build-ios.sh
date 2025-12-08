#!/bin/bash
set -e
echo "🍎 Building iOS..."
flutter build ios --release
echo "✅ iOS build complete!"
