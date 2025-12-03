#!/bin/bash

# Pre-commit Hook - فحص الجودة
# يتم تشغيله تلقائياً قبل كل كوميت

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}🔍 Pre-commit: فحص الجودة...${NC}"
echo ""

# 1. فحص التنسيق
echo "▶ فحص التنسيق..."
if command -v flutter &> /dev/null; then
    if flutter format --set-exit-if-changed . > /dev/null 2>&1; then
        echo -e "${GREEN}✅ التنسيق صحيح${NC}"
    else
        echo -e "${YELLOW}⚠️  تطبيق التنسيق...${NC}"
        flutter format .
        git add -u
    fi
fi

# 2. فحص التحليل
echo "▶ فحص التحليل..."
if command -v flutter &> /dev/null; then
    if flutter analyze --no-pub > /dev/null 2>&1; then
        echo -e "${GREEN}✅ التحليل نظيف${NC}"
    else
        echo -e "${RED}❌ فشل التحليل${NC}"
        flutter analyze --no-pub
        exit 1
    fi
fi

# 3. فحص الأسرار
echo "▶ فحص الأسرار..."
if git diff --cached | grep -iE '(api[_-]?key|password|secret|token|private[_-]?key)' > /dev/null; then
    echo -e "${RED}❌ تم اكتشاف أسرار محتملة!${NC}"
    echo ""
    echo "الأسرار المكتشفة:"
    git diff --cached | grep -iE '(api[_-]?key|password|secret|token|private[_-]?key)'
    echo ""
    exit 1
else
    echo -e "${GREEN}✅ لا توجد أسرار${NC}"
fi

# 4. فحص حجم الملفات
echo "▶ فحص حجم الملفات..."
large_files=$(git diff --cached --name-only | xargs -I {} du -h {} 2>/dev/null | awk '$1 ~ /M$/ && $1+0 > 5')
if [ -n "$large_files" ]; then
    echo -e "${YELLOW}⚠️  ملفات كبيرة (> 5MB):${NC}"
    echo "$large_files"
else
    echo -e "${GREEN}✅ أحجام الملفات مقبولة${NC}"
fi

echo ""
echo -e "${GREEN}✅ جميع الفحوصات نجحت!${NC}"
echo ""

exit 0
