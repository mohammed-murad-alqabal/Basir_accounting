#!/bin/bash

# =============================================================================
# سكريبت إنشاء التقارير الشاملة
# =============================================================================
# الوصف: ينشئ تقرير يومي شامل بصيغة Markdown يتضمن إحصائيات المشروع
#         وتحليل الأخطاء ونتائج الاختبارات والتوصيات
# الاستخدام: ./scripts/generate_report.sh [--output FILE]
# المتطلبات: 2.1, 2.2, 2.3, 2.4, 2.5
# =============================================================================

set -euo pipefail

# الألوان للإخراج
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# المتغيرات العامة
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly LOGS_DIR="$PROJECT_ROOT/logs"
readonly REPORTS_DIR="$LOGS_DIR/reports"
readonly DEFAULT_OUTPUT="$REPORTS_DIR/daily_report_$(date +%Y-%m-%d).md"

OUTPUT_FILE="$DEFAULT_OUTPUT"

# =============================================================================
# الدوال المساعدة
# =============================================================================

# طباعة رسالة ملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# طباعة رسالة خطأ والخروج
error_exit() {
    print_message "$RED" "❌ خطأ: $1"
    exit 1
}

# التحقق من وجود أمر
check_command() {
    if ! command -v "$1" &> /dev/null; then
        error_exit "الأمر '$1' غير موجود. يرجى تثبيته أولاً."
    fi
}

# =============================================================================
# دوال جمع الإحصائيات
# =============================================================================

