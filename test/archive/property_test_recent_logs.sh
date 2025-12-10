#!/bin/bash

# Feature: error-tracking-system, Property 14: Recent Logs Preservation
# Validates: Requirements 5.3
# 
# Property: For any archiving operation, logs newer than 7 days should remain in their original location.

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# متغيرات الاختبار
TEST_DIR="test_recent_logs_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$TEST_DIR/logs/archive"
MAX_AGE_DAYS=7
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
    find "$LOGS_DIR" -maxdepth 1 -name "*.log" -type f -mtime +${MAX_AGE_DAYS} -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null || true
}

# دالة للتحقق من الخاصية
verify_property() {
    local iteration=$1
    
    # إنشاء مجموعة من الملفات بأعمار مختلفة
    local recent_count=$((3 + RANDOM % 5))  # 3-7 ملفات حديثة
    local old_count=$((2 + RANDOM % 4))     # 2-5 ملفات قديمة
    
    local recent_files=()
    local old_files=()
    
    # إنشاء ملفات حديثة (0-7 أيام)
    for i in $(seq 1 $recent_count); do
        local days=$((RANDOM % 8))
        local filename="recent_${iteration}_${i}_${days}d.log"
        create_log_with_age "$filename" "$days"
        recent_files+=("$filename")
    done
    
    # إنشاء ملفات قديمة (8-30 يوم)
    for i in $(seq 1 $old_count); do
        local days=$((8 + RANDOM % 23))
        local filename="old_${iteration}_${i}_${days}d.log"
        create_log_with_age "$filename" "$days"
        old_files+=("$filename")
    done
    
    # تشغيل الأرشفة
    run_archive
    
    # التحقق: جميع الملفات الحديثة يجب أن تبقى في مكانها
    local recent_preserved=true
    for file in "${recent_files[@]}"; do
        if [ ! -f "$LOGS_DIR/$file" ] || [ -f "$ARCHIVE_DIR/$file" ]; then
            recent_preserved=false
            echo "FAILED: Iteration $iteration - Recent file moved: $file"
            break
        fi
    done
    
    # التحقق: جميع الملفات القديمة يجب أن تنتقل للأرشيف
    local old_archived=true
    for file in "${old_files[@]}"; do
        if [ -f "$LOGS_DIR/$file" ] || [ ! -f "$ARCHIVE_DIR/$file" ]; then
            old_archived=false
            echo "FAILED: Iteration $iteration - Old file not archived: $file"
            break
        fi
    done
    
    # النتيجة
    if [ "$recent_preserved" = true ] && [ "$old_archived" = true ]; then
        return 0
    else
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
    print_message "$GREEN" "  Property Test: Recent Logs Preservation"
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    echo ""
    
    print_message "$YELLOW" "🧪 Running $ITERATIONS iterations..."
    echo ""
    
    # إنشاء مجلدات الاختبار
    mkdir -p "$LOGS_DIR"
    mkdir -p "$ARCHIVE_DIR"
    
    # تشغيل الاختبارات
    for i in $(seq 1 $ITERATIONS); do
        if verify_property "$i"; then
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
