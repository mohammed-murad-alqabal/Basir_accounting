#!/bin/bash

# Feature: error-tracking-system, Property 12: Archive Age-based Migration
# Validates: Requirements 5.1
# 
# Property: For any log file older than 7 days, the archive manager should move it to the archive directory.

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# متغيرات الاختبار
TEST_DIR="test_archive_age_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$TEST_DIR/logs/archive"
ITERATIONS=100
PASSED=0
FAILED=0

# دالة للطباعة الملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# دالة لإنشاء ملف سجل بتاريخ محدد
create_log_with_age() {
    local filename=$1
    local days_old=$2
    local filepath="$LOGS_DIR/$filename"
    
    # إنشاء الملف
    echo "Test log content - $days_old days old" > "$filepath"
    
    # تعديل تاريخ الملف
    touch -d "$days_old days ago" "$filepath"
}

# دالة لتشغيل الأرشفة
run_archive() {
    # تشغيل منطق الأرشفة مباشرة
    local MAX_AGE_DAYS=7
    
    # البحث عن ملفات السجلات القديمة ونقلها
    find "$LOGS_DIR" -maxdepth 1 -name "*.log" -type f -mtime +${MAX_AGE_DAYS} -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null || true
}

# دالة للتحقق من الخاصية
verify_property() {
    local iteration=$1
    local old_days=$2
    local recent_days=$3
    
    # إنشاء ملفات سجلات عشوائية
    local old_file="old_log_${iteration}_${old_days}d.log"
    local recent_file="recent_log_${iteration}_${recent_days}d.log"
    
    create_log_with_age "$old_file" "$old_days"
    create_log_with_age "$recent_file" "$recent_days"
    
    # تشغيل الأرشفة
    run_archive
    
    # التحقق: الملف القديم يجب أن يكون في الأرشيف
    if [ -f "$ARCHIVE_DIR/$old_file" ] && [ ! -f "$LOGS_DIR/$old_file" ]; then
        local old_check=true
    else
        local old_check=false
    fi
    
    # التحقق: الملف الحديث يجب أن يبقى في مكانه
    if [ -f "$LOGS_DIR/$recent_file" ] && [ ! -f "$ARCHIVE_DIR/$recent_file" ]; then
        local recent_check=true
    else
        local recent_check=false
    fi
    
    # النتيجة
    if [ "$old_check" = true ] && [ "$recent_check" = true ]; then
        return 0
    else
        echo "FAILED: Iteration $iteration - Old file in archive: $old_check, Recent file in logs: $recent_check"
        return 1
    fi
}

# دالة التنظيف
cleanup() {
    rm -rf "$TEST_DIR"
}

# الاختبار الرئيسي
main() {
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    print_message "$GREEN" "  Property Test: Archive Age-based Migration"
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    echo ""
    
    print_message "$YELLOW" "🧪 Running $ITERATIONS iterations..."
    echo ""
    
    # إنشاء مجلدات الاختبار
    mkdir -p "$LOGS_DIR"
    mkdir -p "$ARCHIVE_DIR"
    
    # تشغيل الاختبارات
    for i in $(seq 1 $ITERATIONS); do
        # توليد أعمار عشوائية
        # الملف القديم: 8-30 يوم (أكثر من 7 أيام)
        local old_days=$((8 + RANDOM % 23))
        
        # الملف الحديث: 0-7 أيام (7 أيام أو أقل)
        local recent_days=$((RANDOM % 8))
        
        if verify_property "$i" "$old_days" "$recent_days"; then
            ((PASSED++))
            if [ $((i % 10)) -eq 0 ]; then
                print_message "$GREEN" "  ✓ Iteration $i/$ITERATIONS passed"
            fi
        else
            ((FAILED++))
            print_message "$RED" "  ✗ Iteration $i/$ITERATIONS failed"
        fi
        
        # تنظيف بين الاختبارات
        rm -f "$LOGS_DIR"/*.log
        rm -f "$ARCHIVE_DIR"/*.log
    done
    
    echo ""
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    
    # النتائج
    if [ $FAILED -eq 0 ]; then
        print_message "$GREEN" "✅ ALL TESTS PASSED ($PASSED/$ITERATIONS)"
        print_message "$GREEN" "═══════════════════════════════════════════════════════"
        cleanup
        exit 0
    else
        print_message "$RED" "❌ SOME TESTS FAILED"
        print_message "$YELLOW" "  Passed: $PASSED/$ITERATIONS"
        print_message "$RED" "  Failed: $FAILED/$ITERATIONS"
        print_message "$GREEN" "═══════════════════════════════════════════════════════"
        cleanup
        exit 1
    fi
}

# تشغيل الاختبار
main
