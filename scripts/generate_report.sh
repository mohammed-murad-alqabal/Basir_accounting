#!/bin/bash

###############################################################################
# سكريبت إنشاء التقارير - نظام تتبع الأخطاء والسجلات
#
# الوصف:
#   ينشئ تقرير شامل يومي بصيغة Markdown يتضمن:
#   - إحصائيات المشروع (عدد الملفات، الحجم، Commits)
#   - ملخص الأخطاء والتحذيرات مع التصنيف
#   - نتائج الاختبارات ونسبة التغطية
#   - توصيات قابلة للتنفيذ للتحسين
#
# الاستخدام:
#   scripts/generate_report.sh [OPTIONS]
#
# الخيارات:
#   --output <file>    تحديد ملف الإخراج (افتراضي: logs/reports/daily_report_YYYYMMDD.md)
#   --format <type>    تنسيق التقرير (markdown|json|html) (افتراضي: markdown)
#   --help             عرض هذه الرسالة
#
# المشروع: بصير MVP
# التاريخ: 4 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
###############################################################################

set -euo pipefail

# الألوان
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# المتغيرات العامة
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/logs/reports"
OUTPUT_FILE=""
FORMAT="markdown"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DATE_READABLE=$(date +"%Y-%m-%d %H:%M:%S")

# إنشاء جميع المجلدات المطلوبة
mkdir -p "$REPORTS_DIR" "$PROJECT_ROOT/logs/errors" "$PROJECT_ROOT/logs/archive"

###############################################################################
# الدوال المساعدة
###############################################################################

