#!/bin/bash
echo "🚀 تحسين سريع للبيئة التطويرية..."
flutter clean && flutter pub get
dart run build_runner build --delete-conflicting-outputs
echo "✅ تم التحسين بنجاح!"