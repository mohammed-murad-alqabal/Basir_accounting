#!/bin/bash
# Configure development environment

set -e

echo "⚙️ Configuring environment..."

# Create .env file if not exists
if [ ! -f .env ]; then
  echo "📝 Creating .env file..."
  cp .env.example .env
fi

# Setup Android keystore (if needed)
if [ ! -f android/app/keystore.jks ]; then
  echo "🔑 Android keystore not found. Please add it manually."
fi

echo "✅ Environment configured!"
