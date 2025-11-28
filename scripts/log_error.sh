#!/bin/bash

# نظام تسجيل الأخطاء التلقائي
# يقوم بتسجيل الأخطاء في ملف وإنشاء Issue على GitHub إذا لزم الأمر

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# المجلدات
LOG_DIR="logs/errors"
REPORT_DIR="logs/reports"

# إنشاء المجلدات إذا لم تكن موجودة
mkdir -p "$LOG_DIR"
mkdir -p "$REPORT_DIR"

# الحصول على التاريخ والوقت
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
DATE=$(date '+%Y-%m-%d')

# ملف السجل
LOG_FILE="$LOG_DIR/error_${TIMESTAMP}.log"
DAILY_REPORT="$REPORT_DIR/daily_report_${DATE}.md"

# دالة لتسجيل الأخطاء
log_error() {
    local error_type="$1"
    local error_message="$2"
    local file_path="$3"
    local line_number="$4"
    
    echo -e "${RED}[ERROR]${NC} $error_type: $error_message"
    
    # كتابة في ملف السجل
    cat >> "$LOG_FILE" << EOF
===========================================
Timestamp: $TIMESTAMP
Type: $error_type
Message: $error_message
File: $file_path
Line: $line_number
===========================================

EOF
    
    # إضافة إلى التقرير اليومي
    if [ ! -f "$DAILY_REPORT" ]; then
        cat > "$DAILY_REPORT" << EOF
# تقرير الأخطاء اليومي - $DATE

## الأخطاء المسجلة

EOF
    fi
    
    cat >> "$DAILY_REPORT" << EOF
### [$TIMESTAMP] $error_type
- **الرسالة:** $error_message
- **الملف:** \`$file_path\`
- **السطر:** $line_number

EOF
}

# دالة لتحليل أخطاء Flutter
analyze_flutter_errors() {
    echo -e "${YELLOW}[INFO]${NC} تحليل أخطاء Flutter..."
    
    flutter analyze > /tmp/flutter_analyze.txt 2>&1 || true
    
    # استخراج الأخطاء
    grep -E "error •|warning •" /tmp/flutter_analyze.txt | while read -r line; do
        error_type=$(echo "$line" | grep -oP "(error|warning)")
        error_message=$(echo "$line" | cut -d'•' -f2 | cut -d'•' -f1 | xargs)
        file_path=$(echo "$line" | grep -oP "lib/[^ ]*" || echo "unknown")
        
        log_error "$error_type" "$error_message" "$file_path" "N/A"
    done
    
    echo -e "${GREEN}[SUCCESS]${NC} تم تحليل أخطاء Flutter"
}

# دالة لتحليل أخطاء الاختبارات
analyze_test_errors() {
    echo -e "${YELLOW}[INFO]${NC} تحليل أخطاء الاختبارات..."
    
    flutter test > /tmp/flutter_test.txt 2>&1 || true
    
    # استخراج الاختبارات الفاشلة
    grep -E "FAILED|ERROR" /tmp/flutter_test.txt | while read -r line; do
        log_error "test_failure" "$line" "test" "N/A"
    done
    
    echo -e "${GREEN}[SUCCESS]${NC} تم تحليل أخطاء الاختبارات"
}

# دالة لإنشاء تقرير شامل
generate_summary_report() {
    local summary_file="$REPORT_DIR/summary_${DATE}.md"
    
    echo -e "${YELLOW}[INFO]${NC} إنشاء تقرير شامل..."
    
    # عدد الأخطاء
    local error_count=$(grep -c "Type: error" "$LOG_DIR"/*.log 2>/dev/null || echo "0")
    local warning_count=$(grep -c "Type: warning" "$LOG_DIR"/*.log 2>/dev/null || echo "0")
    
    cat > "$summary_file" << EOF
# تقرير الأخطاء الشامل - $DATE

## الإحصائيات

| النوع | العدد |
|:---|:---:|
| **Errors** | $error_count |
| **Warnings** | $warning_count |
| **الإجمالي** | $((error_count + warning_count)) |

## الملفات الأكثر تأثراً

EOF
    
    # استخراج الملفات الأكثر تأثراً
    grep "File:" "$LOG_DIR"/*.log 2>/dev/null | \
        cut -d':' -f3 | \
        sort | uniq -c | sort -rn | head -10 | \
        while read -r count file; do
            echo "- \`$file\`: $count مشكلة" >> "$summary_file"
        done
    
    echo -e "${GREEN}[SUCCESS]${NC} تم إنشاء التقرير الشامل: $summary_file"
}

# دالة لإنشاء Issue على GitHub (اختياري)
create_github_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"
    
    if [ -z "$GITHUB_TOKEN" ]; then
        echo -e "${YELLOW}[WARNING]${NC} GITHUB_TOKEN غير معرف. تخطي إنشاء Issue."
        return
    fi
    
    echo -e "${YELLOW}[INFO]${NC} إنشاء Issue على GitHub..."
    
    # استخدام GitHub CLI إذا كان متوفراً
    if command -v gh &> /dev/null; then
        gh issue create --title "$title" --body "$body" --label "$labels"
        echo -e "${GREEN}[SUCCESS]${NC} تم إنشاء Issue على GitHub"
    else
        echo -e "${YELLOW}[WARNING]${NC} GitHub CLI غير متوفر. تخطي إنشاء Issue."
    fi
}

# دالة لتنظيف السجلات القديمة
cleanup_old_logs() {
    echo -e "${YELLOW}[INFO]${NC} تنظيف السجلات القديمة..."
    
    # حذف السجلات الأقدم من 30 يوم
    find "$LOG_DIR" -name "*.log" -mtime +30 -delete
    find "$REPORT_DIR" -name "*.md" -mtime +30 -delete
    
    echo -e "${GREEN}[SUCCESS]${NC} تم تنظيف السجلات القديمة"
}

# الدالة الرئيسية
main() {
    echo -e "${GREEN}=== نظام تسجيل الأخطاء ===${NC}"
    echo ""
    
    # تحليل الأخطاء
    analyze_flutter_errors
    analyze_test_errors
    
    # إنشاء التقارير
    generate_summary_report
    
    # تنظيف السجلات القديمة
    cleanup_old_logs
    
    echo ""
    echo -e "${GREEN}[SUCCESS]${NC} تم إكمال تسجيل الأخطاء"
    echo -e "${GREEN}[INFO]${NC} ملف السجل: $LOG_FILE"
    echo -e "${GREEN}[INFO]${NC} التقرير اليومي: $DAILY_REPORT"
}

# تشغيل البرنامج
main "$@"
