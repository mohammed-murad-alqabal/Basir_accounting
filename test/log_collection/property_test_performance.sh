#!/bin/bash

################################################################################
# Property-Based Test: Log Collection Performance
#
# Feature: error-tracking-system
# Property 22: Log Collection Performance
# Validates: Requirements 10.3
#
# الخاصية:
#   لأي تنفيذ لسكريبت جمع السجلات، يجب أن يكتمل التنفيذ
#   في أقل من دقيقة واحدة (60 ثانية).
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_performance_$$"
LOGS_DIR="$TEST_DIR/logs"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=20  # عدد أقل للاختبارات الأداء
MAX_EXECUTION_TIME=60  # 60 ثانية

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

measure_execution_time() {
    cd "$TEST_DIR" || return 1
    
    local start_time=$(date +%s)
    "$TEST_DIR/scripts/collect_logs.sh" > /dev/null 2>&1
    local end_time=$(date +%s)
    
    local duration=$((end_time - start_time))
    echo "$duration"
}

test_property() {
    local iteration=$1
    
    # قياس وقت التنفيذ
    local execution_time=$(measure_execution_time)
    
    # التحقق: يجب أن يكون أقل من 60 ثانية
    if [ "$execution_time" -lt "$MAX_EXECUTION_TIME" ]; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS (Time: ${execution_time}s)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Time: ${execution_time}s > ${MAX_EXECUTION_TIME}s)"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 22: Log Collection Performance"
    echo "=========================================="
    echo ""
    echo "الخاصية: جمع السجلات يجب أن يكتمل في أقل من 60 ثانية"
    echo "عدد التكرارات: $TOTAL_ITERATIONS"
    echo ""
    
    setup
    echo "جاري تشغيل اختبارات الأداء..."
    echo ""
    
    local total_time=0
    local min_time=999999
    local max_time=0
    
    for ((i=1; i<=TOTAL_ITERATIONS; i++)); do
        rm -rf "$LOGS_DIR"
        mkdir -p "$LOGS_DIR"
        
        local start=$(date +%s)
        test_property "$i"
        local end=$(date +%s)
        local duration=$((end - start))
        
        total_time=$((total_time + duration))
        [ $duration -lt $min_time ] && min_time=$duration
        [ $duration -gt $max_time ] && max_time=$duration
    done
    
    local avg_time=$((total_time / TOTAL_ITERATIONS))
    
    echo ""
    echo "=========================================="
    echo "النتائج النهائية"
    echo "=========================================="
    echo -e "إجمالي التكرارات: $TOTAL_ITERATIONS"
    echo -e "${GREEN}نجح: $PASSED${NC}"
    echo -e "${RED}فشل: $FAILED${NC}"
    echo "نسبة النجاح: $((PASSED * 100 / TOTAL_ITERATIONS))%"
    echo ""
    echo "إحصائيات الأداء:"
    echo "  الحد الأدنى: ${min_time}s"
    echo "  المتوسط: ${avg_time}s"
    echo "  الحد الأقصى: ${max_time}s"
    echo "  المطلوب: < ${MAX_EXECUTION_TIME}s"
    echo ""
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}✓ الخاصية محققة - الأداء ممتاز${NC}"
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة - الأداء بحاجة لتحسين${NC}"
        exit 1
    fi
}

main
