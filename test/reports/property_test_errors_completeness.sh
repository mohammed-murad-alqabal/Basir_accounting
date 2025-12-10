#!/bin/bash

###############################################################################
# Property 7: Report Content Completeness - Errors
#
# الخاصية:
#   لأي تقرير يتم إنشاؤه، يجب أن يتضمن ملخص تفصيلي للأخطاء والتحذيرات:
#   - عدد الأخطاء (Errors)
#   - عدد التحذيرات (Warnings)
#   - عدد المعلومات (Info)
#   - أهم الأخطاء
#   - أهم التحذيرات
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_report_errors_$$"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=50

setup() {
    mkdir -p "$TEST_DIR"/{lib,test,logs/reports}
    cd "$TEST_DIR" || exit 1
    
    cp "$PROJECT_ROOT/scripts/generate_report.sh" "$TEST_DIR/"
    chmod +x generate_report.sh
    
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    cat > pubspec.yaml << 'EOF'
name: test_project
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
EOF
    
    echo "test" > README.md
    git add .
    git commit -m "initial" > /dev/null 2>&1
}

cleanup() {
    [ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"
}

trap cleanup EXIT

check_errors_section() {
    local report_file=$1
    
    # التحقق من وجود قسم الأخطاء
    if ! grep -q "تحليل الأخطاء والتحذيرات" "$report_file"; then
        return 1
    fi
    
    # التحقق من وجود الإحصائيات
    local required_items=(
        "أخطاء"
        "تحذيرات"
        "معلومات"
    )
    
    for item in "${required_items[@]}"; do
        if ! grep -q "$item" "$report_file"; then
            return 1
        fi
    done
    
    return 0
}

run_test_iteration() {
    # إنشاء ملف Dart بسيط
    cat > lib/main.dart << 'EOF'
void main() {
  print('Hello');
}
EOF
    
    git add .
    git commit -m "add main" > /dev/null 2>&1
    
    # إنشاء التقرير
    local report_file="logs/reports/test_report.md"
    ./generate_report.sh --output "$report_file" > /dev/null 2>&1
    
    if [ ! -f "$report_file" ]; then
        return 1
    fi
    
    check_errors_section "$report_file"
}

main() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "Property 7: Report Content Completeness - Errors"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    setup
    
    for i in $(seq 1 $TOTAL_ITERATIONS); do
        if run_test_iteration; then
            ((PASSED++))
            if [ $((i % 10)) -eq 0 ]; then
                echo -e "${GREEN}  ✓ Iteration $i/$TOTAL_ITERATIONS passed${NC}"
            fi
        else
            ((FAILED++))
        fi
        
        rm -rf lib/* logs/reports/*
    done
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "النتائج النهائية"
    echo "═══════════════════════════════════════════════════════════════"
    echo "إجمالي: $TOTAL_ITERATIONS"
    echo -e "${GREEN}نجح: $PASSED${NC}"
    echo -e "${RED}فشل: $FAILED${NC}"
    echo "نسبة النجاح: $((PASSED * 100 / TOTAL_ITERATIONS))%"
    echo ""
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}✅ ALL TESTS PASSED${NC}"
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة${NC}"
        exit 1
    fi
}

main
