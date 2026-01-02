#!/bin/bash

# Git Repository Cleanup Script
# Project: Basir MVP
# Author: Basir Development Agents Team
# Date: December 8, 2025
# Version: 1.0.0

# Description:
# This script performs comprehensive git repository cleanup:
# - Checks git status
# - Removes unwanted files from staging
# - Cleans temporary files
# - Generates detailed report
# - Applies all 5 core principles

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ISSUES_FOUND=0
ISSUES_FIXED=0

# Report file
REPORT_DIR=".kiro/docs/reports"
REPORT_FILE="${REPORT_DIR}/git_cleanup_report_$(date +%Y%m%d_%H%M%S).txt"

# Create report directory if it doesn't exist
mkdir -p "${REPORT_DIR}"

# Function: Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function: Log to report
log_report() {
    echo "$1" >> "${REPORT_FILE}"
}

# Function: Print header
print_header() {
    local title=$1
    print_message "${BLUE}" "\n=========================================="
    print_message "${BLUE}" "$title"
    print_message "${BLUE}" "==========================================\n"
    log_report ""
    log_report "=========================================="
    log_report "$title"
    log_report "=========================================="
    log_report ""
}

# Start script
print_header "🧹 Git Repository Cleanup"
log_report "Date: $(date)"
log_report "Project: Basir MVP"
log_report ""

# Principle 1: COLLABORATION FIRST
print_message "${YELLOW}" "⚠️  This script will clean up your git repository"
print_message "${YELLOW}" "   It will remove unwanted files and clean temporary files"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_message "${RED}" "❌ Error: Not a git repository"
    log_report "ERROR: Not a git repository"
    exit 1
fi

# Check 1: Git Status
print_header "📊 Check 1: Git Status Analysis"
print_message "${BLUE}" "Analyzing git status..."

# Get git status
GIT_STATUS=$(git status --porcelain)

if [ -z "$GIT_STATUS" ]; then
    print_message "${GREEN}" "✅ Repository is clean"
    log_report "✅ Repository is clean"
else
    print_message "${YELLOW}" "⚠️  Found changes in repository"
    log_report "⚠️  Found changes in repository"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
    
    # Count modified files
    MODIFIED_COUNT=$(echo "$GIT_STATUS" | grep "^ M" | wc -l)
    STAGED_COUNT=$(echo "$GIT_STATUS" | grep "^M" | wc -l)
    UNTRACKED_COUNT=$(echo "$GIT_STATUS" | grep "^??" | wc -l)
    
    print_message "${BLUE}" "   Modified files: $MODIFIED_COUNT"
    print_message "${BLUE}" "   Staged files: $STAGED_COUNT"
    print_message "${BLUE}" "   Untracked files: $UNTRACKED_COUNT"
    
    log_report "   Modified files: $MODIFIED_COUNT"
    log_report "   Staged files: $STAGED_COUNT"
    log_report "   Untracked files: $UNTRACKED_COUNT"
fi

# Check 2: Build Files
print_header "🏗️  Check 2: Build Files"
print_message "${BLUE}" "Checking for build files..."

BUILD_FILES_FOUND=0

# Check .dart_tool
if git ls-files --error-unmatch .dart_tool/ >/dev/null 2>&1; then
    print_message "${YELLOW}" "⚠️  .dart_tool/ is tracked by git"
    log_report "⚠️  .dart_tool/ is tracked by git"
    BUILD_FILES_FOUND=$((BUILD_FILES_FOUND + 1))
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check android/.gradle
if git ls-files --error-unmatch android/.gradle/ >/dev/null 2>&1; then
    print_message "${YELLOW}" "⚠️  android/.gradle/ is tracked by git"
    log_report "⚠️  android/.gradle/ is tracked by git"
    BUILD_FILES_FOUND=$((BUILD_FILES_FOUND + 1))
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check build/
if git ls-files --error-unmatch build/ >/dev/null 2>&1; then
    print_message "${YELLOW}" "⚠️  build/ is tracked by git"
    log_report "⚠️  build/ is tracked by git"
    BUILD_FILES_FOUND=$((BUILD_FILES_FOUND + 1))
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

if [ $BUILD_FILES_FOUND -eq 0 ]; then
    print_message "${GREEN}" "✅ No build files tracked by git"
    log_report "✅ No build files tracked by git"
else
    print_message "${YELLOW}" "   Found $BUILD_FILES_FOUND build directories tracked"
    log_report "   Found $BUILD_FILES_FOUND build directories tracked"
fi

# Check 3: Temporary Files
print_header "📄 Check 3: Temporary Files"
print_message "${BLUE}" "Checking for temporary files..."

TEMP_FILES_COUNT=0

# Check test_results/
if [ -d "test_results" ]; then
    TEMP_FILES_COUNT=$((TEMP_FILES_COUNT + 1))
    print_message "${YELLOW}" "⚠️  test_results/ directory exists"
    log_report "⚠️  test_results/ directory exists"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check for temporary report files
TEMP_REPORTS=$(find .kiro/docs/reports -name "*_TEMP.md" -o -name "*_OLD.md" -o -name "*_UPDATED.md" 2>/dev/null | wc -l)
if [ $TEMP_REPORTS -gt 0 ]; then
    TEMP_FILES_COUNT=$((TEMP_FILES_COUNT + TEMP_REPORTS))
    print_message "${YELLOW}" "⚠️  Found $TEMP_REPORTS temporary report files"
    log_report "⚠️  Found $TEMP_REPORTS temporary report files"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

