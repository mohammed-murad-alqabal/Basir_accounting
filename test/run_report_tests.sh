#!/bin/bash

###############################################################################
# سكريبت تشغيل اختبارات نظام التقارير
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORTS_DIR="$SCRIPT_DIR/reports"

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "═══════════════════════════════════════════════════════════════"
echo "   تشغيل اختبارات نظام التقارير - بصير MVP"
echo "═══════════════════════════════════════════════════════════════"
echo ""

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .sh)
    
    echo -e "${BLUE}🧪 تشغيل: $test_name${NC}"
    
    if bash "$test_file"; then
        ((PASSED_TESTS++))
        echo -e "${GREEN}✅ نجح: $test_name${NC}"
    else
        ((FAILED_TESTS++))
        echo -e "${RED}❌ فشل: $test_name${NC}"
    fi
    
    ((TOTAL_TESTS++))
    echo ""
}

# تشغيل جميع الاختبارات
for test_file in "$REPORTS_DIR"/property_test_*.sh; do
    if [ -f "$test_file" ]; then
        run_test "$test_file"
    fi
done

# النتائج النهائية
echo "═══════════════════════════════════════════════════════════════"
echo "النتائج النهائية"
echo "═══════════════════════════════════════════════════════════════"
echo "إجمالي الاختبارات: $TOTAL_TESTS"
echo -e "${GREEN}نجح: $PASSED_TESTS${NC}"
echo -e "${RED}فشل: $FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ جميع الاختبارات نجحت!${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}❌ بعض الاختبارات فشلت${NC}"
    exit 1
fi
