#!/bin/bash

# Targeted Error Fix Script
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 18 ديسمبر 2025

echo "🎯 Targeted Error Fix"
echo "════════════════════════════════════════════════════════════════"

# 1. إصلاح الفواصل الخاطئة في الـ constructors
echo "🔧 Fixing constructor commas..."

# إصلاح {super.key},) إلى {super.key})
find lib/ -name "*.dart" -exec sed -i 's/{super\.key},)/{super.key})/' {} \;

# إصلاح (,) إلى ()
find lib/ -name "*.dart" -exec sed -i 's/(,)/()/' {} \;

# إصلاح  ,); إلى );
find lib/ -name "*.dart" -exec sed -i 's/ ,);/);/' {} \;

echo "✅ Constructor commas fixed"

# 2. إصلاح مشاكل الـ generated files
echo "🔄 Regenerating code..."

# حذف الملفات المولدة التالفة
find lib/ -name "*.g.dart" -delete
find lib/ -name "*.freezed.dart" -delete

# إعادة توليد الكود
flutter packages pub run build_runner build --delete-conflicting-outputs

echo "✅ Code regenerated"

# 3. فحص النتائج
echo "🔍 Checking results..."
ISSUES=$(flutter analyze 2>&1 | grep -o "[0-9]* issues found" | grep -o "[0-9]*" || echo "0")

echo ""
echo "📊 Current issues: $ISSUES"

if [ "$ISSUES" -lt 50 ]; then
    echo "✅ Excellent progress!"
elif [ "$ISSUES" -lt 100 ]; then
    echo "⚠️ Good progress, more fixes needed"
else
    echo "❌ Significant issues remain"
fi