#!/bin/bash

# Repository Health Monitor
# نظام المراقبة المستمرة للمستودع
# المشروع: بصير MVP

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# المتغيرات
ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
REPORT_DIR="$ROOT_DIR/Documentation/reports/automated"
LOG_FILE="$ROOT_DIR/.kiro/automation/monitor.log"
METRICS_FILE="$ROOT_DIR/.kiro/automation/metrics.json"
MAX_ROOT_FILES=10
MAX_REPO_SIZE=$((500 * 1024 * 1024)) # 500 MB
AUTO_FIX=true

# إنشاء المجلدات
mkdir -p "$REPORT_DIR"
mkdir -p "$(dirname $LOG_FILE)"
mkdir -p "$(dirname $METRICS_FILE)"

# ====================
# دوال مساعدة
# ====================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ====================
# 1. فحص صحة المستودع
# ====================

check_repository_health() {
    print_header "🏥 فحص صحة المستودع"
    
    local issues=0
    local warnings=0
    local fixes=0
    
    # فحص عدد الملفات في الجذر
    echo -e "${BLUE}[1/8]${NC} فحص تنظيم الجذر..."
    local root_md_count=$(ls -1 "$ROOT_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$root_md_count" -gt "$MAX_ROOT_FILES" ]; then
        echo -e "${YELLOW}⚠${NC} عدد ملفات .md في الجذر: $root_md_count (الحد الأقصى: $MAX_ROOT_FILES)"
        warnings=$((warnings + 1))
        log "WARNING: Too many files in root: $root_md_count"
    else
        echo -e "${GREEN}✓${NC} الجذر منظم ($root_md_count ملفات)"
    fi
    
    # فحص حجم المستودع
    echo -e "${BLUE}[2/8]${NC} فحص حجم المستودع..."
    local repo_size=$(du -sb "$ROOT_DIR" 2>/dev/null | cut -f1)
    local repo_size_mb=$((repo_size / 1024 / 1024))
    if [ "$repo_size" -gt "$MAX_REPO_SIZE" ]; then
        echo -e "${YELLOW}⚠${NC} حجم المستودع: ${repo_size_mb} MB (الحد الأقصى: 500 MB)"
        warnings=$((warnings + 1))
        log "WARNING: Repository size: ${repo_size_mb} MB"
    else
        echo -e "${GREEN}✓${NC} حجم المستودع: ${repo_size_mb} MB"
    fi
    
    # فحص الملفات المؤقتة
    echo -e "${BLUE}[3/8]${NC} البحث عن ملفات مؤقتة..."
    local temp_files=$(find "$ROOT_DIR" -type f \( -name "test_*.txt" -o -name "test_*.json" -o -name "*.log" -o -name "*.tmp" \) 2>/dev/null | wc -l | tr -d ' ')
    if [ "$temp_files" -gt 0 ]; then
        echo -e "${YELLOW}⚠${NC} وجد $temp_files ملف مؤقت"
        warnings=$((warnings + 1))
        
        if [ "$AUTO_FIX" = true ]; then
            echo -e "${CYAN}🔧${NC} تنظيف الملفات المؤقتة..."
            find "$ROOT_DIR" -type f \( -name "test_*.txt" -o -name "test_*.json" \) -delete 2>/dev/null || true
            fixes=$((fixes + 1))
            echo -e "${GREEN}✓${NC} تم التنظيف"
        fi
    else
        echo -e "${GREEN}✓${NC} لا توجد ملفات مؤقتة"
    fi
    
    # فحص المجلدات المؤقتة
    echo -e "${BLUE}[4/8]${NC} البحث عن مجلدات مؤقتة..."
    local temp_dirs=$(find "$ROOT_DIR" -type d -name "test_archive*" -o -name "test_compression*" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$temp_dirs" -gt 0 ]; then
        echo -e "${YELLOW}⚠${NC} وجد $temp_dirs مجلد مؤقت"
        warnings=$((warnings + 1))
        
        if [ "$AUTO_FIX" = true ]; then
            echo -e "${CYAN}🔧${NC} حذف المجلدات المؤقتة..."
            find "$ROOT_DIR" -type d \( -name "test_archive*" -o -name "test_compression*" \) -exec rm -rf {} + 2>/dev/null || true
            fixes=$((fixes + 1))
            echo -e "${GREEN}✓${NC} تم الحذف"
        fi
    else
        echo -e "${GREEN}✓${NC} لا توجد مجلدات مؤقتة"
    fi
    
    # فحص تنظيم Documentation
    echo -e "${BLUE}[5/8]${NC} فحص تنظيم Documentation..."
    if [ -d "$ROOT_DIR/Documentation/reports" ]; then
        local reports_count=$(find "$ROOT_DIR/Documentation/reports" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} Documentation منظم ($reports_count تقرير)"
    else
        echo -e "${YELLOW}⚠${NC} مجلد Documentation/reports غير موجود"
        warnings=$((warnings + 1))
    fi
    
    # فحص CHANGELOG
    echo -e "${BLUE}[6/8]${NC} فحص CHANGELOG..."
    if [ -f "$ROOT_DIR/CHANGELOG.md" ]; then
        local last_update=$(stat -f%m "$ROOT_DIR/CHANGELOG.md" 2>/dev/null || stat -c%Y "$ROOT_DIR/CHANGELOG.md" 2>/dev/null)
        local now=$(date +%s)
        local days_old=$(( (now - last_update) / 86400 ))
        if [ "$days_old" -gt 7 ]; then
            echo -e "${YELLOW}⚠${NC} CHANGELOG لم يُحدث منذ $days_old يوم"
            warnings=$((warnings + 1))
        else
            echo -e "${GREEN}✓${NC} CHANGELOG محدث"
        fi
    else
        echo -e "${RED}✗${NC} CHANGELOG.md غير موجود"
        issues=$((issues + 1))
    fi
    
    # فحص .gitignore
    echo -e "${BLUE}[7/8]${NC} فحص .gitignore..."
    if [ -f "$ROOT_DIR/.gitignore" ]; then
        if grep -q "test_.*\.txt" "$ROOT_DIR/.gitignore" && grep -q "test_.*\.json" "$ROOT_DIR/.gitignore"; then
            echo -e "${GREEN}✓${NC} .gitignore محدث"
        else
            echo -e "${YELLOW}⚠${NC} .gitignore يحتاج تحديث"
            warnings=$((warnings + 1))
        fi
    else
        echo -e "${RED}✗${NC} .gitignore غير موجود"
        issues=$((issues + 1))
    fi
    
    # فحص Git status
    echo -e "${BLUE}[8/8]${NC} فحص Git status..."
    if git -C "$ROOT_DIR" status --porcelain 2>/dev/null | grep -q .; then
        local uncommitted=$(git -C "$ROOT_DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${YELLOW}ℹ${NC} يوجد $uncommitted تغيير غير مُحفوظ"
    else
        echo -e "${GREEN}✓${NC} Working tree نظيف"
    fi
    
    # النتيجة
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓${NC} الفحص مكتمل"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "📊 النتائج:"
    echo "  • المشاكل: $issues"
    echo "  • التحذيرات: $warnings"
    echo "  • الإصلاحات التلقائية: $fixes"
    echo ""
    
    # حفظ المقاييس
    cat > "$METRICS_FILE" <<EOF
{
  "timestamp": "$(date -Iseconds)",
  "root_files": $root_md_count,
  "repo_size_mb": $repo_size_mb,
  "temp_files": $temp_files,
  "temp_dirs": $temp_dirs,
  "issues": $issues,
  "warnings": $warnings,
  "fixes": $fixes
}
EOF
    
    log "Health check completed: issues=$issues, warnings=$warnings, fixes=$fixes"
    
    return $issues
}

# ====================
# 2. إنشاء تقرير
# ====================

generate_report() {
    print_header "📝 إنشاء تقرير"
    
    local report_file="$REPORT_DIR/health-check-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" <<EOF
# تقرير الفحص الصحي التلقائي

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')  
**المنشئ:** نظام المراقبة التلقائية  
**الحالة:** $([ -f "$METRICS_FILE" ] && jq -r 'if .issues == 0 then "✅ ممتاز" elif .issues < 3 then "⚠️ يحتاج انتباه" else "🔴 حرج" end' "$METRICS_FILE" || echo "غير معروف")

---

## 📊 المقاييس

$([ -f "$METRICS_FILE" ] && cat <<METRICS
| المقياس | القيمة |
|:---|:---:|
| **ملفات الجذر** | $(jq -r '.root_files' "$METRICS_FILE") |
| **حجم المستودع** | $(jq -r '.repo_size_mb' "$METRICS_FILE") MB |
| **ملفات مؤقتة** | $(jq -r '.temp_files' "$METRICS_FILE") |
| **مجلدات مؤقتة** | $(jq -r '.temp_dirs' "$METRICS_FILE") |
| **المشاكل** | $(jq -r '.issues' "$METRICS_FILE") |
| **التحذيرات** | $(jq -r '.warnings' "$METRICS_FILE") |
| **الإصلاحات التلقائية** | $(jq -r '.fixes' "$METRICS_FILE") |
METRICS
)

---

## 🎯 التوصيات

$([ -f "$METRICS_FILE" ] && {
    local root_files=$(jq -r '.root_files' "$METRICS_FILE")
    local warnings=$(jq -r '.warnings' "$METRICS_FILE")
    
    if [ "$root_files" -gt 10 ]; then
        echo "- ⚠️ عدد ملفات الجذر كبير - يُنصح بنقل بعض الملفات إلى Documentation/"
    fi
    
    if [ "$warnings" -gt 0 ]; then
        echo "- ⚠️ توجد $warnings تحذيرات تحتاج مراجعة"
    fi
    
    if [ "$warnings" -eq 0 ] && [ "$root_files" -le 10 ]; then
        echo "- ✅ المستودع في حالة ممتازة - استمر في العمل الجيد!"
    fi
})

---

**تم إنشاؤه بواسطة:** نظام المراقبة التلقائية  
**الإصدار:** 1.0
EOF
    
    echo -e "${GREEN}✓${NC} تم إنشاء التقرير: $(basename $report_file)"
    log "Report generated: $report_file"
}

# ====================
# التنفيذ الرئيسي
# ====================

main() {
    print_header "🤖 نظام المراقبة التلقائية للمستودع"
    
    echo "📅 التاريخ: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "📁 المستودع: $ROOT_DIR"
    echo ""
    
    log "=== Starting health check ==="
    
    # تشغيل الفحص
    if check_repository_health; then
        echo -e "${GREEN}✓${NC} الفحص مكتمل بنجاح"
    else
        echo -e "${YELLOW}⚠${NC} الفحص مكتمل مع مشاكل"
    fi
    
    # إنشاء التقرير
    generate_report
    
    log "=== Health check completed ==="
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ العملية مكتملة${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# تشغيل
main "$@"
