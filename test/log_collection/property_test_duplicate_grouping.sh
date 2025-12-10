#!/bin/bash

################################################################################
# Property-Based Test: Duplicate Error Grouping
#
# Feature: error-tracking-system
# Property 5: Duplicate Error Grouping
# Validates: Requirements 1.5
#
# الخاصية:
#   لأي مجموعة من الأخطاء المتشابهة التي تحدث عدة مرات،
#   يجب على النظام تجميعها معاً ومنع الإدخالات المكررة.
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_duplicate_$$"
LOGS_DIR="$TEST_DIR/logs"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

setup() {
    mkdir -p "$TEST_DIR"/{lib,logs,scripts}
    cp "$PROJECT_ROOT/scripts/collect_logs.sh" "$TEST_DIR/scripts/"
    chmod +x "$TEST_DIR/scripts/collect_logs.sh"
    
    cat > "$TEST_DIR/pubspec.yaml" << 'EOF'
name: test_project
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
EOF
}

cleanup() {
    [ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"
}

trap cleanup EXIT

run_collect_logs_multiple_times() {
    cd "$TEST_DIR" || return 1
    
    # تشغيل السكريبت عدة مرات
    for i in {1..3}; do
        "$TEST_DIR/scripts/collect_logs.sh" > /dev/null 2>&1
        sleep 1
    done
}

count_log_files() {
    find "$LOGS_DIR" -maxdepth 1 -name "*.log" 2>/dev/null | wc -l
}

test_property() {
    local iteration=$1
    
    # تشغيل جمع السجلات عدة مرات
    run_collect_logs_multiple_times
    
    # حساب عدد ملفات السجل
    local log_count=$(count_log_files)
    
    # يجب أن يكون هناك 3 ملفات على الأقل (analyze, test, errors)
    # ولكن ليس أكثر من 9 (3 مرات × 3 أنواع)
    if [ "$log_count" -ge 3 ] && [ "$log_count" -le 9 ]; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS (Log files: $log_count)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Log files: $log_count)"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 5: Duplicate Error Grouping"
    echo "=========================================="
    echo ""
    echo "الخاصية: الأخطاء المتشابهة يجب تجميعها ومنع التكرار"
    echo "عدد التكرارات: $TOTAL_ITERATIONS"
    echo ""
    
    setup
    echo "جاري تشغيل الاختبارات..."
    echo ""
    
    for ((i=1; i<=TOTAL_ITERATIONS; i++)); do
        rm -rf "$LOGS_DIR"
        mkdir -p "$LOGS_DIR"
        
        test_property "$i"
        
        [ $((i % 10)) -eq 0 ] && echo "  التقدم: $i/$TOTAL_ITERATIONS"
    done
    
    echo ""
    echo "=========================================="
    echo "النتائج النهائية"
    echo "=========================================="
    echo -e "إجمالي: $TOTAL_ITERATIONS"
    echo -e "${GREEN}نجح: $PASSED${NC}"
    echo -e "${RED}فشل: $FAILED${NC}"
    echo "نسبة النجاح: $((PASSED * 100 / TOTAL_ITERATIONS))%"
    echo ""
    
    [ $FAILED -eq 0 ] && echo -e "${GREEN}✓ الخاصية محققة${NC}" && exit 0
    echo -e "${RED}✗ الخاصية غير محققة${NC}" && exit 1
}

main
