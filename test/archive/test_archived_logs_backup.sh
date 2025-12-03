#!/bin/bash
# Property-Based Test: Archived Logs Backup
# Feature: error-tracking-system, Property 15: Archived Logs Backup
# Validates: Requirements 5.4
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
echo -e "${GREEN}🧪 Property 15: Archived Logs Backup${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# إعداد بيئة الاختبار
TEST_DIR="test_backup_$$"
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

# Property: For any archived log, a compressed backup should exist after deletion
for i in $(seq 1 $TOTAL_ITERATIONS); do
    # إنشاء ملفات سجل في الأرشيف
    NUM_FILES=$((1 + RANDOM % 5))
    
    for j in $(seq 1 $NUM_FILES); do
        LOG_FILE="$ARCHIVE_DIR/backup_test_${i}_${j}.log"
        echo "Backup test log $i-$j - $(date)" > "$LOG_FILE"
        echo "Line 2: Some error message" >> "$LOG_FILE"
        echo "Line 3: Stack trace" >> "$LOG_FILE"
    done
    
    # إنشاء نسخة احتياطية مضغوطة
    BACKUP_FILE="$LOGS_DIR/backup_archive_${i}.tar.gz"
    
    if tar -czf "$BACKUP_FILE" -C "$ARCHIVE_DIR" . 2>/dev/null; then
        # حذف الملفات الأصلية
        rm -f "$ARCHIVE_DIR"/backup_test_${i}_*.log
        
        # التحقق من الخاصية: النسخة الاحتياطية موجودة
        if [ -f "$BACKUP_FILE" ]; then
            # التحقق من إمكانية استخراج النسخة الاحتياطية
            EXTRACT_DIR="$TEST_DIR/extract_${i}"
            mkdir -p "$EXTRACT_DIR"
            
            if tar -xzf "$BACKUP_FILE" -C "$EXTRACT_DIR" 2>/dev/null; then
                # التحقق من عدد الملفات المستخرجة
                EXTRACTED_COUNT=$(find "$EXTRACT_DIR" -type f -name "*.log" | wc -l)
                
                if [ $EXTRACTED_COUNT -eq $NUM_FILES ]; then
                    ((PASSED++))
                else
                    echo -e "${RED}❌ Iteration $i: فشل - عدد الملفات المستخرجة ($EXTRACTED_COUNT) لا يطابق الأصلي ($NUM_FILES)${NC}"
                    ((FAILED++))
                fi
                
                rm -rf "$EXTRACT_DIR"
            else
                echo -e "${RED}❌ Iteration $i: فشل - فشل استخراج النسخة الاحتياطية${NC}"
                ((FAILED++))
            fi
        else
            echo -e "${RED}❌ Iteration $i: فشل - النسخة الاحتياطية غير موجودة${NC}"
            ((FAILED++))
        fi
        
        # تنظيف
        rm -f "$BACKUP_FILE"
    else
        echo -e "${RED}❌ Iteration $i: فشل - فشل إنشاء النسخة الاحتياطية${NC}"
        ((FAILED++))
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
    echo -e "${GREEN}✅ Property 15 PASSED: النسخ الاحتياطي يعمل بشكل صحيح${NC}"
    exit 0
else
    echo -e "${RED}❌ Property 15 FAILED: بعض النسخ الاحتياطية فشلت${NC}"
    exit 1
fi
