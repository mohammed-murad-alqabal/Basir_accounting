#!/bin/bash

# سكريبت تنظيف شامل لمشروع بصير
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 5 ديسمبر 2025

echo "🧹 بدء عملية التنظيف الشامل..."
echo "================================"

# تنظيف build
echo ""
echo "📦 تنظيف مجلد build..."
if [ -d "build" ]; then
    SIZE_BEFORE=$(du -sh build 2>/dev/null | cut -f1)
    flutter clean
    echo "   ✅ تم تنظيف build (كان: $SIZE_BEFORE)"
else
    echo "   ℹ️  مجلد build غير موجود"
fi

# تنظيف logs
echo ""
echo "📝 تنظيف مجلد logs..."
if [ -d "logs" ]; then
    SIZE_BEFORE=$(du -sh logs 2>/dev/null | cut -f1)
    rm -rf logs/*
    mkdir -p logs
    echo "   ✅ تم تنظيف logs (كان: $SIZE_BEFORE)"
else
    mkdir -p logs
    echo "   ✅ تم إنشاء مجلد logs"
fi

# تنظيف coverage القديمة
echo ""
echo "📊 تنظيف ملفات coverage القديمة (أكثر من 7 أيام)..."
if [ -d "coverage" ]; then
    DELETED=$(find coverage -type f -mtime +7 2>/dev/null | wc -l)
    find coverage -type f -mtime +7 -delete 2>/dev/null
    echo "   ✅ تم حذف $DELETED ملف قديم"
else
    echo "   ℹ️  مجلد coverage غير موجود"
fi

# تنظيف Gradle cache
echo ""
echo "🔧 تنظيف Gradle cache..."
if [ -d "$HOME/.gradle/caches" ]; then
    rm -rf ~/.gradle/caches/transforms-* 2>/dev/null
    rm -rf ~/.gradle/caches/build-cache-* 2>/dev/null
    echo "   ✅ تم تنظيف Gradle cache"
else
    echo "   ℹ️  Gradle cache غير موجود"
fi

# تنظيف Flutter cache
echo ""
echo "🎯 إصلاح Flutter pub cache..."
flutter pub cache repair > /dev/null 2>&1
echo "   ✅ تم إصلاح Flutter cache"

# تنظيف Dart analysis cache
echo ""
echo "🔍 تنظيف Dart analysis cache..."
if [ -d ".dart_tool/flutter_build" ]; then
    rm -rf .dart_tool/flutter_build
    echo "   ✅ تم تنظيف Dart analysis cache"
else
    echo "   ℹ️  Dart analysis cache غير موجود"
fi

# حساب المساحة المحررة
echo ""
echo "================================"
echo "✅ اكتمل التنظيف بنجاح!"
echo ""
echo "💡 نصائح:"
echo "   • قم بتشغيل 'flutter pub get' لاستعادة التبعيات"
echo "   • قم بتشغيل 'flutter build' عند الحاجة"
echo "   • استخدم هذا السكريبت أسبوعياً للحفاظ على الأداء"
echo ""
