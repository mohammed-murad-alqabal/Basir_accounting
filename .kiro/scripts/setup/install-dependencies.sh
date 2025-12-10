#!/bin/bash
# Install all project dependencies

set -e

echo "📦 Installing dependencies..."

# Flutter dependencies
flutter pub get

# iOS dependencies (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🍎 Installing iOS dependencies..."
  cd ios && pod install && cd ..
fi

echo "✅ Dependencies installed!"
