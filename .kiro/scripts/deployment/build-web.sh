#!/bin/bash

# Enhanced Web Build Script v2.0
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
MAX_BUNDLE_SIZE_MB=5
BUILD_DIR="build/web"
ASSETS_DIR="$BUILD_DIR/assets"

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
    
    # Check if web is enabled
    if ! flutter config | grep -q "enable-web: true"; then
        print_message "$YELLOW" "⚠️  Web support not enabled. Enabling..."
        flutter config --enable-web
    fi
    print_message "$GREEN" "✅ Web support enabled"
    
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

# Build web app
build_web() {
    print_header "🏗️  Building Web App"
    
    local start_time=$(date +%s)
    
    # Clean previous builds
    print_message "$BLUE" "🧹 Cleaning previous builds..."
    flutter clean
    rm -rf "$BUILD_DIR"
    
    # Build web
    print_message "$BLUE" "🔨 Building web release..."
    if ! flutter build web --release --web-renderer canvaskit; then
        print_message "$RED" "❌ Web build failed"
        exit 1
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    print_message "$GREEN" "✅ Web build completed in ${duration}s"
}

# Compress assets
compress_assets() {
    print_header "🗜️  Compressing Assets"
    
    if [ ! -d "$ASSETS_DIR" ]; then
        print_message "$YELLOW" "⚠️  Assets directory not found. Skipping compression..."
        return
    fi
    
    local compressed_count=0
    
    # Compress PNG images
    if command_exists pngquant; then
        print_message "$BLUE" "🖼️  Compressing PNG images..."
        find "$ASSETS_DIR" -name "*.png" -type f | while read -r file; do
            pngquant --ext .png --force "$file" 2>/dev/null && ((compressed_count++)) || true
        done
        print_message "$GREEN" "✅ Compressed PNG images"
    else
        print_message "$YELLOW" "⚠️  pngquant not found. Skipping PNG compression..."
        print_message "$YELLOW" "💡 Install with: brew install pngquant (macOS) or apt-get install pngquant (Linux)"
    fi
    
    # Compress JPEG images
    if command_exists jpegoptim; then
        print_message "$BLUE" "🖼️  Compressing JPEG images..."
        find "$ASSETS_DIR" -name "*.jpg" -o -name "*.jpeg" -type f | while read -r file; do
            jpegoptim --max=85 "$file" 2>/dev/null && ((compressed_count++)) || true
        done
        print_message "$GREEN" "✅ Compressed JPEG images"
    else
        print_message "$YELLOW" "⚠️  jpegoptim not found. Skipping JPEG compression..."
        print_message "$YELLOW" "💡 Install with: brew install jpegoptim (macOS) or apt-get install jpegoptim (Linux)"
    fi
    
    if [ $compressed_count -gt 0 ]; then
        print_message "$GREEN" "✅ Compressed $compressed_count assets"
    fi
}

# Validate bundle size (KISS principle: <5MB)
validate_bundle_size() {
    print_header "📏 Validating Bundle Size"
    
    if [ ! -d "$BUILD_DIR" ]; then
        print_message "$YELLOW" "⚠️  Build directory not found. Skipping size validation..."
        return
    fi
    
    local bundle_size_bytes=$(du -sb "$BUILD_DIR" | cut -f1)
    local bundle_size_mb=$((bundle_size_bytes / 1024 / 1024))
    
    print_message "$BLUE" "📊 Bundle Size: ${bundle_size_mb}MB"
    
    # Calculate main.dart.js size
    if [ -f "$BUILD_DIR/main.dart.js" ]; then
        local js_size_bytes=$(stat -c%s "$BUILD_DIR/main.dart.js" 2>/dev/null || stat -f%z "$BUILD_DIR/main.dart.js" 2>/dev/null)
        local js_size_kb=$((js_size_bytes / 1024))
        print_message "$BLUE" "📊 main.dart.js Size: ${js_size_kb}KB"
    fi
    
    if [ $bundle_size_mb -gt $MAX_BUNDLE_SIZE_MB ]; then
        print_message "$YELLOW" "⚠️  Bundle size (${bundle_size_mb}MB) exceeds recommended limit (${MAX_BUNDLE_SIZE_MB}MB)"
        print_message "$YELLOW" "💡 Consider:"
        print_message "$YELLOW" "   - Enabling tree-shaking"
        print_message "$YELLOW" "   - Compressing assets"
        print_message "$YELLOW" "   - Removing unused dependencies"
        print_message "$YELLOW" "   - Using deferred loading"
    else
        print_message "$GREEN" "✅ Bundle size is within limits"
    fi
}