# جمع إحصائيات المشروع
collect_project_stats() {
    local total_files=$(find lib -name "*.dart" 2>/dev/null | wc -l)
    local total_lines=$(find lib -name "*.dart" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    local total_size=$(du -sh lib 2>/dev/null | awk '{print $1}')
    local total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    local last_commit=$(git log -1 --format="%h - %s (%ar)" 2>/dev/null || echo "لا توجد commits")
    
    cat <<EOF
## 📊 إحصائيات المشروع

| المقياس | القيمة |
|:---|:---|
| **إجمالي ملفات Dart** | $total_files |
| **إجمالي الأسطر** | $total_lines |
| **حجم المشروع** | $total_size |
| **إجمالي Commits** | $total_commits |
| **آخر Commit** | $last_commit |

EOF
}

# تحليل الأخطاء والتحذيرات
analyze_errors() {
    print_message "$BLUE" "تحليل الأخطاء والتحذيرات..."
    
    # تشغيل flutter analyze
    local analyze_output=$(flutter analyze --no-pub 2>&1 || true)
    local error_count=$(echo "$analyze_output" | grep -c "error •" 2>/dev/null || echo "0")
    local warning_count=$(echo "$analyze_output" | grep -c "warning •" 2>/dev/null || echo "0")
    local info_count=$(echo "$analyze_output" | grep -c "info •" 2>/dev/null || echo "0")
    
    # تنظيف الأرقام (إزالة المسافات والأحرف غير الرقمية)
    error_count=$(echo "$error_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    warning_count=$(echo "$warning_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    info_count=$(echo "$info_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    
    # التأكد من أن القيم أرقام صحيحة
    error_count=${error_count:-0}
    warning_count=${warning_count:-0}
    info_count=${info_count:-0}
    
    cat <<EOF
## 🔍 تحليل الأخطاء والتحذيرات

| النوع | العدد | الحالة |
|:---|:---|:---|
| **أخطاء (Errors)** | $error_count | $([ "$error_count" -eq 0 ] && echo "✅" || echo "❌") |
| **تحذيرات (Warnings)** | $warning_count | $([ "$warning_count" -eq 0 ] && echo "✅" || echo "⚠️") |
| **معلومات (Info)** | $info_count | ℹ️ |

EOF

    if [ "$error_count" -gt 0 ] || [ "$warning_count" -gt 0 ]; then
        echo "### التفاصيل"
        echo ""
        echo '```'
        echo "$analyze_output" | head -20
        echo '```'
        echo ""
    fi
}

# جمع نتائج الاختبارات
collect_test_results() {
    print_message "$BLUE" "جمع نتائج الاختبارات..."
    
    # تشغيل الاختبارات
    local test_output=$(flutter test --no-pub 2>&1 || true)
    local passed_tests=$(echo "$test_output" | grep -oP '\d+(?= tests? passed)' 2>/dev/null | head -1 || echo "0")
    local failed_tests=$(echo "$test_output" | grep -oP '\d+(?= tests? failed)' 2>/dev/null | head -1 || echo "0")
    
    # تنظيف الأرقام
    passed_tests=$(echo "$passed_tests" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    failed_tests=$(echo "$failed_tests" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    
    # التأكد من أن القيم أرقام صحيحة
    passed_tests=${passed_tests:-0}
    failed_tests=${failed_tests:-0}
    
    local total_tests=$((passed_tests + failed_tests))
    local success_rate=0
    
    if [ "$total_tests" -gt 0 ]; then
        success_rate=$(awk "BEGIN {printf \"%.1f\", ($passed_tests / $total_tests) * 100}")
    fi
    
    # محاولة الحصول على تغطية الاختبارات
    local coverage="N/A"
    if [ -f "coverage/lcov.info" ]; then
        coverage=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | awk '{print $2}' || echo "N/A")
    fi
    
    cat <<EOF
## 🧪 نتائج الاختبارات

| المقياس | القيمة |
|:---|:---|
| **إجمالي الاختبارات** | $total_tests |
| **نجح** | $passed_tests ✅ |
| **فشل** | $failed_tests $([ "$failed_tests" -eq 0 ] && echo "✅" || echo "❌") |
| **معدل النجاح** | $success_rate% |
| **التغطية** | $coverage |

EOF
}

# محرك التوصيات
generate_recommendations() {
    print_message "$BLUE" "إنشاء التوصيات..."
    
    local recommendations=()
    
    # التحقق من الأخطاء
    local error_count=$(flutter analyze --no-pub 2>&1 | grep -c "error •" 2>/dev/null || echo "0")
    error_count=$(echo "$error_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    error_count=${error_count:-0}
    
    if [ "$error_count" -gt 0 ]; then
        recommendations+=("🔴 **عاجل**: يوجد $error_count خطأ يجب إصلاحه فوراً. قم بتشغيل \`flutter analyze\` لمعرفة التفاصيل.")
    fi
    
    # التحقق من التحذيرات
    local warning_count=$(flutter analyze --no-pub 2>&1 | grep -c "warning •" 2>/dev/null || echo "0")
    warning_count=$(echo "$warning_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    warning_count=${warning_count:-0}
    
    if [ "$warning_count" -gt 5 ]; then
        recommendations+=("⚠️ **مهم**: يوجد $warning_count تحذير. يُنصح بمعالجتها لتحسين جودة الكود.")
    fi
    
    # التحقق من الاختبارات الفاشلة
    local failed_tests=$(flutter test --no-pub 2>&1 | grep -oP '\d+(?= tests? failed)' 2>/dev/null | head -1 || echo "0")
    failed_tests=$(echo "$failed_tests" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    failed_tests=${failed_tests:-0}
    
    if [ "$failed_tests" -gt 0 ]; then
        recommendations+=("❌ **حرج**: $failed_tests اختبار فشل. يجب إصلاحها قبل المتابعة.")
    fi
    
    # التحقق من التغطية
    if [ -f "coverage/lcov.info" ]; then
        local coverage_num=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | awk '{print $2}' | sed 's/%//' || echo "0")
        if [ "${coverage_num%.*}" -lt 70 ]; then
            recommendations+=("📊 **تحسين**: تغطية الاختبارات أقل من 70%. يُنصح بإضافة المزيد من الاختبارات.")
        fi
    fi
    
    # التحقق من حجم المشروع
    local total_files=$(find lib -name "*.dart" 2>/dev/null | wc -l)
    if [ "$total_files" -gt 100 ]; then
        recommendations+=("📦 **ملاحظة**: المشروع يحتوي على $total_files ملف. فكر في تنظيم الكود في modules.")
    fi
    
    # التحقق من آخر commit
    local days_since_commit=$(git log -1 --format="%cr" 2>/dev/null | grep -oP '\d+(?= days?)' || echo "0")
    if [ "$days_since_commit" -gt 7 ]; then
        recommendations+=("⏰ **تذكير**: آخر commit كان منذ $days_since_commit يوم. تأكد من حفظ التغييرات بانتظام.")
    fi
    
    # طباعة التوصيات
    cat <<EOF
## 💡 التوصيات

EOF

    if [ ${#recommendations[@]} -eq 0 ]; then
        echo "✅ **ممتاز!** لا توجد توصيات حالياً. المشروع في حالة جيدة."
        echo ""
    else
        for rec in "${recommendations[@]}"; do
            echo "$rec"
            echo ""
        done
    fi
}

# =============================================================================
# دالة إنشاء التقرير
# =============================================================================

generate_report() {
    print_message "$GREEN" "إنشاء التقرير الشامل..."
    
    # إنشاء مجلد التقارير إذا لم يكن موجوداً
    mkdir -p "$REPORTS_DIR"
    
    # إنشاء التقرير
    cat > "$OUTPUT_FILE" <<EOF
# تقرير يومي شامل - مشروع بصير MVP

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')  
**المؤلف:** نظام تتبع الأخطاء التلقائي  
**الإصدار:** 1.0

---

## نظرة عامة

هذا التقرير اليومي الشامل يتضمن جميع إحصائيات المشروع، تحليل الأخطاء، نتائج الاختبارات، والتوصيات.

---

EOF

    # إضافة الأقسام
    collect_project_stats >> "$OUTPUT_FILE"
    analyze_errors >> "$OUTPUT_FILE"
    collect_test_results >> "$OUTPUT_FILE"
    generate_recommendations >> "$OUTPUT_FILE"
    
    # إضافة الخاتمة
    cat >> "$OUTPUT_FILE" <<EOF
---

## الخلاصة

**الحالة العامة:** $(determine_overall_status)

**الإجراءات المطلوبة:**
$(list_required_actions)

---

**تم إنشاء التقرير بواسطة:** نظام تتبع الأخطاء التلقائي  
**الوقت:** $(date '+%Y-%m-%d %H:%M:%S')
EOF

    print_message "$GREEN" "✅ تم إنشاء التقرير بنجاح: $OUTPUT_FILE"
}

# تحديد الحالة العامة
determine_overall_status() {
    local error_count=$(flutter analyze --no-pub 2>&1 | grep -c "error •" 2>/dev/null || echo "0")
    error_count=$(echo "$error_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    error_count=${error_count:-0}
    
    local failed_tests=$(flutter test --no-pub 2>&1 | grep -oP '\d+(?= tests? failed)' 2>/dev/null | head -1 || echo "0")
    failed_tests=$(echo "$failed_tests" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    failed_tests=${failed_tests:-0}
    
    if [ "$error_count" -gt 0 ] || [ "$failed_tests" -gt 0 ]; then
        echo "❌ **يحتاج إلى إصلاح**"
    elif [ "$error_count" -eq 0 ] && [ "$failed_tests" -eq 0 ]; then
        echo "✅ **ممتاز**"
    else
        echo "⚠️ **جيد مع ملاحظات**"
    fi
}

# قائمة الإجراءات المطلوبة
list_required_actions() {
    local actions=()
    local error_count=$(flutter analyze --no-pub 2>&1 | grep -c "error •" 2>/dev/null || echo "0")
    error_count=$(echo "$error_count" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    error_count=${error_count:-0}
    
    local failed_tests=$(flutter test --no-pub 2>&1 | grep -oP '\d+(?= tests? failed)' 2>/dev/null | head -1 || echo "0")
    failed_tests=$(echo "$failed_tests" | tr -d '[:space:]' | grep -o '[0-9]*' | head -1)
    failed_tests=${failed_tests:-0}
    
    if [ "$error_count" -gt 0 ]; then
        actions+=("- إصلاح $error_count خطأ في الكود")
    fi
    
    if [ "$failed_tests" -gt 0 ]; then
        actions+=("- إصلاح $failed_tests اختبار فاشل")
    fi
    
    if [ ${#actions[@]} -eq 0 ]; then
        echo "- لا توجد إجراءات مطلوبة حالياً ✅"
    else
        printf '%s\n' "${actions[@]}"
    fi
}

# =============================================================================
# معالجة المعاملات
# =============================================================================

show_help() {
    cat <<EOF
الاستخدام: $0 [OPTIONS]

إنشاء تقرير يومي شامل للمشروع

الخيارات:
  --output FILE, -o FILE    مسار ملف الإخراج (افتراضي: $DEFAULT_OUTPUT)
  --help, -h               عرض هذه الرسالة

أمثلة:
  $0                       # إنشاء تقرير بالاسم الافتراضي
  $0 -o my_report.md       # إنشاء تقرير بمسار مخصص

المتطلبات المحققة:
  - 2.1: إنشاء تقرير يومي شامل
  - 2.2: إحصائيات المشروع الكاملة
  - 2.3: ملخص الأخطاء والتحذيرات
  - 2.4: نتائج الاختبارات والتغطية
  - 2.5: توصيات قابلة للتنفيذ

EOF
}

# =============================================================================
# البرنامج الرئيسي
# =============================================================================

main() {
    # معالجة المعاملات
    while [[ $# -gt 0 ]]; do
        case $1 in
            --output|-o)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                error_exit "خيار غير معروف: $1"
                ;;
        esac
    done
    
    # التحقق من المتطلبات
    check_command "flutter"
    check_command "git"
    
    # الانتقال إلى جذر المشروع
    cd "$PROJECT_ROOT"
    
    # إنشاء التقرير
    generate_report
    
    print_message "$GREEN" "🎉 تم إنشاء التقرير بنجاح!"
    print_message "$BLUE" "📄 الملف: $OUTPUT_FILE"
}

# تشغيل البرنامج الرئيسي
main "$@"
