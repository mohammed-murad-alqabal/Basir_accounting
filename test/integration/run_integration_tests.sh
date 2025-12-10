#!/bin/bash

# =============================================================================
# تشغيل جميع اختبارات التكامل - Integration Testing
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# الوكيل المسؤول: وكيل الاختبار (Testing Agent)
# =============================================================================
# الوصف: تشغيل جميع اختبارات التكامل بشكل شامل
# المتطلبات: جميع المتطلبات
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../scripts/utils/error_handler.sh"

# عدادات
TOTAL_SUITES=0
PASSED_SUITES=0
FAILED_SUITES=0

# تشغيل مجموعة اختبارات
run_test_suite() {
    local suite_name=$1
    local suite_script=$2
    
    ((TOTAL_SUITES++))
    
    print_colored "$CYAN" "\n═══════════════════════════════════════════════════════════"
    print_colored "$CYAN" "  تشغيل: $suite_name"
    print_colored "$CYAN" "═══════════════════════════════════════════════════════════"
    echo ""
    
    if bash "$suite_script"; then
        print_success "\n✓ $suite_name: نجح"
        ((PASSED_SUITES++))
        return 0
    else
        print_error "\n✗ $suite_name: فشل"
        ((FAILED_SUITES++))
        return 1
    fi
}

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبارات التكامل النهائية"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""
print_info "المشروع: بصير MVP"
print_info "التاريخ: $(date '+%Y-%m-%d %H:%M:%S')"
print_info "الوكيل: وكيل الاختبار (Testing Agent)"
echo ""

# تشغيل اختبار سير العمل الكامل
run_test_suite \
    "اختبار سير العمل الكامل" \
    "$SCRIPT_DIR/test_full_workflow.sh"

# تشغيل اختبار سيناريوهات الأخطاء
run_test_suite \
    "اختبار سيناريوهات الأخطاء" \
    "$SCRIPT_DIR/test_error_scenarios.sh"

print_colored "$BLUE" "\n═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  النتائج النهائية - اختبارات التكامل"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

echo "إجمالي مجموعات الاختبار: $TOTAL_SUITES"
print_colored "$GREEN" "✓ نجح: $PASSED_SUITES"
print_colored "$RED" "✗ فشل: $FAILED_SUITES"

if [ $TOTAL_SUITES -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_SUITES * 100 / TOTAL_SUITES))
    echo "معدل النجاح: ${SUCCESS_RATE}%"
    
    if [ $SUCCESS_RATE -eq 100 ]; then
        print_colored "$GREEN" "\n🎉 ممتاز! جميع اختبارات التكامل نجحت"
    elif [ $SUCCESS_RATE -ge 70 ]; then
        print_colored "$YELLOW" "\n⚠ جيد، لكن يحتاج بعض التحسين"
    else
        print_colored "$RED" "\n✗ يحتاج إلى تحسينات كبيرة"
    fi
fi

echo ""
print_info "تم إكمال جميع اختبارات التكامل"
echo ""

if [ $FAILED_SUITES -gt 0 ]; then
    exit 1
fi

exit 0
