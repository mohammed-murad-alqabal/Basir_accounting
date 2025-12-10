#!/bin/bash

################################################################################
# Property-Based Test: Skip CI Tag Presence
#
# Feature: error-tracking-system
# Property 17: Skip CI Tag Presence
# Validates: Requirements 6.3
#
# الخاصية:
#   لأي commit للسجلات يتم إنشاؤه بواسطة النظام، يجب أن تحتوي
#   رسالة الـ commit على [skip ci] لتجنب تشغيل workflows غير ضرورية.
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_skip_ci_$$"
LOGS_DIR="$TEST_DIR/logs"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

setup() {
    mkdir -p "$TEST_DIR"/{lib,logs,scripts,.git}
    
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
    
    cd "$TEST_DIR" || exit 1
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    echo "test" > README.md
    git add README.md
    git commit -m "initial commit" > /dev/null 2>&1
}

cleanup() {
    [ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"
}

trap cleanup EXIT

create_log_changes() {
    echo "Test log entry $(date)" > "$LOGS_DIR/test_log_$RANDOM.log"
}

run_collect_with_push() {
    cd "$TEST_DIR" || return 1
    "$TEST_DIR/scripts/collect_logs.sh" --push > /dev/null 2>&1
}

check_skip_ci_tag() {
    cd "$TEST_DIR" || return 1
    
    local last_commit=$(git log -1 --pretty=%B 2>/dev/null)
    
    # التحقق من وجود [skip ci] في رسالة الـ commit
    if echo "$last_commit" | grep -q "\[skip ci\]"; then
        return 0
    fi
    
    return 1
}

test_property() {
    local iteration=$1
    
    create_log_changes
    run_collect_with_push
    
    if check_skip_ci_tag; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS ([skip ci] tag present)"
        ((PASSED++))
        return 0
    else
        local last_commit=$(cd "$TEST_DIR" && git log -1 --pretty=%B 2>/dev/null)
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Missing [skip ci] tag)"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 17: Skip CI Tag Presence"
    echo "=========================================="
    echo ""
    echo "الخاصية: رسائل الـ commit يجب أن تحتوي على [skip ci]"
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
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}✓ الخاصية محققة - جميع الـ commits تحتوي على [skip ci]${NC}"
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة${NC}"
        exit 1
    fi
}

main
