#!/bin/bash

# سكريبت مراقبة التبعيات التلقائي
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 13 ديسمبر 2025

set -e

# الألوان للإخراج
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# المتغيرات
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=".dependency_backups"
REPORT_DIR="Documentation/reports/maintenance"
LOG_FILE="logs/dependency_monitor_${TIMESTAMP}.log"

# إنشاء المجلدات إذا لم تكن موجودة
mkdir -p "$BACKUP_DIR" "$REPORT_DIR" "logs"

# دالة الطباعة الملونة
print_status() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
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

# دالة إنشاء النسخ الاحتياطية
create_backup() {
    print_status "إنشاء نسخة احتياطية..."
    
    if [ -f "pubspec.yaml" ]; then
        cp pubspec.yaml "${BACKUP_DIR}/pubspec_${TIMESTAMP}_monitor.yaml"
        print_success "تم إنشاء نسخة احتياطية من pubspec.yaml"
    fi
    
    if [ -f "pubspec.lock" ]; then
        cp pubspec.lock "${BACKUP_DIR}/pubspec_${TIMESTAMP}_monitor.lock"
        print_success "تم إنشاء نسخة احتياطية من pubspec.lock"
    fi
}

# دالة فحص Flutter
check_flutter() {
    print_status "فحص بيئة Flutter..."
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter غير مثبت أو غير موجود في PATH"
        exit 1
    fi
    
    flutter doctor --android-licenses > /dev/null 2>&1 || true
    
    if flutter doctor | grep -q "No issues found!"; then
        print_success "بيئة Flutter سليمة"
    else
        print_warning "توجد مشاكل في بيئة Flutter"
        flutter doctor
    fi
}

# دالة فحص التبعيات
check_dependencies() {
    print_status "فحص التبعيات..."
    
    # فحص التحديثات المتاحة
    echo "=== التحديثات المتاحة ===" >> "$LOG_FILE"
    flutter pub outdated >> "$LOG_FILE" 2>&1
    
    # عد التحديثات المتاحة
    OUTDATED_COUNT=$(flutter pub outdated 2>/dev/null | grep -c "available" || echo "0")
    
    if [ "$OUTDATED_COUNT" -gt 0 ]; then
        print_warning "يوجد $OUTDATED_COUNT تحديث متاح"
    else
        print_success "جميع التبعيات محدثة"
    fi
}

# دالة فحص الكود
analyze_code() {
    print_status "تحليل الكود..."
    
    echo "=== تحليل الكود ===" >> "$LOG_FILE"
    if flutter analyze >> "$LOG_FILE" 2>&1; then
        print_success "لا توجد مشاكل في الكود"
    else
        print_error "توجد مشاكل في الكود"
        flutter analyze
        return 1
    fi
}

# دالة تشغيل الاختبارات السريعة
run_quick_tests() {
    print_status "تشغيل اختبارات سريعة..."
    
    echo "=== الاختبارات السريعة ===" >> "$LOG_FILE"
    
    # تشغيل اختبارات محددة فقط للسرعة
    if flutter test test/unit/domain/entities/ --reporter=compact >> "$LOG_FILE" 2>&1; then
        print_success "الاختبارات الأساسية نجحت"
    else
        print_warning "بعض الاختبارات فشلت - راجع السجل"
        return 1
    fi
}

# دالة فحص الحزم المتوقفة
check_discontinued_packages() {
    print_status "فحص الحزم المتوقفة..."
    
    DISCONTINUED_PACKAGES=("js" "build_resolvers" "build_runner_core")
    
    for package in "${DISCONTINUED_PACKAGES[@]}"; do
        if grep -q "$package" pubspec.yaml; then
            print_warning "الحزمة المتوقفة '$package' ما زالت مستخدمة"
        fi
    done
}

# دالة إنشاء تقرير سريع
generate_quick_report() {
    print_status "إنشاء تقرير سريع..."
    
    REPORT_FILE="${REPORT_DIR}/quick_monitor_${TIMESTAMP}.md"
    
    cat > "$REPORT_FILE" << EOF
# تقرير مراقبة سريع - $(date '+%Y-%m-%d %H:%M:%S')

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**النوع:** مراقبة تلقائية  
**الحالة:** $([ $? -eq 0 ] && echo "✅ سليم" || echo "⚠️ يحتاج مراجعة")

## النتائج السريعة

### Flutter Doctor
$(flutter doctor --version 2>/dev/null || echo "غير متاح")

### التحديثات المتاحة
$OUTDATED_COUNT تحديث متاح

### تحليل الكود
$([ -f "$LOG_FILE" ] && grep -A 5 "تحليل الكود" "$LOG_FILE" || echo "لم يتم التحليل")

### الاختبارات
$([ -f "$LOG_FILE" ] && grep -A 3 "الاختبارات السريعة" "$LOG_FILE" || echo "لم يتم تشغيل الاختبارات")

---
**تم إنشاؤه تلقائياً بواسطة:** dependency_monitor.sh
EOF

    print_success "تم إنشاء تقرير سريع: $REPORT_FILE"
}

# دالة التنظيف
cleanup_old_files() {
    print_status "تنظيف الملفات القديمة..."
    
    # حذف النسخ الاحتياطية الأقدم من 30 يوم
    find "$BACKUP_DIR" -name "pubspec_*_monitor.*" -mtime +30 -delete 2>/dev/null || true
    
    # حذف السجلات الأقدم من 7 أيام
    find "logs" -name "dependency_monitor_*.log" -mtime +7 -delete 2>/dev/null || true
    
    print_success "تم تنظيف الملفات القديمة"
}

# الدالة الرئيسية
main() {
    echo "=========================================="
    echo "🔍 سكريبت مراقبة التبعيات التلقائي"
    echo "=========================================="
    
    # إنشاء النسخ الاحتياطية
    create_backup
    
    # فحص البيئة
    check_flutter
    
    # فحص التبعيات
    check_dependencies
    
    # تحليل الكود
    if ! analyze_code; then
        print_error "فشل تحليل الكود - توقف السكريبت"
        exit 1
    fi
    
    # تشغيل اختبارات سريعة
    run_quick_tests || print_warning "بعض الاختبارات فشلت"
    
    # فحص الحزم المتوقفة
    check_discontinued_packages
    
    # إنشاء تقرير سريع
    generate_quick_report
    
    # تنظيف الملفات القديمة
    cleanup_old_files
    
    echo "=========================================="
    print_success "انتهت مراقبة التبعيات بنجاح"
    echo "📄 السجل: $LOG_FILE"
    echo "📊 التقرير: ${REPORT_DIR}/quick_monitor_${TIMESTAMP}.md"
    echo "=========================================="
}

# تشغيل السكريبت
main "$@"