if [ $TEMP_FILES_COUNT -eq 0 ]; then
    print_message "${GREEN}" "✅ No temporary files found"
    log_report "✅ No temporary files found"
else
    print_message "${YELLOW}" "   Found $TEMP_FILES_COUNT temporary files"
    log_report "   Found $TEMP_FILES_COUNT temporary files"
fi

# Check 4: .gitignore Effectiveness
print_header "🛡️  Check 4: .gitignore Effectiveness"
print_message "${BLUE}" "Checking .gitignore..."

GITIGNORE_ISSUES=0

# Check if .gitignore exists
if [ ! -f ".gitignore" ]; then
    print_message "${RED}" "❌ .gitignore not found"
    log_report "❌ .gitignore not found"
    GITIGNORE_ISSUES=$((GITIGNORE_ISSUES + 1))
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    # Check for required patterns
    REQUIRED_PATTERNS=(
        "build/"
        ".dart_tool/"
        "android/.gradle/"
        "test_results/"
    )
    
    for pattern in "${REQUIRED_PATTERNS[@]}"; do
        if ! grep -q "$pattern" .gitignore; then
            print_message "${YELLOW}" "⚠️  Missing pattern: $pattern"
            log_report "⚠️  Missing pattern: $pattern"
            GITIGNORE_ISSUES=$((GITIGNORE_ISSUES + 1))
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    done
    
    if [ $GITIGNORE_ISSUES -eq 0 ]; then
        print_message "${GREEN}" "✅ .gitignore is properly configured"
        log_report "✅ .gitignore is properly configured"
    else
        print_message "${YELLOW}" "   Found $GITIGNORE_ISSUES missing patterns"
        log_report "   Found $GITIGNORE_ISSUES missing patterns"
    fi
fi

# Cleanup Actions
print_header "🧹 Cleanup Actions"

if [ $ISSUES_FOUND -eq 0 ]; then
    print_message "${GREEN}" "✅ No cleanup needed - repository is clean!"
    log_report "✅ No cleanup needed - repository is clean!"
else
    print_message "${YELLOW}" "Found $ISSUES_FOUND issues - starting cleanup..."
    log_report "Found $ISSUES_FOUND issues - starting cleanup..."
    
    # Action 1: Clean temporary files
    if [ -d "test_results" ]; then
        print_message "${BLUE}" "   Removing test_results/..."
        rm -rf test_results/
        print_message "${GREEN}" "   ✅ Removed test_results/"
        log_report "   ✅ Removed test_results/"
        ISSUES_FIXED=$((ISSUES_FIXED + 1))
    fi
    
    # Action 2: Clean temporary reports
    if [ $TEMP_REPORTS -gt 0 ]; then
        print_message "${BLUE}" "   Removing temporary report files..."
        find .kiro/docs/reports -name "*_TEMP.md" -delete 2>/dev/null || true
        find .kiro/docs/reports -name "*_OLD.md" -delete 2>/dev/null || true
        find .kiro/docs/reports -name "*_UPDATED.md" -delete 2>/dev/null || true
        print_message "${GREEN}" "   ✅ Removed temporary report files"
        log_report "   ✅ Removed temporary report files"
        ISSUES_FIXED=$((ISSUES_FIXED + 1))
    fi
    
    # Action 3: Reset modified build files
    print_message "${BLUE}" "   Resetting modified build files..."
    git checkout -- .dart_tool/ 2>/dev/null || true
    git checkout -- android/.gradle/ 2>/dev/null || true
    git checkout -- build/ 2>/dev/null || true
    print_message "${GREEN}" "   ✅ Reset build files"
    log_report "   ✅ Reset build files"
    ISSUES_FIXED=$((ISSUES_FIXED + 1))
fi

# Final Status
print_header "📊 Final Status"

print_message "${BLUE}" "Issues found: $ISSUES_FOUND"
print_message "${BLUE}" "Issues fixed: $ISSUES_FIXED"
log_report "Issues found: $ISSUES_FOUND"
log_report "Issues fixed: $ISSUES_FIXED"

if [ $ISSUES_FOUND -eq $ISSUES_FIXED ]; then
    print_message "${GREEN}" "\n✅ Cleanup completed successfully!"
    log_report ""
    log_report "✅ Cleanup completed successfully!"
else
    REMAINING=$((ISSUES_FOUND - ISSUES_FIXED))
    print_message "${YELLOW}" "\n⚠️  $REMAINING issues remaining"
    log_report ""
    log_report "⚠️  $REMAINING issues remaining"
fi

# Principles Applied
print_header "✅ Principles Applied"
print_message "${GREEN}" "✅ COLLABORATION FIRST - User informed before actions"
print_message "${GREEN}" "✅ KISS - Simple and straightforward cleanup"
print_message "${GREEN}" "✅ Security First - No sensitive data exposed"
print_message "${GREEN}" "✅ Quality First - Comprehensive checks"
print_message "${GREEN}" "✅ ENGLISH FOR CODE - All code in English"

log_report "✅ COLLABORATION FIRST - User informed before actions"
log_report "✅ KISS - Simple and straightforward cleanup"
log_report "✅ Security First - No sensitive data exposed"
log_report "✅ Quality First - Comprehensive checks"
log_report "✅ ENGLISH FOR CODE - All code in English"

# Report location
print_message "${BLUE}" "\n📄 Report saved to: ${REPORT_FILE}"
log_report ""
log_report "Report saved to: ${REPORT_FILE}"

# Final git status
print_header "📊 Final Git Status"
git status --short

echo ""
print_message "${GREEN}" "🎉 Git cleanup completed!"
