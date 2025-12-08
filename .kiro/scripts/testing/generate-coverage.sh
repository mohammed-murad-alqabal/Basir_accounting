#!/bin/bash
# Generate test coverage report - Enhanced
# Implements: Quality First principle (70%+ coverage)

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MIN_COVERAGE=70

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Enhanced Coverage Report Generator - بصير MVP v2.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run tests with coverage
echo -e "${BLUE}🧪 Running tests with coverage...${NC}"
flutter test --coverage --reporter expanded
echo ""

# Check if coverage file exists
if [ ! -f coverage/lcov.info ]; then
  echo -e "${YELLOW}⚠️  No coverage file generated${NC}"
  exit 1
fi

# Install lcov if needed
if ! command -v lcov &> /dev/null; then
  echo -e "${BLUE}📦 Installing lcov...${NC}"
  sudo apt-get update -qq && sudo apt-get install -y lcov
  echo ""
fi

# Calculate coverage
echo -e "${BLUE}📊 Calculating coverage...${NC}"
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep lines | awk '{print $2}' | sed 's/%//' || echo "0")

echo "📈 Total Coverage: ${COVERAGE}%"
echo "🎯 Target: ${MIN_COVERAGE}%"
echo ""

# Generate HTML report
echo -e "${BLUE}📄 Generating HTML report...${NC}"
genhtml coverage/lcov.info -o coverage/html --quiet

# Generate detailed report
echo -e "${BLUE}📋 Generating detailed report...${NC}"
lcov --list coverage/lcov.info > coverage/detailed_report.txt

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Coverage Report Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📈 Coverage: ${COVERAGE}%"
echo "🎯 Target: ${MIN_COVERAGE}%"
echo ""

if (( $(echo "$COVERAGE >= $MIN_COVERAGE" | bc -l) )); then
  echo -e "${GREEN}✅ Coverage meets Quality First principle (${MIN_COVERAGE}%+)${NC}"
else
  echo -e "${YELLOW}⚠️  Coverage below target: ${COVERAGE}% < ${MIN_COVERAGE}%${NC}"
  echo -e "${YELLOW}💡 Quality First: Add more tests to reach ${MIN_COVERAGE}%+${NC}"
fi

echo ""
echo "📁 Reports generated:"
echo "   📄 HTML: coverage/html/index.html"
echo "   📋 Detailed: coverage/detailed_report.txt"
echo "   📊 LCOV: coverage/lcov.info"
echo ""
echo "💡 To view HTML report:"
echo "   xdg-open coverage/html/index.html  # Linux"
echo "   open coverage/html/index.html      # macOS"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
