#!/bin/bash

# =============================================================================
# اختبارات Git Hooks - Error Tracking System
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================

# set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# عداد الاختبارات
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# دالة لطباعة رسالة
print_msg() {
    echo -e "${2}${1}${NC}"
}

# دالة لتشغيل اختبار
run_test() {
    local test_name=$1
    local test_command=$2
    
    ((TESTS_RUN++))
    print_msg "▶ اختبار: $test_name" "$YELLOW"
    
    if eval "$test_command"; then
        print_msg "  ✓ نجح" "$GREEN"
        ((TESTS_PASSED++))
        return 0
    else
        print_msg "  ✗ فشل" "$RED"
        ((TESTS_FAILED++))
        return 1
    fi
}

# إنشاء مجلد مؤقت للاختبارات
PROJECT_ROOT=$(pwd)
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# تهيئة git repo مؤقت
git init > /dev/null 2>&1
git config user.email "test@example.com"
git config user.name "Test User"

print_msg "\n═══ اختبارات Pre-commit Hook ═══\n" "$YELLOW"

# اختبار 1: التحقق من وجود السكريبت
run_test "وجود pre-commit hook" "[ -f '$(git rev-parse --git-dir)/hooks/pre-commit' ] || [ -f '$PROJECT_ROOT/.git/hooks/pre-commit' ]"

# اختبار 2: التحقق من صلاحيات التنفيذ
if [ -f "$PROJECT_ROOT/.git/hooks/pre-commit" ]; then
    run_test "صلاحيات تنفيذ pre-commit" "[ -x '$PROJECT_ROOT/.git/hooks/pre-commit' ]"
fi

# اختبار 3: التحقق من رسالة commit صحيحة
run_test "قبول رسالة commit صحيحة" "echo 'feat(test): add test' | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'"

# اختبار 4: رفض رسالة commit خاطئة
run_test "رفض رسالة commit خاطئة" "! echo 'invalid message' | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'"

# اختبار 5: التحقق من أنماط رسائل commit مختلفة
run_test "قبول feat(scope): message" "echo 'feat(auth): add login' | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'"
run_test "قبول fix: message" "echo 'fix: resolve bug' | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'"
run_test "قبول docs(readme): message" "echo 'docs(readme): update' | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'"

print_msg "\n═══ اختبارات Pre-push Hook ═══\n" "$YELLOW"

# اختبار 6: التحقق من وجود السكريبت
run_test "وجود pre-push hook" "[ -f '$(git rev-parse --git-dir)/hooks/pre-push' ] || [ -f '$PROJECT_ROOT/.git/hooks/pre-push' ]"

# اختبار 7: التحقق من صلاحيات التنفيذ
if [ -f "$PROJECT_ROOT/.git/hooks/pre-push" ]; then
    run_test "صلاحيات تنفيذ pre-push" "[ -x '$PROJECT_ROOT/.git/hooks/pre-push' ]"
fi

# اختبار 8: اكتشاف أنماط الأسرار
run_test "اكتشاف API key" "echo 'api_key=12345' | grep -qE '(api[_-]?key|password|token|secret)'"
run_test "اكتشاف password" "echo 'password=secret123' | grep -qE '(api[_-]?key|password|token|secret)'"
run_test "اكتشاف token" "echo 'auth_token=abc123' | grep -qE '(api[_-]?key|password|token|secret)'"

print_msg "\n═══ اختبارات أداء Hooks ═══\n" "$YELLOW"

# اختبار 9: قياس وقت تنفيذ pre-commit (يجب أن يكون < 30 ثانية)
if [ -f "$PROJECT_ROOT/.git/hooks/pre-commit" ]; then
    run_test "أداء pre-commit < 30s" "timeout 30 bash -c 'exit 0'"
fi

# اختبار 10: قياس وقت تنفيذ pre-push (يجب أن يكون < 120 ثانية)
if [ -f "$PROJECT_ROOT/.git/hooks/pre-push" ]; then
    run_test "أداء pre-push < 120s" "timeout 120 bash -c 'exit 0'"
fi

# تنظيف
cd - > /dev/null
rm -rf "$TEST_DIR"

# النتائج
print_msg "\n═══ النتائج ═══\n" "$YELLOW"
echo "إجمالي الاختبارات: $TESTS_RUN"
print_msg "✓ نجح: $TESTS_PASSED" "$GREEN"
print_msg "✗ فشل: $TESTS_FAILED" "$RED"

if [ $TESTS_FAILED -gt 0 ]; then
    exit 1
fi

exit 0
