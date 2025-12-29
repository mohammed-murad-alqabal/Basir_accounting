#!/bin/bash

# بصير MVP - Figma Integration Setup Script
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

echo "🎨 إعداد تكامل Figma..."
echo "======================="

# إنشاء .env إذا لم يكن موجود
if [ ! -f ".env" ]; then
    echo "📝 إنشاء ملف .env..."
    cp .env.example .env
fi

# إضافة متغيرات Figma إذا لم تكن موجودة
if ! grep -q "FIGMA_ACCESS_TOKEN=" .env; then
    echo "📝 إضافة متغيرات Figma..."
    echo "" >> .env
    echo "# Figma Integration" >> .env
    echo "FIGMA_ACCESS_TOKEN=your_figma_token_here" >> .env
    echo "FIGMA_TEAM_ID=your_team_id_here" >> .env
    echo "FIGMA_PROJECT_ID=your_project_id_here" >> .env
fi

echo "✅ الإعداد مكتمل"
echo ""
echo "📋 الخطوات التالية:"
echo "=================="
echo "1. احصل على Personal Access Token:"
echo "   https://www.figma.com/settings"
echo ""
echo "2. حدث FIGMA_ACCESS_TOKEN في .env"
echo ""
echo "3. اختبر التكامل:"
echo "   ./scripts/test_figma_integration.sh"
echo ""
echo "📚 دليل كامل:"
echo "   docs/FIGMA_INTEGRATION_GUIDE.md"