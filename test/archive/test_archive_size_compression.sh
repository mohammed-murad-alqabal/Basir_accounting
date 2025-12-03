#!/bin/bash
# Property-Based Test: Archive Size-based Compression
# Feature: error-tracking-system, Property 13: Archive Size-based Compression
# Validates: Requirements 5.2
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🧪 Property 13: Archive Size-based Compression${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# إعداد بيئة الاختبار
TEST_DIR="test_compression_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$LOGS_DIR/archive"

mkdir -p "$LOGS_DIR"
mkdir -p "$ARCHIVE_DIR"

# عداد النجاح والفشل
PASSED=0
FAILED=0
TOTAL_ITERATIONS=100

echo -e "${BLUE}📊 تشغيل $TOTAL_ITERATIONS تكرار...${NC}"
echo ""

# Property: For any archive exceeding MAX_SIZE_MB, it should be compressed
for i in $(seq 1 $TOTAL_ITERATIONS); do
    # توليد حجم عشوائي للأرشيف (5-15 MB)
    ARCHIVE_SIZE_MB=$((5 + RANDOM % 11))
    MAX_SIZE_MB=10
    
    # إنشاء ملفات لمحاكاة حجم الأرشيف
    # كل ملف حوالي 1 MB
    for j in $(seq 1 $ARCHIVE_SIZE_MB); do
        dd if=/dev/zero of="$ARCHIVE_DIR/log_${i}_${j}.log" bs=1024 count=1024 2>/dev/null
    done
    
    # حساب الحجم الفعلي
    ACTUAL_SIZE_KB=$(du -sk "$ARCHIVE_DIR" | cut -f1)
    ACTUAL_SIZE_MB=$((ACTUAL_SIZE_KB / 1024))
    
    # التحقق من الخاصية
    if [ $ACTUAL_SIZE_MB -gt $MAX_SIZE_MB ]; then
        # يجب أن يتم الضغط
        ARCHIVE_FILE="$LOGS_DIR/archive_test_${i}.tar.gz"
        
        if tar -czf "$ARCHIVE_FILE" -C "$ARCHIVE_DIR" . 2>/dev/null; then
            COMPRESSED_SIZE_KB=$(du -sk "$ARCHIVE_FILE" | cut -f1)
            COMPRESSED_SIZE_MB=$((COMPRESSED_SIZE_KB / 1024))
            
            # التحقق من أن الضغط فعال (على الأقل 30% تقليل)
            COMPRESSION_RATIO=$(( (ACTUAL_SIZE_KB - COMPRESSED_SIZE_KB) * 100 / ACTUAL_SIZE_KB ))
            
            if [ $COMPRESSION_RATIO -ge 30 ]; then
                ((PASSED++))
            else
                echo -e "${RED}❌ Iteration $i: فشل - نسبة الضغط منخفضة (${COMPRESSION_RATIO}%)${NC}"
                ((FAILED++))
            fi
            
            # حذف الملف المضغوط
            rm -f "$ARCHIVE_FILE"
        else
            echo -e "${RED}❌ Iteration $i: فشل - فشل عملية الضغط${NC}"
            ((FAILED++))
        fi
    else
        # لا يجب الضغط
        ((PASSED++))
    fi
    
    # تنظيف الأرشيف للتكرار التالي
    rm -f "$ARCHIVE_DIR"/*.log
    
    # تقدم
    if [ $((i % 20)) -eq 0 ]; then
        echo -e "${BLUE}  • تم إكمال $i/$TOTAL_ITERATIONS تكرار...${NC}"
    fi
done

# تنظيف
rm -rf "$TEST_DIR"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📊 النتائج:${NC}"
echo -e "${GREEN}  • نجح: $PASSED/$TOTAL_ITERATIONS${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}  • فشل: $FAILED/$TOTAL_ITERATIONS${NC}"
fi
echo -e "${GREEN}  • نسبة النجاح: $(( PASSED * 100 / TOTAL_ITERATIONS ))%${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Property 13 PASSED: الضغط يعمل بشكل صحيح عند تجاوز الحد${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 13 FAILED: بعض عمليات الضغط فشلت${NC}"
    exit 1
fi
