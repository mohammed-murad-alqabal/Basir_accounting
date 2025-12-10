#!/bin/bash
# Install Git Hooks - Error Tracking System
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 3 ديسمبر 2025

set -e

# الألوان
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔧 تثبيت Git Hooks...${NC}"
echo ""

# التحقق من وجود مجلد .git
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  هذا ليس مستودع Git${NC}"
    exit 1
fi

# نسخ pre-commit hook
if [ -f "scripts/hooks/pre-commit" ]; then
    cp scripts/hooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo -e "${GREEN}✅ تم تثبيت pre-commit hook${NC}"
else
    echo -e "${YELLOW}⚠️  ملف pre-commit غير موجود${NC}"
fi

# نسخ commit-msg hook
if [ -f "scripts/hooks/commit-msg" ]; then
    cp scripts/hooks/commit-msg .git/hooks/commit-msg
    chmod +x .git/hooks/commit-msg
    echo -e "${GREEN}✅ تم تثبيت commit-msg hook${NC}"
else
    echo -e "${YELLOW}⚠️  ملف commit-msg غير موجود${NC}"
fi

# نسخ pre-push hook (سيتم إنشاؤه لاحقاً)
if [ -f "scripts/hooks/pre-push" ]; then
    cp scripts/hooks/pre-push .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    echo -e "${GREEN}✅ تم تثبيت pre-push hook${NC}"
fi

echo ""
echo -e "${GREEN}✅ تم تثبيت Git Hooks بنجاح!${NC}"
echo ""
echo -e "${YELLOW}ملاحظة: يمكنك تعطيل الـ hooks من ملف التكوين:${NC}"
echo -e "${YELLOW}  .kiro/config/error_tracking.yml${NC}"
echo ""

exit 0
