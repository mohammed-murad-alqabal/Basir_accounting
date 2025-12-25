#!/bin/bash

# Mastery CLI - Basser Institutional Tool
# Created: 2025-12-25
# Purpose: High-precision engineering checks and project management.

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
GOLD='\033[0;33m'
NC='\033[0m' # No Color

function show_help() {
    echo -e "${GOLD}Basser Mastery CLI v1.0.0${NC}"
    echo "Usage: ./scripts/mastery.sh [command]"
    echo ""
    echo "Commands:"
    echo "  check      Run analyze, test, and format (Institutional Audit)"
    echo "  build      Generate production-ready optimized build"
    echo "  info       Display project engineering metrics"
    echo "  help       Show this help message"
}

function run_check() {
    echo -e "${BLUE}Starting Mastery Institutional Audit...${NC}"
    
    echo -e "1. Running Dart Format..."
    dart format .
    
    echo -e "2. Running Flutter Analyze..."
    flutter analyze
    if [ $? -ne 0 ]; then
        echo -e "${RED}Audit Failed: Static analysis errors found.${NC}"
        exit 1
    fi
    
    echo -e "3. Running Flutter Tests..."
    flutter test
    if [ $? -ne 0 ]; then
        echo -e "${RED}Audit Failed: Unit/Widget tests failed.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Audit Passed: Mastery level achieved! 🏆${NC}"
}

function run_info() {
    echo -e "${GOLD}Basser Mastery Project Metrics${NC}"
    echo "--------------------------------"
    
    # Count Lines of Code (Dart)
    LOC=$(find lib -name "*.dart" | xargs wc -l | tail -n 1 | awk '{print $1}')
    echo "Lines of Code (Dart): $LOC"
    
    # Count Tests
    TESTS=$(find test -name "*_test.dart" | wc -l)
    echo "Test Files: $TESTS"
    
    # Dependencies count
    DEPS=$(grep -c "^  [a-z]" pubspec.yaml)
    echo "External Dependencies: $DEPS"
    
    # Bundle Size Estimation (if build exists)
    if [ -d "build/app/outputs/flutter-apk" ]; then
        SIZE=$(du -sh build/app/outputs/flutter-apk | awk '{print $1}')
        echo "Last Build Size (APK): $SIZE"
    fi
    
    echo "--------------------------------"
}

case "$1" in
    check)
        run_check
        ;;
    info)
        run_info
        ;;
    help)
        show_help
        ;;
    *)
        show_help
        ;;
esac
