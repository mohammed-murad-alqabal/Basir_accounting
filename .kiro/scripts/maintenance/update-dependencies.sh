#!/bin/bash
set -e
echo "📦 Updating dependencies..."
flutter pub upgrade
flutter pub get
echo "✅ Dependencies updated!"
