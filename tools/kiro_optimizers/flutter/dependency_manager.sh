#!/bin/bash

# Flutter Dependency Management Hook
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
    echo -e "${PURPLE}📦 $1${NC}"
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

# التحقق من وجود pubspec.yaml
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found"
    exit 1
fi

# إنشاء مجلد التقارير
mkdir -p .kiro/reports/dependencies

REPORT_FILE=".kiro/reports/dependencies/dependency_report_$(date +%Y%m%d_%H%M%S).md"

print_header "Flutter Dependency Management"

# دالة عرض القائمة الرئيسية
show_menu() {
    echo ""
    echo "Available actions:"
    echo "1. 📊 Analyze Dependencies"
    echo "2. 🔄 Update Dependencies"
    echo "3. 🔍 Check Outdated"
    echo "4. 🛡️ Security Audit"
    echo "5. 🧹 Clean Dependencies"
    echo "6. 📋 Generate Report"
    echo "7. 🚀 Quick Fix"
    echo "0. Exit"
    echo ""
}

# 1. Analyze Dependencies
analyze_dependencies() {
    print_header "Dependency Analysis"
    
    print_info "Analyzing pubspec.yaml..."
    
    # حساب Dependencies
    TOTAL_DEPS=$(grep -c "^  [a-zA-Z]" pubspec.yaml 2>/dev/null || echo "0")
    
    # فصل production و dev dependencies
    DEV_START=$(grep -n "dev_dependencies:" pubspec.yaml | cut -d: -f1 2>/dev/null || echo "999999")
    PROD_DEPS=$(head -n "$DEV_START" pubspec.yaml | grep -c "^  [a-zA-Z]" 2>/dev/null || echo "0")
    DEV_DEPS=$((TOTAL_DEPS - PROD_DEPS))
    
    print_info "Dependencies breakdown:"
    print_info "  - Total: $TOTAL_DEPS"
    print_info "  - Production: $PROD_DEPS"
    print_info "  - Development: $DEV_DEPS"
    
    # فحص Dependencies الأساسية لـ basir_accounting_system
    echo ""
    print_info "Basir Accounting System Essential Dependencies:"
    
    check_dependency() {
        local dep_name=$1
        local dep_description=$2
        if grep -q "$dep_name" pubspec.yaml; then
            print_status "$dep_description: ✅ Found"
        else
            print_warning "$dep_description: ❌ Missing"
        fi
    }
    
    check_dependency "flutter_riverpod" "State Management (Riverpod)"
    check_dependency "isar" "Local Database (Isar)"
    check_dependency "flutter_secure_storage" "Secure Storage"
    check_dependency "freezed" "Code Generation (Freezed)"
    check_dependency "json_annotation" "JSON Serialization"
    check_dependency "uuid" "UUID Generation"
    check_dependency "intl" "Internationalization"
    check_dependency "flutter_localizations" "Flutter Localizations"
    
    # فحص Dev Dependencies
    echo ""
    print_info "Development Dependencies:"
    check_dependency "build_runner" "Code Generation Runner"
    check_dependency "freezed" "Freezed Code Generator"
    check_dependency "json_serializable" "JSON Serializable"
    check_dependency "flutter_test" "Testing Framework"
    check_dependency "mockito" "Mocking Framework"
    check_dependency "flutter_lints" "Linting Rules"
    
    print_status "Dependency analysis completed"
}

# 2. Update Dependencies
update_dependencies() {
    print_header "Updating Dependencies"
    
    print_info "Getting current dependencies..."
    flutter pub get
    
    print_info "Checking for updates..."
    flutter pub outdated > .kiro/reports/dependencies/outdated_$(date +%Y%m%d_%H%M%S).txt 2>&1 || true
    
    echo ""
    echo -n "Do you want to upgrade dependencies? (y/N): "
    read -r upgrade_confirm
    
    if [[ $upgrade_confirm =~ ^[Yy]$ ]]; then
        print_info "Upgrading dependencies..."
        flutter pub upgrade
        
        print_info "Running code generation..."
        flutter packages pub run build_runner build --delete-conflicting-outputs
        
        print_status "Dependencies updated successfully"
    else
        print_info "Upgrade cancelled"
    fi
}

# 3. Check Outdated
check_outdated() {
    print_header "Checking Outdated Dependencies"
    
    print_info "Checking for outdated packages..."
    
    OUTDATED_FILE=".kiro/reports/dependencies/outdated_$(date +%Y%m%d_%H%M%S).txt"
    
    if flutter pub outdated > "$OUTDATED_FILE" 2>&1; then
        print_status "Outdated check completed"
    else
        print_warning "Some packages may have issues"
    fi
    
    echo ""
    print_info "Results saved to: $OUTDATED_FILE"
    
    # عرض ملخص
    if grep -q "All dependencies are up to date" "$OUTDATED_FILE"; then
        print_status "All dependencies are up to date!"
    else
        OUTDATED_COUNT=$(grep -c "^  " "$OUTDATED_FILE" 2>/dev/null || echo "0")
        if [ "$OUTDATED_COUNT" -gt 0 ]; then
            print_warning "$OUTDATED_COUNT packages have updates available"
            echo ""
            echo "Top outdated packages:"
            head -10 "$OUTDATED_FILE" | grep "^  " || true
        fi
    fi
}

