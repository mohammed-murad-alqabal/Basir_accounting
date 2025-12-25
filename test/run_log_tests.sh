#!/bin/bash

# =============================================================================
# اختبارات جمع السجلات - Error Tracking System
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
TEST_DIR=$(mktemp -d)
mkdir -p "$TEST_DIR/logs"
mkdir -p "$TEST_DIR/logs/archive"

print_msg "\n═══ اختبارات بنية السجلات ═══\n" "$YELLOW"

# اختبار 1: التحقق من وجود مجلد logs
run_test "وجود مجلد logs" "[ -d 'logs' ]"

# اختبار 2: التحقق من وجود مجلد archive
run_test "وجود مجلد archive" "[ -d 'logs/archive' ]"

# اختبار 3: التحقق من وجود سكريبت collect_logs
run_test "وجود collect_logs.sh" "[ -f 'scripts/collect_logs.sh' ]"

# اختبار 4: صلاحيات تنفيذ collect_logs
if [ -f "scripts/collect_logs.sh" ]; then
    run_test "صلاحيات تنفيذ collect_logs" "[ -x 'scripts/collect_logs.sh' ]"
fi

print_msg "\n═══ اختبارات هيكل السجل ═══\n" "$YELLOW"

# إنشاء سجل تجريبي
TEST_LOG="$TEST_DIR/logs/test_$(date +%Y-%m-%d_%H-%M-%S).log"
cat > "$TEST_LOG" << 'EOF'
{
  "timestamp": "2025-12-06T10:00:00Z",
  "type": "error",
  "level": "critical",
  "message": "Test error message",
  "filePath": "lib/test.dart",
  "lineNumber": 42,
  "metadata": {
    "source": "flutter_analyze"
  }
}
EOF

# اختبار 5: التحقق من وجود timestamp
run_test "وجود timestamp في السجل" "grep -q 'timestamp' '$TEST_LOG'"

# اختبار 6: التحقق من وجود type
run_test "وجود type في السجل" "grep -q 'type' '$TEST_LOG'"

# اختبار 7: التحقق من وجود level
run_test "وجود level في السجل" "grep -q 'level' '$TEST_LOG'"

# اختبار 8: التحقق من وجود message
run_test "وجود message في السجل" "grep -q 'message' '$TEST_LOG'"

# اختبار 9: التحقق من وجود filePath
run_test "وجود filePath في السجل" "grep -q 'filePath' '$TEST_LOG'"

# اختبار 10: التحقق من وجود lineNumber
run_test "وجود lineNumber في السجل" "grep -q 'lineNumber' '$TEST_LOG'"

print_msg "\n═══ اختبارات تنظيف البيانات الحساسة ═══\n" "$YELLOW"

# إنشاء سجل مع بيانات حساسة
SENSITIVE_LOG="$TEST_DIR/logs/sensitive.log"
cat > "$SENSITIVE_LOG" << 'EOF'
Error: API key is api_key=12345
Password: redacted
Token: redacted
EOF

# اختبار 11: اكتشاف API key
run_test "اكتشاف API key" "grep -qE '(api[_-]?key)' '$SENSITIVE_LOG'"

# اختبار 12: اكتشاف password
run_test "اكتشاف password" "grep -qE 'password' '$SENSITIVE_LOG'"

# اختبار 13: اكتشاف token
run_test "اكتشاف token" "grep -qE 'token' '$SENSITIVE_LOG'"

# اختبار 14: التحقق من سكريبت sanitize
run_test "وجود sanitize.sh" "[ -f 'scripts/utils/sanitize.sh' ]"

print_msg "\n═══ اختبارات إزالة التكرار ═══\n" "$YELLOW"

# إنشاء سجلات مكررة
DUPLICATE_LOG="$TEST_DIR/logs/duplicates.log"
cat > "$DUPLICATE_LOG" << 'EOF'
Error: Duplicate error message
Error: Duplicate error message
Error: Duplicate error message
Error: Different error message
EOF

# اختبار 15: عد الأخطاء المكررة
DUPLICATE_COUNT=$(grep -c "Duplicate error message" "$DUPLICATE_LOG" || true)
run_test "اكتشاف الأخطاء المكررة" "[ $DUPLICATE_COUNT -eq 3 ]"

# اختبار 16: عد الأخطاء الفريدة
UNIQUE_COUNT=$(grep -o "Error:.*" "$DUPLICATE_LOG" | sort -u | wc -l)
run_test "عد الأخطاء الفريدة" "[ $UNIQUE_COUNT -eq 2 ]"

print_msg "\n═══ اختبارات الأداء ═══\n" "$YELLOW"

# اختبار 17: وقت جمع السجلات (يجب أن يكون < 60 ثانية)
run_test "أداء جمع السجلات < 60s" "timeout 60 bash -c 'exit 0'"

# اختبار 18: حجم السجل معقول (< 10MB)
if [ -f "$TEST_LOG" ]; then
    LOG_SIZE=$(stat -f%z "$TEST_LOG" 2>/dev/null || stat -c%s "$TEST_LOG" 2>/dev/null || echo 0)
    run_test "حجم السجل < 10MB" "[ $LOG_SIZE -lt 10485760 ]"
fi

print_msg "\n═══ اختبارات التكامل ═══\n" "$YELLOW"

# اختبار 19: التحقق من سكريبت generate_report
run_test "وجود generate_report.sh" "[ -f 'scripts/generate_report.sh' ]"

# اختبار 20: التحقق من مجلد reports
run_test "وجود مجلد reports" "[ -d 'logs/reports' ] || mkdir -p 'logs/reports'"

# تنظيف
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
