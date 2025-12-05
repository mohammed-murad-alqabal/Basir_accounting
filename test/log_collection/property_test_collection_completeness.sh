#!/bin/bash

################################################################################
# Property-Based Test: Log Collection Completeness
#
# Feature: error-tracking-system
# Property 1: Log Collection Completeness
# Validates: Requirements 1.1
#
# الخاصية:
#   لأي تنفيذ لـ Flutter Analyze ينتج أخطاء أو تحذيرات،
#   يجب على نظام تتبع الأخطاء جمع وتخزين جميع الأخطاء والتحذيرات
#   في ملف سجل منظم.
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEST_DIR="$PROJECT_ROOT/test_collection_$$"
LOGS_DIR="$TEST_DIR/logs"

# الألوان
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# عدادات
PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

# دالة الإعداد
setup() {
    mkdir -p "$TEST_DIR"/{lib,logs,scripts}
    
    # نسخ السكريبت
    cp "$PROJECT_ROOT/scripts/collect_logs.sh" "$TEST_DIR/scripts/"
    chmod +x "$TEST_DIR/scripts/collect_logs.sh"
    
    # إنشاء pubspec.yaml بسيط
    cat > "$TEST_DIR/pubspec.yaml" << 'EOF'
name: test_project
description: Test project
version: 1.0.0
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
EOF
}

# دالة التنظيف
cleanup() {
    if [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
}

trap cleanup EXIT

# دالة إنشاء ملف Dart مع أخطاء عشوائية
generate_dart_file_with_errors() {
    local error_count=$1
    local file="$TEST_DIR/lib/test_file_$RANDOM.dart"
    
    cat > "$file" << 'EOF'
// ملف اختبار مع أخطاء
class TestClass {
EOF
    
    # إضافة أخطاء عشوائية
    for ((i=1; i<=error_count; i++)); do
        local error_type=$((RANDOM % 3))
        case $error_type in
            0)
                # متغير غير مستخدم
                echo "  var unusedVariable$i = 'test';" >> "$file"
                ;;
            1)
                # استيراد غير مستخدم
                echo "import 'dart:async' as async$i;" >> "$file"
                ;;
            2)
                # نوع غير صحيح
                echo "  String wrongType$i = 123;" >> "$file"
                ;;
        esac
    done
    
    echo "}" >> "$file"
    
    echo "$error_count"
}

# دالة تشغيل Flutter Analyze وحساب الأخطاء
run_analyze_and_count_errors() {
    cd "$TEST_DIR" || return 1
    
    # تشغيل flutter analyze
    local analyze_output=$(flutter analyze --no-pub 2>&1 || true)
    
    # حساب عدد الأخطاء والتحذيرات
    local error_count=$(echo "$analyze_output" | grep -c "error •" || echo "0")
    local warning_count=$(echo "$analyze_output" | grep -c "warning •" || echo "0")
    local info_count=$(echo "$analyze_output" | grep -c "info •" || echo "0")
    
    local total=$((error_count + warning_count + info_count))
    echo "$total"
}

# دالة تشغيل سكريبت جمع السجلات
run_collect_logs() {
    cd "$TEST_DIR" || return 1
    "$TEST_DIR/scripts/collect_logs.sh" > /dev/null 2>&1
}

# دالة حساب الأخطاء في السجل
count_errors_in_log() {
    local log_file=$(ls -t "$LOGS_DIR"/flutter_analyze_*.log 2>/dev/null | head -1)
    
    if [ ! -f "$log_file" ]; then
        echo "0"
        return
    fi
    
    # حساب الأخطاء والتحذيرات في السجل
    local error_count=$(grep -c "error •" "$log_file" 2>/dev/null || echo "0")
    local warning_count=$(grep -c "warning •" "$log_file" 2>/dev/null || echo "0")
    local info_count=$(grep -c "info •" "$log_file" 2>/dev/null || echo "0")
    
    local total=$((error_count + warning_count + info_count))
    echo "$total"
}

# دالة الاختبار الرئيسية
test_property() {
    local iteration=$1
    
    # إنشاء عدد عشوائي من الأخطاء (1-10)
    local expected_errors=$((RANDOM % 10 + 1))
    
    # إنشاء ملف Dart مع أخطاء
    generate_dart_file_with_errors "$expected_errors" > /dev/null
    
    # تشغيل Flutter Analyze وحساب الأخطاء الفعلية
    local actual_errors=$(run_analyze_and_count_errors)
    
    # تشغيل سكريبت جمع السجلات
    run_collect_logs
    
    # حساب الأخطاء في السجل
    local logged_errors=$(count_errors_in_log)
    
    # التحقق: يجب أن يكون عدد الأخطاء في السجل مساوياً للأخطاء الفعلية
    if [ "$logged_errors" -eq "$actual_errors" ] && [ "$actual_errors" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} Iteration $iteration: PASS (Expected: $actual_errors, Logged: $logged_errors)"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗${NC} Iteration $iteration: FAIL (Expected: $actual_errors, Logged: $logged_errors)"
        ((FAILED++))
        return 1
    fi
}

# الدالة الرئيسية
main() {
    echo "=========================================="
    echo "Property 1: Log Collection Completeness"
    echo "=========================================="
    echo ""
    echo "الخاصية: لأي تنفيذ لـ Flutter Analyze ينتج أخطاء أو تحذيرات،"
    echo "يجب على نظام تتبع الأخطاء جمع وتخزين جميع الأخطاء والتحذيرات."
    echo ""
    echo "عدد التكرارات: $TOTAL_ITERATIONS"
    echo ""
    
    # الإعداد
    echo "جاري الإعداد..."
    setup
    echo ""
    
    # تشغيل الاختبارات
    echo "جاري تشغيل الاختبارات..."
    echo ""
    
    for ((i=1; i<=TOTAL_ITERATIONS; i++)); do
        # تنظيف السجلات السابقة
        rm -rf "$LOGS_DIR"
        mkdir -p "$LOGS_DIR"
        
        # تنظيف ملفات Dart السابقة
        rm -f "$TEST_DIR/lib"/*.dart
        
        # تشغيل الاختبار
        test_property "$i"
        
        # عرض التقدم كل 10 تكرارات
        if [ $((i % 10)) -eq 0 ]; then
            echo "  التقدم: $i/$TOTAL_ITERATIONS"
        fi
    done
    
    echo ""
    echo "=========================================="
    echo "النتائج النهائية"
    echo "=========================================="
    echo -e "إجمالي التكرارات: $TOTAL_ITERATIONS"
    echo -e "${GREEN}نجح: $PASSED${NC}"
    echo -e "${RED}فشل: $FAILED${NC}"
    
    local success_rate=$((PASSED * 100 / TOTAL_ITERATIONS))
    echo "نسبة النجاح: $success_rate%"
    echo ""
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}✓ الخاصية محققة بنسبة 100%${NC}"
        exit 0
    else
        echo -e "${RED}✗ الخاصية غير محققة بالكامل${NC}"
        exit 1
    fi
}

# تشغيل الاختبار
main
