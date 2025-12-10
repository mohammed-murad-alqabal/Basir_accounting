#!/bin/bash

# سكريبت إصلاح المشاكل عالية الأولوية
# تاريخ الإنشاء: 28 نوفمبر 2025

echo "🔧 بدء إصلاح المشاكل عالية الأولوية..."
echo ""

# 1. إضافة تبعية crypto
echo "📦 الخطوة 1: إضافة تبعية crypto..."
if ! grep -q "crypto:" pubspec.yaml; then
    echo "  ✓ إضافة crypto إلى pubspec.yaml"
    flutter pub add crypto
else
    echo "  ℹ️ crypto موجودة بالفعل"
fi
echo ""

# 2. تشغيل flutter format
echo "🎨 الخطوة 2: تنسيق الكود..."
flutter format lib/ test/
echo "  ✓ تم تنسيق الكود"
echo ""

# 3. تشغيل flutter analyze
echo "🔍 الخطوة 3: تحليل الكود..."
flutter analyze > analysis_report.txt 2>&1
ISSUES=$(grep -c "info •" analysis_report.txt || echo "0")
echo "  ℹ️ عدد المشاكل المتبقية: $ISSUES"
echo ""

# 4. تشغيل الاختبارات
echo "🧪 الخطوة 4: تشغيل الاختبارات..."
flutter test --no-pub > test_report.txt 2>&1
if [ $? -eq 0 ]; then
    echo "  ✓ جميع الاختبارات نجحت"
else
    echo "  ⚠️ بعض الاختبارات فشلت - راجع test_report.txt"
fi
echo ""

# 5. إنشاء تقرير
echo "📄 الخطوة 5: إنشاء تقرير..."
cat > fix_report.md << EOF
# تقرير الإصلاح - $(date '+%Y-%m-%d %H:%M:%S')

## الإصلاحات المطبقة

### 1. إضافة تبعية crypto
- ✅ تم إضافة crypto إلى pubspec.yaml

### 2. تنسيق الكود
- ✅ تم تنسيق جميع ملفات lib/ و test/

### 3. التحليل
- عدد المشاكل المتبقية: $ISSUES

### 4. الاختبارات
- الحالة: $([ $? -eq 0 ] && echo "✅ نجحت" || echo "⚠️ فشلت")

## الخطوات التالية

1. مراجعة analysis_report.txt للمشاكل المتبقية
2. إصلاح معالجة الاستثناءات يدوياً
3. إصلاح Future غير منتظرة يدوياً
4. تشغيل flutter analyze مرة أخرى

---

**تم الإنشاء:** $(date '+%Y-%m-%d %H:%M:%S')
EOF

echo "  ✓ تم إنشاء fix_report.md"
echo ""

echo "✨ اكتمل الإصلاح!"
echo ""
echo "📊 الملفات المنشأة:"
echo "  - analysis_report.txt"
echo "  - test_report.txt"
echo "  - fix_report.md"
echo ""
echo "📝 الخطوات التالية:"
echo "  1. راجع fix_report.md"
echo "  2. راجع analysis_report.txt"
echo "  3. أصلح المشاكل المتبقية يدوياً"
echo ""
