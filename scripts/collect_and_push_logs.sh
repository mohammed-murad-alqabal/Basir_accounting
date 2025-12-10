#!/bin/bash

# نظام جمع ودفع السجلات التلقائي
# يقوم بجمع جميع السجلات والتقارير ودفعها إلى GitHub

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   نظام جمع ودفع السجلات التلقائي    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# المجلدات
LOG_DIR="logs"
REPORT_DIR="logs/reports"
ERROR_DIR="logs/errors"
ARCHIVE_DIR="logs/archive"

# التاريخ
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# إنشاء المجلدات إذا لم تكن موجودة
mkdir -p "$LOG_DIR" "$REPORT_DIR" "$ERROR_DIR" "$ARCHIVE_DIR"

# دالة لتسجيل الرسائل
log_message() {
    local level="$1"
    local message="$2"
    local color="$NC"
    
    case "$level" in
        "INFO") color="$BLUE" ;;
        "SUCCESS") color="$GREEN" ;;
        "WARNING") color="$YELLOW" ;;
        "ERROR") color="$RED" ;;
    esac
    
    echo -e "${color}[$level]${NC} $message"
}

# دالة لجمع سجلات Flutter Analyze
collect_analyze_logs() {
    log_message "INFO" "جمع سجلات Flutter Analyze..."
    
    local output_file="$LOG_DIR/flutter_analyze_${TIMESTAMP}.log"
    
    if flutter analyze > "$output_file" 2>&1; then
        log_message "SUCCESS" "تم جمع سجلات Flutter Analyze"
    else
        log_message "WARNING" "Flutter Analyze أنتج أخطاء (تم حفظها)"
    fi
    
    # استخراج الإحصائيات
    local errors=$(grep -c "error •" "$output_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c "warning •" "$output_file" 2>/dev/null || echo "0")
    local info=$(grep -c "info •" "$output_file" 2>/dev/null || echo "0")
    
    log_message "INFO" "Errors: $errors, Warnings: $warnings, Info: $info"
}

# دالة لجمع سجلات الاختبارات
collect_test_logs() {
    log_message "INFO" "جمع سجلات الاختبارات..."
    
    local output_file="$LOG_DIR/flutter_test_${TIMESTAMP}.log"
    
    if flutter test --coverage > "$output_file" 2>&1; then
        log_message "SUCCESS" "تم جمع سجلات الاختبارات"
    else
        log_message "WARNING" "بعض الاختبارات فشلت (تم حفظها)"
    fi
    
    # استخراج نتائج الاختبارات
    local passed=$(grep -oP '\+\K[0-9]+' "$output_file" 2>/dev/null | tail -1 || echo "0")
    local failed=$(grep -oP '\-\K[0-9]+' "$output_file" 2>/dev/null | tail -1 || echo "0")
    
    log_message "INFO" "Passed: $passed, Failed: $failed"
}

# دالة لإنشاء تقرير شامل
generate_comprehensive_report() {
    log_message "INFO" "إنشاء تقرير شامل..."
    
    local report_file="$REPORT_DIR/comprehensive_report_${DATE}.md"
    
    # عدد الملفات
    local dart_files=$(find lib -name "*.dart" 2>/dev/null | wc -l)
    local test_files=$(find test -name "*.dart" 2>/dev/null | wc -l)
    
    # حجم المشروع
    local project_size=$(du -sh . 2>/dev/null | cut -f1)
    
    # آخر commit
    local last_commit=$(git log -1 --pretty=format:"%h - %s (%cr)" 2>/dev/null || echo "N/A")
    
    # الفرع الحالي
    local current_branch=$(git branch --show-current 2>/dev/null || echo "N/A")
    
    # إحصائيات Git
    local total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    local contributors=$(git shortlog -sn --all 2>/dev/null | wc -l || echo "0")
    
    cat > "$report_file" << EOF
# تقرير شامل - $DATE

## 📊 معلومات المشروع

| المعلومة | القيمة |
|:---|:---|
| **التاريخ** | $DATE |
| **الوقت** | $(date '+%H:%M:%S') |
| **الفرع** | $current_branch |
| **آخر Commit** | $last_commit |
| **حجم المشروع** | $project_size |

## 📁 إحصائيات الملفات

| النوع | العدد |
|:---|:---:|
| **ملفات Dart** | $dart_files |
| **ملفات الاختبار** | $test_files |
| **النسبة** | $(echo "scale=2; $test_files * 100 / $dart_files" | bc 2>/dev/null || echo "N/A")% |

## 🔄 إحصائيات Git

| المعلومة | القيمة |
|:---|:---:|
| **إجمالي Commits** | $total_commits |
| **المساهمون** | $contributors |
| **الفروع** | $(git branch -a 2>/dev/null | wc -l || echo "0") |

## 📝 السجلات المجمعة

EOF
    
    # إضافة قائمة السجلات
    if [ -d "$LOG_DIR" ]; then
        echo "### سجلات اليوم" >> "$report_file"
        echo "" >> "$report_file"
        ls -lh "$LOG_DIR"/*_${DATE}*.log 2>/dev/null | awk '{print "- `" $9 "` (" $5 ")"}' >> "$report_file" || echo "- لا توجد سجلات" >> "$report_file"
    fi
    
    # إضافة ملخص الأخطاء
    echo "" >> "$report_file"
    echo "## 🐛 ملخص الأخطاء" >> "$report_file"
    echo "" >> "$report_file"
    
    if [ -d "$ERROR_DIR" ]; then
        local error_count=$(find "$ERROR_DIR" -name "*.log" -mtime -1 2>/dev/null | wc -l)
        echo "- **أخطاء اليوم:** $error_count" >> "$report_file"
    fi
    
    # إضافة التوصيات
    echo "" >> "$report_file"
    echo "## 💡 التوصيات" >> "$report_file"
    echo "" >> "$report_file"
    
    # فحص التغطية
    if [ -f "coverage/lcov.info" ]; then
        local coverage=$(lcov --summary coverage/lcov.info 2>&1 | grep lines | awk '{print $2}' | sed 's/%//' || echo "0")
        if (( $(echo "$coverage < 70" | bc -l 2>/dev/null || echo "1") )); then
            echo "- ⚠️ **تحسين التغطية:** التغطية الحالية ${coverage}% (الهدف: 70%+)" >> "$report_file"
        else
            echo "- ✅ **التغطية ممتازة:** ${coverage}%" >> "$report_file"
        fi
    fi
    
    # فحص الأخطاء
    local latest_analyze="$LOG_DIR/flutter_analyze_${TIMESTAMP}.log"
    if [ -f "$latest_analyze" ]; then
        local errors=$(grep -c "error •" "$latest_analyze" 2>/dev/null || echo "0")
        if [ "$errors" -gt "0" ]; then
            echo "- ⚠️ **إصلاح الأخطاء:** يوجد $errors خطأ حرج" >> "$report_file"
        else
            echo "- ✅ **لا توجد أخطاء حرجة**" >> "$report_file"
        fi
    fi
    
    echo "" >> "$report_file"
    echo "---" >> "$report_file"
    echo "*تم إنشاء هذا التقرير تلقائياً بواسطة نظام جمع السجلات*" >> "$report_file"
    
    log_message "SUCCESS" "تم إنشاء التقرير: $report_file"
}

# دالة لأرشفة السجلات القديمة
archive_old_logs() {
    log_message "INFO" "أرشفة السجلات القديمة..."
    
    # أرشفة السجلات الأقدم من 7 أيام
    find "$LOG_DIR" -name "*.log" -mtime +7 -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null || true
    find "$REPORT_DIR" -name "*.md" -mtime +7 -exec mv {} "$ARCHIVE_DIR/" \; 2>/dev/null || true
    
    # ضغط الأرشيف إذا كان كبيراً
    if [ -d "$ARCHIVE_DIR" ] && [ "$(du -s "$ARCHIVE_DIR" | cut -f1)" -gt 10000 ]; then
        local archive_file="$ARCHIVE_DIR/archive_${DATE}.tar.gz"
        tar -czf "$archive_file" -C "$ARCHIVE_DIR" . 2>/dev/null || true
        find "$ARCHIVE_DIR" -name "*.log" -delete 2>/dev/null || true
        find "$ARCHIVE_DIR" -name "*.md" -delete 2>/dev/null || true
        log_message "SUCCESS" "تم ضغط الأرشيف: $archive_file"
    fi
    
    log_message "SUCCESS" "تم أرشفة السجلات القديمة"
}

# دالة لدفع السجلات إلى Git
push_logs_to_git() {
    log_message "INFO" "دفع السجلات إلى Git..."
    
    # التحقق من وجود تغييرات
    if [ -z "$(git status --porcelain logs/)" ]; then
        log_message "INFO" "لا توجد تغييرات جديدة في السجلات"
        return
    fi
    
    # إضافة السجلات
    git add logs/ 2>/dev/null || true
    
    # إنشاء commit
    local commit_msg="chore(logs): تحديث السجلات - $DATE

- تم جمع سجلات Flutter Analyze
- تم جمع سجلات الاختبارات
- تم إنشاء التقرير الشامل
- تم أرشفة السجلات القديمة

[skip ci]"
    
    if git commit -m "$commit_msg" 2>/dev/null; then
        log_message "SUCCESS" "تم إنشاء commit للسجلات"
        
        # دفع إلى GitHub
        if git push 2>/dev/null; then
            log_message "SUCCESS" "تم دفع السجلات إلى GitHub"
        else
            log_message "WARNING" "فشل دفع السجلات (قد تحتاج إلى push يدوي)"
        fi
    else
        log_message "WARNING" "لا توجد تغييرات للـ commit"
    fi
}

# دالة لإنشاء ملخص
print_summary() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           ملخص العملية                ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # عدد الملفات
    local log_count=$(find "$LOG_DIR" -name "*.log" -mtime -1 2>/dev/null | wc -l)
    local report_count=$(find "$REPORT_DIR" -name "*.md" -mtime -1 2>/dev/null | wc -l)
    
    echo -e "${GREEN}✅ السجلات المجمعة:${NC} $log_count"
    echo -e "${GREEN}✅ التقارير المنشأة:${NC} $report_count"
    
    # حجم السجلات
    local logs_size=$(du -sh "$LOG_DIR" 2>/dev/null | cut -f1 || echo "N/A")
    echo -e "${GREEN}✅ حجم السجلات:${NC} $logs_size"
    
    # آخر تقرير
    local latest_report=$(ls -t "$REPORT_DIR"/*.md 2>/dev/null | head -1)
    if [ ! -z "$latest_report" ]; then
        echo -e "${GREEN}✅ آخر تقرير:${NC} $(basename "$latest_report")"
    fi
    
    echo ""
    echo -e "${BLUE}[INFO]${NC} للاطلاع على التقرير الشامل:"
    echo -e "  ${GREEN}cat $REPORT_DIR/comprehensive_report_${DATE}.md${NC}"
    echo ""
}

# الدالة الرئيسية
main() {
    log_message "INFO" "بدء عملية جمع السجلات..."
    echo ""
    
    # 1. جمع السجلات
    collect_analyze_logs
    collect_test_logs
    
    # 2. إنشاء التقارير
    generate_comprehensive_report
    
    # 3. أرشفة السجلات القديمة
    archive_old_logs
    
    # 4. دفع إلى Git (اختياري)
    if [ "$1" == "--push" ] || [ "$1" == "-p" ]; then
        push_logs_to_git
    else
        log_message "INFO" "تخطي دفع السجلات (استخدم --push للدفع)"
    fi
    
    # 5. عرض الملخص
    print_summary
    
    log_message "SUCCESS" "تمت عملية جمع السجلات بنجاح!"
}

# تشغيل البرنامج
main "$@"
