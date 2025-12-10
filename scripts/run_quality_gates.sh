#!/bin/bash

# Quality Gates Runner Script
# This script runs all quality gates locally before pushing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COVERAGE_THRESHOLD=70
DOC_COVERAGE_THRESHOLD=95

echo -e "${BLUE}🎯 Running Quality Gates${NC}"
echo "================================"
echo ""

# Track failures
FAILED_GATES=()

# Function to run a gate
run_gate() {
    local gate_name=$1
    local gate_command=$2
    
    echo -e "${BLUE}Running: $gate_name${NC}"
    
    if eval "$gate_command"; then
        echo -e "${GREEN}✅ $gate_name passed${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}❌ $gate_name failed${NC}"
        echo ""
        FAILED_GATES+=("$gate_name")
        return 1
    fi
}

# 1. Documentation Quality Gate
echo -e "${YELLOW}📚 Documentation Quality Gate${NC}"
echo "--------------------------------"

run_gate "Documentation Coverage" \
    "dart run lib/tools/documentation/cli/documentation_cli.dart analyze --path lib/" || true

run_gate "Documentation Quality" \
    "dart run lib/tools/documentation/cli/documentation_cli.dart validate --strict --path lib/" || true

# 2. Code Quality Gate
echo -e "${YELLOW}🔍 Code Quality Gate${NC}"
echo "--------------------------------"

run_gate "Flutter Analyze" \
    "flutter analyze --no-pub" || true

# 3. Test Quality Gate
echo -e "${YELLOW}🧪 Test Quality Gate${NC}"
echo "--------------------------------"

run_gate "Unit Tests" \
    "flutter test --coverage" || true

# Check coverage
if [ -f "coverage/lcov.info" ]; then
    echo "Checking test coverage..."
    
    # Install lcov if not available
    if ! command -v lcov &> /dev/null; then
        echo -e "${YELLOW}⚠️  lcov not found. Install it to check coverage.${NC}"
    else
        COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep "lines" | awk '{print $2}' | sed 's/%//')
        
        echo "Test Coverage: ${COVERAGE}%"
        echo "Required: ${COVERAGE_THRESHOLD}%"
        
        if (( $(echo "$COVERAGE < $COVERAGE_THRESHOLD" | bc -l) )); then
            echo -e "${RED}❌ Coverage below threshold${NC}"
            FAILED_GATES+=("Test Coverage")
        else
            echo -e "${GREEN}✅ Coverage meets threshold${NC}"
        fi
    fi
fi

echo ""

# 4. Security Quality Gate
echo -e "${YELLOW}🔒 Security Quality Gate${NC}"
echo "--------------------------------"

# Check for hardcoded secrets
echo "Checking for hardcoded secrets..."
if grep -r -E "(api_key|apikey|api-key|password|secret|token|auth)" lib/ --include="*.dart" | grep -v "//" | grep -v "test"; then
    echo -e "${YELLOW}⚠️  Potential secrets found. Please review.${NC}"
else
    echo -e "${GREEN}✅ No obvious secrets found${NC}"
fi

echo ""

# Summary
echo -e "${BLUE}📊 Quality Gates Summary${NC}"
echo "================================"
echo ""

if [ ${#FAILED_GATES[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ All quality gates passed!${NC}"
    echo ""
    echo "You're ready to push your changes."
    exit 0
else
    echo -e "${RED}❌ ${#FAILED_GATES[@]} quality gate(s) failed:${NC}"
    for gate in "${FAILED_GATES[@]}"; do
        echo "  - $gate"
    done
    echo ""
    echo "Please fix the issues before pushing."
    exit 1
fi
