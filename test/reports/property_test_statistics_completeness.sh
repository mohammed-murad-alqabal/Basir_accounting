#!/bin/bash

###############################################################################
# Property 6: Report Content Completeness - Statistics
#
# الخاصية:
#   لأي تقرير يتم إنشاؤه، يجب أن يتضمن جميع الإحصائيات المطلوبة:
#   - عدد ملفات Dart
#   - عدد ملفات الاختبار
#   - إجمالي الأسطر
#   - حجم المشروع
#   - عدد الـ Commits
#   - عدد المساهمين
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_report_stats_$$"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

setup() {
    mkdir -p "$TEST_DIR"/{lib,test,logs/reports}
    cd "$TEST_DIR" || exit 1
    
    # نسخ السكريبت
    cp "$PROJECT_ROOT/scripts/generate_report.sh" "$TEST_DIR/"
    chmod +x generate_report.sh
    
    # تهيئة git
    git init > /dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # إنشاء pubspec.yaml
    cat > pubspec.yaml << 'EOF'
name: test_project
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
EOF
    
    # إنشاء commit أولي
    echo "test" > README.md
    git add .
    git commit -m "initial commit" > /dev/null 2>&1
}

cleanup() {
    [ -d "$TEST_DIR" ] && rm -rf "$TEST_DIR"
}

trap cleanup EXIT

create_test_project() {
    local dart_files=$1
    local test_files=$2
    
    # إنشاء ملفات Dart
    for i in $(seq 1 "$dart_files"); do
        cat > "lib/file_$i.dart" << 'EOF'
class TestClass {
  void testMethod() {
    print('test');
  }
}
EOF
    done
    
    # إنشاء ملفات اختبار
    for i in $(seq 1 "$test_files"); do
        cat > "test/file_${i}_test.dart" << 'EOF'
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test', () {
    expect(true, true);
  });
}
EOF
    done
    
    # إنشاء commit
    git add .
    git commit -m "add files" > /dev/null 2>&1
}

check_statistics_in_report() {
    local report_file=$1
    
    # التحقق من وجود جميع الإحصائيات المطلوبة
    local required_stats=(
        "ملفات Dart"
        "ملفات الاختبار"
        "إجمالي الأسطر"
        "حجم المشروع"
        "عدد الـ Commits"
        "المساهمون"
    )
    
    for stat in "${required_stats[@]}"; do
        if ! grep -q "$stat" "$report_file"; then
            return 1
        fi
    done
    
    return 0
}

run_test_iteration() {
    local iteration=$1
    
    # إنشاء مشروع اختبار عشوائي
    local dart_files=$((RANDOM % 20 + 1))
    local test_files=$((RANDOM % 10 + 1))
    
    create_test_project "$dart_files" "$test_files"
    
    # إنشاء التقرير
    local report_file="logs/reports/test_report.md"
    ./generate_report.sh --output "$report_file" > /dev/null 2>&1
    
    # التحقق من وجود التقرير
    if [ ! -f "$report_file" ]; then
        return 1
    fi
    
    # التحقق من اكتمال الإحصائيات
    if ! check_statistics_in_report "$report_file"; then
        return 1
    fi
    
    # التحقق من صحة القيم
    local reported_dart=$(grep "ملفات Dart" "$report_file" | grep -oP '\d+' | head -1)
    local reported_test=$(grep "ملفات الاختبار" "$report_file" | grep -oP '\d+' | head -1)
    
    if [ "$reported_dart" != "$dart_files" ] || [ "$reported_test" != "$test_files" ]; then
        return 1
    fi
    
    return 0
}

main() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "Property 6: Report Content Completeness - Statistics"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo "الخاصية: جميع التقارير يجب أن تتضمن إحصائيات كاملة"
    echo "الاختبارات: $TOTAL_ITERATIONS iterations"
    echo ""
    
    setup
    
    for i in $(seq 1 $TOTAL_ITERATIONS); do
        if run_test_iteration "$i"; then
            ((PASSED++))
            if [ $((i % 10)) -eq 0 ]; then
                echo -e "${GREEN}  ✓ Iteration $i/$TOTAL_ITERATIONS passed${NC}"
            fi
        else
            ((FAILED++))
            echo -e "${RED}  ✗ Iteration $i/$TOTAL_ITERATIONS failed${NC}"
        fi
        
        # تنظيف للتكرار التالي
        rm -rf lib/* test/* logs/reports/*
    done
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "النتائج النهائية"
    echo "═══════════════════════════════════════════════════════════════"
    echo "إجمالي: $TOTAL_ITERATIONS"
    echo -e "${GREEN}نجح: $PASSED${NC}"
    echo -e "${RED}فشل: $FAILED${NC}"
    
    local success_rate=$((PASSED * 100 / TOTAL_ITERATIONS))
    echo "نسبة النجاح: $success_rate%"
    echo ""
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}✅ ALL TESTS PASSED ($PASSED/$TOTAL_ITERATIONS)${NC}"
        echo ""
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة - بعض التقارير لا تتضمن إحصائيات كاملة${NC}"
        echo ""
        exit 1
    fi
}

main
