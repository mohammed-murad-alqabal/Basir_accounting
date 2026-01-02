#!/bin/bash

# Flutter Localization Management Hook
# المؤلف: فريق وكلاء تطوير مشروع بصير
# التاريخ: 18 ديسمبر 2025

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}🌐 $1${NC}"
    echo "════════════════════════════════════════════════════════════════"
}

print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_header "Flutter Localization Manager"

# إنشاء مجلدات L10n
setup_l10n_structure() {
    print_info "Setting up localization structure..."
    
    mkdir -p lib/l10n
    mkdir -p lib/generated
    
    # إنشاء l10n.yaml إذا لم يكن موجوداً
    if [ ! -f "l10n.yaml" ]; then
        cat > l10n.yaml << EOF
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/generated/l10n
nullable-getter: false
synthetic-package: false
EOF
        print_status "Created l10n.yaml configuration"
    fi
    
    print_status "Localization structure ready"
}

# إنشاء ملفات ARB الأساسية
create_arb_files() {
    print_info "Creating ARB files..."
    
    # English (template)
    cat > lib/l10n/app_en.arb << 'EOF'
{
  "@@locale": "en",
  "appTitle": "Basir App",
  "@appTitle": {
    "description": "The title of the application"
  },
  "welcome": "Welcome",
  "@welcome": {
    "description": "Welcome message"
  },
  "login": "Login",
  "@login": {
    "description": "Login button text"
  },
  "email": "Email",
  "@email": {
    "description": "Email field label"
  },
  "password": "Password",
  "@password": {
    "description": "Password field label"
  },
  "submit": "Submit",
  "@submit": {
    "description": "Submit button text"
  },
  "cancel": "Cancel",
  "@cancel": {
    "description": "Cancel button text"
  },
  "save": "Save",
  "@save": {
    "description": "Save button text"
  },
  "delete": "Delete",
  "@delete": {
    "description": "Delete button text"
  },
  "edit": "Edit",
  "@edit": {
    "description": "Edit button text"
  },
  "search": "Search",
  "@search": {
    "description": "Search field placeholder"
  }
}
EOF
    
    # Arabic
    cat > lib/l10n/app_ar.arb << 'EOF'
{
  "@@locale": "ar",
  "appTitle": "بصير MVP",
  "welcome": "مرحباً",
  "login": "تسجيل الدخول",
  "email": "البريد الإلكتروني",
  "password": "كلمة المرور",
  "submit": "إرسال",
  "cancel": "إلغاء",
  "save": "حفظ",
  "delete": "حذف",
  "edit": "تحرير",
  "search": "بحث"
}
EOF
    
    print_status "ARB files created"
}

# فحص الترجمات المفقودة
check_missing_translations() {
    print_info "Checking for missing translations..."
    
    if [ ! -f "lib/l10n/app_en.arb" ] || [ ! -f "lib/l10n/app_ar.arb" ]; then
        print_error "ARB files not found. Run setup first."
        return 1
    fi
    
    # استخراج المفاتيح من الملف الإنجليزي
    EN_KEYS=$(jq -r 'keys[]' lib/l10n/app_en.arb | grep -v "^@" | sort)
    AR_KEYS=$(jq -r 'keys[]' lib/l10n/app_ar.arb | grep -v "^@" | sort)
    
    # البحث عن المفاتيح المفقودة
    MISSING_IN_AR=$(comm -23 <(echo "$EN_KEYS") <(echo "$AR_KEYS"))
    MISSING_IN_EN=$(comm -23 <(echo "$AR_KEYS") <(echo "$EN_KEYS"))
    
    if [ -n "$MISSING_IN_AR" ]; then
        print_warning "Missing Arabic translations:"
        echo "$MISSING_IN_AR" | while read -r key; do
            echo "  - $key"
        done
    fi
    
    if [ -n "$MISSING_IN_EN" ]; then
        print_warning "Missing English translations:"
        echo "$MISSING_IN_EN" | while read -r key; do
            echo "  - $key"
        done
    fi
    
    if [ -z "$MISSING_IN_AR" ] && [ -z "$MISSING_IN_EN" ]; then
        print_status "All translations are synchronized"
    fi
}

# إضافة ترجمة جديدة
add_translation() {
    local key=$1
    local en_value=$2
    local ar_value=$3
    local description=$4
    
    if [ -z "$key" ] || [ -z "$en_value" ] || [ -z "$ar_value" ]; then
        print_error "Usage: add_translation <key> <en_value> <ar_value> [description]"
        return 1
    fi
    
    print_info "Adding translation: $key"
    
    # إضافة للملف الإنجليزي
    local temp_en=$(mktemp)
    jq --arg key "$key" --arg value "$en_value" --arg desc "${description:-Translation for $key}" \
       '. + {($key): $value, ("@" + $key): {"description": $desc}}' \
       lib/l10n/app_en.arb > "$temp_en"
    mv "$temp_en" lib/l10n/app_en.arb
    
    # إضافة للملف العربي
    local temp_ar=$(mktemp)
    jq --arg key "$key" --arg value "$ar_value" \
       '. + {($key): $value}' \
       lib/l10n/app_ar.arb > "$temp_ar"
    mv "$temp_ar" lib/l10n/app_ar.arb
    
    print_status "Translation added successfully"
}

