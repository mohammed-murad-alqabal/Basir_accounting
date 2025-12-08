#!/bin/bash
# Setup project script

set -e

echo "🚀 Setting up Basser MVP project..."

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Generate code
echo "🔨 Generating code..."
flutter pub run build_runner build --delete-conflicting-outputs

# Setup git hooks
echo "🪝 Setting up git hooks..."
chmod +x .githooks/*
git config core.hooksPath .githooks

echo "✅ Project setup complete!"
