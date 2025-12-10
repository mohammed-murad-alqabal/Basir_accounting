#!/bin/bash

# Feature: error-tracking-system, Property 13: Archive Size-based Compression
# Validates: Requirements 5.2
# 
# Property: For any archive directory exceeding 10MB in size, the system should compress the logs into a tar.gz file.

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# متغيرات الاختبار
TEST_DIR="test_compression_size_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$TEST_DIR/logs/archive"
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

# دالة لحساب حجم الأرشيف بالميجابايت
get_archive_size_mb() {
    local size_bytes=$(du -sb "$ARCHIVE_DIR" 2>/dev/null | cut -f1)
    local size_mb=$((size_bytes / 1024 / 1024))
    echo $size_mb
}

# دالة لإنشاء ملفات سجلات بحجم محدد
create_logs_with_size() {
    local target_size_mb=$1
    local file_count=$2
    
    # التأكد من أن الحجم لكل ملف على الأقل 1MB
    local file_size_mb=$((target_size_mb / file_count))
    if [ $file_size_mb -lt 1 ]; then
        file_size_mb=1
        file_count=$target_size_mb
    fi
    
    for i in $(seq 1 $file_count); do
        # إنشاء ملف بحجم محدد (بالميجابايت)
        dd if=/dev/zero of="$ARCHIVE_DIR/log_${i}.log" bs=1M count=$file_size_mb 2>/dev/null
    done
}

# دالة لتشغيل الضغط
run_compression() {
    local archive_size=$(get_archive_size_mb)
    
    if [ $archive_size -gt $MAX_ARCHIVE_SIZE_MB ]; then
        local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
        local archive_file="$LOGS_DIR/archive_${timestamp}.tar.gz"
        
        # ضغط الأرشيف
        tar -czf "$archive_file" -C "$ARCHIVE_DIR" . 2>/dev/null
        
        if [ $? -eq 0 ]; then
            # حذف الملفات الأصلية
            rm -f "$ARCHIVE_DIR"/*.log 2>/dev/null
            echo "$archive_file"
            return 0
        else
            echo ""
            return 1
        fi
    else
        echo ""
        return 2  # لا حاجة للضغط
    fi
}

# دالة للتحقق من الخاصية
verify_property() {
    local iteration=$1
    local target_size_mb=$2
    
    # إنشاء ملفات سجلات
    local file_count=5
    create_logs_with_size "$target_size_mb" "$file_count"
    
    # الحجم قبل الضغط
    local size_before=$(get_archive_size_mb)
    
    # تشغيل الضغط وحفظ النتيجة
    run_compression > /dev/null
    local compress_result=$?
    
    # البحث عن ملف مضغوط تم إنشاؤه
    local archive_file=$(find "$LOGS_DIR" -maxdepth 1 -name "archive_*.tar.gz" -type f | head -1)
    
    # التحقق من النتيجة
    # الحجم الفعلي قد يكون أقل قليلاً من المستهدف بسبب طريقة الإنشاء
    if [ $size_before -gt $MAX_ARCHIVE_SIZE_MB ]; then
        # يجب أن يتم الضغط
        if [ $compress_result -eq 0 ] && [ -n "$archive_file" ] && [ -f "$archive_file" ]; then
            # التحقق من أن الملفات الأصلية تم حذفها
            local remaining_logs=$(find "$ARCHIVE_DIR" -name "*.log" -type f | wc -l)
            if [ $remaining_logs -eq 0 ]; then
                return 0
            else
                echo "FAILED: Iteration $iteration - Original files not deleted (found $remaining_logs files)"
                return 1
            fi
        else
            echo "FAILED: Iteration $iteration - Compression should have occurred but didn't (size: ${size_before}MB > ${MAX_ARCHIVE_SIZE_MB}MB, result=$compress_result)"
            return 1
        fi
    else
        # لا يجب أن يتم الضغط
        if [ $compress_result -eq 2 ] && [ -z "$archive_file" ]; then
            return 0
        else
            echo "FAILED: Iteration $iteration - Compression should not have occurred (size: ${size_before}MB <= ${MAX_ARCHIVE_SIZE_MB}MB, result=$compress_result)"
            return 1
        fi
    fi
}

# دالة التنظيف
cleanup() {
    rm -rf "$TEST_DIR"
}

# الاختبار الرئيسي
main() {
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    print_message "$GREEN" "  Property Test: Archive Size-based Compression"
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    echo ""
    
    print_message "$YELLOW" "🧪 Running $ITERATIONS iterations..."
    echo ""
    
    # إنشاء مجلدات الاختبار
    mkdir -p "$LOGS_DIR"
    mkdir -p "$ARCHIVE_DIR"
    
    # تشغيل الاختبارات
    for i in $(seq 1 $ITERATIONS); do
        # توليد حجم عشوائي
        # 50% من الحالات: حجم أكبر من 10MB (11-20MB)
        # 50% من الحالات: حجم أصغر من أو يساوي 10MB (1-10MB)
        if [ $((RANDOM % 2)) -eq 0 ]; then
            local target_size=$((11 + RANDOM % 10))
        else
            local target_size=$((1 + RANDOM % 10))
        fi
        
        if verify_property "$i" "$target_size"; then
            ((PASSED++))
            if [ $((i % 10)) -eq 0 ]; then
                print_message "$GREEN" "  ✓ Iteration $i/$ITERATIONS passed"
            fi
        else
            ((FAILED++))
            print_message "$RED" "  ✗ Iteration $i/$ITERATIONS failed"
        fi
        
        # تنظيف بين الاختبارات
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
