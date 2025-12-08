#!/bin/bash
set -e
echo "🚀 Building all platforms..."
./build-android.sh
./build-ios.sh
./build-web.sh
echo "✅ All builds complete!"
