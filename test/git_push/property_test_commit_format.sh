#!/bin/bash

################################################################################
# Property-Based Test: Commit Message Format Consistency
#
# Feature: error-tracking-system
# Property 16: Commit Message Format Consistency
# Validates: Requirements 6.2
#
# الخاصية:
#   لأي commit للسجلات يتم إنشاؤه بواسطة النظام، يجب أن تتبع
#   رسالة الـ commit صيغة Conventional Commits (مثل: "chore(logs): update logs").
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_commit_format_$$"
LOGS_DIR="$TEST_DIR/logs"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

setup() {
    mkdir -p "$TEST_DIR"/{lib,logs,scripts,.git}
    
    # نسخ السكريبت
    cp "$PROJECT_ROOT/scripts/collect_logs.sh" "$TEST_DIR/scripts/"
    chmod +x "$TEST_DIR/scripts/collect_logs.sh"
    
    # إنشاء pubspec.yaml
    cat > "$TEST_DIR/pubspec.yaml" << 'EOF'
name: test_project
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
EOF
    
    # تهيئة git repository
    cd "$TEST_DIR" || exit 1
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # إنشاء commit أولي
    echo "test" > README.md
    git add README.md
    git commit -m "initial commit" > /dev/null 2>&1
}

cleanup() {
    [ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"
}

trap cleanup EXIT

create_log_changes() {
    # إنشاء تغييرات في السجلات
    echo "Test log entry $(date)" > "$LOGS_DIR/test_log_$RANDOM.log"
}

run_collect_with_push() {
    cd "$TEST_DIR" || return 1
    
    # تشغيل السكريبت مع خيار --push
    "$TEST_DIR/scripts/collect_logs.sh" --push > /dev/null 2>&1
}

check_commit_message_format() {
    cd "$TEST_DIR" || return 1
    
    # الحصول على آخر رسالة commit
    local last_commit=$(git log -1 --pretty=%B 2>/dev/null)
    
    # التحقق من صيغة Conventional Commits
    # الصيغة: type(scope): description
    # مثال: chore(logs): update logs
    if echo "$last_commit" | grep -qE "^(feat|fix|docs|style|refactor|test|chore)\([a-z]+\): .+"; then
        return 0
    fi
    
    return 1
}

test_property() {
    local iteration=$1
    
    # إنشاء تغييرات في السجلات
    create_log_changes
    
    # تشغيل السكريبت مع --push
    run_collect_with_push
    
    # التحقق من صيغة رسالة الـ commit
    if check_commit_message_format; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS (Commit message follows Conventional Commits)"
        ((PASSED++))
        return 0
    else
        local last_commit=$(cd "$TEST_DIR" && git log -1 --pretty=%B 2>/dev/null)
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Invalid format: $last_commit)"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 16: Commit Message Format"
    echo "=========================================="
    echo ""
    echo "الخاصية: رسائل الـ commit يجب أن تتبع صيغة Conventional Commits"
    echo "الصيغة المطلوبة: type(scope): description"
    echo "عدد التكرارات: $TOTAL_ITERATIONS"
    echo ""
    
    setup
    echo "جاري تشغيل الاختبارات..."
    echo ""
    
    for ((i=1; i<=TOTAL_ITERATIONS; i++)); do
        # إعادة تعيين السجلات
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
        echo -e "${GREEN}✓ الخاصية محققة - جميع الـ commits تتبع الصيغة الصحيحة${NC}"
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة - بعض الـ commits لا تتبع الصيغة${NC}"
        exit 1
    fi
}

main
