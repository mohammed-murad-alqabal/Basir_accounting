#!/bin/bash

# بصير MVP - Figma Integration Test Script
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

echo "🧪 اختبار تكامل Figma..."
echo "========================="

# تحميل متغيرات البيئة
if [ -f ".env" ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "❌ ملف .env غير موجود"
    exit 1
fi

# التحقق من المتطلبات
if [ -z "$FIGMA_ACCESS_TOKEN" ]; then
    echo "❌ FIGMA_ACCESS_TOKEN غير محدد في .env"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 غير مثبت"
    exit 1
fi

# تثبيت requests إذا لم يكن مثبت
python3 -c "import requests" 2>/dev/null || pip3 install requests

echo "✅ المتطلبات جاهزة"

# اختبار معلومات المستخدم
echo ""
echo "� اختبار مالاتصال..."
USER_INFO=$(python3 scripts/figma_api.py me 2>/dev/null)

if echo "$USER_INFO" | grep -q '"error"'; then
    echo "❌ فشل الاتصال بـ Figma API"
    echo "$USER_INFO"
    exit 1
fi

USER_NAME=$(echo "$USER_INFO" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('handle', 'Unknown'))")
echo "✅ متصل بنجاح - المستخدم: $USER_NAME"

echo ""
echo "📋 الاستخدام:"
echo "=============="
echo "# معلومات المستخدم"
echo "python3 scripts/figma_api.py me"
echo ""
echo "# معلومات ملف تصميم"
echo "python3 scripts/figma_api.py file FILE_KEY"
echo ""
echo "# تعليقات ملف"
echo "python3 scripts/figma_api.py comments FILE_KEY"
echo ""
echo "💡 للحصول على FILE_KEY: انسخ الرقم من URL الملف في Figma"
echo ""
echo "✅ تكامل Figma جاهز!"