# توليد ملفات الترجمة
generate_localizations() {
    print_info "Generating localization files..."
    
    if [ ! -f "l10n.yaml" ]; then
        print_error "l10n.yaml not found. Run setup first."
        return 1
    fi
    
    flutter gen-l10n
    
    print_status "Localization files generated"
}

# فحص استخدام الترجمات في الكود
check_translation_usage() {
    print_info "Checking translation usage in code..."
    
    if [ ! -f "lib/l10n/app_en.arb" ]; then
        print_error "ARB files not found"
        return 1
    fi
    
    # استخراج جميع المفاتيح
    KEYS=$(jq -r 'keys[]' lib/l10n/app_en.arb | grep -v "^@")
    
    echo "Translation usage report:"
    echo "========================"
    
    while read -r key; do
        USAGE_COUNT=$(grep -r "AppLocalizations.*\.$key" lib/ | wc -l 2>/dev/null || echo "0")
        if [ "$USAGE_COUNT" -eq 0 ]; then
            print_warning "Unused translation: $key"
        else
            print_info "Used $USAGE_COUNT times: $key"
        fi
    done <<< "$KEYS"
}

# القائمة الرئيسية
show_menu() {
    echo ""
    echo "Localization Management Options:"
    echo "1. 🏗️ Setup L10n Structure"
    echo "2. 📝 Create ARB Files"
    echo "3. 🔍 Check Missing Translations"
    echo "4. ➕ Add New Translation"
    echo "5. 🔄 Generate Localizations"
    echo "6. 📊 Check Translation Usage"
    echo "7. 📋 Generate Report"
    echo "0. Exit"
    echo ""
}

# تقرير شامل
generate_report() {
    print_info "Generating localization report..."
    
    local report_file=".kiro/reports/localization_report_$(date +%Y%m%d_%H%M%S).md"
    mkdir -p .kiro/reports
    
    cat > "$report_file" << EOF
# Localization Report

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')
**المؤلف:** فريق وكلاء تطوير مشروع بصير

## Configuration Status

EOF
    
    if [ -f "l10n.yaml" ]; then
        echo "- ✅ **l10n.yaml:** Configured" >> "$report_file"
    else
        echo "- ❌ **l10n.yaml:** Missing" >> "$report_file"
    fi
    
    if [ -f "lib/l10n/app_en.arb" ]; then
        EN_COUNT=$(jq 'keys | length' lib/l10n/app_en.arb)
        echo "- ✅ **English ARB:** $EN_COUNT keys" >> "$report_file"
    else
        echo "- ❌ **English ARB:** Missing" >> "$report_file"
    fi
    
    if [ -f "lib/l10n/app_ar.arb" ]; then
        AR_COUNT=$(jq 'keys | length' lib/l10n/app_ar.arb)
        echo "- ✅ **Arabic ARB:** $AR_COUNT keys" >> "$report_file"
    else
        echo "- ❌ **Arabic ARB:** Missing" >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    echo "---" >> "$report_file"
    echo "" >> "$report_file"
    echo "**Generated by:** Flutter Localization Manager" >> "$report_file"
    
    print_status "Report saved to: $report_file"
}

# التحقق من المعاملات
if [ $# -eq 0 ]; then
    # وضع تفاعلي
    while true; do
        show_menu
        echo -n "Choose option (0-7): "
        read -r choice
        
        case $choice in
            1) setup_l10n_structure ;;
            2) create_arb_files ;;
            3) check_missing_translations ;;
            4) 
                echo -n "Enter key: "
                read -r key
                echo -n "Enter English value: "
                read -r en_value
                echo -n "Enter Arabic value: "
                read -r ar_value
                echo -n "Enter description (optional): "
                read -r description
                add_translation "$key" "$en_value" "$ar_value" "$description"
                ;;
            5) generate_localizations ;;
            6) check_translation_usage ;;
            7) generate_report ;;
            0) 
                print_status "Goodbye! 👋"
                exit 0
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
        
        echo ""
        echo "Press Enter to continue..."
        read -r
    done
else
    # وضع command line
    case $1 in
        "setup") setup_l10n_structure ;;
        "create") create_arb_files ;;
        "check") check_missing_translations ;;
        "generate") generate_localizations ;;
        "usage") check_translation_usage ;;
        "report") generate_report ;;
        *)
            echo "Usage: $0 [setup|create|check|generate|usage|report]"
            exit 1
            ;;
    esac
fi