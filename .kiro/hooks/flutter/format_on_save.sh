#!/bin/bash

# Flutter Code Formatting Hook - On Save
# المشروع: بصير MVP - workspace-transformation
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Flutter Code Formatting Hook - On Save${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter first.${NC}"
    exit 1
fi

# التحقق من وجود dart
if ! command -v dart &> /dev/null; then
    echo -e "${RED}❌ Dart not found. Please install Dart first.${NC}"
    exit 1
fi

# الحصول على قائمة الملفات المعدلة
CHANGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(dart)$' || true)

if [ -z "$CHANGED_FILES" ]; then
    echo -e "${GREEN}✅ No Dart files to format${NC}"
    exit 0
fi

echo -e "${YELLOW}📝 Formatting Dart files...${NC}"

# تنسيق كل ملف
FORMAT_ERRORS=0
for file in $CHANGED_FILES; do
    if [ -f "$file" ]; then
        echo -e "  ${BLUE}→${NC} Formatting: $file"
        
        # تنسيق الملف
        if dart format "$file" --set-exit-if-changed > /dev/null 2>&1; then
            echo -e "    ${GREEN}✅ Formatted successfully${NC}"
            # إضافة الملف المنسق إلى staging
            git add "$file"
        else
            echo -e "    ${YELLOW}⚠️  Already formatted${NC}"
        fi
    fi
done

# تشغيل flutter analyze على الملفات المعدلة
echo -e "${YELLOW}🔍 Running Flutter analyze...${NC}"
if flutter analyze --no-preamble > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Flutter analyze passed${NC}"
else
    echo -e "${RED}❌ Flutter analyze failed. Please fix issues before committing.${NC}"
    flutter analyze --no-preamble
    exit 1
fi

# التحقق من import sorting
echo -e "${YELLOW}📦 Checking import organization...${NC}"
for file in $CHANGED_FILES; do
    if [ -f "$file" ]; then
        # التحقق من ترتيب imports
        if dart fix --apply "$file" > /dev/null 2>&1; then
            echo -e "  ${GREEN}✅${NC} Imports organized: $file"
            git add "$file"
        fi
    fi
done

echo -e "${GREEN}🎉 All formatting checks passed!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"

exit 0