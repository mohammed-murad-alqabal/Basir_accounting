#!/bin/bash
# Hook: 30_update_docs.sh
# Type: on-save
# Description: تحديث التوثيق تلقائياً عند حفظ الملفات
# Project: بصير MVP (Flutter)
# Compliance: يطبق مبدأ Transparency من steering/philosophy.md

# هذا الـ hook يعمل عند حفظ ملفات معينة
# يمكن تفعيله من Kiro IDE

# الملف المحفوظ (يتم تمريره من Kiro)
SAVED_FILE="${1:-}"

if [ -z "$SAVED_FILE" ]; then
    exit 0
fi

echo "📝 تحديث التوثيق..."

# 1. إذا تم حفظ ملف في lib/، تحديث API docs
if [[ "$SAVED_FILE" == lib/* ]] && [[ "$SAVED_FILE" == *.dart ]]; then
    # التحقق من وجود تعليقات DartDoc
    if grep -q "///" "$SAVED_FILE"; then
        echo "   ✅ الملف يحتوي على DartDoc comments"
    else
        echo "   ⚠️  الملف لا يحتوي على DartDoc comments"
        echo "   💡 يُنصح بإضافة /// للتوثيق"
    fi
fi

# 2. إذا تم حفظ ملف spec، تحديث SPECS_ANALYSIS_REPORT.md
if [[ "$SAVED_FILE" == .kiro/specs/* ]]; then
    echo "   📋 تم تحديث spec: $SAVED_FILE"
    # يمكن إضافة منطق لتحديث التقرير تلقائياً
fi

# 3. إذا تم حفظ README.md، التحقق من الروابط
if [[ "$SAVED_FILE" == "README.md" ]]; then
    echo "   📖 تم تحديث README.md"
    # التحقق من الروابط المكسورة
    if command -v markdown-link-check &> /dev/null; then
        markdown-link-check README.md
    fi
fi

exit 0
