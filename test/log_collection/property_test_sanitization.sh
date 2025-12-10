#!/bin/bash

################################################################################
# Property-Based Test: Sensitive Data Sanitization
#
# Feature: error-tracking-system
# Property 19: Sensitive Data Sanitization
# Validates: Requirements 9.1, 9.5
#
# الخاصية:
#   لأي إدخال سجل يحتوي على أنماط معلومات حساسة (كلمات مرور، رموز، مفاتيح)،
#   يجب على النظام إزالتها أو إخفاءها تلقائياً.
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_sanitize_$$"
LOGS_DIR="$TEST_DIR/logs"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

# أنماط البيانات الحساسة للاختبار
SENSITIVE_PATTERNS=(
    "password=<credential-fixture>"
    "api_key=<credential-fixture>"
    "token=<credential-fixture>"
    "secret=<credential-fixture>"
    "bearer abc123def456"
    "user@example.com"
    "555-123-4567"
)

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

create_log_with_sensitive_data() {
    local pattern=$1
    local log_file="$LOGS_DIR/test_log_$RANDOM.log"
    
    cat > "$log_file" << EOF
=== Test Log ===
Timestamp: $(date '+%Y-%m-%d %H:%M:%S')
Status: TEST
Error: Connection failed with $pattern
EOF
}

run_sanitization() {
    cd "$TEST_DIR" || return 1
    
    # تشغيل السكريبت الذي يقوم بالتنظيف
    "$TEST_DIR/scripts/collect_logs.sh" > /dev/null 2>&1
}

check_sanitization() {
    local pattern=$1
    local log_file=$(ls -t "$LOGS_DIR"/*.log 2>/dev/null | head -1)
    
    [ ! -f "$log_file" ] && return 1
    
    # التحقق من عدم وجود البيانات الحساسة
    if grep -q "REDACTED" "$log_file"; then
        return 0
    fi
    
    # إذا لم يتم العثور على REDACTED، تحقق من عدم وجود النمط الأصلي
    if ! grep -q "$pattern" "$log_file"; then
        return 0
    fi
    
    return 1
}

test_property() {
    local iteration=$1
    
    # اختيار نمط عشوائي
    local pattern_index=$((RANDOM % ${#SENSITIVE_PATTERNS[@]}))
    local pattern="${SENSITIVE_PATTERNS[$pattern_index]}"
    
    # إنشاء سجل مع بيانات حساسة
    create_log_with_sensitive_data "$pattern"
    
    # تشغيل التنظيف
    run_sanitization
    
    # التحقق من التنظيف
    if check_sanitization "$pattern"; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS (Pattern sanitized)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Pattern not sanitized: $pattern)"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 19: Sensitive Data Sanitization"
    echo "=========================================="
    echo ""
    echo "الخاصية: البيانات الحساسة يجب إزالتها أو إخفاؤها تلقائياً"
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
