#!/bin/bash

# سكريبت لتشغيل جميع اختبارات الأرشفة
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 4 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# متغيرات
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# دالة للطباعة الملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# دالة لتشغيل اختبار واحد
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .sh)
    
    ((TOTAL_TESTS++))
    
    print_message "$BLUE" "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_message "$YELLOW" "🧪 Running: $test_name"
    print_message "$BLUE" "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if bash "$test_file"; then
        ((PASSED_TESTS++))
        print_message "$GREEN" "✅ $test_name PASSED"
    else
        ((FAILED_TESTS++))
        print_message "$RED" "❌ $test_name FAILED"
    fi
}

# البداية
print_message "$GREEN" "═══════════════════════════════════════════════════════"
print_message "$GREEN" "   تشغيل جميع اختبارات الأرشفة - بصير MVP"
print_message "$GREEN" "═══════════════════════════════════════════════════════"

# تشغيل جميع الاختبارات
for test in test/archive/property_test_*.sh; do
    if [ -f "$test" ]; then
        run_test "$test"
    fi
done

# النتائج النهائية
echo ""
print_message "$GREEN" "═══════════════════════════════════════════════════════"
print_message "$GREEN" "   النتائج النهائية"
print_message "$GREEN" "═══════════════════════════════════════════════════════"
print_message "$YELLOW" "  إجمالي الاختبارات: $TOTAL_TESTS"
print_message "$GREEN" "  ✅ نجح: $PASSED_TESTS"

if [ $FAILED_TESTS -gt 0 ]; then
    print_message "$RED" "  ❌ فشل: $FAILED_TESTS"
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    exit 1
else
    print_message "$GREEN" "  🎉 جميع الاختبارات نجحت!"
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    exit 0
fi
