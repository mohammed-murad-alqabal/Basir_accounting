#!/bin/bash

# Enhanced Accessibility Testing Script v2.0
# Implements: COLLABORATION FIRST, KISS, Security First, Quality First, ENGLISH FOR CODE
# Project: Basser MVP
# Author: Basser Development Agents Team
# Date: December 8, 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ACCESSIBILITY_DIR="test_results/accessibility"
REPORT_FILE="$ACCESSIBILITY_DIR/accessibility_report_$(date +%Y%m%d_%H%M%S).txt"

# Accessibility standards
MIN_CONTRAST_RATIO=4.5  # WCAG AA standard
MIN_TOUCH_TARGET_SIZE=48  # dp (Material Design guideline)
MIN_TEXT_SIZE=14  # sp

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
    mkdir -p "$ACCESSIBILITY_DIR"
    print_message "$GREEN" "✅ Results directory created"
}

# Check for semantic labels
check_semantic_labels() {
    print_header "🏷️  Checking Semantic Labels"
    
    print_message "$BLUE" "Checking for widgets without semantic labels..."
    
    local issues_found=0
    
    # Check for Image widgets without semanticLabel
    local images_without_labels=$(grep -r "Image\." lib/ --include="*.dart" | \
        grep -v "semanticLabel" | \
        grep -v "// " | \
        wc -l)
    
    if [ $images_without_labels -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $images_without_labels Image widgets without semanticLabel"
        print_message "$YELLOW" "💡 Add semanticLabel to all Image widgets for screen readers"
        ((issues_found++))
    else
        print_message "$GREEN" "✅ All Image widgets have semantic labels"
    fi
    
    # Check for IconButton without Tooltip or semanticLabel
    local icons_without_labels=$(grep -r "IconButton" lib/ --include="*.dart" | \
        grep -v "tooltip" | \
        grep -v "semanticLabel" | \
        grep -v "// " | \
        wc -l)
    
    if [ $icons_without_labels -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $icons_without_labels IconButton widgets without tooltip/semanticLabel"
        print_message "$YELLOW" "💡 Add tooltip or semanticLabel to all IconButton widgets"
        ((issues_found++))
    else
        print_message "$GREEN" "✅ All IconButton widgets have labels"
    fi
    
    return $issues_found
}

# Check contrast ratios
check_contrast_ratios() {
    print_header "🎨 Checking Contrast Ratios"
    
    print_message "$BLUE" "Checking color contrast ratios..."
    
    print_message "$YELLOW" "⚠️  Automated contrast checking requires visual inspection"
    print_message "$BLUE" "💡 Manual checks needed:"
    print_message "$BLUE" "   1. Use Chrome DevTools Accessibility Inspector"
    print_message "$BLUE" "   2. Check contrast ratio for all text"
    print_message "$BLUE" "   3. Minimum ratio: ${MIN_CONTRAST_RATIO}:1 (WCAG AA)"
    print_message "$BLUE" "   4. Recommended: 7:1 (WCAG AAA)"
    
    # Check for common low-contrast patterns in code
    local low_contrast_patterns=$(grep -r "Colors.grey\[300\]" lib/ --include="*.dart" | \
        grep "Text\|color:" | \
        wc -l)
    
    if [ $low_contrast_patterns -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $low_contrast_patterns potential low-contrast color usages"
        print_message "$YELLOW" "💡 Review grey color usage for sufficient contrast"
        return 1
    else
        print_message "$GREEN" "✅ No obvious low-contrast patterns found"
        return 0
    fi
}

# Check text sizes
check_text_sizes() {
    print_header "📏 Checking Text Sizes"
    
    print_message "$BLUE" "Checking for small text sizes..."
    
    local issues_found=0
    
    # Check for small font sizes
    local small_text=$(grep -r "fontSize:" lib/ --include="*.dart" | \
        grep -E "fontSize: [0-9]+" | \
        awk -F'fontSize: ' '{print $2}' | \
        awk '{print $1}' | \
        while read size; do
            size_num=$(echo "$size" | tr -d ',')
            if [ "$size_num" -lt $MIN_TEXT_SIZE ]; then
                echo "$size_num"
            fi
        done | wc -l)
    
    if [ $small_text -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $small_text text elements with size < ${MIN_TEXT_SIZE}sp"
        print_message "$YELLOW" "💡 Minimum recommended text size: ${MIN_TEXT_SIZE}sp"
        ((issues_found++))
    else
        print_message "$GREEN" "✅ All text sizes meet minimum requirements"
    fi
    
    return $issues_found
}

# Check touch target sizes
check_touch_targets() {
    print_header "👆 Checking Touch Target Sizes"
    
    print_message "$BLUE" "Checking for small touch targets..."
    
    print_message "$YELLOW" "⚠️  Touch target size checking requires manual inspection"
    print_message "$BLUE" "💡 Guidelines:"
    print_message "$BLUE" "   - Minimum size: ${MIN_TOUCH_TARGET_SIZE}dp x ${MIN_TOUCH_TARGET_SIZE}dp"
    print_message "$BLUE" "   - Applies to: buttons, icons, checkboxes, etc."
    print_message "$BLUE" "   - Use SizedBox or Container to ensure minimum size"
    
    # Check for IconButton without explicit size
    local small_buttons=$(grep -r "IconButton" lib/ --include="*.dart" | \
        grep -v "iconSize" | \
        grep -v "// " | \
        wc -l)
    
    if [ $small_buttons -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $small_buttons IconButton widgets without explicit iconSize"
        print_message "$YELLOW" "💡 Consider setting iconSize to ensure ${MIN_TOUCH_TARGET_SIZE}dp minimum"
        return 1
    else
        print_message "$GREEN" "✅ IconButton widgets have explicit sizes"
        return 0
    fi
}

# Check for keyboard navigation support
check_keyboard_navigation() {
    print_header "⌨️  Checking Keyboard Navigation"
    
    print_message "$BLUE" "Checking keyboard navigation support..."
    
    # Check for Focus widgets
    local focus_widgets=$(grep -r "Focus\|FocusNode\|FocusScope" lib/ --include="*.dart" | wc -l)
    
    if [ $focus_widgets -gt 0 ]; then
        print_message "$GREEN" "✅ Found $focus_widgets focus-related widgets"
    else
        print_message "$YELLOW" "⚠️  No focus management found"
        print_message "$YELLOW" "💡 Consider adding keyboard navigation support"
        return 1
    fi
    
    return 0
}

# Check for screen reader support
check_screen_reader_support() {
    print_header "📢 Checking Screen Reader Support"
    
    print_message "$BLUE" "Checking screen reader support..."
    
    # Check for Semantics widgets
    local semantics_widgets=$(grep -r "Semantics\|ExcludeSemantics\|MergeSemantics" lib/ --include="*.dart" | wc -l)
    
    if [ $semantics_widgets -gt 0 ]; then
        print_message "$GREEN" "✅ Found $semantics_widgets semantic widgets"
    else
        print_message "$YELLOW" "⚠️  Limited semantic widget usage"
        print_message "$YELLOW" "💡 Use Semantics widgets to improve screen reader support"
        return 1
    fi
    
    return 0
}

# Check for RTL support (important for Arabic)
check_rtl_support() {
    print_header "🔄 Checking RTL Support"
    
    print_message "$BLUE" "Checking RTL (Right-to-Left) support..."
    
    local issues_found=0
    
    # Check for Directionality widgets
    local directionality_widgets=$(grep -r "Directionality\|TextDirection" lib/ --include="*.dart" | wc -l)
    
    if [ $directionality_widgets -gt 0 ]; then
        print_message "$GREEN" "✅ Found $directionality_widgets directionality-related widgets"
    else
        print_message "$YELLOW" "⚠️  No explicit RTL support found"
        print_message "$YELLOW" "💡 Add Directionality widgets for Arabic support"
        ((issues_found++))
    fi
    
    # Check for hardcoded left/right instead of start/end
    local hardcoded_directions=$(grep -r "EdgeInsets.only(left:\|EdgeInsets.only(right:" lib/ --include="*.dart" | \
        grep -v "// " | \
        wc -l)
    
    if [ $hardcoded_directions -gt 0 ]; then
        print_message "$YELLOW" "⚠️  Found $hardcoded_directions hardcoded left/right paddings"
        print_message "$YELLOW" "💡 Use start/end instead of left/right for RTL support"
        ((issues_found++))
    else
        print_message "$GREEN" "✅ No hardcoded left/right paddings found"
    fi
    
    return $issues_found
}

# Run accessibility tests
run_accessibility_tests() {
    print_header "🧪 Running Accessibility Tests"
    
    print_message "$BLUE" "Running Flutter accessibility tests..."
    
    # Run tests with semantics debugging
    if flutter test --dart-define=SEMANTICS_DEBUG=true; then
        print_message "$GREEN" "✅ Accessibility tests passed"
        return 0
    else
        print_message "$YELLOW" "⚠️  Some accessibility tests failed"
        return 1
    fi
}

# Generate accessibility report
generate_report() {
    print_header "📊 Accessibility Report"
    
    {
        echo "Accessibility Testing Report"
        echo "============================"
        echo ""
        echo "Date: $(date)"
        echo "Flutter Version: $(flutter --version | head -n 1)"
        echo ""
        echo "Accessibility Standards:"
        echo "-----------------------"
        echo "- WCAG 2.1 Level AA"
        echo "- Material Design Guidelines"
        echo "- iOS Human Interface Guidelines"
        echo ""
        echo "Test Results:"
        echo "------------"
        echo "See detailed results above"
        echo ""
        echo "Common Issues Found:"
        echo "-------------------"
        echo "1. Missing semantic labels"
        echo "2. Low contrast ratios"
        echo "3. Small text sizes"
        echo "4. Small touch targets"
        echo "5. Limited keyboard navigation"
        echo "6. Insufficient screen reader support"
        echo "7. Missing RTL support"
        echo ""
        echo "Recommendations:"
        echo "---------------"
        echo ""
        echo "1. Semantic Labels:"
        echo "   - Add semanticLabel to all Image widgets"
        echo "   - Add tooltip to all IconButton widgets"
        echo "   - Use Semantics widget for custom widgets"
        echo ""
        echo "2. Contrast Ratios:"
        echo "   - Minimum: 4.5:1 (WCAG AA)"
        echo "   - Recommended: 7:1 (WCAG AAA)"
        echo "   - Test with Chrome DevTools"
        echo ""
        echo "3. Text Sizes:"
        echo "   - Minimum: ${MIN_TEXT_SIZE}sp"
        echo "   - Support text scaling"
        echo "   - Test with large text settings"
        echo ""
        echo "4. Touch Targets:"
        echo "   - Minimum: ${MIN_TOUCH_TARGET_SIZE}dp x ${MIN_TOUCH_TARGET_SIZE}dp"
        echo "   - Add padding if needed"
        echo "   - Test on real devices"
        echo ""
        echo "5. Keyboard Navigation:"
        echo "   - Add FocusNode to interactive widgets"
        echo "   - Support Tab navigation"
        echo "   - Test with keyboard only"
        echo ""
        echo "6. Screen Readers:"
        echo "   - Test with TalkBack (Android)"
        echo "   - Test with VoiceOver (iOS)"
        echo "   - Use Semantics widgets"
        echo ""
        echo "7. RTL Support:"
        echo "   - Use Directionality widget"
        echo "   - Use start/end instead of left/right"
        echo "   - Test in Arabic locale"
        echo ""
        echo "Testing Tools:"
        echo "-------------"
        echo "- Flutter DevTools (Accessibility Inspector)"
        echo "- Chrome DevTools (Contrast Checker)"
        echo "- TalkBack (Android)"
        echo "- VoiceOver (iOS)"
        echo "- Accessibility Scanner (Android)"
        echo ""
        echo "Principles Applied:"
        echo "------------------"
        echo "- ✅ COLLABORATION FIRST: Clear accessibility guidelines"
        echo "- ✅ KISS: Simple accessibility checks"
        echo "- ✅ Security First: No sensitive data in tests"
        echo "- ✅ Quality First: Comprehensive accessibility testing"
        echo "- ✅ ENGLISH FOR CODE: All tests in English"
        echo ""
        echo "Next Steps:"
        echo "----------"
        echo "1. Review all warnings and issues"
        echo "2. Fix critical accessibility problems"
        echo "3. Test with real assistive technologies"
        echo "4. Re-run tests to verify fixes"
        echo "5. Include accessibility in code reviews"
    } > "$REPORT_FILE"
    
    cat "$REPORT_FILE"
    print_message "$GREEN" "✅ Report saved to: $REPORT_FILE"
}

# Main execution
main() {
    print_header "♿ Enhanced Accessibility Testing v2.0"
    
    print_message "$BLUE" "Starting accessibility testing..."
    echo ""
    
    # Execute test steps
    pre_test_checks
    
    # Run accessibility checks
    local total_issues=0
    
    check_semantic_labels || ((total_issues+=$?))
    check_contrast_ratios || ((total_issues++))
    check_text_sizes || ((total_issues+=$?))
    check_touch_targets || ((total_issues++))
    check_keyboard_navigation || ((total_issues++))
    check_screen_reader_support || ((total_issues++))
    check_rtl_support || ((total_issues+=$?))
    run_accessibility_tests || ((total_issues++))
    
    generate_report
    
    if [ $total_issues -eq 0 ]; then
        print_header "✅ Accessibility Testing Completed Successfully!"
        print_message "$GREEN" "🎉 No accessibility issues found!"
    else
        print_header "⚠️  Accessibility Testing Completed with Issues"
        print_message "$YELLOW" "⚠️  Found accessibility issues that need attention"
        print_message "$YELLOW" "💡 Review the report and fix issues"
    fi
    
    print_message "$BLUE" "📁 Report location: $REPORT_FILE"
    print_message "$BLUE" "💡 Test with real assistive technologies for best results"
}

# Run main function
main "$@"
