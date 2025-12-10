#!/bin/bash
# Enhanced Quality Check Script
# Implements: KISS, Security First, Quality First principles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MIN_COVERAGE=70
MAX_LINE_LENGTH=80
MAX_FUNCTION_LINES=30

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Enhanced Quality Check - بصير MVP v2.0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Track failures
FAILURES=0

# 1. Check formatting
echo -e "${BLUE}📝 Checking code formatting...${NC}"
if dart format --set-exit-if-changed lib/ test/ 2>/dev/null; then
  echo -e "${GREEN}✅ Code is properly formatted${NC}"
else
  echo -e "${RED}❌ Code formatting issues found${NC}"
  echo -e "${YELLOW}💡 Run: dart format .${NC}"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# 2. Static analysis
echo -e "${BLUE}🔬 Running static analysis...${NC}"
if flutter analyze --fatal-infos 2>&1 | tee /tmp/analyze.log; then
  echo -e "${GREEN}✅ No analysis issues found${NC}"
else
  echo -e "${RED}❌ Analysis issues found${NC}"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# 3. Check for English code (ENGLISH FOR CODE principle)
echo -e "${BLUE}🌍 Checking ENGLISH FOR CODE principle...${NC}"
ARABIC_IN_CODE=$(grep -r -P "[\u0600-\u06FF]" lib/ --include="*.dart" 2>/dev/null | grep -v "//\|/\*\|'\|\"" || true)
if [ -z "$ARABIC_IN_CODE" ]; then
  echo -e "${GREEN}✅ All code is in English${NC}"
else
  echo -e "${YELLOW}⚠️  Found Arabic in code (should be in comments/strings only)${NC}"
  echo "$ARABIC_IN_CODE" | head -5
fi
echo ""

# 4. Check KISS principle (function complexity)
echo -e "${BLUE}🎯 Checking KISS principle (function complexity)...${NC}"
COMPLEX_FUNCTIONS=$(find lib/ -name "*.dart" -exec awk -v max=$MAX_FUNCTION_LINES '
  /^[[:space:]]*(Future<|void |[A-Z].*) [a-z].*\(/ {
    start=NR; fname=$0
  }
  /^[[:space:]]*\}[[:space:]]*$/ {
    if (start > 0 && NR - start > max) {
      print FILENAME ":" start ": " fname " (" NR-start " lines, max: " max ")"
    }
    start=0
  }
' {} \; 2>/dev/null || true)

if [ -z "$COMPLEX_FUNCTIONS" ]; then
  echo -e "${GREEN}✅ No overly complex functions (>${MAX_FUNCTION_LINES} lines)${NC}"
else
  echo -e "${YELLOW}⚠️  Found complex functions:${NC}"
  echo "$COMPLEX_FUNCTIONS" | head -5
  echo -e "${YELLOW}💡 KISS: Keep functions small and simple${NC}"
fi
echo ""

# 5. Check line length
echo -e "${BLUE}📏 Checking line length (max: ${MAX_LINE_LENGTH})...${NC}"
LONG_LINES=$(find lib/ test/ -name "*.dart" -exec awk -v max=$MAX_LINE_LENGTH '
  length > max {
    print FILENAME ":" NR ": " length " chars (max: " max ")"
  }
' {} \; 2>/dev/null | head -10 || true)

if [ -z "$LONG_LINES" ]; then
  echo -e "${GREEN}✅ All lines within ${MAX_LINE_LENGTH} characters${NC}"
else
  echo -e "${YELLOW}⚠️  Found long lines:${NC}"
  echo "$LONG_LINES"
  echo -e "${YELLOW}💡 Consider breaking long lines${NC}"
fi
echo ""

# 6. Security First - Check for secrets
echo -e "${BLUE}🔒 Security First - Checking for hardcoded secrets...${NC}"
SECRETS=$(grep -r -i -E "(password|secret|api_key|token|private_key)" lib/ --include="*.dart" 2>/dev/null | \
  grep -v "SecureStorage\|// TODO\|// FIXME\|test" | \
  grep "=" || true)

if [ -z "$SECRETS" ]; then
  echo -e "${GREEN}✅ No hardcoded secrets found${NC}"
else
  echo -e "${RED}❌ Found potential hardcoded secrets${NC}"
  echo "$SECRETS" | head -5
  echo -e "${YELLOW}💡 Security First: Use flutter_secure_storage${NC}"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# 7. Run tests
echo -e "${BLUE}🧪 Running tests...${NC}"
if flutter test --coverage --reporter expanded 2>&1 | tee /tmp/test.log; then
  echo -e "${GREEN}✅ All tests passed${NC}"
else
  echo -e "${RED}❌ Some tests failed${NC}"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# 8. Check coverage (Quality First principle)
echo -e "${BLUE}📊 Checking test coverage (Quality First: ${MIN_COVERAGE}%+)...${NC}"
if [ -f coverage/lcov.info ]; then
  # Install lcov if not available
  if ! command -v lcov &> /dev/null; then
    echo "Installing lcov..."
    sudo apt-get update -qq && sudo apt-get install -y lcov
  fi
  
  COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep lines | awk '{print $2}' | sed 's/%//' || echo "0")
  
  echo "📈 Coverage: ${COVERAGE}%"
  echo "🎯 Target: ${MIN_COVERAGE}%"
  
  if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
    echo -e "${RED}❌ Coverage below target: ${COVERAGE}% < ${MIN_COVERAGE}%${NC}"
    echo -e "${YELLOW}💡 Quality First: Maintain ${MIN_COVERAGE}%+ test coverage${NC}"
    FAILURES=$((FAILURES + 1))
  else
    echo -e "${GREEN}✅ Coverage meets target: ${COVERAGE}% ≥ ${MIN_COVERAGE}%${NC}"
  fi
else
  echo -e "${RED}❌ No coverage file found${NC}"
  FAILURES=$((FAILURES + 1))
fi
echo ""

# Final report
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Quality Check Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $FAILURES -eq 0 ]; then
  echo -e "${GREEN}✅ All quality checks passed!${NC}"
  echo ""
  echo "🎯 Philosophy Principles Applied:"
  echo "   ✅ KISS - Code complexity checked"
  echo "   ✅ ENGLISH FOR CODE - Code language validated"
  echo "   ✅ Security First - No hardcoded secrets"
  echo "   ✅ Quality First - ${MIN_COVERAGE}%+ coverage maintained"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 0
else
  echo -e "${RED}❌ Quality checks failed: $FAILURES issue(s) found${NC}"
  echo ""
  echo "Please fix the issues above and try again."
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi
