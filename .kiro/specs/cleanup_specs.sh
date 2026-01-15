#!/bin/bash

# Specs Directory Cleanup Script
# Basir Accounting System Development Agents Team
# Date: January 14, 2026

set -e

echo "🧹 Starting Specs Directory Cleanup..."
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Backup current state
echo "📦 Creating backup..."
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r * "$BACKUP_DIR/" 2>/dev/null || true
print_status "Backup created at: $BACKUP_DIR"
echo ""

# Phase 1: Create archive structure
echo "📁 Phase 1: Creating archive structure..."
mkdir -p archived/2025-completed
mkdir -p archived/meta-work
mkdir -p archived/superseded
print_status "Archive directories created"
echo ""

# Phase 2: Move completed specs
echo "📦 Phase 2: Archiving completed specs..."
if [ -d "completed" ]; then
    for spec in completed/*; do
        if [ -d "$spec" ]; then
            spec_name=$(basename "$spec")
            mv "$spec" "archived/2025-completed/"
            print_status "Archived: $spec_name"
        fi
    done
fi
echo ""

# Phase 3: Archive meta-work from active
echo "🔧 Phase 3: Archiving meta-work specs..."
META_SPECS=(
    "context-optimization"
    "documentation-reorganization"
    "flutter-standards-unification"
    "repository-deep-cleanup"
    "repository-excellence-framework"
    "strategic-framework"
    "workspace-transformation"
    "mvp-reality-assessment-and-recovery"
    "git-merge-automation"
    "core-mvp-stabilization"
)

for spec in "${META_SPECS[@]}"; do
    if [ -d "active/$spec" ]; then
        mv "active/$spec" "archived/meta-work/"
        print_status "Archived meta-work: $spec"
    else
        print_warning "Not found: $spec"
    fi
done
echo ""

# Phase 4: Move completed but mislabeled as active
echo "✅ Phase 4: Moving completed specs from active..."
COMPLETED_SPECS=(
    "brand-visual-identity"
    "dashboard-test-integration"
    "git-repository-optimization-completed"
    "isar-testing-fix"
    "testing-integration"
    "widget-tests-fix"
    "release-management"
)

for spec in "${COMPLETED_SPECS[@]}"; do
    if [ -d "active/$spec" ]; then
        mv "active/$spec" "archived/2025-completed/"
        print_status "Moved to completed: $spec"
    else
        print_warning "Not found: $spec"
    fi
done
echo ""

# Phase 5: Archive duplicate/planning specs
echo "📋 Phase 5: Archiving duplicate planning specs..."
PLANNING_SPECS=(
    "beta-testing-program"
    "enhanced-onboarding"
    "onboarding-tutorial"
)

for spec in "${PLANNING_SPECS[@]}"; do
    if [ -d "active/$spec" ]; then
        mv "active/$spec" "planning/"
        print_status "Moved to planning: $spec"
    else
        print_warning "Not found: $spec"
    fi
done
echo ""

# Phase 6: Clean root level
echo "🗑️  Phase 6: Cleaning root-level duplicates..."
if [ -f "COMPREHENSIVE_IMPROVEMENT_PLAN.md" ]; then
    mv "COMPREHENSIVE_IMPROVEMENT_PLAN.md" \
       "archived/superseded/"
    print_status "Archived: COMPREHENSIVE_IMPROVEMENT_PLAN.md"
fi

if [ -f "IMMEDIATE_ACTION_PLAN.md" ]; then
    mv "IMMEDIATE_ACTION_PLAN.md" \
       "archived/superseded/"
    print_status "Archived: IMMEDIATE_ACTION_PLAN.md"
fi

if [ -d "comprehensive-improvement-plan" ]; then
    mv "comprehensive-improvement-plan" \
       "archived/superseded/"
    print_status "Archived: comprehensive-improvement-plan/"
fi

if [ -d "git-strategy-erp-development" ]; then
    mv "git-strategy-erp-development" \
       "archived/superseded/"
    print_status "Archived: git-strategy-erp-development/"
fi
echo ""

# Phase 7: Move technical layers to docs
echo "📚 Phase 7: Moving technical layers to docs..."
if [ -d "technical-layers" ]; then
    mkdir -p ../../docs/architecture
    mv "technical-layers" "../../docs/architecture/"
    print_status "Moved technical-layers to docs/architecture/"
fi
echo ""

# Generate statistics
echo "📊 Generating statistics..."
echo ""
echo "Results:"
echo "--------"
ACTIVE_COUNT=$(find active -maxdepth 1 -type d 2>/dev/null | wc -l)
ACTIVE_COUNT=$((ACTIVE_COUNT - 1)) # Subtract the active dir itself
ARCHIVED_COUNT=$(find archived -maxdepth 2 -type d 2>/dev/null | wc -l)
TOTAL_FILES=$(find . -name "*.md" 2>/dev/null | wc -l)
TOTAL_SIZE=$(du -sh . 2>/dev/null | cut -f1)

echo "Active specs: $ACTIVE_COUNT"
echo "Archived specs: $ARCHIVED_COUNT"
echo "Total MD files: $TOTAL_FILES"
echo "Total size: $TOTAL_SIZE"
echo ""

# List remaining active specs
echo "📋 Remaining Active Specs:"
echo "-------------------------"
for spec in .kiro/specs/active/*/; do
    if [ -d "$spec" ]; then
        spec_name=$(basename "$spec")
        echo "  • $spec_name"
    fi
done
echo ""

# Success message
echo "========================================"
echo -e "${GREEN}✓ Cleanup completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Review remaining active specs"
echo "2. Update .kiro/specs/README.md"
echo "3. Commit changes"
echo "4. Delete backup if satisfied: rm -rf $BACKUP_DIR"
echo ""
