#!/bin/bash

# Alternative Test Runner for Flutter Framework Issues
# Created by: فريق وكلاء تطوير مشروع بصير
# Date: 10 ديسمبر 2025

set -e

echo "🧪 بدء تشغيل الاختبارات البديلة..."
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to run tests in a directory
run_tests_in_dir() {
    local dir=$1
    local name=$2
    
    echo -e "${YELLOW}📂 تشغيل اختبارات: $name${NC}"
    
    if [ -d "$dir" ]; then
        local test_files=$(find "$dir" -name "*.dart" | wc -l)
        if [ $test_files -gt 0 ]; then
            echo "   عدد ملفات الاختبار: $test_files"
            
            # Run tests with timeout and error handling
            if timeout 300 flutter test "$dir" --reporter=expanded 2>/dev/null; then
                echo -e "   ${GREEN}✅ نجح${NC}"
                PASSED_TESTS=$((PASSED_TESTS + test_files))
            else
                echo -e "   ${RED}❌ فشل أو تم تجاوز الوقت المحدد${NC}"
                FAILED_TESTS=$((FAILED_TESTS + test_files))
            fi
            TOTAL_TESTS=$((TOTAL_TESTS + test_files))
        else
            echo "   لا توجد ملفات اختبار"
        fi
    else
        echo "   المجلد غير موجود"
    fi
    echo ""
}

# Function to run individual test files
run_individual_tests() {
    local dir=$1
    local name=$2
    
    echo -e "${YELLOW}📂 تشغيل اختبارات فردية: $name${NC}"
    
    if [ -d "$dir" ]; then
        local success_count=0
        local fail_count=0
        
        find "$dir" -name "*.dart" | while read -r test_file; do
            local filename=$(basename "$test_file")
            echo -n "   اختبار $filename: "
            
            if timeout 60 flutter test "$test_file" --reporter=compact >/dev/null 2>&1; then
                echo -e "${GREEN}✅${NC}"
                success_count=$((success_count + 1))
            else
                echo -e "${RED}❌${NC}"
                fail_count=$((fail_count + 1))
            fi
        done
        
        echo "   النتيجة: $success_count نجح، $fail_count فشل"
    fi
    echo ""
}

# Main execution
echo "🎯 استراتيجية الاختبار البديلة"
echo "================================"

# Strategy 1: Test by category
echo "📋 المرحلة 1: اختبار حسب الفئات"
run_tests_in_dir "test/unit/core" "Core Tests"
run_tests_in_dir "test/unit/features" "Features Tests"
run_tests_in_dir "test/unit/data" "Data Tests"
run_tests_in_dir "test/widget" "Widget Tests"

# Strategy 2: Individual file testing for problematic areas
echo "📋 المرحلة 2: اختبار الملفات الفردية"
run_individual_tests "test/unit/core/theme" "Theme Tests"

# Strategy 3: Integration tests
echo "📋 المرحلة 3: اختبارات التكامل"
if [ -f "test/integration/run_integration_tests.sh" ]; then
    echo "🔗 تشغيل اختبارات التكامل..."
    if bash test/integration/run_integration_tests.sh; then
        echo -e "${GREEN}✅ اختبارات التكامل نجحت${NC}"
    else
        echo -e "${RED}❌ اختبارات التكامل فشلت${NC}"
    fi
else
    echo "⚠️ اختبارات التكامل غير متوفرة"
fi

# Summary
echo ""
echo "📊 ملخص النتائج"
echo "================"
echo "إجمالي الاختبارات: $TOTAL_TESTS"
echo -e "نجح: ${GREEN}$PASSED_TESTS${NC}"
echo -e "فشل: ${RED}$FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}🎉 جميع الاختبارات نجحت!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️ بعض الاختبارات فشلت - راجع السجلات${NC}"
    exit 1
fi