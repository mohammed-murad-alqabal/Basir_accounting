#!/bin/bash

# Enhanced iOS Build Script v2.0
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
MAX_IPA_SIZE_MB=50
BUILD_DIR="build/ios"
ARCHIVE_PATH="$BUILD_DIR/Runner.xcarchive"
IPA_PATH="$BUILD_DIR/Runner.ipa"

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

# Pre-build checks
pre_build_checks() {
    print_header "🔍 Pre-Build Checks"
    
    # Check Flutter
    if ! command_exists flutter; then
        print_message "$RED" "❌ Flutter not found. Please install Flutter SDK."
        exit 1
    fi
    print_message "$GREEN" "✅ Flutter found: $(flutter --version | head -n 1)"
    
    # Check Xcode (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists xcodebuild; then
            print_message "$RED" "❌ Xcode not found. Please install Xcode."
            exit 1
        fi
        print_message "$GREEN" "✅ Xcode found: $(xcodebuild -version | head -n 1)"
    else
        print_message "$YELLOW" "⚠️  Not running on macOS. iOS build requires macOS."
        exit 1
    fi
    
    # Check if ios directory exists
    if [ ! -d "ios" ]; then
        print_message "$RED" "❌ ios directory not found. Are you in the project root?"
        exit 1
    fi
    print_message "$GREEN" "✅ iOS directory found"
    
    # Check dependencies
    print_message "$BLUE" "📦 Checking dependencies..."
    flutter pub get
    print_message "$GREEN" "✅ Dependencies installed"
}

# Run quality checks
quality_checks() {
    print_header "🔍 Quality Checks"
    
    # Format check
    print_message "$BLUE" "📝 Checking code formatting..."
    if ! dart format --set-exit-if-changed . >/dev/null 2>&1; then
        print_message "$YELLOW" "⚠️  Code formatting issues found. Running formatter..."
        dart format .
    fi
    print_message "$GREEN" "✅ Code formatting OK"
    
    # Analysis
    print_message "$BLUE" "🔍 Running static analysis..."
    if ! flutter analyze --no-fatal-infos; then
        print_message "$RED" "❌ Static analysis failed"
        exit 1
    fi
    print_message "$GREEN" "✅ Static analysis passed"
    
    # Tests
    print_message "$BLUE" "🧪 Running tests..."
    if ! flutter test; then
        print_message "$RED" "❌ Tests failed"
        exit 1
    fi
    print_message "$GREEN" "✅ All tests passed"
}

# Build iOS app
build_ios() {
    print_header "🏗️  Building iOS App"
    
    local start_time=$(date +%s)
    
    # Clean previous builds
    print_message "$BLUE" "🧹 Cleaning previous builds..."
    flutter clean
    rm -rf "$BUILD_DIR"
    
    # Build iOS
    print_message "$BLUE" "🔨 Building iOS release..."
    if ! flutter build ios --release --no-codesign; then
        print_message "$RED" "❌ iOS build failed"
        exit 1
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    print_message "$GREEN" "✅ iOS build completed in ${duration}s"
}

# Create archive (requires macOS and Xcode)
create_archive() {
    print_header "📦 Creating Archive"
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_message "$YELLOW" "⚠️  Archive creation requires macOS. Skipping..."
        return
    fi
    
    print_message "$BLUE" "📦 Creating Xcode archive..."
    
    cd ios
    xcodebuild -workspace Runner.xcworkspace \
        -scheme Runner \
        -configuration Release \
        -archivePath "../$ARCHIVE_PATH" \
        archive
    cd ..
    
    print_message "$GREEN" "✅ Archive created"
}

