#!/bin/bash

# =============================================================================
# اختبار تغطية .gitignore - Security Testing
# =============================================================================
# المشروع: بصير MVP
# التاريخ: 6 ديسمبر 2025
# المؤلف: فريق وكلاء تطوير مشروع بصير
# =============================================================================
# الوصف: التحقق من تغطية .gitignore لجميع أنواع الملفات الحساسة
# المتطلبات: Requirements 9.4
# =============================================================================

set -e

# تحميل مكتبة معالجة الأخطاء
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../scripts/utils/error_handler.sh"

# الألوان
readonly BOLD='\033[1m'

# عدادات
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# =============================================================================
# دوال الاختبار
# =============================================================================

# اختبار تجاهل نمط ملف معين
test_gitignore_pattern() {
    local test_name=$1
    local file_pattern=$2
    
    ((TOTAL_TESTS++))
    
    # التحقق من وجود النمط في .gitignore
    if grep -q "$file_pattern" .gitignore 2>/dev/null; then
        print_success "✓ $test_name: النمط موجود في .gitignore"
        ((PASSED_TESTS++))
        return 0
    else
        print_error "✗ $test_name: النمط غير موجود في .gitignore"
        ((FAILED_TESTS++))
        return 1
    fi
}

# =============================================================================
# بدء الاختبارات
# =============================================================================

print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  اختبار تغطية .gitignore للملفات الحساسة"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

# =============================================================================
# 1. اختبار ملفات البيئة
# =============================================================================

print_colored "$YELLOW" "\n═══ 1. اختبار ملفات البيئة ═══\n"

test_gitignore_pattern "ملف .env" "\.env"
test_gitignore_pattern "ملف .env.local" "\.env\.local"
test_gitignore_pattern "ملف .env.production" "\.env\.production"
test_gitignore_pattern "ملف .env.development" "\.env\.development"

# =============================================================================
# 2. اختبار ملفات المفاتيح
# =============================================================================

print_colored "$YELLOW" "\n═══ 2. اختبار ملفات المفاتيح ═══\n"

test_gitignore_pattern "ملفات .pem" "\.pem"
test_gitignore_pattern "ملفات .key" "\.key"
test_gitignore_pattern "ملفات .p12" "\.p12"
test_gitignore_pattern "ملفات .pfx" "\.pfx"

# =============================================================================
# 3. اختبار ملفات الشهادات
# =============================================================================

print_colored "$YELLOW" "\n═══ 3. اختبار ملفات الشهادات ═══\n"

test_gitignore_pattern "ملفات .crt" "\.crt"
test_gitignore_pattern "ملفات .cer" "\.cer"
test_gitignore_pattern "ملفات .der" "\.der"

# =============================================================================
# 4. اختبار ملفات التكوين الحساسة
# =============================================================================

print_colored "$YELLOW" "\n═══ 4. اختبار ملفات التكوين الحساسة ═══\n"

test_gitignore_pattern "ملف secrets.yaml" "secrets"
test_gitignore_pattern "ملف credentials" "credentials"
test_gitignore_pattern "ملف config.local" "config\.local"

# =============================================================================
# 5. اختبار ملفات قواعد البيانات
# =============================================================================

print_colored "$YELLOW" "\n═══ 5. اختبار ملفات قواعد البيانات ═══\n"

test_gitignore_pattern "ملفات .db" "\.db"
test_gitignore_pattern "ملفات .sqlite" "\.sqlite"
test_gitignore_pattern "ملفات .sql" "\.sql"

# =============================================================================
# 6. اختبار ملفات النسخ الاحتياطي
# =============================================================================

print_colored "$YELLOW" "\n═══ 6. اختبار ملفات النسخ الاحتياطي ═══\n"

test_gitignore_pattern "ملفات .bak" "\.bak"
test_gitignore_pattern "ملفات .backup" "\.backup"
test_gitignore_pattern "ملفات .old" "\.old"

# =============================================================================
# 7. اختبار ملفات السجلات
# =============================================================================

print_colored "$YELLOW" "\n═══ 7. اختبار ملفات السجلات ═══\n"

test_gitignore_pattern "ملفات .log" "\.log"
test_gitignore_pattern "مجلد logs" "logs/"

# =============================================================================
# 8. اختبار ملفات IDE
# =============================================================================

print_colored "$YELLOW" "\n═══ 8. اختبار ملفات IDE ═══\n"

test_gitignore_pattern "مجلد .idea" "\.idea"
test_gitignore_pattern "مجلد .vscode" "\.vscode"
test_gitignore_pattern "ملفات .iml" "\.iml"

# =============================================================================
# 9. اختبار ملفات نظام التشغيل
# =============================================================================

print_colored "$YELLOW" "\n═══ 9. اختبار ملفات نظام التشغيل ═══\n"

test_gitignore_pattern "ملف .DS_Store" "\.DS_Store"
test_gitignore_pattern "ملف Thumbs.db" "Thumbs\.db"
test_gitignore_pattern "ملف desktop.ini" "desktop\.ini"

# =============================================================================
# 10. اختبار ملفات التبعيات
# =============================================================================

print_colored "$YELLOW" "\n═══ 10. اختبار ملفات التبعيات ═══\n"

test_gitignore_pattern "مجلد node_modules" "node_modules"
test_gitignore_pattern "مجلد vendor" "vendor"
test_gitignore_pattern "مجلد .pub-cache" "\.pub-cache"

# =============================================================================
# النتائج النهائية
# =============================================================================

print_colored "$BLUE" "\n═══════════════════════════════════════════════════════════"
print_colored "$BLUE" "  النتائج النهائية"
print_colored "$BLUE" "═══════════════════════════════════════════════════════════"
echo ""

echo "إجمالي الاختبارات: $TOTAL_TESTS"
print_colored "$GREEN" "✓ نجح: $PASSED_TESTS"
print_colored "$RED" "✗ فشل: $FAILED_TESTS"

if [ $TOTAL_TESTS -gt 0 ]; then
    SUCCESS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo "معدل النجاح: ${SUCCESS_RATE}%"
    
    if [ $SUCCESS_RATE -ge 90 ]; then
        print_colored "$GREEN" "\n🎉 ممتاز! .gitignore يغطي جميع الملفات الحساسة"
    elif [ $SUCCESS_RATE -ge 70 ]; then
        print_colored "$YELLOW" "\n⚠ جيد، لكن يحتاج إضافة بعض الأنماط"
    else
        print_colored "$RED" "\n✗ يحتاج إلى تحسينات كبيرة في .gitignore"
    fi
fi

echo ""

# الخروج
if [ $FAILED_TESTS -gt 0 ]; then
    exit 1
fi

exit 0
