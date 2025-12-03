#!/bin/bash

# =============================================================================
# سكريبت تشغيل جميع الاختبارات
# =============================================================================
# الوصف: يقوم بتشغيل جميع اختبارات الخصائص للتحقق من عمل النظام
# الاستخدام: ./test/run_all_tests.sh [--verbose]
# =============================================================================

set -euo pipefail

# الألوان للإخراج
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# المتغيرات العامة
VERBOSE=false
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0
START_TIME=$(date +%s)

# =============================================================================
# الدوال المساعدة
# =============================================================================

# طباعة رسالة ملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# طباعة عنوان القسم
print_section() {
    local title=$1
    echo ""
    print_message "$BLUE" "═══════════════════════════════════════════════════════════════"
    print_message "$BLUE" "  $title"
    print_message "$BLUE" "═══════════════════════════════════════════════════════════════"
    echo ""
}

# طباعة نتيجة الاختبار
print_test_result() {
    local test_name=$1
    local status=$2
    local duration=$3
    
    case $status in
        "PASS")
            print_message "$GREEN" "✓ $test_name (${duration}s)"
            ((PASSED_TESTS++))
            ;;
        "FAIL")
            print_message "$RED" "✗ $test_name (${duration}s)"
            ((FAILED_TESTS++))
            ;;
        "SKIP")
            print_message "$YELLOW" "⊘ $test_name (تم التخطي)"
            ((SKIPPED_TESTS++))
            ;;
    esac
    ((TOTAL_TESTS++))
}

# تشغيل اختبار واحد
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .sh)
    
    if [[ ! -f "$test_file" ]]; then
        print_test_result "$test_name" "SKIP" "0"
        return
    fi
    
    local test_start=$(date +%s)
    
    # التحقق من نوع الاختبار (bats أو bash عادي)
    local test_runner="bash"
    if head -n1 "$test_file" | grep -q "bats"; then
        test_runner="bats"
    fi
    
    if $VERBOSE; then
        echo ""
        print_message "$BLUE" "تشغيل: $test_name"
        if $test_runner "$test_file"; then
            local test_end=$(date +%s)
            local duration=$((test_end - test_start))
            print_test_result "$test_name" "PASS" "$duration"
        else
            local test_end=$(date +%s)
            local duration=$((test_end - test_start))
            print_test_result "$test_name" "FAIL" "$duration"
        fi
    else
        if $test_runner "$test_file" > /dev/null 2>&1; then
            local test_end=$(date +%s)
            local duration=$((test_end - test_start))
            print_test_result "$test_name" "PASS" "$duration"
        else
            local test_end=$(date +%s)
            local duration=$((test_end - test_start))
            print_test_result "$test_name" "FAIL" "$duration"
        fi
    fi
}

# تشغيل مجموعة اختبارات
run_test_suite() {
    local suite_name=$1
    local test_dir=$2
    
    print_section "$suite_name"
    
    if [[ ! -d "$test_dir" ]]; then
        print_message "$YELLOW" "⚠ المجلد غير موجود: $test_dir"
        return
    fi
    
    local test_files=($(find "$test_dir" -name "test_*.sh" -type f | sort))
    
    if [[ ${#test_files[@]} -eq 0 ]]; then
        print_message "$YELLOW" "⚠ لا توجد اختبارات في: $test_dir"
        return
    fi
    
    for test_file in "${test_files[@]}"; do
        run_test "$test_file"
    done
}

# طباعة الملخص النهائي
print_summary() {
    local end_time=$(date +%s)
    local total_duration=$((end_time - START_TIME))
    
    print_section "ملخص النتائج"
    
    echo "إجمالي الاختبارات: $TOTAL_TESTS"
    print_message "$GREEN" "✓ نجح: $PASSED_TESTS"
    print_message "$RED" "✗ فشل: $FAILED_TESTS"
    print_message "$YELLOW" "⊘ تم التخطي: $SKIPPED_TESTS"
    echo ""
    echo "الوقت الإجمالي: ${total_duration}s"
    echo ""
    
    if [[ $FAILED_TESTS -eq 0 ]]; then
        print_message "$GREEN" "🎉 جميع الاختبارات نجحت!"
        return 0
    else
        print_message "$RED" "❌ بعض الاختبارات فشلت!"
        return 1
    fi
}

# =============================================================================
# البرنامج الرئيسي
# =============================================================================

main() {
    # معالجة المعاملات
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --help|-h)
                echo "الاستخدام: $0 [--verbose]"
                echo ""
                echo "الخيارات:"
                echo "  --verbose, -v    عرض تفاصيل الاختبارات"
                echo "  --help, -h       عرض هذه الرسالة"
                exit 0
                ;;
            *)
                print_message "$RED" "خيار غير معروف: $1"
                exit 1
                ;;
        esac
    done
    
    # التحقق من وجود مجلد الاختبارات
    if [[ ! -d "test" ]]; then
        print_message "$RED" "❌ مجلد الاختبارات غير موجود!"
        exit 1
    fi
    
    # طباعة العنوان
    print_section "تشغيل جميع اختبارات نظام تتبع الأخطاء"
    
    # تشغيل مجموعات الاختبارات
    run_test_suite "اختبارات Git Hooks" "test/hooks"
    run_test_suite "اختبارات الأمان" "test/security"
    run_test_suite "اختبارات جمع السجلات" "test/log_collection"
    run_test_suite "اختبارات الأرشفة" "test/archive"
    run_test_suite "اختبارات Git" "test/git"
    run_test_suite "اختبارات الأداء" "test/performance"
    
    # طباعة الملخص
    print_summary
}

# تشغيل البرنامج الرئيسي
main "$@"
