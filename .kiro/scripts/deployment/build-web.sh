#!/bin/bash
set -e
echo "🌐 Building Web..."
flutter build web --release
echo "✅ Web build complete!"