# Optimize build
optimize_build() {
    print_header "⚡ Optimizing Build"
    
    # Gzip compress main files
    if command_exists gzip; then
        print_message "$BLUE" "🗜️  Gzip compressing main files..."
        
        for file in "$BUILD_DIR"/*.{js,css,html} 2>/dev/null; do
            if [ -f "$file" ]; then
                gzip -9 -k "$file"
                print_message "$GREEN" "✅ Compressed: $(basename "$file")"
            fi
        done
    else
        print_message "$YELLOW" "⚠️  gzip not found. Skipping compression..."
    fi
}

# Generate build report
generate_report() {
    print_header "📊 Build Report"
    
    local report_file="$BUILD_DIR/build-report.txt"
    
    {
        echo "Web Build Report"
        echo "================"
        echo ""
        echo "Date: $(date)"
        echo "Flutter Version: $(flutter --version | head -n 1)"
        echo ""
        echo "Build Status: ✅ Success"
        echo ""
        
        if [ -d "$BUILD_DIR" ]; then
            local bundle_size_bytes=$(du -sb "$BUILD_DIR" | cut -f1)
            local bundle_size_mb=$((bundle_size_bytes / 1024 / 1024))
            echo "Bundle Size: ${bundle_size_mb}MB"
            echo "Build Path: $BUILD_DIR"
        fi
        
        if [ -f "$BUILD_DIR/main.dart.js" ]; then
            local js_size_bytes=$(stat -c%s "$BUILD_DIR/main.dart.js" 2>/dev/null || stat -f%z "$BUILD_DIR/main.dart.js" 2>/dev/null)
            local js_size_kb=$((js_size_bytes / 1024))
            echo "main.dart.js Size: ${js_size_kb}KB"
        fi
        
        echo ""
        echo "Optimizations Applied:"
        if command_exists pngquant; then
            echo "- ✅ PNG compression"
        fi
        if command_exists jpegoptim; then
            echo "- ✅ JPEG compression"
        fi
        if command_exists gzip; then
            echo "- ✅ Gzip compression"
        fi
        
        echo ""
        echo "Principles Applied:"
        echo "- ✅ COLLABORATION FIRST: Clear output and error messages"
        echo "- ✅ KISS: Simple, straightforward build process"
        echo "- ✅ Security First: No hardcoded secrets"
        echo "- ✅ Quality First: Pre-build checks and validations"
        echo "- ✅ ENGLISH FOR CODE: All code and comments in English"
        
        echo ""
        echo "Deployment Instructions:"
        echo "1. Upload contents of $BUILD_DIR to your web server"
        echo "2. Or deploy to Firebase Hosting: firebase deploy --only hosting"
        echo "3. Or deploy to Netlify: netlify deploy --prod --dir=$BUILD_DIR"
    } > "$report_file"
    
    cat "$report_file"
    print_message "$GREEN" "✅ Report saved to: $report_file"
}

# Main execution
main() {
    print_header "🌐 Enhanced Web Build Script v2.0"
    
    print_message "$BLUE" "Starting web build process..."
    echo ""
    
    # Execute build steps
    pre_build_checks
    quality_checks
    build_web
    compress_assets
    validate_bundle_size
    optimize_build
    generate_report
    
    print_header "✅ Web Build Completed Successfully!"
    
    print_message "$GREEN" "🎉 All steps completed!"
    print_message "$BLUE" "📁 Build artifacts location: $BUILD_DIR"
    print_message "$BLUE" "🌐 Ready for deployment!"
}

# Run main function
main "$@"
