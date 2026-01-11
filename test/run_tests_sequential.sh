#!/bin/bash

# نظام بصير المحاسبي - استراتيجية تنفيذ الاختبارات المتسلسلة
# Basir Accounting System - Sequential Test Execution Strategy
# المؤلف: فريق وكلاء تطوير نظام بصير المحاسبي

set -e

echo "🧪 بدء تنفيذ الاختبارات المتسلسلة لنظام بصير المحاسبي"
echo "🧪 Starting Sequential Test Execution for Basir Accounting System"
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
START_TIME=$(date +%s)

# Function to run a test category
run_test_category() {
    local category=$1
    local description=$2
    
    echo -e "\n${YELLOW}📋 تنفيذ: $description${NC}"
    echo -e "${YELLOW}📋 Running: $description${NC}"
    
    if [ -d "test/$category" ]; then
        for test_file in $(find test/$category -name "*_test.dart" -type f); do
            echo -e "  🔍 اختبار: $(basename $test_file)"
            echo -e "  🔍 Testing: $(basename $test_file)"
            
            if flutter test "$test_file" --reporter=compact > /dev/null 2>&1; then
                echo -e "  ${GREEN}✅ نجح${NC}"
                ((PASSED_TESTS++))
            else
                echo -e "  ${RED}❌ فشل${NC}"
                echo -e "  ${RED}❌ Failed: $test_file${NC}"
                ((FAILED_TESTS++))
            fi
            ((TOTAL_TESTS++))
        done
    else
        echo -e "  ${YELLOW}⚠️  المجلد غير موجود: test/$category${NC}"
        echo -e "  ${YELLOW}⚠️  Directory not found: test/$category${NC}"
    fi
}

# Function to run individual test files
run_individual_tests() {
    local pattern=$1
    local description=$2
    
    echo -e "\n${YELLOW}📋 تنفيذ: $description${NC}"
    echo -e "${YELLOW}📋 Running: $description${NC}"
    
    for test_file in $(find test -name "$pattern" -type f); do
        echo -e "  🔍 اختبار: $(basename $test_file)"
        echo -e "  🔍 Testing: $(basename $test_file)"
        
        if flutter test "$test_file" --reporter=compact > /dev/null 2>&1; then
            echo -e "  ${GREEN}✅ نجح${NC}"
            ((PASSED_TESTS++))
        else
            echo -e "  ${RED}❌ فشل${NC}"
            echo -e "  ${RED}❌ Failed: $test_file${NC}"
            ((FAILED_TESTS++))
        fi
        ((TOTAL_TESTS++))
    done
}

echo -e "\n${GREEN}🔧 التحقق من التحليل الثابت${NC}"
echo -e "${GREEN}🔧 Running Static Analysis${NC}"
if flutter analyze; then
    echo -e "${GREEN}✅ التحليل الثابت نجح${NC}"
    echo -e "${GREEN}✅ Static Analysis Passed${NC}"
else
    echo -e "${RED}❌ التحليل الثابت فشل${NC}"
    echo -e "${RED}❌ Static Analysis Failed${NC}"
    exit 1
fi

# Run test categories sequentially
run_test_category "core" "اختبارات النواة الأساسية (Core Tests)"
run_test_category "unit" "اختبارات الوحدة (Unit Tests)"
run_individual_tests "*_test.dart" "الاختبارات المتبقية (Remaining Tests)"

# Calculate execution time
END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME - START_TIME))

# Print summary
echo -e "\n=================================================="
echo -e "${GREEN}📊 ملخص النتائج / Results Summary${NC}"
echo -e "=================================================="
echo -e "⏱️  وقت التنفيذ / Execution Time: ${EXECUTION_TIME}s"
echo -e "📈 إجمالي الاختبارات / Total Tests: $TOTAL_TESTS"
echo -e "${GREEN}✅ نجح / Passed: $PASSED_TESTS${NC}"

if [ $FAILED_TESTS -gt 0 ]; then
    echo -e "${RED}❌ فشل / Failed: $FAILED_TESTS${NC}"
    echo -e "\n${RED}🚨 بعض الاختبارات فشلت${NC}"
    echo -e "${RED}🚨 Some tests failed${NC}"
    exit 1
else
    echo -e "${GREEN}❌ فشل / Failed: $FAILED_TESTS${NC}"
    echo -e "\n${GREEN}🎉 جميع الاختبارات نجحت!${NC}"
    echo -e "${GREEN}🎉 All tests passed!${NC}"
fi

echo -e "\n${GREEN}✨ نظام بصير المحاسبي جاهز للإنتاج${NC}"
echo -e "${GREEN}✨ Basir Accounting System is Production Ready${NC}"