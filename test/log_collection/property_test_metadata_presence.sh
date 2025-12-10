#!/bin/bash

################################################################################
# Property-Based Test: Log Metadata Presence
#
# Feature: error-tracking-system
# Property 4: Log Metadata Presence
# Validates: Requirements 1.4
#
# الخاصية:
#   لأي إدخال سجل جديد، يجب أن يتضمن timestamp دقيق وmetadata كاملة.
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_metadata_$$"
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

run_collect_logs() {
    cd "$TEST_DIR" || return 1
    "$TEST_DIR/scripts/collect_logs.sh" > /dev/null 2>&1
}

check_metadata() {
    local log_file=$(ls -t "$LOGS_DIR"/*.log 2>/dev/null | head -1)
    
    [ ! -f "$log_file" ] && return 1
    
    # التحقق من وجود timestamp بصيغة صحيحة
    if ! grep -E "Timestamp: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" "$log_file" > /dev/null; then
        return 1
    fi
    
    # التحقق من وجود metadata أساسية
    grep -q "Status:" "$log_file" || return 1
    grep -q "===" "$log_file" || return 1
    
    return 0
}

test_property() {
    local iteration=$1
    
    run_collect_logs
    
    if check_metadata; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 4: Log Metadata Presence"
    echo "=========================================="
    echo ""
    echo "الخاصية: كل سجل يجب أن يحتوي على timestamp دقيق وmetadata كاملة"
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
