#!/bin/bash

# نظام فحص التوافق التلقائي لملفات التوجيه
# Automatic Steering Files Compatibility Checker
#
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 16 ديسمبر 2025

set -e

# الألوان للمخرجات
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# دالة طباعة الرسائل الملونة
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# دالة عرض المساعدة
show_help() {
    echo "نظام فحص التوافق التلقائي لملفات التوجيه"
    echo ""
    echo "الاستخدام:"
    echo "  $0 [OPTIONS]"
    echo ""
    echo "الخيارات:"
    echo "  -f, --file FILE           فحص ملف واحد فقط"
    echo "  -o, --output FORMAT       تنسيق التقرير (markdown|json|both) [افتراضي: both]"
    echo "  -s, --severity LEVEL      الحد الأدنى للخطورة (low|medium|high) [افتراضي: medium]"
    echo "  -c, --ci                  وضع CI/CD (فشل عند وجود مشاكل)"
    echo "  -q, --quiet               تشغيل صامت"
    echo "  -h, --help                عرض هذه المساعدة"
    echo ""
    echo "أمثلة:"
    echo "  $0                                    # فحص جميع الملفات"
    echo "  $0 -f .kiro/steering/file.md         # فحص ملف واحد"
    echo "  $0 -c -s high                        # وضع CI مع خطورة عالية"
    echo "  $0 -o json -q                        # تقرير JSON صامت"
}

# المتغيرات الافتراضية
FILE=""
OUTPUT_FORMAT="both"
SEVERITY="medium"
CI_MODE=false
QUIET=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/steering_compatibility_checker.py"

# معالجة المعاملات
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            FILE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -s|--severity)
            SEVERITY="$2"
            shift 2
            ;;
        -c|--ci)
            CI_MODE=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "معامل غير معروف: $1"
            show_help
            exit 1
            ;;
    esac
done

# التحقق من وجود Python
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 غير مثبت"
    exit 1
fi

# التحقق من وجود السكريبت
if [[ ! -f "$PYTHON_SCRIPT" ]]; then
    print_error "السكريبت غير موجود: $PYTHON_SCRIPT"
    exit 1
fi

# إنشاء مجلد التقارير إذا لم يكن موجوداً
mkdir -p reports/compatibility

# بناء الأمر
CMD="python3 \"$PYTHON_SCRIPT\""

if [[ -n "$FILE" ]]; then
    CMD="$CMD --file \"$FILE\""
fi

CMD="$CMD --output-format $OUTPUT_FORMAT"
CMD="$CMD --severity-threshold $SEVERITY"

if [[ "$CI_MODE" == true ]]; then
    CMD="$CMD --fail-on-issues"
fi

# تشغيل الفحص
if [[ "$QUIET" == false ]]; then
    print_info "بدء فحص التوافق..."
    if [[ -n "$FILE" ]]; then
        print_info "فحص الملف: $FILE"
    else
        print_info "فحص جميع ملفات التوجيه في .kiro/steering/"
    fi
    print_info "تنسيق التقرير: $OUTPUT_FORMAT"
    print_info "مستوى الخطورة: $SEVERITY"
fi

# تنفيذ الأمر
if eval "$CMD"; then
    if [[ "$QUIET" == false ]]; then
        print_success "اكتمل الفحص بنجاح"
        
        # عرض التقارير المتاحة
        REPORTS_DIR="reports/compatibility"
        if [[ -d "$REPORTS_DIR" ]]; then
            LATEST_MARKDOWN=$(ls -t "$REPORTS_DIR"/compatibility_report_*.md 2>/dev/null | head -1)
            LATEST_JSON=$(ls -t "$REPORTS_DIR"/compatibility_issues_*.json 2>/dev/null | head -1)
            
            if [[ -n "$LATEST_MARKDOWN" ]]; then
                print_info "تقرير Markdown: $LATEST_MARKDOWN"
            fi
            
            if [[ -n "$LATEST_JSON" ]]; then
                print_info "تقرير JSON: $LATEST_JSON"
            fi
        fi
    fi
    exit 0
else
    EXIT_CODE=$?
    if [[ "$QUIET" == false ]]; then
        if [[ "$CI_MODE" == true ]]; then
            print_error "فشل الفحص: تم العثور على مشاكل تتطلب إصلاح"
        else
            print_error "حدث خطأ أثناء الفحص"
        fi
    fi
    exit $EXIT_CODE
fi