show_help() {
    cat << EOF
═══════════════════════════════════════════════════════════════
   سكريبت إنشاء التقارير - نظام تتبع الأخطاء والسجلات
═══════════════════════════════════════════════════════════════

الاستخدام:
    scripts/generate_report.sh [OPTIONS]

الخيارات:
    --output <file>    تحديد ملف الإخراج
                       (افتراضي: logs/reports/daily_report_YYYYMMDD.md)
    --format <type>    تنسيق التقرير (markdown|json|html)
                       (افتراضي: markdown)
    --help             عرض هذه الرسالة

الأمثلة:
    # إنشاء تقرير يومي بالتنسيق الافتراضي
    scripts/generate_report.sh

    # إنشاء تقرير بتنسيق JSON
    scripts/generate_report.sh --format json

    # إنشاء تقرير في ملف محدد
    scripts/generate_report.sh --output my_report.md

المتطلبات:
    - Flutter SDK
    - Git
    - أدوات Unix الأساسية (wc, find, du)

EOF
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

###############################################################################
# جمع إحصائيات المشروع
###############################################################################

collect_project_stats() {
    log_info "جمع إحصائيات المشروع..."
    
    local stats_file="$REPORTS_DIR/.stats_$TIMESTAMP.tmp"
    
    # عدد ملفات Dart
    local dart_files=$(find "$PROJECT_ROOT/lib" -name "*.dart" 2>/dev/null | wc -l)
    
    # عدد ملفات الاختبار
    local test_files=$(find "$PROJECT_ROOT/test" -name "*_test.dart" 2>/dev/null | wc -l)
    
    # إجمالي أسطر الكود
    local total_lines=$(find "$PROJECT_ROOT/lib" -name "*.dart" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    
    # حجم المشروع
    local project_size=$(du -sh "$PROJECT_ROOT" 2>/dev/null | awk '{print $1}')
    
    # عدد الـ commits
    local commit_count=$(cd "$PROJECT_ROOT" && git rev-list --count HEAD 2>/dev/null || echo "0")
    
    # آخر commit
    local last_commit=$(cd "$PROJECT_ROOT" && git log -1 --format="%h - %s (%ar)" 2>/dev/null || echo "لا يوجد")
    
    # عدد المساهمين
    local contributors=$(cd "$PROJECT_ROOT" && git shortlog -sn --all 2>/dev/null | wc -l)
    
    # حفظ الإحصائيات
    cat > "$stats_file" << EOF
DART_FILES=$dart_files
TEST_FILES=$test_files
TOTAL_LINES=$total_lines
PROJECT_SIZE=$project_size
COMMIT_COUNT=$commit_count
LAST_COMMIT=$last_commit
CONTRIBUTORS=$contributors
EOF
    
    echo "$stats_file"
}

###############################################################################
# تحليل الأخطاء والتحذيرات
###############################################################################

analyze_errors() {
    log_info "تحليل الأخطاء والتحذيرات..."
    
    local analysis_file="$REPORTS_DIR/.analysis_$TIMESTAMP.tmp"
    
    # تشغيل Flutter Analyze
    cd "$PROJECT_ROOT"
    local analyze_output=$(flutter analyze --no-pub 2>&1 || true)
    
    # عد الأخطاء والتحذيرات
    local error_count=$(echo "$analyze_output" | grep -c "error •" || echo "0")
    local warning_count=$(echo "$analyze_output" | grep -c "warning •" || echo "0")
    local info_count=$(echo "$analyze_output" | grep -c "info •" || echo "0")
    
    # استخراج أهم الأخطاء
    local top_errors=$(echo "$analyze_output" | grep "error •" | head -5 || echo "لا توجد أخطاء")
    
    # استخراج أهم التحذيرات
    local top_warnings=$(echo "$analyze_output" | grep "warning •" | head -5 || echo "لا توجد تحذيرات")
    
    # حفظ التحليل
    cat > "$analysis_file" << EOF
ERROR_COUNT=$error_count
WARNING_COUNT=$warning_count
INFO_COUNT=$info_count
TOP_ERRORS<<ERRORS_END
$top_errors
ERRORS_END
TOP_WARNINGS<<WARNINGS_END
$top_warnings
WARNINGS_END
EOF
    
    echo "$analysis_file"
}

###############################################################################
# جمع نتائج الاختبارات
###############################################################################

collect_test_results() {
    log_info "جمع نتائج الاختبارات..."
    
    local test_file="$REPORTS_DIR/.tests_$TIMESTAMP.tmp"
    
    cd "$PROJECT_ROOT"
    
    # تشغيل الاختبارات مع التغطية
    local test_output=$(flutter test --coverage 2>&1 || true)
    
    # عد الاختبارات
    local total_tests=$(echo "$test_output" | grep -oP '\d+(?= tests? passed)' | head -1 || echo "0")
    local passed_tests=$(echo "$test_output" | grep -oP '\d+(?= passed)' | head -1 || echo "0")
    local failed_tests=$(echo "$test_output" | grep -oP '\d+(?= failed)' | head -1 || echo "0")
    
    # حساب نسبة النجاح
    local success_rate="0"
    if [ "$total_tests" -gt 0 ]; then
        success_rate=$(awk "BEGIN {printf \"%.1f\", ($passed_tests/$total_tests)*100}")
    fi
    
    # قراءة نسبة التغطية
    local coverage="0.0"
    if [ -f "coverage/lcov.info" ]; then
        # حساب التغطية من ملف lcov
        local lines_found=$(grep -o "LF:[0-9]*" coverage/lcov.info | cut -d: -f2 | awk '{s+=$1} END {print s}')
        local lines_hit=$(grep -o "LH:[0-9]*" coverage/lcov.info | cut -d: -f2 | awk '{s+=$1} END {print s}')
        
        if [ "$lines_found" -gt 0 ]; then
            coverage=$(awk "BEGIN {printf \"%.1f\", ($lines_hit/$lines_found)*100}")
        fi
    fi
    
    # حفظ النتائج
    cat > "$test_file" << EOF
TOTAL_TESTS=$total_tests
PASSED_TESTS=$passed_tests
FAILED_TESTS=$failed_tests
SUCCESS_RATE=$success_rate
COVERAGE=$coverage
EOF
    
    echo "$test_file"
}

###############################################################################
# محرك التوصيات
###############################################################################

generate_recommendations() {
    log_info "إنشاء التوصيات..."
    
    local stats_file="$1"
    local analysis_file="$2"
    local test_file="$3"
    
    # قراءة البيانات
    source "$stats_file"
    source "$analysis_file"
    source "$test_file"
    
    local recommendations=()
    
    # توصيات بناءً على الأخطاء
    if [ "$ERROR_COUNT" -gt 0 ]; then
        recommendations+=("🔴 **حرج:** يوجد $ERROR_COUNT خطأ يجب إصلاحه فوراً")
    fi
    
    if [ "$WARNING_COUNT" -gt 10 ]; then
        recommendations+=("⚠️ **تحذير:** عدد التحذيرات مرتفع ($WARNING_COUNT). يُنصح بمعالجتها")
    fi
    
    # توصيات بناءً على الاختبارات
    if [ "$TOTAL_TESTS" -eq 0 ]; then
        recommendations+=("🧪 **اختبارات:** لا توجد اختبارات! يجب إضافة اختبارات للكود")
    elif [ "$FAILED_TESTS" -gt 0 ]; then
        recommendations+=("❌ **اختبارات:** يوجد $FAILED_TESTS اختبار فاشل. يجب إصلاحها")
    fi
    
    # توصيات بناءً على التغطية
    local coverage_num=$(echo "$COVERAGE" | cut -d. -f1)
    if [ "$coverage_num" -lt 70 ]; then
        recommendations+=("📊 **تغطية:** نسبة التغطية منخفضة ($COVERAGE%). الهدف: 70%+")
    fi
    
    # توصيات بناءً على حجم الملفات
    if [ "$DART_FILES" -gt 100 ] && [ "$TEST_FILES" -lt 50 ]; then
        recommendations+=("🎯 **جودة:** نسبة ملفات الاختبار منخفضة. يُنصح بزيادتها")
    fi
    
    # إذا لم توجد مشاكل
    if [ ${#recommendations[@]} -eq 0 ]; then
        recommendations+=("✅ **ممتاز:** المشروع في حالة جيدة! استمر في العمل الرائع")
    fi
    
    # طباعة التوصيات
    printf '%s\n' "${recommendations[@]}"
}

###############################################################################
# إنشاء تقرير Markdown
###############################################################################

generate_markdown_report() {
    local output="$1"
    local stats_file="$2"
    local analysis_file="$3"
    local test_file="$4"
    
    # قراءة البيانات
    source "$stats_file"
    source "$analysis_file"
    source "$test_file"
    
    # إنشاء التوصيات
    local recommendations=$(generate_recommendations "$stats_file" "$analysis_file" "$test_file")
    
    # إنشاء التقرير
    cat > "$output" << EOF
# تقرير يومي - نظام تتبع الأخطاء والسجلات

**المشروع:** بصير MVP  
**التاريخ:** $DATE_READABLE  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**النوع:** تقرير يومي تلقائي

---

## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **ملفات Dart** | $DART_FILES |
| **ملفات الاختبار** | $TEST_FILES |
| **إجمالي الأسطر** | $TOTAL_LINES |
| **حجم المشروع** | $PROJECT_SIZE |
| **عدد الـ Commits** | $COMMIT_COUNT |
| **المساهمون** | $CONTRIBUTORS |

**آخر Commit:** $LAST_COMMIT

---

## 🔍 تحليل الأخطاء والتحذيرات

### الملخص

| النوع | العدد |
|:---|:---:|
| **أخطاء (Errors)** | $ERROR_COUNT |
| **تحذيرات (Warnings)** | $WARNING_COUNT |
| **معلومات (Info)** | $INFO_COUNT |

### أهم الأخطاء

\`\`\`
$TOP_ERRORS
\`\`\`

### أهم التحذيرات

\`\`\`
$TOP_WARNINGS
\`\`\`

---

## 🧪 نتائج الاختبارات

### الملخص

| المقياس | القيمة |
|:---|:---:|
| **إجمالي الاختبارات** | $TOTAL_TESTS |
| **الناجحة** | $PASSED_TESTS ✅ |
| **الفاشلة** | $FAILED_TESTS ❌ |
| **نسبة النجاح** | $SUCCESS_RATE% |

### التغطية (Coverage)

**نسبة التغطية الحالية:** $COVERAGE%

EOF

    # إضافة مؤشر التغطية
    local coverage_num=$(echo "$COVERAGE" | cut -d. -f1)
    if [ "$coverage_num" -ge 70 ]; then
        echo "**الحالة:** ✅ ممتاز (الهدف: 70%+)" >> "$output"
    elif [ "$coverage_num" -ge 50 ]; then
        echo "**الحالة:** ⚠️ جيد (يحتاج تحسين)" >> "$output"
    else
        echo "**الحالة:** ❌ منخفض (يحتاج عمل)" >> "$output"
    fi
    
    # إضافة التوصيات
    cat >> "$output" << EOF

---

## 💡 التوصيات

$recommendations

---

## 📈 الاتجاهات

### الأسبوع الماضي
- عدد الـ Commits: $COMMIT_COUNT
- الأخطاء المصلحة: -
- الاختبارات المضافة: -

### الأهداف القادمة
- [ ] الوصول إلى تغطية 70%+
- [ ] إصلاح جميع الأخطاء الحرجة
- [ ] تقليل التحذيرات إلى أقل من 10

---

**تم إنشاء هذا التقرير تلقائياً بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** $DATE_READABLE  
**الإصدار:** 1.0
EOF
    
    log_success "تم إنشاء التقرير: $output"
}

###############################################################################
# إنشاء تقرير JSON
###############################################################################

generate_json_report() {
    local output="$1"
    local stats_file="$2"
    local analysis_file="$3"
    local test_file="$4"
    
    # قراءة البيانات
    source "$stats_file"
    source "$analysis_file"
    source "$test_file"
    
    # إنشاء JSON
    cat > "$output" << EOF
{
  "metadata": {
    "project": "بصير MVP",
    "date": "$DATE_READABLE",
    "timestamp": "$TIMESTAMP",
    "author": "فريق وكلاء تطوير مشروع بصير"
  },
  "statistics": {
    "dart_files": $DART_FILES,
    "test_files": $TEST_FILES,
    "total_lines": $TOTAL_LINES,
    "project_size": "$PROJECT_SIZE",
    "commit_count": $COMMIT_COUNT,
    "contributors": $CONTRIBUTORS,
    "last_commit": "$LAST_COMMIT"
  },
  "analysis": {
    "errors": $ERROR_COUNT,
    "warnings": $WARNING_COUNT,
    "info": $INFO_COUNT
  },
  "tests": {
    "total": $TOTAL_TESTS,
    "passed": $PASSED_TESTS,
    "failed": $FAILED_TESTS,
    "success_rate": $SUCCESS_RATE,
    "coverage": $COVERAGE
  }
}
EOF
    
    log_success "تم إنشاء التقرير: $output"
}

###############################################################################
# الدالة الرئيسية
###############################################################################

main() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "   سكريبت إنشاء التقارير - نظام تتبع الأخطاء والسجلات"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    
    # معالجة المعاملات
    while [[ $# -gt 0 ]]; do
        case $1 in
            --output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            --format)
                FORMAT="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "معامل غير معروف: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # تحديد ملف الإخراج الافتراضي
    if [ -z "$OUTPUT_FILE" ]; then
        OUTPUT_FILE="$REPORTS_DIR/daily_report_$(date +%Y%m%d).md"
    fi
    
    # جمع البيانات
    local stats_file=$(collect_project_stats)
    local analysis_file=$(analyze_errors)
    local test_file=$(collect_test_results)
    
    # إنشاء التقرير حسب التنسيق
    case $FORMAT in
        markdown|md)
            generate_markdown_report "$OUTPUT_FILE" "$stats_file" "$analysis_file" "$test_file"
            ;;
        json)
            generate_json_report "$OUTPUT_FILE" "$stats_file" "$analysis_file" "$test_file"
            ;;
        *)
            log_error "تنسيق غير مدعوم: $FORMAT"
            exit 1
            ;;
    esac
    
    # تنظيف الملفات المؤقتة
    rm -f "$stats_file" "$analysis_file" "$test_file"
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    log_success "تم إنشاء التقرير بنجاح!"
    echo "📄 الملف: $OUTPUT_FILE"
    echo "═══════════════════════════════════════════════════════════════"
}

# تشغيل البرنامج
main "$@"
