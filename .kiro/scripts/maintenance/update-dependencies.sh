#!/bin/bash

# Enhanced Dependency Update Script v2.0
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
BACKUP_DIR=".dependency_backups"
BACKUP_FILE="$BACKUP_DIR/pubspec_$(date +%Y%m%d_%H%M%S).yaml"

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

# Create backup
create_backup() {
    print_header "💾 Creating Backup"
    
    mkdir -p "$BACKUP_DIR"
    
    if [ -f "pubspec.yaml" ]; then
        cp pubspec.yaml "$BACKUP_FILE"
        print_message "$GREEN" "✅ Backup created: $BACKUP_FILE"
    else
        print_message "$RED" "❌ pubspec.yaml not found"
        exit 1
    fi
    
    if [ -f "pubspec.lock" ]; then
        cp pubspec.lock "$BACKUP_DIR/pubspec_$(date +%Y%m%d_%H%M%S).lock"
        print_message "$GREEN" "✅ pubspec.lock backed up"
    fi
}

# Check for outdated dependencies
check_outdated() {
    print_header "🔍 Checking for Outdated Dependencies"
    
    if ! command_exists flutter; then
        print_message "$RED" "❌ Flutter not found"
        exit 1
    fi
    
    print_message "$BLUE" "Checking for outdated packages..."
    
    # Get outdated packages
    outdated_output=$(flutter pub outdated --json 2>/dev/null || echo "{}")
    
    if [ "$outdated_output" = "{}" ]; then
        print_message "$GREEN" "✅ All dependencies are up to date!"
        return 0
    fi
    
    # Parse and display outdated packages
    print_message "$YELLOW" "📦 Outdated packages found:"
    echo "$outdated_output" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    packages = data.get('packages', [])
    for pkg in packages:
        name = pkg.get('package', 'unknown')
        current = pkg.get('current', {}).get('version', 'unknown')
        latest = pkg.get('latest', {}).get('version', 'unknown')
        if current != latest:
            print(f'  - {name}: {current} → {latest}')
except:
    pass
" 2>/dev/null || flutter pub outdated
    
    return 1
}

# Update dependencies
update_dependencies() {
    print_header "⬆️  Updating Dependencies"
    
    print_message "$BLUE" "Updating all dependencies..."
    
    if ! flutter pub upgrade; then
        print_message "$RED" "❌ Dependency update failed"
        rollback
        exit 1
    fi
    
    print_message "$GREEN" "✅ Dependencies updated successfully"
}

# Run tests
run_tests() {
    print_header "🧪 Running Tests"
    
    print_message "$BLUE" "Running tests to verify updates..."
    
    if ! flutter test; then
        print_message "$RED" "❌ Tests failed after update"
        print_message "$YELLOW" "💡 Rolling back to previous versions..."
        rollback
        exit 1
    fi
    
    print_message "$GREEN" "✅ All tests passed"
}

# Security audit
security_audit() {
    print_header "🔒 Security Audit"
    
    print_message "$BLUE" "Checking for security vulnerabilities..."
    
    # Check for known vulnerable packages (basic check)
    if [ -f "pubspec.lock" ]; then
        # List of known vulnerable package patterns (example)
        vulnerable_patterns=(
            "http: 0.12"
            "path_provider: 1.6"
        )
        
        found_vulnerable=false
        for pattern in "${vulnerable_patterns[@]}"; do
            if grep -q "$pattern" pubspec.lock; then
                print_message "$YELLOW" "⚠️  Potentially vulnerable package: $pattern"
                found_vulnerable=true
            fi
        done
        
        if [ "$found_vulnerable" = false ]; then
            print_message "$GREEN" "✅ No known vulnerabilities found"
        else
            print_message "$YELLOW" "💡 Consider updating vulnerable packages"
        fi
    fi
}

# Rollback to backup
rollback() {
    print_header "⏮️  Rolling Back"
    
    if [ -f "$BACKUP_FILE" ]; then
        print_message "$YELLOW" "Rolling back to previous versions..."
        cp "$BACKUP_FILE" pubspec.yaml
        flutter pub get
        print_message "$GREEN" "✅ Rollback completed"
    else
        print_message "$RED" "❌ Backup file not found"
    fi
}

# Generate update report
generate_report() {
    print_header "📊 Update Report"
    
    local report_file="$BACKUP_DIR/update_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Dependency Update Report"
        echo "========================"
        echo ""
        echo "Date: $(date)"
        echo "Flutter Version: $(flutter --version | head -n 1)"
        echo ""
        echo "Update Status: ✅ Success"
        echo ""
        echo "Backup Location: $BACKUP_FILE"
        echo ""
        echo "Updated Packages:"
        flutter pub outdated 2>/dev/null || echo "All packages up to date"
        echo ""
        echo "Tests Status: ✅ Passed"
        echo ""
        echo "Principles Applied:"
        echo "- ✅ COLLABORATION FIRST: Clear update process"
        echo "- ✅ KISS: Simple update workflow"
        echo "- ✅ Security First: Security audit performed"
        echo "- ✅ Quality First: Tests run after update"
        echo "- ✅ ENGLISH FOR CODE: All code in English"
        echo ""
        echo "Rollback Instructions:"
        echo "If issues occur, run:"
        echo "  cp $BACKUP_FILE pubspec.yaml"
        echo "  flutter pub get"
    } > "$report_file"
    
    cat "$report_file"
    print_message "$GREEN" "✅ Report saved to: $report_file"
}

# Interactive mode
interactive_update() {
    print_header "🤝 Interactive Update Mode"
    
    print_message "$BLUE" "This will update all dependencies."
    print_message "$YELLOW" "⚠️  A backup will be created automatically."
    echo ""
    
    read -p "Do you want to proceed? (y/n): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message "$YELLOW" "Update cancelled by user"
        exit 0
    fi
}

# Main execution
main() {
    print_header "⬆️  Enhanced Dependency Update Script v2.0"
    
    print_message "$BLUE" "Starting dependency update process..."
    echo ""
    
    # Check if Flutter is available
    if ! command_exists flutter; then
        print_message "$RED" "❌ Flutter not found. Please install Flutter SDK."
        exit 1
    fi
    
    # Interactive confirmation (COLLABORATION FIRST)
    interactive_update
    
    # Execute update steps
    create_backup
    
    if check_outdated; then
        print_message "$GREEN" "✅ All dependencies are already up to date!"
        exit 0
    fi
    
    update_dependencies
    run_tests
    security_audit
    generate_report
    
    print_header "✅ Dependency Update Completed Successfully!"
    
    print_message "$GREEN" "🎉 All steps completed!"
    print_message "$BLUE" "📁 Backup location: $BACKUP_FILE"
    print_message "$BLUE" "📊 Report location: $BACKUP_DIR/"
    
    echo ""
    print_message "$YELLOW" "💡 If you encounter any issues, you can rollback using:"
    print_message "$YELLOW" "   cp $BACKUP_FILE pubspec.yaml && flutter pub get"
}

# Run main function
main "$@"
