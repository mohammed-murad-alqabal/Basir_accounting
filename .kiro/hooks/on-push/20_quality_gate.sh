#!/bin/bash
# Hook: 20_quality_gate.sh
# Type: on-push
# Description: فحص جودة الكود قبل الـ push
# Project: بصير MVP (Flutter)
# Compliance: يطبق مبدأ Quality First من steering/philosophy.md

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Kiro Quality Gate (بصير MVP)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# عداد الأخطاء
ERRORS=0

# 1. فحص التنسيق (Formatting)
echo "📋 1. فحص تنسيق الكود..."
if ! dart format --set-exit-if-changed lib/ test/ 2>/dev/null; then
    echo "   ❌ الكود غير منسق بشكل صحيح"
    echo "   💡 قم بتشغيل: dart format lib/ test/"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ التنسيق صحيح"
fi

# 2. التحليل الثابت (Static Analysis)
echo ""
echo "📋 2. تحليل الكود (flutter analyze)..."
ANALYZE_OUTPUT=$(flutter analyze 2>&1)
ANALYZE_EXIT=$?

if [ $ANALYZE_EXIT -ne 0 ]; then
    echo "   ❌ توجد مشاكل في الكود"
    echo ""
    echo "$ANALYZE_OUTPUT" | grep -E "error|warning" | head -10
    echo ""
    echo "   💡 قم بإصلاح المشاكل قبل الـ push"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ لا توجد مشاكل"
fi

# 3. الاختبارات (Tests)
echo ""
echo "📋 3. تشغيل الاختبارات..."

# التحقق من وجود اختبارات
if [ -d "test" ] && [ "$(find test -name '*_test.dart' | wc -l)" -gt 0 ]; then
    if flutter test --no-pub 2>&1 | tee /tmp/test_output.txt; then
        echo "   ✅ جميع الاختبارات نجحت"
        
        # عرض ملخص الاختبارات
        PASSED=$(grep -c "All tests passed" /tmp/test_output.txt || echo "0")
        if [ "$PASSED" -gt 0 ]; then
            echo "   📊 الاختبارات: نجحت"
        fi
    else
        echo "   ❌ بعض الاختبارات فشلت"
        echo ""
        tail -20 /tmp/test_output.txt
        echo ""
        echo "   💡 قم بإصلاح الاختبارات الفاشلة قبل الـ push"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ⚠️  لا توجد اختبارات"
    echo "   💡 يُنصح بإضافة اختبارات (هدف: 70%+ coverage)"
fi

# 4. التحقق من التبعيات (Dependencies)
echo ""
echo "📋 4. التحقق من التبعيات..."
if flutter pub outdated --no-dependency-overrides 2>&1 | grep -q "All your dependencies are up to date"; then
    echo "   ✅ جميع التبعيات محدثة"
else
    echo "   ⚠️  توجد تبعيات قديمة"
    echo "   💡 قم بتحديث التبعيات: flutter pub upgrade"
    # لا نعتبرها خطأ، فقط تحذير
fi

# 5. التحقق من حجم التطبيق (Build Size)
echo ""
echo "📋 5. التحقق من حجم التطبيق..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "   📦 حجم APK: $SIZE"
    
    # التحقق من الحجم (يجب أن يكون < 50 MB)
    SIZE_MB=$(du -m build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    if [ "$SIZE_MB" -gt 50 ]; then
        echo "   ⚠️  حجم التطبيق كبير (> 50 MB)"
        echo "   💡 يُنصح بتحسين حجم التطبيق"
    else
        echo "   ✅ حجم التطبيق مناسب (< 50 MB)"
    fi
else
    echo "   ℹ️  لم يتم بناء التطبيق بعد"
fi

# النتيجة النهائية
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ]; then
    echo "✅ فحص الجودة اكتمل بنجاح"
    echo "✅ الكود جاهز للـ push"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    exit 0
else
    echo "❌ فحص الجودة فشل ($ERRORS مشكلة)"
    echo "❌ يرجى إصلاح المشاكل قبل الـ push"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "💡 نصائح:"
    echo "  • dart format lib/ test/"
    echo "  • flutter analyze"
    echo "  • flutter test"
    echo ""
    exit 1
fi
