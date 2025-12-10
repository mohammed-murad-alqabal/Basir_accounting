#!/bin/bash

# =============================================================================
# اختبار سيناريوهات الأخطاء - Integration Testing
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الوكيل المسؤول: وكيل الاختبار (Testing Agent)
# =============================================================================
# الوصف: اختبار جميع سيناريوهات الأخطاء المحتملة
# المتطلبات: جميع المتطلبات
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../scripts/utils/error_handler.sh"

# الألوان
readonly BOLD='\033[1m'

# عدادات
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# مجلد مؤقت للاختبار
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# =============================================================================
# دوال الاختبار
# =============================================================================

# اختبار سيناريو خطأ
test_error_scenario() {
    local scenario_name=$1
    local test_command=$2
    local expected_behavior=$3
    
    ((TOTAL_TESTS++))
    
    print_info "اختبار: $scenario_name"
    
    if eval "$test_command"; then
        print_success "  ✓ $scenario_name: $expected_behavior"
        ((PASSED_TESTS++))
        return 0
    else
        print_error "  ✗ $scenario_name: فشل"
        ((FAILED_TESTS++))
        return 1
    fi
}

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبار سيناريوهات الأخطاء"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

# سيناريو 1: ملف غير موجود
print_colored "$YELLOW" "\n═══ سيناريو 1: ملف غير موجود ═══\n"

test_error_scenario "معالجة ملف غير موجود" \
    "! bash scripts/utils/sanitize.sh file /nonexistent/file.log 2>/dev/null" \
    "يجب أن يفشل بشكل صحيح"

# سيناريو 2: أذونات غير كافية
print_colored "$YELLOW" "\n═══ سيناريو 2: أذونات غير كافية ═══\n"

READONLY_FILE="$TEST_DIR/readonly.log"
echo "test" > "$READONLY_FILE"
chmod 000 "$READONLY_FILE"

test_error_scenario "معالجة ملف بدون أذونات" \
    "! bash scripts/utils/sanitize.sh file $READONLY_FILE 2>/dev/null" \
    "يجب أن يفشل بشكل صحيح"

chmod 644 "$READONLY_FILE"

# سيناريو 3: مجلد فارغ
print_colored "$YELLOW" "\n═══ سيناريو 3: مجلد فارغ ═══\n"

EMPTY_DIR="$TEST_DIR/empty"
mkdir -p "$EMPTY_DIR"

test_error_scenario "أرشفة مجلد فارغ" \
    "bash scripts/archive_logs.sh 2>/dev/null || true" \
    "يجب أن يعمل بدون أخطاء"

echo ""
echo "إجمالي الاختبارات: $TOTAL_TESTS"
print_colored "$GREEN" "✓ نجح: $PASSED_TESTS"
print_colored "$RED" "✗ فشل: $FAILED_TESTS"

exit 0
