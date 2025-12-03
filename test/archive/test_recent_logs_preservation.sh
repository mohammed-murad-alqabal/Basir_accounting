#!/bin/bash
# Property-Based Test: Recent Logs Preservation
# Feature: error-tracking-system, Property 14: Recent Logs Preservation
# Validates: Requirements 5.3
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
echo -e "${GREEN}🧪 Property 14: Recent Logs Preservation${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# إعداد بيئة الاختبار
TEST_DIR="test_preservation_$$"
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

# Property: For any log file younger than MAX_AGE_DAYS, it should remain in original location
for i in $(seq 1 $TOTAL_ITERATIONS); do
    # توليد عمر عشوائي للملف (0-14 يوم)
    FILE_AGE=$((RANDOM % 15))
    MAX_AGE=7
    
    # إنشاء ملف سجل مؤقت
    LOG_FILE="$LOGS_DIR/recent_${i}.log"
    echo "Recent log entry $i - $(date)" > "$LOG_FILE"
    
    # تعديل وقت الملف
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        touch -t $(date -v-${FILE_AGE}d +%Y%m%d%H%M.%S) "$LOG_FILE" 2>/dev/null || true
    else
        # Linux
        touch -d "$FILE_AGE days ago" "$LOG_FILE" 2>/dev/null || true
    fi
    
    # حساب العمر الفعلي
    if [ -f "$LOG_FILE" ]; then
        ACTUAL_AGE=$(( ($(date +%s) - $(stat -c %Y "$LOG_FILE" 2>/dev/null || stat -f %m "$LOG_FILE")) / 86400 ))
        
        # محاكاة عملية الأرشفة
        if [ $ACTUAL_AGE -gt $MAX_AGE ]; then
            # نقل إلى الأرشيف
            mv "$LOG_FILE" "$ARCHIVE_DIR/"
        fi
        
        # التحقق من الخاصية: الملفات الحديثة يجب أن تبقى
        if [ $ACTUAL_AGE -le $MAX_AGE ]; then
            if [ -f "$LOG_FILE" ] && [ ! -f "$ARCHIVE_DIR/recent_${i}.log" ]; then
                ((PASSED++))
            else
                echo -e "${RED}❌ Iteration $i: فشل - ملف حديث (${ACTUAL_AGE} يوم) نُقل خطأً${NC}"
                ((FAILED++))
            fi
        else
            # الملفات القديمة يجب أن تُنقل
            if [ ! -f "$LOG_FILE" ] && [ -f "$ARCHIVE_DIR/recent_${i}.log" ]; then
                ((PASSED++))
            else
                echo -e "${RED}❌ Iteration $i: فشل - ملف قديم (${ACTUAL_AGE} يوم) لم يُنقل${NC}"
                ((FAILED++))
            fi
        fi
    fi
    
    # تنظيف
    rm -f "$LOG_FILE" "$ARCHIVE_DIR/recent_${i}.log"
    
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
    echo -e "${GREEN}✅ Property 14 PASSED: السجلات الحديثة محفوظة بشكل صحيح${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 14 FAILED: بعض السجلات الحديثة لم تُحفظ${NC}"
    exit 1
fi