# 4. Security Audit
security_audit() {
    print_header "Security Audit"
    
    print_info "Running security audit..."
    
    AUDIT_FILE=".kiro/reports/dependencies/security_audit_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$AUDIT_FILE" << EOF
# Dependency Security Audit

**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')

## Security Checks

EOF
    
    # فحص Dependencies المعروفة بالمشاكل الأمنية
    print_info "Checking for known vulnerable packages..."
    
    VULNERABLE_PACKAGES=("http" "dio" "shared_preferences")
    FOUND_VULNERABLE=0
    
    for package in "${VULNERABLE_PACKAGES[@]}"; do
        if grep -q "^  $package:" pubspec.yaml; then
            print_warning "Found potentially vulnerable package: $package"
            echo "- ⚠️ **$package**: Review for security updates" >> "$AUDIT_FILE"
            FOUND_VULNERABLE=$((FOUND_VULNERABLE + 1))
        fi
    done
    
    # فحص HTTPS vs HTTP في Dependencies
    print_info "Checking dependency sources..."
    
    HTTP_DEPS=$(grep -c "http://" pubspec.yaml 2>/dev/null || echo "0")
    if [ "$HTTP_DEPS" -gt 0 ]; then
        print_warning "Found $HTTP_DEPS HTTP (non-secure) dependency sources"
        echo "- ⚠️ **HTTP Sources**: $HTTP_DEPS non-secure dependency sources found" >> "$AUDIT_FILE"
    else
        print_status "All dependency sources use HTTPS"
        echo "- ✅ **HTTPS Sources**: All dependency sources are secure" >> "$AUDIT_FILE"
    fi
    
    # فحص Git dependencies
    GIT_DEPS=$(grep -c "git:" pubspec.yaml 2>/dev/null || echo "0")
    if [ "$GIT_DEPS" -gt 0 ]; then
        print_warning "Found $GIT_DEPS Git dependencies (review for security)"
        echo "- ⚠️ **Git Dependencies**: $GIT_DEPS Git dependencies found - review sources" >> "$AUDIT_FILE"
    fi
    
    cat >> "$AUDIT_FILE" << EOF

## Summary

- **Potentially Vulnerable Packages:** $FOUND_VULNERABLE
- **HTTP Sources:** $HTTP_DEPS
- **Git Dependencies:** $GIT_DEPS

## Recommendations

EOF
    
    if [ "$FOUND_VULNERABLE" -gt 0 ]; then
        echo "- Update vulnerable packages to latest secure versions" >> "$AUDIT_FILE"
    fi
    
    if [ "$HTTP_DEPS" -gt 0 ]; then
        echo "- Replace HTTP sources with HTTPS alternatives" >> "$AUDIT_FILE"
    fi
    
    if [ "$GIT_DEPS" -gt 0 ]; then
        echo "- Review Git dependencies for security and stability" >> "$AUDIT_FILE"
    fi
    
    if [ "$FOUND_VULNERABLE" -eq 0 ] && [ "$HTTP_DEPS" -eq 0 ]; then
        echo "- ✅ No major security issues found" >> "$AUDIT_FILE"
    fi
    
    print_status "Security audit completed"
    print_info "Report saved to: $AUDIT_FILE"
}

# 5. Clean Dependencies
clean_dependencies() {
    print_header "Cleaning Dependencies"
    
    print_info "Cleaning Flutter project..."
    
    # تنظيف شامل
    flutter clean
    
    print_info "Removing .dart_tool..."
    rm -rf .dart_tool/
    
    print_info "Removing build directory..."
    rm -rf build/
    
    print_info "Getting fresh dependencies..."
    flutter pub get
    
    print_info "Running code generation..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    print_status "Dependencies cleaned successfully"
}

