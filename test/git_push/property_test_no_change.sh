#!/bin/bash

################################################################################
# Property-Based Test: No-Change Detection
#
# Feature: error-tracking-system
# Property 18: No-Change Detection
# Validates: Requirements 6.5
#
# الخاصية:
#   لأي تنفيذ لسكريبت جمع السجلات عندما لا توجد تغييرات جديدة،
#   يجب على النظام تخطي عملية الـ commit والـ push وعرض رسالة إعلامية.
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_no_change_$$"
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

run_collect_with_push_twice() {
    cd "$TEST_DIR" || return 1
    
    # التشغيل الأول - سيقوم بإنشاء السجلات وعمل commit
    "$TEST_DIR/scripts/collect_logs.sh" --push > /dev/null 2>&1
    
    # حفظ عدد الـ commits بعد التشغيل الأول
    local commits_after_first=$(git rev-list --count HEAD 2>/dev/null)
    
    # التشغيل الثاني - لا توجد تغييرات جديدة
    "$TEST_DIR/scripts/collect_logs.sh" --push > /dev/null 2>&1
    
    # حفظ عدد الـ commits بعد التشغيل الثاني
    local commits_after_second=$(git rev-list --count HEAD 2>/dev/null)
    
    # يجب أن يكون العدد متساوي (لم يتم إنشاء commit جديد)
    if [ "$commits_after_first" -eq "$commits_after_second" ]; then
        return 0
    fi
    
    return 1
}

test_property() {
    local iteration=$1
    
    # تشغيل السكريبت مرتين
    if run_collect_with_push_twice; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS (No commit when no changes)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Unnecessary commit created)"
        ((FAILED++))
        return 1
    fi
}

main() {
    echo "=========================================="
    echo "Property 18: No-Change Detection"
    echo "=========================================="
    echo ""
    echo "الخاصية: عدم إنشاء commit عندما لا توجد تغييرات"
    echo "عدد التكرارات: $TOTAL_ITERATIONS"
    echo ""
    
    setup
    echo "جاري تشغيل الاختبارات..."
    echo ""
    
    for ((i=1; i<=TOTAL_ITERATIONS; i++)); do
        # إعادة تهيئة git repository
        cd "$TEST_DIR" || exit 1
        rm -rf .git logs
        git init > /dev/null 2>&1
        git config user.email "test@example.com"
        git config user.name "Test User"
        echo "test" > README.md
        git add README.md
        git commit -m "initial commit" > /dev/null 2>&1
        mkdir -p logs
        
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
        echo -e "${GREEN}✓ الخاصية محققة - لا يتم إنشاء commits غير ضرورية${NC}"
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة${NC}"
        exit 1
    fi
}

main
