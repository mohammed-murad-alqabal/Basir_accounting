#!/bin/bash

# Comprehensive Documentation Reorganization Check
# Phase 14: Final verification script

echo "🔍 Starting comprehensive documentation reorganization check..."
echo "=================================================="

# Initialize counters
total_issues=0
critical_issues=0

# Function to report issue
report_issue() {
    local severity=$1
    local message=$2
    echo "[$severity] $message"
    total_issues=$((total_issues + 1))
    if [ "$severity" = "CRITICAL" ]; then
        critical_issues=$((critical_issues + 1))
    fi
}

# Check 1: Project root should be clean of documentation files
echo "📋 Check 1: Project root cleanliness"
doc_files_in_root=$(find . -maxdepth 1 -name "*.md" -not -name "README.md" -not -name "CHANGELOG.md" -not -name "CONTRIBUTING.md" -not -name "SECURITY.md" -not -name "TESTING.md" -not -name "LICENSE" | wc -l)

if [ $doc_files_in_root -gt 0 ]; then
    report_issue "CRITICAL" "Found $doc_files_in_root documentation files in project root"
    find . -maxdepth 1 -name "*.md" -not -name "README.md" -not -name "CHANGELOG.md" -not -name "CONTRIBUTING.md" -not -name "SECURITY.md" -not -name "TESTING.md"
else
    echo "✅ Project root is clean"
fi

# Check 2: .kiro/ root should be organized
echo "📋 Check 2: .kiro/ root organization"
kiro_loose_files=$(find .kiro -maxdepth 1 -name "*.md" -not -name "README.md" | wc -l)

if [ $kiro_loose_files -gt 0 ]; then
    report_issue "WARNING" "Found $kiro_loose_files loose files in .kiro/ root"
    find .kiro -maxdepth 1 -name "*.md" -not -name "README.md"
else
    echo "✅ .kiro/ root is properly organized"
fi

# Check 3: .kiro/docs/ should have organized structure
echo "📋 Check 3: .kiro/docs/ structure"
docs_loose_files=$(find .kiro/docs -maxdepth 1 -name "*.md" -not -name "README.md" | wc -l)

if [ $docs_loose_files -gt 0 ]; then
    report_issue "WARNING" "Found $docs_loose_files loose files in .kiro/docs/ root"
    find .kiro/docs -maxdepth 1 -name "*.md" -not -name "README.md"
else
    echo "✅ .kiro/docs/ is properly organized"
fi

# Check 4: Documentation/ structure
echo "📋 Check 4: Documentation/ structure verification"
if [ ! -d "Documentation" ]; then
    report_issue "CRITICAL" "Documentation/ directory missing"
else
    echo "✅ Documentation/ directory exists"
    
    # Check for required files
    required_files=("README.md" "INDEX.md" "QUICK_START.md")
    for file in "${required_files[@]}"; do
        if [ ! -f "Documentation/$file" ]; then
            report_issue "CRITICAL" "Missing required file: Documentation/$file"
        else
            echo "✅ Found Documentation/$file"
        fi
    done
    
    # Check for required directories
    required_dirs=("Core" "guides" "reports" "sessions")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "Documentation/$dir" ]; then
            report_issue "CRITICAL" "Missing required directory: Documentation/$dir"
        else
            echo "✅ Found Documentation/$dir/"
        fi
    done
fi

# Check 5: Link validation (basic)
echo "📋 Check 5: Basic link validation"
broken_links=0

# Check for common broken link patterns
if grep -r "\.kiro/docs/[A-Z_]*\.md" --include="*.md" . | grep -v "\.kiro/docs/reports/" | grep -v "\.kiro/docs/plans/" | grep -v "\.kiro/docs/analysis/" | grep -v "\.kiro/docs/standards/" | grep -v "\.kiro/docs/workspace/" | grep -v "\.kiro/docs/reorganization/" > /dev/null; then
    report_issue "WARNING" "Found potential broken links to moved files"
    broken_links=$((broken_links + 1))
fi

if [ $broken_links -eq 0 ]; then
    echo "✅ No obvious broken links detected"
fi

# Check 6: File count verification
echo "📋 Check 6: File count verification"
total_md_files=$(find . -name "*.md" | wc -l)
echo "📊 Total .md files in project: $total_md_files"

documentation_files=$(find Documentation -name "*.md" | wc -l)
echo "📊 Files in Documentation/: $documentation_files"

kiro_files=$(find .kiro -name "*.md" | wc -l)
echo "📊 Files in .kiro/: $kiro_files"

# Final report
echo "=================================================="
echo "🎯 COMPREHENSIVE CHECK RESULTS"
echo "=================================================="

if [ $critical_issues -eq 0 ]; then
    if [ $total_issues -eq 0 ]; then
        echo "🎉 PERFECT! No issues found"
        echo "✅ Documentation reorganization is 100% complete"
        echo "🏆 Grade: A+"
        exit 0
    else
        echo "⚠️  Minor issues found: $total_issues"
        echo "✅ No critical issues - reorganization successful"
        echo "🏆 Grade: A"
        exit 0
    fi
else
    echo "❌ Critical issues found: $critical_issues"
    echo "⚠️  Total issues: $total_issues"
    echo "🔧 Grade: B - Needs fixes"
    exit 1
fi