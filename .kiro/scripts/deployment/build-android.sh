#!/bin/bash
set -e
echo "🤖 Building Android..."
flutter build apk --release
flutter build appbundle --release
echo "✅ Android build complete!"
