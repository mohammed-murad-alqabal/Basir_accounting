#!/bin/bash
# Archive Management Script - Error Tracking System
# المشروع: بصير MVP
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 3 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# المتغيرات
LOGS_DIR="logs"
ARCHIVE_DIR="${LOGS_DIR}/archive"
MAX_AGE_DAYS=7
MAX_SIZE_MB=10
TIMESTAMP=$(date +%Y-%m-%d)

# قراءة التكوين
CONFIG_FILE=".kiro/config/error_tracking.yml"
if [ -f "$CONFIG_FILE" ]; then
    MAX_AGE_DAYS=$(grep -A 4 "archive:" "$CONFIG_FILE" | grep "max_age_days:" | awk '{print $2}' || echo "7")
    MAX_SIZE_MB=$(grep -A 4 "archive:" "$CONFIG_FILE" | grep "max_size_mb:" | awk '{print $2}' || echo "10")
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}📦 إدارة أرشيف السجلات${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

START_TIME=$(date +%s)

# ===== 1. نقل السجلات القديمة =====
echo -e "${BLUE}📁 نقل السجلات القديمة (أكثر من ${MAX_AGE_DAYS} أيام)...${NC}"

MOVED_COUNT=0

# البحث عن ملفات .log القديمة
while IFS= read -r -d '' log_file; do
    # التحقق من عمر الملف
    if [ -f "$log_file" ]; then
        FILE_AGE_DAYS=$(( ($(date +%s) - $(stat -c %Y "$log_file" 2>/dev/null || stat -f %m "$log_file")) / 86400 ))
        
        if [ $FILE_AGE_DAYS -gt $MAX_AGE_DAYS ]; then
            # نقل إلى الأرشيف
            mv "$log_file" "$ARCHIVE_DIR/"
            echo -e "${YELLOW}  • نُقل: $(basename $log_file) (عمره ${FILE_AGE_DAYS} يوم)${NC}"
            ((MOVED_COUNT++))
        fi
    fi
done < <(find "$LOGS_DIR" -maxdepth 1 -name "*.log" -print0 2>/dev/null || true)

if [ $MOVED_COUNT -gt 0 ]; then
    echo -e "${GREEN}✅ تم نقل $MOVED_COUNT ملف إلى الأرشيف${NC}"
else
    echo -e "${YELLOW}ℹ️  لا توجد سجلات قديمة للنقل${NC}"
fi

echo ""

# ===== 2. فحص حجم الأرشيف =====
echo -e "${BLUE}📊 فحص حجم الأرشيف...${NC}"

# حساب حجم الأرشيف بالميجابايت
ARCHIVE_SIZE_KB=$(du -sk "$ARCHIVE_DIR" 2>/dev/null | cut -f1 || echo "0")
ARCHIVE_SIZE_MB=$((ARCHIVE_SIZE_KB / 1024))

echo -e "${BLUE}  • الحجم الحالي: ${ARCHIVE_SIZE_MB} MB${NC}"
echo -e "${BLUE}  • الحد الأقصى: ${MAX_SIZE_MB} MB${NC}"

echo ""

# ===== 3. ضغط الأرشيف إذا لزم الأمر =====
if [ $ARCHIVE_SIZE_MB -gt $MAX_SIZE_MB ]; then
    echo -e "${YELLOW}⚠️  حجم الأرشيف تجاوز الحد الأقصى${NC}"
    echo -e "${BLUE}🗜️  جاري ضغط الأرشيف...${NC}"
    
    # اسم ملف الأرشيف المضغوط
    ARCHIVE_FILE="${LOGS_DIR}/archive_${TIMESTAMP}.tar.gz"
    
    # ضغط جميع ملفات .log في الأرشيف
    if tar -czf "$ARCHIVE_FILE" -C "$ARCHIVE_DIR" . 2>/dev/null; then
        # حساب نسبة الضغط
        ORIGINAL_SIZE=$ARCHIVE_SIZE_KB
        COMPRESSED_SIZE=$(du -sk "$ARCHIVE_FILE" | cut -f1)
        COMPRESSION_RATIO=$(( (ORIGINAL_SIZE - COMPRESSED_SIZE) * 100 / ORIGINAL_SIZE ))
        
        echo -e "${GREEN}✅ تم ضغط الأرشيف بنجاح${NC}"
        echo -e "${GREEN}  • الحجم الأصلي: ${ARCHIVE_SIZE_MB} MB${NC}"
        echo -e "${GREEN}  • الحجم المضغوط: $((COMPRESSED_SIZE / 1024)) MB${NC}"
        echo -e "${GREEN}  • نسبة الضغط: ${COMPRESSION_RATIO}%${NC}"
        echo -e "${GREEN}  • الملف: $ARCHIVE_FILE${NC}"
        
        # حذف الملفات الأصلية بعد الضغط
        rm -f "$ARCHIVE_DIR"/*.log
        echo -e "${GREEN}✅ تم حذف الملفات الأصلية من الأرشيف${NC}"
    else
        echo -e "${RED}❌ فشل ضغط الأرشيف${NC}"
    fi
else
    echo -e "${GREEN}✅ حجم الأرشيف ضمن الحد المسموح${NC}"
fi

echo ""

# ===== 4. إحصائيات الأرشيف =====
echo -e "${BLUE}📈 إحصائيات الأرشيف:${NC}"

# عد الملفات
LOG_COUNT=$(find "$ARCHIVE_DIR" -name "*.log" 2>/dev/null | wc -l || echo "0")
COMPRESSED_COUNT=$(find "$LOGS_DIR" -name "archive_*.tar.gz" 2>/dev/null | wc -l || echo "0")

echo -e "${BLUE}  • ملفات .log في الأرشيف: $LOG_COUNT${NC}"
echo -e "${BLUE}  • ملفات مضغوطة: $COMPRESSED_COUNT${NC}"

# حساب الحجم الإجمالي
TOTAL_SIZE_KB=$(du -sk "$LOGS_DIR" 2>/dev/null | cut -f1 || echo "0")
TOTAL_SIZE_MB=$((TOTAL_SIZE_KB / 1024))
echo -e "${BLUE}  • الحجم الإجمالي للسجلات: ${TOTAL_SIZE_MB} MB${NC}"

echo ""

# ===== 5. دالة استخراج السجلات من الأرشيف =====
extract_from_archive() {
    local archive_file="$1"
    local output_dir="${2:-logs/extracted}"
    
    if [ ! -f "$archive_file" ]; then
        echo -e "${RED}❌ الملف غير موجود: $archive_file${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📦 جاري استخراج السجلات من: $(basename $archive_file)${NC}"
    
    # إنشاء مجلد الاستخراج
    mkdir -p "$output_dir"
    
    # استخراج الملفات
    if tar -xzf "$archive_file" -C "$output_dir" 2>/dev/null; then
        local extracted_count=$(find "$output_dir" -type f | wc -l)
        echo -e "${GREEN}✅ تم استخراج $extracted_count ملف إلى: $output_dir${NC}"
        return 0
    else
        echo -e "${RED}❌ فشل استخراج الأرشيف${NC}"
        return 1
    fi
}

# معالجة الخيارات
case "${1:-}" in
    --extract|-e)
        if [ -z "$2" ]; then
            echo -e "${RED}❌ يرجى تحديد ملف الأرشيف${NC}"
            echo -e "${YELLOW}الاستخدام: $0 --extract <archive_file> [output_dir]${NC}"
            exit 1
        fi
        extract_from_archive "$2" "$3"
        exit $?
        ;;
    --help|-h)
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}📦 سكريبت إدارة أرشيف السجلات${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "${BLUE}الاستخدام:${NC}"
        echo -e "  $0                    # تشغيل عملية الأرشفة التلقائية"
        echo -e "  $0 --extract <file>   # استخراج سجلات من أرشيف"
        echo -e "  $0 --help             # عرض هذه المساعدة"
        echo ""
        echo -e "${BLUE}أمثلة:${NC}"
        echo -e "  $0"
        echo -e "  $0 --extract logs/archive_2025-12-03.tar.gz"
        echo -e "  $0 --extract logs/archive_2025-12-03.tar.gz logs/temp"
        echo ""
        exit 0
        ;;
    "")
        # تشغيل عملية الأرشفة العادية
        ;;
    *)
        echo -e "${RED}❌ خيار غير معروف: $1${NC}"
        echo -e "${YELLOW}استخدم --help لعرض المساعدة${NC}"
        exit 1
        ;;
esac

# ===== النتيجة النهائية =====
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ اكتملت إدارة الأرشيف بنجاح!${NC}"
echo -e "${GREEN}⏱️  الوقت المستغرق: ${DURATION} ثانية${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit 0
