#!/bin/bash
# Run Hooks Tests
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🧪 تشغيل اختبارات Git Hooks...${NC}"
echo ""

# التحقق من تثبيت bats
if ! command -v bats &> /dev/null; then
    echo -e "${RED}❌ bats غير مثبت${NC}"
    echo "يرجى تثبيته باستخدام:"
    echo "  Ubuntu/Debian: sudo apt-get install bats"
    echo "  macOS: brew install bats-core"
    exit 1
fi

# تشغيل اختبارات commit message validation
if [ -f "test/hooks/test_commit_message_validation.sh" ]; then
    echo -e "${GREEN}📋 اختبار التحقق من رسائل الـ commit...${NC}"
    bats test/hooks/test_commit_message_validation.sh
    echo ""
fi

echo -e "${GREEN}✅ جميع اختبارات الـ Hooks نجحت!${NC}"
exit 0
