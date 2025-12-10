#!/bin/bash

################################################################################
# سكريبت تشغيل اختبارات دفع السجلات إلى Git
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
#
# الوصف:
#   يقوم بتشغيل جميع اختبارات الخصائص لنظام دفع السجلات إلى Git
#
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/git_push"

# الألوان
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# عدادات
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo "=========================================="
echo "اختبارات نظام دفع السجلات إلى Git"
echo "=========================================="
echo ""

# قائمة الاختبارات
TESTS=(
    "property_test_commit_format.sh:Property 16: Commit Message Format Consistency"
    "property_test_skip_ci.sh:Property 17: Skip CI Tag Presence"
    "property_test_no_change.sh:Property 18: No-Change Detection"
)

# تشغيل كل اختبار
for test_info in "${TESTS[@]}"; do
    test_file=$(echo "$test_info" | cut -d':' -f1)
    test_name=$(echo "$test_info" | cut -d':' -f2-)
    
    ((TOTAL_TESTS++))
    
    echo -e "${BLUE}جاري تشغيل: $test_name${NC}"
    echo "----------------------------------------"
    
    if [ -f "$TEST_DIR/$test_file" ]; then
        if "$TEST_DIR/$test_file"; then
            echo -e "${GREEN}✓ نجح: $test_name${NC}"
            ((PASSED_TESTS++))
        else
            echo -e "${RED}✗ فشل: $test_name${NC}"
            ((FAILED_TESTS++))
        fi
    else
        echo -e "${RED}✗ الملف غير موجود: $test_file${NC}"
        ((FAILED_TESTS++))
    fi
    
    echo ""
    echo "=========================================="
    echo ""
done

# عرض الملخص النهائي
echo ""
echo "=========================================="
echo "الملخص النهائي"
echo "=========================================="
echo -e "إجمالي الاختبارات: $TOTAL_TESTS"
echo -e "${GREEN}نجح: $PASSED_TESTS${NC}"
echo -e "${RED}فشل: $FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ جميع الاختبارات نجحت!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}✗ بعض الاختبارات فشلت${NC}"
    exit 1
fi
