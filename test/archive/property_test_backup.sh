#!/bin/bash

# Feature: error-tracking-system, Property 15: Archived Logs Backup
# Validates: Requirements 5.4
# 
# Property: For any old log that is deleted from the original directory, a compressed copy should exist in the archive.

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# متغيرات الاختبار
TEST_DIR="test_backup_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$TEST_DIR/logs/archive"
MAX_AGE_DAYS=7
MAX_ARCHIVE_SIZE_MB=10
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
    
    # إنشاء الملف مع محتوى فريد
    echo "Test log content - $filename - $days_old days old - $(date)" > "$filepath"
    
    # تعديل تاريخ الملف
    touch -d "$days_old days ago" "$filepath"
}

# دالة لتشغيل الأرشفة الكاملة
run_full_archive() {
    # نقل الملفات القديمة
    find "$LOGS_DIR" -maxdepth 1 -name "*.log" -type f -mtime +${MAX_AGE_DAYS} -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null || true
    
    # ضغط الأرشيف إذا كان كبيراً
    local archive_size_bytes=$(du -sb "$ARCHIVE_DIR" 2>/dev/null | cut -f1)
    local archive_size_mb=$((archive_size_bytes / 1024 / 1024))
    
    if [ $archive_size_mb -gt $MAX_ARCHIVE_SIZE_MB ]; then
        local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
        local archive_file="$LOGS_DIR/archive_${timestamp}.tar.gz"
        
        # ضغط الأرشيف
        tar -czf "$archive_file" -C "$ARCHIVE_DIR" . 2>/dev/null
        
        if [ $? -eq 0 ]; then
            # حذف الملفات الأصلية بعد الضغط
            rm -f "$ARCHIVE_DIR"/*.log 2>/dev/null
            echo "$archive_file"
            return 0
        fi
    fi
    
    return 1
}

# دالة للتحقق من وجود ملف في الأرشيف المضغوط
check_file_in_compressed_archive() {
    local archive_file=$1
    local filename=$2
    
    # استخراج قائمة الملفات من الأرشيف
    tar -tzf "$archive_file" 2>/dev/null | grep -q "^\./$filename$\|^$filename$"
    return $?
}

# دالة للتحقق من الخاصية
verify_property() {
    local iteration=$1
    
    # إنشاء مجموعة من الملفات القديمة
    local file_count=$((5 + RANDOM % 5))  # 5-9 ملفات
    local created_files=()
    
    for i in $(seq 1 $file_count); do
        local days=$((8 + RANDOM % 23))  # 8-30 يوم
        local filename="old_log_${iteration}_${i}.log"
        create_log_with_age "$filename" "$days"
        created_files+=("$filename")
    done
    
    # حفظ محتوى الملفات قبل الأرشفة
    declare -A file_contents
    for file in "${created_files[@]}"; do
        file_contents["$file"]=$(cat "$LOGS_DIR/$file")
    done
    
    # تشغيل الأرشفة الكاملة
    local archive_file=$(run_full_archive)
    
    # التحقق من أن جميع الملفات تم حذفها من المجلد الأصلي
    local all_deleted=true
    for file in "${created_files[@]}"; do
        if [ -f "$LOGS_DIR/$file" ]; then
            all_deleted=false
            echo "FAILED: Iteration $iteration - File still in original location: $file"
            break
        fi
    done
    
    if [ "$all_deleted" = false ]; then
        return 1
    fi
    
    # التحقق من وجود نسخة احتياطية
    local all_backed_up=true
    
    if [ -n "$archive_file" ] && [ -f "$archive_file" ]; then
        # الملفات في أرشيف مضغوط
        for file in "${created_files[@]}"; do
            if ! check_file_in_compressed_archive "$archive_file" "$file"; then
                all_backed_up=false
                echo "FAILED: Iteration $iteration - File not in compressed archive: $file"
                break
            fi
        done
    else
        # الملفات في مجلد الأرشيف غير المضغوط
        for file in "${created_files[@]}"; do
            if [ ! -f "$ARCHIVE_DIR/$file" ]; then
                all_backed_up=false
                echo "FAILED: Iteration $iteration - File not in archive directory: $file"
                break
            fi
        done
    fi
    
    if [ "$all_backed_up" = true ]; then
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
    print_message "$GREEN" "  Property Test: Archived Logs Backup"
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
        rm -f "$LOGS_DIR"/*.tar.gz
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