# Export IPA (requires macOS and Xcode)
export_ipa() {
    print_header "📤 Exporting IPA"
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_message "$YELLOW" "⚠️  IPA export requires macOS. Skipping..."
        return
    fi
    
    if [ ! -d "$ARCHIVE_PATH" ]; then
        print_message "$YELLOW" "⚠️  Archive not found. Skipping IPA export..."
        return
    fi
    
    print_message "$BLUE" "📤 Exporting IPA..."
    
    # Create ExportOptions.plist if it doesn't exist
    if [ ! -f "ios/ExportOptions.plist" ]; then
        print_message "$YELLOW" "⚠️  ExportOptions.plist not found. Creating default..."
        cat > ios/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
EOF
    fi
    
    cd ios
    xcodebuild -exportArchive \
        -archivePath "../$ARCHIVE_PATH" \
        -exportPath "../$BUILD_DIR" \
        -exportOptionsPlist ExportOptions.plist
    cd ..
    
    print_message "$GREEN" "✅ IPA exported"
}

# Validate IPA size (KISS principle: <50MB)
validate_ipa_size() {
    print_header "📏 Validating IPA Size"
    
    if [ ! -f "$IPA_PATH" ]; then
        print_message "$YELLOW" "⚠️  IPA file not found. Skipping size validation..."
        return
    fi
    
    local ipa_size_bytes=$(stat -f%z "$IPA_PATH" 2>/dev/null || stat -c%s "$IPA_PATH" 2>/dev/null)
    local ipa_size_mb=$((ipa_size_bytes / 1024 / 1024))
    
    print_message "$BLUE" "📊 IPA Size: ${ipa_size_mb}MB"
    
    if [ $ipa_size_mb -gt $MAX_IPA_SIZE_MB ]; then
        print_message "$YELLOW" "⚠️  IPA size (${ipa_size_mb}MB) exceeds recommended limit (${MAX_IPA_SIZE_MB}MB)"
        print_message "$YELLOW" "💡 Consider optimizing assets and removing unused dependencies"
    else
        print_message "$GREEN" "✅ IPA size is within limits"
    fi
}

# Generate build report
generate_report() {
    print_header "📊 Build Report"
    
    local report_file="$BUILD_DIR/build-report.txt"
    mkdir -p "$BUILD_DIR"
    
    {
        echo "iOS Build Report"
        echo "================"
        echo ""
        echo "Date: $(date)"
        echo "Flutter Version: $(flutter --version | head -n 1)"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "Xcode Version: $(xcodebuild -version | head -n 1)"
        fi
        echo ""
        echo "Build Status: ✅ Success"
        echo ""
        if [ -f "$IPA_PATH" ]; then
            local ipa_size_bytes=$(stat -f%z "$IPA_PATH" 2>/dev/null || stat -c%s "$IPA_PATH" 2>/dev/null)
            local ipa_size_mb=$((ipa_size_bytes / 1024 / 1024))
            echo "IPA Size: ${ipa_size_mb}MB"
            echo "IPA Path: $IPA_PATH"
        fi
        echo ""
        echo "Principles Applied:"
        echo "- ✅ COLLABORATION FIRST: Clear output and error messages"
        echo "- ✅ KISS: Simple, straightforward build process"
        echo "- ✅ Security First: No hardcoded secrets"
        echo "- ✅ Quality First: Pre-build checks and validations"
        echo "- ✅ ENGLISH FOR CODE: All code and comments in English"
    } > "$report_file"
    
    cat "$report_file"
    print_message "$GREEN" "✅ Report saved to: $report_file"
}

# Main execution
main() {
    print_header "🍎 Enhanced iOS Build Script v2.0"
    
    print_message "$BLUE" "Starting iOS build process..."
    echo ""
    
    # Execute build steps
    pre_build_checks
    quality_checks
    build_ios
    create_archive
    export_ipa
    validate_ipa_size
    generate_report
    
    print_header "✅ iOS Build Completed Successfully!"
    
    print_message "$GREEN" "🎉 All steps completed!"
    print_message "$BLUE" "📁 Build artifacts location: $BUILD_DIR"
    
    if [ -f "$IPA_PATH" ]; then
        print_message "$BLUE" "📦 IPA file: $IPA_PATH"
    fi
}

# Run main function
main "$@"
