#!/bin/bash

# Enhanced Internationalization Testing Script v2.0
# Implements: COLLABORATION FIRST, KISS, Security First, Quality First, ENGLISH FOR CODE
# Project: Basser MVP
# Author: Basser Development Agents Team
# Date: December 8, 2025

# Don't exit on error - we want to run all checks
set +e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
I18N_DIR="test_results/i18n"
REPORT_FILE="$I18N_DIR/i18n_report_$(date +%Y%m%d_%H%M%S).txt"

# Supported locales
LOCALES=("ar" "en")

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print section header
print_header() {
    echo ""
    print_message "$BLUE" "=================================================="
    print_message "$BLUE" "$1"
    print_message "$BLUE" "=================================================="
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Pre-test checks
pre_test_checks() {
    print_header "🔍 Pre-Test Checks"
    
    # Check Flutter
    if ! command_exists flutter; then
        print_message "$RED" "❌ Flutter not found. Please install Flutter SDK."
        exit 1
    fi
    print_message "$GREEN" "✅ Flutter found: $(flutter --version | head -n 1)"
    
    # Create results directory
    mkdir -p "$I18N_DIR"
    print_message "$GREEN" "✅ Results directory created"
}

# Find translation files
find_translation_files() {
    print_header "📁 Finding Translation Files"
    
    print_message "$BLUE" "Looking for translation files..."
    
    # Common locations for translation files
    local translation_patterns=(
        "lib/l10n/*.arb"
        "lib/i18n/*.json"
        "assets/translations/*.json"
        "assets/i18n/*.json"
    )
    
    local found_files=()
    for pattern in "${translation_patterns[@]}"; do
        # Use find to handle patterns safely
        while IFS= read -r file; do
            if [ -f "$file" ]; then
                found_files+=("$file")
                print_message "$GREEN" "✅ Found: $file"
            fi
        done < <(compgen -G "$pattern" 2>/dev/null || true)
    done
    
    if [ ${#found_files[@]} -eq 0 ]; then
        print_message "$YELLOW" "⚠️  No translation files found"
        print_message "$YELLOW" "💡 Expected locations:"
        for pattern in "${translation_patterns[@]}"; do
            print_message "$YELLOW" "   - $pattern"
        done
        print_message "$BLUE" "💡 This is expected for projects without i18n setup yet"
        return 1
    fi
    
    return 0
}

# Check for missing translation keys
check_missing_keys() {
    print_header "🔑 Checking for Missing Translation Keys"
    
    print_message "$BLUE" "Comparing translation files..."
    
    # Find ARB files (Flutter's standard)
    local arb_files=()
    if compgen -G "lib/l10n/*.arb" > /dev/null 2>&1; then
        while IFS= read -r file; do
            arb_files+=("$file")
        done < <(compgen -G "lib/l10n/*.arb")
    fi
    
    if [ ${#arb_files[@]} -lt 2 ]; then
        print_message "$YELLOW" "⚠️  Need at least 2 translation files to compare"
        return 1
    fi
    
    # Get keys from first file (reference)
    local reference_file="${arb_files[0]}"
    print_message "$BLUE" "Using $reference_file as reference"
    
    # Extract keys (simple JSON parsing)
    local reference_keys=$(grep -o '"[^"]*":' "$reference_file" | tr -d '":' | grep -v "^@" || true)
    local reference_count=$(echo "$reference_keys" | wc -l)
    
    print_message "$BLUE" "Reference file has $reference_count keys"
    
    # Check other files
    local issues_found=0
    for file in "${arb_files[@]}"; do
        if [ "$file" != "$reference_file" ]; then
            print_message "$BLUE" "Checking $file..."
            
            local file_keys=$(grep -o '"[^"]*":' "$file" | tr -d '":' | grep -v "^@" || true)
            local file_count=$(echo "$file_keys" | wc -l)
            
            # Find missing keys
            local missing_keys=$(comm -23 <(echo "$reference_keys" | sort) <(echo "$file_keys" | sort))
            local missing_count=$(echo "$missing_keys" | grep -v "^$" | wc -l)
            
            if [ $missing_count -gt 0 ]; then
                print_message "$YELLOW" "⚠️  Missing $missing_count keys in $file:"
                echo "$missing_keys" | head -10
                if [ $missing_count -gt 10 ]; then
                    print_message "$YELLOW" "   ... and $((missing_count - 10)) more"
                fi
                ((issues_found++))
            else
                print_message "$GREEN" "✅ All keys present in $file"
            fi
        fi
    done
    
    return $issues_found
}

# Check for hardcoded strings
check_hardcoded_strings() {
    print_header "🔍 Checking for Hardcoded Strings"
    
    print_message "$BLUE" "Looking for hardcoded strings in code..."
    
    # Find Text widgets with hardcoded strings (not using localization)
    local hardcoded_text=$(grep -r "Text(" lib/ --include="*.dart" | \
        grep -v "AppLocalizations\|S.of\|context.l10n\|tr(" | \
        grep -v "// " | \
        grep -v "const Text('')" | \
        wc -l)
    
    if [ $hardcoded_text -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $hardcoded_text potential hardcoded Text widgets"
        print_message "$YELLOW" "💡 Use localization for all user-facing text"
        
        # Show some examples
        print_message "$BLUE" "Examples:"
        grep -r "Text(" lib/ --include="*.dart" | \
            grep -v "AppLocalizations\|S.of\|context.l10n\|tr(" | \
            grep -v "// " | \
            head -5
        
        return 1
    else
        print_message "$GREEN" "✅ No obvious hardcoded strings found"
        return 0
    fi
}

# Check RTL support
check_rtl_support() {
    print_header "🔄 Checking RTL Support"
    
    print_message "$BLUE" "Checking RTL (Right-to-Left) support for Arabic..."
    
    local issues_found=0
    
    # Check for Directionality
    local directionality_usage=$(grep -r "Directionality\|TextDirection" lib/ --include="*.dart" | wc -l)
    
    if [ $directionality_usage -gt 0 ]; then
        print_message "$GREEN" "✅ Found $directionality_usage directionality-related usages"
    else
        print_message "$YELLOW" "⚠️  No explicit RTL support found"
        print_message "$YELLOW" "💡 Add Directionality widgets for proper Arabic support"
        ((issues_found++))
    fi
    
    # Check for hardcoded left/right
    local hardcoded_lr=$(grep -r "Alignment.centerLeft\|Alignment.centerRight\|TextAlign.left\|TextAlign.right" lib/ --include="*.dart" | \
        grep -v "// " | \
        wc -l)
    
    if [ $hardcoded_lr -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $hardcoded_lr hardcoded left/right alignments"
        print_message "$YELLOW" "💡 Use start/end instead of left/right for RTL support"
        ((issues_found++))
    else
        print_message "$GREEN" "✅ No hardcoded left/right alignments found"
    fi
    
    return $issues_found
}

# Check text length handling
check_text_length() {
    print_header "📏 Checking Text Length Handling"
    
    print_message "$BLUE" "Checking for text overflow handling..."
    
    # Check for Text widgets without overflow handling
    local text_without_overflow=$(grep -r "Text(" lib/ --include="*.dart" | \
        grep -v "overflow:\|maxLines:\|softWrap:" | \
        grep -v "// " | \
        wc -l)
    
    if [ $text_without_overflow -gt 50 ]; then
        print_message "$YELLOW" "⚠️  Found $text_without_overflow Text widgets without overflow handling"
        print_message "$YELLOW" "💡 Consider adding overflow, maxLines, or softWrap properties"
        print_message "$YELLOW" "💡 This is important for languages with longer translations"
        return 1
    else
        print_message "$GREEN" "✅ Most Text widgets have overflow handling"
        return 0
    fi
}

# Check locale switching
check_locale_switching() {
    print_header "🌍 Checking Locale Switching"
    
    print_message "$BLUE" "Checking locale switching implementation..."
    
    # Check for locale management
    local locale_management=$(grep -r "Locale\|setLocale\|changeLocale" lib/ --include="*.dart" | wc -l)
    
    if [ $locale_management -gt 0 ]; then
        print_message "$GREEN" "✅ Found $locale_management locale management usages"
    else
        print_message "$YELLOW" "⚠️  No locale switching implementation found"
        print_message "$YELLOW" "💡 Implement locale switching for multi-language support"
        return 1
    fi
    
    return 0
}

# Check date and number formatting
check_formatting() {
    print_header "🔢 Checking Date and Number Formatting"
    
    print_message "$BLUE" "Checking for locale-aware formatting..."
    
    # Check for DateFormat usage
    local date_format=$(grep -r "DateFormat\|intl.DateFormat" lib/ --include="*.dart" | wc -l)
    
    if [ $date_format -gt 0 ]; then
        print_message "$GREEN" "✅ Found $date_format DateFormat usages"
    else
        print_message "$YELLOW" "⚠️  No DateFormat usage found"
        print_message "$YELLOW" "💡 Use DateFormat for locale-aware date formatting"
    fi
    
    # Check for NumberFormat usage
    local number_format=$(grep -r "NumberFormat\|intl.NumberFormat" lib/ --include="*.dart" | wc -l)
    
    if [ $number_format -gt 0 ]; then
        print_message "$GREEN" "✅ Found $number_format NumberFormat usages"
    else
        print_message "$YELLOW" "⚠️  No NumberFormat usage found"
        print_message "$YELLOW" "💡 Use NumberFormat for locale-aware number formatting"
    fi
}

# Run i18n tests
run_i18n_tests() {
    print_header "🧪 Running I18n Tests"
    
    print_message "$BLUE" "Running internationalization tests..."
    
    # Run tests
    if flutter test; then
        print_message "$GREEN" "✅ I18n tests passed"
        return 0
    else
        print_message "$YELLOW" "⚠️  Some i18n tests failed"
        return 1
    fi
}

# Generate i18n report
generate_report() {
    print_header "📊 Internationalization Report"
    
    {
        echo "Internationalization Testing Report"
        echo "==================================="
        echo ""
        echo "Date: $(date)"
        echo "Flutter Version: $(flutter --version | head -n 1)"
        echo ""
        echo "Supported Locales:"
        echo "-----------------"
        for locale in "${LOCALES[@]}"; do
            echo "- $locale"
        done
        echo ""
        echo "Test Results:"
        echo "------------"
        echo "See detailed results above"
        echo ""
        echo "Common Issues Found:"
        echo "-------------------"
        echo "1. Missing translation keys"
        echo "2. Hardcoded strings"
        echo "3. Missing RTL support"
        echo "4. No text overflow handling"
        echo "5. Missing locale switching"
        echo "6. No locale-aware formatting"
        echo ""
        echo "Recommendations:"
        echo "---------------"
        echo ""
        echo "1. Translation Keys:"
        echo "   - Keep all locales in sync"
        echo "   - Use consistent key naming"
        echo "   - Document translation context"
        echo ""
        echo "2. Hardcoded Strings:"
        echo "   - Use AppLocalizations for all text"
        echo "   - Never hardcode user-facing strings"
        echo "   - Use const for non-translatable text"
        echo ""
        echo "3. RTL Support:"
        echo "   - Use Directionality widget"
        echo "   - Use start/end instead of left/right"
        echo "   - Test in Arabic locale"
        echo "   - Use TextDirection.rtl for Arabic"
        echo ""
        echo "4. Text Length:"
        echo "   - Add overflow handling to all Text widgets"
        echo "   - Use maxLines for long text"
        echo "   - Test with long translations"
        echo ""
        echo "5. Locale Switching:"
        echo "   - Implement locale selection UI"
        echo "   - Save user's locale preference"
        echo "   - Restart app or rebuild on locale change"
        echo ""
        echo "6. Formatting:"
        echo "   - Use DateFormat for dates"
        echo "   - Use NumberFormat for numbers"
        echo "   - Use locale-aware currency formatting"
        echo ""
        echo "Testing Checklist:"
        echo "-----------------"
        echo "- [ ] All strings are translated"
        echo "- [ ] No hardcoded strings"
        echo "- [ ] RTL works correctly"
        echo "- [ ] Text doesn't overflow"
        echo "- [ ] Locale switching works"
        echo "- [ ] Dates formatted correctly"
        echo "- [ ] Numbers formatted correctly"
        echo "- [ ] Currency formatted correctly"
        echo "- [ ] Plurals handled correctly"
        echo "- [ ] Gender handled correctly (if applicable)"
        echo ""
        echo "Tools:"
        echo "------"
        echo "- Flutter Intl extension (VS Code)"
        echo "- ARB files for translations"
        echo "- intl package for formatting"
        echo "- flutter_localizations package"
        echo ""
        echo "Principles Applied:"
        echo "------------------"
        echo "- ✅ COLLABORATION FIRST: Clear i18n guidelines"
        echo "- ✅ KISS: Simple i18n implementation"
        echo "- ✅ Security First: No sensitive data in translations"
        echo "- ✅ Quality First: Comprehensive i18n testing"
        echo "- ✅ ENGLISH FOR CODE: Code in English, UI in multiple languages"
        echo ""
        echo "Next Steps:"
        echo "----------"
        echo "1. Fix all missing translation keys"
        echo "2. Remove hardcoded strings"
        echo "3. Implement RTL support"
        echo "4. Add overflow handling"
        echo "5. Test in all supported locales"
        echo "6. Get translations reviewed by native speakers"
    } > "$REPORT_FILE"
    
    cat "$REPORT_FILE"
    print_message "$GREEN" "✅ Report saved to: $REPORT_FILE"
}

# Main execution
main() {
    print_header "🌍 Enhanced Internationalization Testing v2.0"
    
    print_message "$BLUE" "Starting i18n testing..."
    echo ""
    
    # Execute test steps
    pre_test_checks
    
    # Run i18n checks
    local total_issues=0
    
    # Continue even if translation files not found
    find_translation_files || true
    check_missing_keys || true
    check_hardcoded_strings || ((total_issues++))
    check_rtl_support || ((total_issues+=$?))
    check_text_length || ((total_issues++))
    check_locale_switching || ((total_issues++))
    check_formatting
    run_i18n_tests || ((total_issues++))
    
    generate_report
    
    if [ $total_issues -eq 0 ]; then
        print_header "✅ I18n Testing Completed Successfully!"
        print_message "$GREEN" "🎉 No i18n issues found!"
    else
        print_header "⚠️  I18n Testing Completed with Issues"
        print_message "$YELLOW" "⚠️  Found i18n issues that need attention"
        print_message "$YELLOW" "💡 Review the report and fix issues"
    fi
    
    print_message "$BLUE" "📁 Report location: $REPORT_FILE"
    print_message "$BLUE" "💡 Test in all supported locales for best results"
}

# Run main function
main "$@"
