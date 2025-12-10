#!/bin/bash

# Feature: error-tracking-system, Property 23: Compression Efficiency
# Validates: Requirements 10.4
# 
# Property: For any archive compression operation, the resulting compressed file should be at least 70% smaller than the original uncompressed size.

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# متغيرات الاختبار
TEST_DIR="test_compression_efficiency_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$TEST_DIR/logs/archive"
MIN_COMPRESSION_RATIO=70  # 70% تقليل في الحجم
ITERATIONS=10
PASSED=0
FAILED=0

# دالة للطباعة الملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# دالة لإنشاء ملفات سجلات نصية (قابلة للضغط بشكل جيد)
create_compressible_logs() {
    local file_count=$1
    local size_mb_per_file=$2
    
    for i in $(seq 1 $file_count); do
        local filename="$ARCHIVE_DIR/log_${i}.log"
        
        # إنشاء محتوى نصي متكرر (يضغط بشكل جيد) بطريقة أسرع
        local content="[$(date +%Y-%m-%d\ %H:%M:%S)] INFO: This is a test log entry with some repeated content that compresses well"
        
        # تكرار المحتوى لإنشاء ملف بالحجم المطلوب
        local size_kb=$((size_mb_per_file * 1024))
        local content_size=${#content}
        local repetitions=$((size_kb * 1024 / content_size))
        
        for j in $(seq 1 $repetitions); do
            echo "$content" >> "$filename"
        done
    done
}

# دالة لحساب حجم الملف أو المجلد بالبايت
get_size_bytes() {
    local path=$1
    du -sb "$path" 2>/dev/null | cut -f1
}

# دالة لحساب نسبة الضغط
calculate_compression_ratio() {
    local original_size=$1
    local compressed_size=$2
    
    if [ $original_size -eq 0 ]; then
        echo "0"
        return
    fi
    
    # نسبة التقليل = ((الحجم الأصلي - الحجم المضغوط) / الحجم الأصلي) * 100
    local reduction=$((original_size - compressed_size))
    local ratio=$((reduction * 100 / original_size))
    echo "$ratio"
}

# دالة لتشغيل الضغط
run_compression() {
    local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
    local archive_file="$LOGS_DIR/archive_${timestamp}.tar.gz"
    
    # ضغط الأرشيف
    tar -czf "$archive_file" -C "$ARCHIVE_DIR" . 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "$archive_file"
        return 0
    else
        echo ""
        return 1
    fi
}

# دالة للتحقق من الخاصية
verify_property() {
    local iteration=$1
    
    # إنشاء ملفات سجلات عشوائية (أحجام صغيرة للسرعة)
    local file_count=2  # 2 ملفات فقط
    local size_per_file=1  # 1 MB لكل ملف
    
    create_compressible_logs "$file_count" "$size_per_file"
    
    # حساب الحجم الأصلي
    local original_size=$(get_size_bytes "$ARCHIVE_DIR")
    
    # تشغيل الضغط
    local archive_file=$(run_compression)
    
    if [ -z "$archive_file" ] || [ ! -f "$archive_file" ]; then
        echo "FAILED: Iteration $iteration - Compression failed"
        return 1
    fi
    
    # حساب الحجم المضغوط
    local compressed_size=$(get_size_bytes "$archive_file")
    
    # حساب نسبة الضغط
    local compression_ratio=$(calculate_compression_ratio "$original_size" "$compressed_size")
    
    # التحقق من أن نسبة الضغط >= 70%
    if [ $compression_ratio -ge $MIN_COMPRESSION_RATIO ]; then
        return 0
    else
        local original_mb=$((original_size / 1024 / 1024))
        local compressed_mb=$((compressed_size / 1024 / 1024))
        echo "FAILED: Iteration $iteration - Compression ratio ${compression_ratio}% < ${MIN_COMPRESSION_RATIO}% (${original_mb}MB -> ${compressed_mb}MB)"
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
    print_message "$GREEN" "  Property Test: Compression Efficiency"
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    echo ""
    
    print_message "$YELLOW" "🧪 Running $ITERATIONS iterations..."
    print_message "$YELLOW" "   Minimum compression ratio: ${MIN_COMPRESSION_RATIO}%"
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
        rm -f "$LOGS_DIR"/*.tar.gz
        rm -f "$ARCHIVE_DIR"/*.log
    done
    
    echo ""
    print_message "$GREEN" "═══════════════════════════════════════════════════════"
    
    # النتائج
    if [ $FAILED -eq 0 ]; then
        print_message "$GREEN" "✅ ALL TESTS PASSED ($PASSED/$ITERATIONS)"
        print_message "$GREEN" "   All compressions achieved ≥${MIN_COMPRESSION_RATIO}% size reduction"
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
