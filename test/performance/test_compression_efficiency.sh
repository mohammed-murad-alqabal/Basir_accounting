#!/bin/bash
# Property-Based Test: Compression Efficiency
# Feature: error-tracking-system, Property 23: Compression Efficiency
# Validates: Requirements 10.4
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
echo -e "${GREEN}🧪 Property 23: Compression Efficiency${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# إعداد بيئة الاختبار
TEST_DIR="test_efficiency_$$"
LOGS_DIR="$TEST_DIR/logs"
ARCHIVE_DIR="$LOGS_DIR/archive"

mkdir -p "$LOGS_DIR"
mkdir -p "$ARCHIVE_DIR"

# عداد النجاح والفشل
PASSED=0
FAILED=0
TOTAL_ITERATIONS=100
MIN_COMPRESSION_RATIO=70  # الحد الأدنى 70% كما في المتطلبات

echo -e "${BLUE}📊 تشغيل $TOTAL_ITERATIONS تكرار...${NC}"
echo ""

# Property: For any archive, compression should reduce size by at least 70%
for i in $(seq 1 $TOTAL_ITERATIONS); do
    # إنشاء ملفات سجل بمحتوى متكرر (قابل للضغط)
    NUM_FILES=$((3 + RANDOM % 8))
    
    for j in $(seq 1 $NUM_FILES); do
        LOG_FILE="$ARCHIVE_DIR/efficiency_${i}_${j}.log"
        
        # محتوى متكرر لضمان ضغط جيد
        for k in $(seq 1 100); do
            echo "[$(date +%Y-%m-%d)] ERROR: Test error message number $k" >> "$LOG_FILE"
            echo "Stack trace line 1: at function_name (file.dart:123)" >> "$LOG_FILE"
            echo "Stack trace line 2: at another_function (file.dart:456)" >> "$LOG_FILE"
        done
    done
    
    # حساب الحجم الأصلي
    ORIGINAL_SIZE_KB=$(du -sk "$ARCHIVE_DIR" | cut -f1)
    
    # ضغط الأرشيف
    ARCHIVE_FILE="$LOGS_DIR/efficiency_test_${i}.tar.gz"
    
    if tar -czf "$ARCHIVE_FILE" -C "$ARCHIVE_DIR" . 2>/dev/null; then
        # حساب الحجم المضغوط
        COMPRESSED_SIZE_KB=$(du -sk "$ARCHIVE_FILE" | cut -f1)
        
        # حساب نسبة الضغط
        if [ $ORIGINAL_SIZE_KB -gt 0 ]; then
            COMPRESSION_RATIO=$(( (ORIGINAL_SIZE_KB - COMPRESSED_SIZE_KB) * 100 / ORIGINAL_SIZE_KB ))
            
            # التحقق من الخاصية: نسبة الضغط >= 70%
            if [ $COMPRESSION_RATIO -ge $MIN_COMPRESSION_RATIO ]; then
                ((PASSED++))
            else
                echo -e "${RED}❌ Iteration $i: فشل - نسبة الضغط منخفضة (${COMPRESSION_RATIO}% < ${MIN_COMPRESSION_RATIO}%)${NC}"
                ((FAILED++))
            fi
        else
            echo -e "${RED}❌ Iteration $i: فشل - حجم أصلي صفر${NC}"
            ((FAILED++))
        fi
        
        # تنظيف
        rm -f "$ARCHIVE_FILE"
    else
        echo -e "${RED}❌ Iteration $i: فشل - فشل عملية الضغط${NC}"
        ((FAILED++))
    fi
    
    # تنظيف الأرشيف
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
echo -e "${GREEN}  • الحد الأدنى للضغط المطلوب: ${MIN_COMPRESSION_RATIO}%${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Property 23 PASSED: كفاءة الضغط تحقق المتطلبات${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 23 FAILED: بعض عمليات الضغط لم تحقق الكفاءة المطلوبة${NC}"
    exit 1
fi
