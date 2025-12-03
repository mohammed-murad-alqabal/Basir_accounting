#!/bin/bash

# =============================================================================
# سكريبت تثبيت Bats (Bash Automated Testing System)
# =============================================================================
# الوصف: يقوم بتثبيت bats لتشغيل اختبارات نظام تتبع الأخطاء
# الاستخدام: sudo ./scripts/install_bats.sh
# =============================================================================

set -euo pipefail

# الألوان للإخراج
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# طباعة رسالة ملونة
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# التحقق من صلاحيات root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_message "$RED" "❌ هذا السكريبت يتطلب صلاحيات root"
        print_message "$YELLOW" "يرجى تشغيله باستخدام: sudo $0"
        exit 1
    fi
}

# التحقق من وجود bats
check_bats() {
    if command -v bats &> /dev/null; then
        local version=$(bats --version | head -n1)
        print_message "$GREEN" "✓ bats مثبت بالفعل: $version"
        return 0
    else
        return 1
    fi
}

# تثبيت bats على Ubuntu/Debian
install_bats_debian() {
    print_message "$BLUE" "تثبيت bats على Ubuntu/Debian..."
    
    # تحديث قائمة الحزم
    print_message "$YELLOW" "تحديث قائمة الحزم..."
    apt-get update -qq
    
    # تثبيت bats
    print_message "$YELLOW" "تثبيت bats..."
    apt-get install -y bats
    
    # التحقق من التثبيت
    if command -v bats &> /dev/null; then
        local version=$(bats --version | head -n1)
        print_message "$GREEN" "✓ تم تثبيت bats بنجاح: $version"
        return 0
    else
        print_message "$RED" "❌ فشل تثبيت bats"
        return 1
    fi
}

# تثبيت bats من المصدر (احتياطي)
install_bats_from_source() {
    print_message "$BLUE" "تثبيت bats من المصدر..."
    
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # تنزيل bats
    print_message "$YELLOW" "تنزيل bats..."
    git clone https://github.com/bats-core/bats-core.git
    cd bats-core
    
    # تثبيت
    print_message "$YELLOW" "تثبيت bats..."
    ./install.sh /usr/local
    
    # تنظيف
    cd /
    rm -rf "$temp_dir"
    
    # التحقق من التثبيت
    if command -v bats &> /dev/null; then
        local version=$(bats --version | head -n1)
        print_message "$GREEN" "✓ تم تثبيت bats بنجاح: $version"
        return 0
    else
        print_message "$RED" "❌ فشل تثبيت bats"
        return 1
    fi
}

# البرنامج الرئيسي
main() {
    print_message "$BLUE" "═══════════════════════════════════════════════════════════════"
    print_message "$BLUE" "  تثبيت Bats (Bash Automated Testing System)"
    print_message "$BLUE" "═══════════════════════════════════════════════════════════════"
    echo ""
    
    # التحقق من صلاحيات root
    check_root
    
    # التحقق من وجود bats
    if check_bats; then
        print_message "$GREEN" "لا حاجة للتثبيت"
        exit 0
    fi
    
    # محاولة التثبيت
    if command -v apt-get &> /dev/null; then
        # نظام Debian/Ubuntu
        if install_bats_debian; then
            print_message "$GREEN" "🎉 تم التثبيت بنجاح!"
            exit 0
        fi
    fi
    
    # محاولة التثبيت من المصدر
    print_message "$YELLOW" "محاولة التثبيت من المصدر..."
    if install_bats_from_source; then
        print_message "$GREEN" "🎉 تم التثبيت بنجاح!"
        exit 0
    fi
    
    # فشل التثبيت
    print_message "$RED" "❌ فشل تثبيت bats"
    print_message "$YELLOW" "يرجى تثبيت bats يدوياً من:"
    print_message "$YELLOW" "https://github.com/bats-core/bats-core"
    exit 1
}

# تشغيل البرنامج الرئيسي
main "$@"