# 6. Generate Report
generate_report() {
    print_header "Generating Comprehensive Report"
    
    cat > "$REPORT_FILE" << EOF
# Flutter Dependencies Report

**المشروع:** نظام بصير المحاسبي (Basir Accounting System)  
**التاريخ:** $(date '+%Y-%m-%d %H:%M:%S')  
**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## Dependencies Overview

EOF
    
    # حساب Dependencies
    TOTAL_DEPS=$(grep -c "^  [a-zA-Z]" pubspec.yaml 2>/dev/null || echo "0")
    DEV_START=$(grep -n "dev_dependencies:" pubspec.yaml | cut -d: -f1 2>/dev/null || echo "999999")
    PROD_DEPS=$(head -n "$DEV_START" pubspec.yaml | grep -c "^  [a-zA-Z]" 2>/dev/null || echo "0")
    DEV_DEPS=$((TOTAL_DEPS - PROD_DEPS))
    
    cat >> "$REPORT_FILE" << EOF
### Statistics
- **Total Dependencies:** $TOTAL_DEPS
- **Production Dependencies:** $PROD_DEPS
- **Development Dependencies:** $DEV_DEPS

### Essential Dependencies Status

EOF
    
    # فحص Dependencies الأساسية
    check_and_report() {
        local dep_name=$1
        local dep_description=$2
        if grep -q "$dep_name" pubspec.yaml; then
            echo "- ✅ **$dep_description:** Found" >> "$REPORT_FILE"
        else
            echo "- ❌ **$dep_description:** Missing" >> "$REPORT_FILE"
        fi
    }
    
    check_and_report "flutter_riverpod" "State Management (Riverpod)"
    check_and_report "isar" "Local Database (Isar)"
    check_and_report "flutter_secure_storage" "Secure Storage"
    check_and_report "freezed" "Code Generation (Freezed)"
    check_and_report "json_annotation" "JSON Serialization"
    check_and_report "uuid" "UUID Generation"
    check_and_report "intl" "Internationalization"
    
    cat >> "$REPORT_FILE" << EOF

### Development Dependencies

EOF
    
    check_and_report "build_runner" "Code Generation Runner"
    check_and_report "freezed" "Freezed Code Generator"
    check_and_report "json_serializable" "JSON Serializable"
    check_and_report "flutter_test" "Testing Framework"
    check_and_report "mockito" "Mocking Framework"
    check_and_report "flutter_lints" "Linting Rules"
    
    # إضافة قائمة Dependencies الكاملة
    cat >> "$REPORT_FILE" << EOF

### Complete Dependencies List

#### Production Dependencies
\`\`\`yaml
EOF
    
    head -n "$DEV_START" pubspec.yaml | grep "^  [a-zA-Z]" >> "$REPORT_FILE" 2>/dev/null || true
    
    cat >> "$REPORT_FILE" << EOF
\`\`\`

#### Development Dependencies
\`\`\`yaml
EOF
    
    tail -n +$((DEV_START + 1)) pubspec.yaml | grep "^  [a-zA-Z]" >> "$REPORT_FILE" 2>/dev/null || true
    
    cat >> "$REPORT_FILE" << EOF
\`\`\`

---

**Generated by:** Flutter Dependency Management Hook
EOF
    
    print_status "Report generated successfully"
    print_info "Report saved to: $REPORT_FILE"
}

# 7. Quick Fix
quick_fix() {
    print_header "Quick Fix"
    
    print_info "Running quick dependency fixes..."
    
    # تنظيف وإعادة تثبيت
    flutter clean
    flutter pub get
    
    # تشغيل code generation
    if grep -q "build_runner" pubspec.yaml; then
        print_info "Running code generation..."
        flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    
    # فحص المشاكل الشائعة
    print_info "Checking for common issues..."
    
    # فحص version conflicts
    if flutter pub deps > /dev/null 2>&1; then
        print_status "No version conflicts detected"
    else
        print_warning "Version conflicts detected - run 'flutter pub deps' for details"
    fi
    
    print_status "Quick fix completed"
}

# التحقق من المعاملات
if [ $# -eq 0 ]; then
    # وضع تفاعلي
    while true; do
        show_menu
        echo -n "Choose an option (0-7): "
        read -r choice
        
        case $choice in
            1) analyze_dependencies ;;
            2) update_dependencies ;;
            3) check_outdated ;;
            4) security_audit ;;
            5) clean_dependencies ;;
            6) generate_report ;;
            7) quick_fix ;;
            0) 
                print_status "Goodbye! 👋"
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please try again."
                ;;
        esac
        
        echo ""
        echo "Press Enter to continue..."
        read -r
    done
else
    # وضع command line
    case $1 in
        "analyze") analyze_dependencies ;;
        "update") update_dependencies ;;
        "outdated") check_outdated ;;
        "audit") security_audit ;;
        "clean") clean_dependencies ;;
        "report") generate_report ;;
        "fix") quick_fix ;;
        *)
            echo "Usage: $0 [analyze|update|outdated|audit|clean|report|fix]"
            echo ""
            echo "Commands:"
            echo "  analyze  - Analyze current dependencies"
            echo "  update   - Update dependencies"
            echo "  outdated - Check for outdated packages"
            echo "  audit    - Run security audit"
            echo "  clean    - Clean and reinstall dependencies"
            echo "  report   - Generate comprehensive report"
            echo "  fix      - Quick fix common issues"
            echo ""
            echo "Run without arguments for interactive mode"
            exit 1
            ;;
    esac
fi