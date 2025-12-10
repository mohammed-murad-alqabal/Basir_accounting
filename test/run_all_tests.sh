#!/bin/bash

# =============================================================================
# تشغيل جميع الاختبارات - Error Tracking System
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================

set -e

# الألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# عداد النتائج
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# دالة لطباعة رسالة ملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# دالة لطباعة عنوان القسم
print_section() {
    echo ""
    print_message "$BLUE" "═══════════════════════════════════════════════════════════"
    print_message "$BLUE" "  $1"
    print_message "$BLUE" "═══════════════════════════════════════════════════════════"
    echo ""
}

# دالة لتشغيل مجموعة اختبارات
run_test_suite() {
    local suite_name=$1
    local test_script=$2
    
    print_message "$YELLOW" "▶ تشغيل: $suite_name"
    
    if [ -f "$test_script" ]; then
        if bash "$test_script"; then
            print_message "$GREEN" "✓ نجح: $suite_name"
            ((PASSED_TESTS++))
        else
            print_message "$RED" "✗ فشل: $suite_name"
            ((FAILED_TESTS++))
        fi
        ((TOTAL_TESTS++))
    else
        print_message "$YELLOW" "⚠ غير موجود: $test_script"
    fi
}

# بداية التنفيذ
print_section "تشغيل جميع اختبارات نظام تتبع الأخطاء"

# التحقق من وجود bats
if ! command -v bats &> /dev/null; then
    print_message "$YELLOW" "⚠ تحذير: bats غير مثبت. سيتم تشغيل الاختبارات الأساسية فقط."
    print_message "$YELLOW" "   لتثبيت bats: npm install -g bats"
    echo ""
fi

# 1. اختبارات Git Hooks
print_section "1. اختبارات Git Hooks"
run_test_suite "Pre-commit Hook Tests" "test/run_hooks_tests.sh"

# 2. اختبارات جمع السجلات
print_section "2. اختبارات جمع السجلات"
run_test_suite "Log Collection Tests" "test/run_log_tests.sh"

# 3. اختبارات الأرشفة
print_section "3. اختبارات الأرشفة"
run_test_suite "Archive Management Tests" "test/run_archive_tests.sh"

# 4. اختبارات الأمان
print_section "4. اختبارات الأمان"
if [ -f "test/run_security_tests.sh" ]; then
    run_test_suite "Security Tests" "test/run_security_tests.sh"
else
    print_message "$YELLOW" "⚠ اختبارات الأمان غير متوفرة بعد"
fi

# 5. اختبارات الأداء
print_section "5. اختبارات الأداء"
if [ -f "test/run_performance_tests.sh" ]; then
    run_test_suite "Performance Tests" "test/run_performance_tests.sh"
else
    print_message "$YELLOW" "⚠ اختبارات الأداء غير متوفرة بعد"
fi

# 6. اختبارات Property-Based
print_section "6. اختبارات Property-Based"
if [ -f "test/run_property_tests.sh" ]; then
    run_test_suite "Property-Based Tests" "test/run_property_tests.sh"
else
    print_message "$YELLOW" "⚠ اختبارات Property-Based غير متوفرة بعد"
fi

# 7. اختبارات Dart
print_section "7. اختبارات Dart"
if command -v flutter &> /dev/null; then
    print_message "$YELLOW" "▶ تشغيل: Flutter Tests"
    if flutter test; then
        print_message "$GREEN" "✓ نجح: Flutter Tests"
        ((PASSED_TESTS++))
    else
        print_message "$RED" "✗ فشل: Flutter Tests"
        ((FAILED_TESTS++))
    fi
    ((TOTAL_TESTS++))
else
    print_message "$YELLOW" "⚠ Flutter غير مثبت"
fi

# النتائج النهائية
print_section "النتائج النهائية"

echo "إجمالي الاختبارات: $TOTAL_TESTS"
print_message "$GREEN" "✓ نجح: $PASSED_TESTS"
print_message "$RED" "✗ فشل: $FAILED_TESTS"

# حساب النسبة المئوية
if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "معدل النجاح: ${SUCCESS_RATE}%"
    
    if [ $SUCCESS_RATE -ge 90 ]; then
        print_message "$GREEN" "🎉 ممتاز! معدل نجاح عالي"
    elif [ $SUCCESS_RATE -ge 70 ]; then
        print_message "$YELLOW" "⚠ جيد، لكن يحتاج تحسين"
    else
        print_message "$RED" "✗ يحتاج إلى عمل كبير"
    fi
fi

echo ""
print_message "$BLUE" "═══════════════════════════════════════════════════════════"

# الخروج بحالة الفشل إذا فشل أي اختبار
if [ $FAILED_TESTS -gt 0 ]; then
    exit 1
fi

exit 0
