#!/bin/bash

# Spec Compliance Checker
# يتحقق من التزام الكود بالمواصفات المعتمدة
# المشروع: نظام بصير المحاسبي

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
DOCS_DIR="$ROOT_DIR/docs"
STANDARDS_DIR="$DOCS_DIR/standards"
STEERING_DIR="$DOCS_DIR/guides/steering"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔍 Spec Compliance Checker${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Check Architecture Compliance
echo -e "${BLUE}[1/5] Architecture Compliance${NC}"

if [ -f "$STEERING_DIR/architecture-mapping.md" ]; then
    echo -e "${GREEN}✓${NC} Architecture mapping found"
    
    # Check Feature-First organization
    if [ -d "$ROOT_DIR/lib/features" ]; then
        FEATURE_COUNT=$(find "$ROOT_DIR/lib/features" -mindepth 1 -maxdepth 1 -type d | wc -l)
        echo -e "${GREEN}✓${NC} Feature-First organization: $FEATURE_COUNT features found"
    else
        echo -e "${YELLOW}⚠${NC} lib/features/ not found - not using Feature-First?"
    fi
    
    # Check Clean Architecture layers
    for feature in "$ROOT_DIR/lib/features"/*; do
        if [ -d "$feature" ]; then
            fname=$(basename "$feature")
            has_presentation=false
            has_domain=false
            has_data=false
            
            [ -d "$feature/presentation" ] && has_presentation=true
            [ -d "$feature/domain" ] && has_domain=true
            [ -d "$feature/data" ] && has_data=true
            
            if [ "$has_presentation" = true ] && [ "$has_domain" = true ]; then
                echo -e "${GREEN}  ✓${NC} $fname: Clean Architecture layers present"
            else
                echo -e "${YELLOW}  ⚠${NC} $fname: Missing layers (P:$has_presentation, D:$has_domain)"
            fi
        fi
    done
else
    echo -e "${RED}✗${NC} Architecture mapping not found at $STEERING_DIR/architecture-mapping.md"
fi

echo ""

# 2. Check Standards Compliance
echo -e "${BLUE}[2/5] Standards Compliance${NC}"

STANDARDS=("flutter.md" "engineering.md" "naming.md" "code-quality.md" "accounting.md")
STANDARDS_OK=0

for std in "${STANDARDS[@]}"; do
    if [ -f "$STANDARDS_DIR/$std" ]; then
        echo -e "${GREEN}✓${NC} $std found"
        STANDARDS_OK=$((STANDARDS_OK + 1))
    else
        echo -e "${YELLOW}⚠${NC} $std not found"
    fi
done

echo -e "${BLUE}  Standards coverage: $STANDARDS_OK/${#STANDARDS[@]}${NC}"
echo ""

# 3. Check Flutter/Dart Quality
echo -e "${BLUE}[3/5] Flutter/Dart Quality${NC}"

if command -v flutter &> /dev/null; then
    echo -e "${BLUE}  Running flutter analyze...${NC}"
    
    ANALYZE_OUTPUT=$(flutter analyze --no-pub 2>&1 || true)
    
    if echo "$ANALYZE_OUTPUT" | grep -q "No issues found"; then
        echo -e "${GREEN}✓${NC} No issues found by flutter analyze"
    else
        # Count issues (handle grep returning exit code 1 when no matches)
        ERROR_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "error •" || true)
        WARNING_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "warning •" || true)
        INFO_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c "info •" || true)
        
        # Ensure they are integers (default to 0 if empty)
        ERROR_COUNT=${ERROR_COUNT:-0}
        WARNING_COUNT=${WARNING_COUNT:-0}
        INFO_COUNT=${INFO_COUNT:-0}
        
        echo -e "${YELLOW}⚠${NC} Issues found:"
        if [ "$ERROR_COUNT" -gt 0 ] 2>/dev/null; then
            echo -e "${RED}  ✗ Errors: $ERROR_COUNT${NC}"
        fi
        if [ "$WARNING_COUNT" -gt 0 ] 2>/dev/null; then
            echo -e "${YELLOW}  ⚠ Warnings: $WARNING_COUNT${NC}"
        fi
        if [ "$INFO_COUNT" -gt 0 ] 2>/dev/null; then
            echo -e "${BLUE}  ℹ Info: $INFO_COUNT${NC}"
        fi
    fi
    
    # Check formatting
    echo -e "${BLUE}  Checking code formatting...${NC}"
    FORMAT_OUTPUT=$(dart format --set-exit-if-changed "$ROOT_DIR/lib" 2>&1 || true)
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Code formatting OK"
    else
        echo -e "${YELLOW}⚠${NC} Code needs formatting. Run: dart format lib/"
    fi
else
    echo -e "${YELLOW}⚠${NC} Flutter not found - skipping Flutter checks"
fi

echo ""

# 4. Check Security Compliance
echo -e "${BLUE}[4/5] Security Compliance${NC}"

# Check for hardcoded secrets
SECRET_PATTERNS=(
    "password\s*=\s*['\"][^'\"]+['\"]"
    "api[_-]?key\s*=\s*['\"][^'\"]+['\"]"
    "secret\s*=\s*['\"][^'\"]+['\"]"
    "token\s*=\s*['\"][^'\"]+['\"]"
    "sk_live_"
    "sk_test_"
)

SECRETS_FOUND=0
for pattern in "${SECRET_PATTERNS[@]}"; do
    MATCHES=$(grep -rE "$pattern" "$ROOT_DIR/lib" 2>/dev/null | grep -v ".g.dart" | grep -v ".freezed.dart" || true)
    
    if [ -n "$MATCHES" ]; then
        echo -e "${RED}✗${NC} Potential hardcoded secret found:"
        echo "$MATCHES" | head -3
        SECRETS_FOUND=$((SECRETS_FOUND + 1))
    fi
done

if [ "$SECRETS_FOUND" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No hardcoded secrets found"
fi

# Check for .env file usage
if [ -f "$ROOT_DIR/.env" ]; then
    if grep -q ".env" "$ROOT_DIR/.gitignore" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} .env is in .gitignore"
    else
        echo -e "${RED}✗${NC} .env exists but not in .gitignore!"
    fi
fi

echo ""

# 5. Check Documentation
echo -e "${BLUE}[5/5] Documentation Check${NC}"

# Check for steering documents
STEERING_DOCS=("product.md" "tech.md" "philosophy.md" "roadmap.md")
STEERING_OK=0

for doc in "${STEERING_DOCS[@]}"; do
    if [ -f "$STEERING_DIR/$doc" ]; then
        echo -e "${GREEN}✓${NC} $doc found"
        STEERING_OK=$((STEERING_OK + 1))
    else
        echo -e "${YELLOW}⚠${NC} $doc not found"
    fi
done

# Check README
if [ -f "$ROOT_DIR/README.md" ]; then
    echo -e "${GREEN}✓${NC} README.md found"
else
    echo -e "${YELLOW}⚠${NC} README.md not found"
fi

# Check CHANGELOG
if [ -f "$ROOT_DIR/CHANGELOG.md" ]; then
    echo -e "${GREEN}✓${NC} CHANGELOG.md found"
else
    echo -e "${YELLOW}⚠${NC} CHANGELOG.md not found"
fi

echo ""

# Final Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 Compliance Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

TOTAL_CHECKS=5
PASSED_CHECKS=0

[ "$STANDARDS_OK" -ge 3 ] && PASSED_CHECKS=$((PASSED_CHECKS + 1))
[ "$SECRETS_FOUND" -eq 0 ] && PASSED_CHECKS=$((PASSED_CHECKS + 1))
[ "$STEERING_OK" -ge 3 ] && PASSED_CHECKS=$((PASSED_CHECKS + 1))
[ -d "$ROOT_DIR/lib/features" ] && PASSED_CHECKS=$((PASSED_CHECKS + 1))
command -v flutter &> /dev/null && PASSED_CHECKS=$((PASSED_CHECKS + 1))

SCORE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo ""
echo -e "Compliance Score: ${SCORE}%"
echo ""

if [ "$SCORE" -ge 80 ]; then
    echo -e "${GREEN}✓${NC} Excellent compliance!"
    exit 0
elif [ "$SCORE" -ge 60 ]; then
    echo -e "${YELLOW}⚠${NC} Good compliance, but improvements needed"
    exit 0
else
    echo -e "${RED}✗${NC} Low compliance - immediate attention required"
    exit 1
fi
