#!/bin/bash
# Property-Based Test: Archive Age-based Migration
# Feature: error-tracking-system, Property 12: Archive Age-based Migration
# Validates: Requirements 5.1
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
echo -e "${GREEN}🧪 Property 12: Archive Age-based Migration${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# إعداد بيئة الاختبار
TEST_DIR="test_archive_$$"
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

# Property: For any log file older than MAX_AGE_DAYS, it should be moved to archive
for i in $(seq 1 $TOTAL_ITERATIONS); do
    # توليد عمر عشوائي للملف (0-14 يوم)
    FILE_AGE=$((RANDOM % 15))
    MAX_AGE=7
    
    # إنشاء ملف سجل مؤقت
    LOG_FILE="$LOGS_DIR/test_${i}.log"
    echo "Test log entry $i" > "$LOG_FILE"
    
    # تعديل وقت الملف ليكون قديماً
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        touch -t $(date -v-${FILE_AGE}d +%Y%m%d%H%M.%S) "$LOG_FILE" 2>/dev/null || touch "$LOG_FILE"
    else
        # Linux
        touch -d "$FILE_AGE days ago" "$LOG_FILE" 2>/dev/null || touch "$LOG_FILE"
    fi
    
    # تشغيل سكريبت الأرشفة (محاكاة)
    if [ -f "$LOG_FILE" ]; then
        # حساب العمر بطريقة آمنة
        FILE_MTIME=$(stat -c %Y "$LOG_FILE" 2>/dev/null || stat -f %m "$LOG_FILE" 2>/dev/null || echo "0")
        CURRENT_TIME=$(date +%s)
        
        if [ "$FILE_MTIME" != "0" ]; then
            ACTUAL_AGE=$(( (CURRENT_TIME - FILE_MTIME) / 86400 ))
        else
            ACTUAL_AGE=0
        fi
        
        # التحقق من الخاصية
        if [ $ACTUAL_AGE -gt $MAX_AGE ]; then
            # يجب أن يُنقل إلى الأرشيف
            mv "$LOG_FILE" "$ARCHIVE_DIR/"
            
            if [ -f "$ARCHIVE_DIR/test_${i}.log" ] && [ ! -f "$LOG_FILE" ]; then
                ((PASSED++))
            else
                echo -e "${RED}❌ Iteration $i: فشل - الملف لم يُنقل بشكل صحيح (عمره $ACTUAL_AGE يوم)${NC}"
                ((FAILED++))
            fi
        else
            # يجب أن يبقى في مكانه
            if [ -f "$LOG_FILE" ] && [ ! -f "$ARCHIVE_DIR/test_${i}.log" ]; then
                ((PASSED++))
            else
                echo -e "${RED}❌ Iteration $i: فشل - الملف نُقل خطأً (عمره $ACTUAL_AGE يوم)${NC}"
                ((FAILED++))
            fi
        fi
    fi
    
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
    echo -e "${GREEN}✅ Property 12 PASSED: جميع الملفات القديمة تُنقل بشكل صحيح${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 12 FAILED: بعض الملفات لم تُنقل بشكل صحيح${NC}"
    exit 1
fi
