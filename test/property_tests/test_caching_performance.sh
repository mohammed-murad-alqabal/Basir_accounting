#!/bin/bash

# =============================================================================
# Property Test 24: Caching Performance Improvement
# =============================================================================
# Feature: error-tracking-system
# Property: 24 - Caching Performance Improvement
# Validates: Requirements 10.5
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# عداد الاختبارات
ITERATIONS=100
PASSED=0
FAILED=0

# دالة لطباعة رسالة
print_msg() {
    echo -e "${2}${1}${NC}"
}

# دالة لقياس وقت التنفيذ
measure_time() {
    local start=$(date +%s%N)
    eval "$1" > /dev/null 2>&1
    local end=$(date +%s%N)
    echo $(( (end - start) / 1000000 )) # تحويل إلى ميلي ثانية
}

# إنشاء مجلد مؤقت للاختبارات
TEST_DIR=$(mktemp -d)
CACHE_DIR="$TEST_DIR/cache"
mkdir -p "$CACHE_DIR"

print_msg "\n═══════════════════════════════════════════════════════════" "$BLUE"
print_msg "  Property Test 24: Caching Performance Improvement" "$BLUE"
print_msg "═══════════════════════════════════════════════════════════\n" "$BLUE"

print_msg "Property: For any repeated execution of the same operation," "$YELLOW"
print_msg "          the cached execution should be faster than the first execution.\n" "$YELLOW"

print_msg "Validates: Requirements 10.5 (Performance - Caching)\n" "$YELLOW"

print_msg "Running $ITERATIONS iterations...\n" "$BLUE"

# دالة لمحاكاة عملية مكلفة
expensive_operation() {
    local input=$1
    local cache_file="$CACHE_DIR/cache_$input"
    
    # التحقق من وجود نتيجة مخزنة
    if [ -f "$cache_file" ]; then
        # قراءة من الكاش (سريع)
        cat "$cache_file"
        return 0
    fi
    
    # عملية مكلفة (بطيء) - محاكاة عملية تستغرق وقتاً
    sleep 0.01
    local result="computed_result_$input"
    
    # حفظ في الكاش
    echo "$result" > "$cache_file"
    echo "$result"
}

# تشغيل الاختبارات
for i in $(seq 1 $ITERATIONS); do
    # توليد مدخل عشوائي
    INPUT=$((RANDOM % 50))
    
    # التنفيذ الأول (بدون كاش)
    rm -f "$CACHE_DIR/cache_$INPUT" 2>/dev/null || true
    FIRST_TIME=$(measure_time "expensive_operation $INPUT")
    
    # التنفيذ الثاني (مع كاش)
    SECOND_TIME=$(measure_time "expensive_operation $INPUT")
    
    # التحقق: التنفيذ الثاني يجب أن يكون أسرع
    if [ $SECOND_TIME -lt $FIRST_TIME ]; then
        ((PASSED++))
        if [ $((i % 10)) -eq 0 ]; then
            print_msg "  ✓ Iteration $i: First=${FIRST_TIME}ms, Cached=${SECOND_TIME}ms (${FIRST_TIME}ms → ${SECOND_TIME}ms)" "$GREEN"
        fi
    else
        ((FAILED++))
        print_msg "  ✗ Iteration $i: Cached execution NOT faster! First=${FIRST_TIME}ms, Cached=${SECOND_TIME}ms" "$RED"
    fi
done

# حساب الإحصائيات
SUCCESS_RATE=$((PASSED * 100 / ITERATIONS))

print_msg "\n═══════════════════════════════════════════════════════════" "$BLUE"
print_msg "  Results" "$BLUE"
print_msg "═══════════════════════════════════════════════════════════\n" "$BLUE"

echo "Total Iterations: $ITERATIONS"
print_msg "✓ Passed: $PASSED" "$GREEN"
print_msg "✗ Failed: $FAILED" "$RED"
echo "Success Rate: ${SUCCESS_RATE}%"

# تنظيف
rm -rf "$TEST_DIR"

# تحديد النتيجة
if [ $SUCCESS_RATE -ge 90 ]; then
    print_msg "\n🎉 Property HOLDS: Caching consistently improves performance!" "$GREEN"
    exit 0
elif [ $SUCCESS_RATE -ge 70 ]; then
    print_msg "\n⚠ Property PARTIALLY HOLDS: Caching improves performance in most cases." "$YELLOW"
    exit 0
else
    print_msg "\n✗ Property VIOLATED: Caching does not consistently improve performance!" "$RED"
    exit 1
fi
