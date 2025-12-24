#!/bin/bash

# GitHub Integration Test Script
# تم إنشاؤه بواسطة: فريق وكلاء تطوير مشروع بصير
# التاريخ: 15 ديسمبر 2025

echo "🔍 بدء اختبار تكامل GitHub الشامل..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -e "${BLUE}اختبار: $test_name${NC}"
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ نجح: $test_name${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ فشل: $test_name${NC}"
        ((TESTS_FAILED++))
    fi
    echo ""
}

# Test 1: GitHub Token Environment Variable
echo -e "${YELLOW}1. فحص متغير البيئة GITHUB_TOKEN${NC}"
if [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${GREEN}✅ GITHUB_TOKEN موجود (الطول: ${#GITHUB_TOKEN})${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ GITHUB_TOKEN غير موجود${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 2: GitHub API Basic Access
echo -e "${YELLOW}2. اختبار الوصول الأساسي لـ GitHub API${NC}"
run_test "GitHub API User Info" "curl -s -H 'Authorization: token $GITHUB_TOKEN' https://api.github.com/user"

# Test 3: Repository Access
echo -e "${YELLOW}3. اختبار الوصول للمستودع${NC}"
run_test "Basser_MVP Repository Access" "curl -s -H 'Authorization: token $GITHUB_TOKEN' https://api.github.com/repos/mohammed-murad-alqabal/Basser_MVP"

# Test 4: Repository Contents
echo -e "${YELLOW}4. اختبار قراءة محتويات المستودع${NC}"
run_test "Repository Contents" "curl -s -H 'Authorization: token $GITHUB_TOKEN' https://api.github.com/repos/mohammed-murad-alqabal/Basser_MVP/contents"

# Test 5: Rate Limit Check
echo -e "${YELLOW}5. فحص حدود الاستخدام${NC}"
RATE_LIMIT_RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit)
RATE_LIMIT=$(echo "$RATE_LIMIT_RESPONSE" | grep -o '"remaining":[0-9]*' | cut -d':' -f2)
if [ -n "$RATE_LIMIT" ] && [ "$RATE_LIMIT" -gt 100 ]; then
    echo -e "${GREEN}✅ حدود الاستخدام جيدة: $RATE_LIMIT طلب متبقي${NC}"
    ((TESTS_PASSED++))
elif [ -n "$RATE_LIMIT" ]; then
    echo -e "${YELLOW}⚠️ حدود الاستخدام منخفضة: $RATE_LIMIT طلب متبقي${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ لا يمكن قراءة حدود الاستخدام${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 6: MCP Server Package Check
echo -e "${YELLOW}6. فحص حزمة GitHub MCP Server${NC}"
if npx -y @modelcontextprotocol/server-github --help > /dev/null 2>&1; then
    echo -e "${GREEN}✅ حزمة GitHub MCP Server متاحة${NC}"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ حزمة GitHub MCP Server غير متاحة${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Test 7: Git Local Configuration
echo -e "${YELLOW}7. فحص تكوين Git المحلي${NC}"
if git config --get user.name > /dev/null && git config --get user.email > /dev/null; then
    echo -e "${GREEN}✅ تكوين Git محلي صحيح${NC}"
    echo "   المستخدم: $(git config --get user.name)"
    echo "   البريد: $(git config --get user.email)"
    ((TESTS_PASSED++))
else
    echo -e "${RED}❌ تكوين Git محلي غير مكتمل${NC}"
    ((TESTS_FAILED++))
fi
echo ""

# Summary
echo "=================================================="
echo -e "${BLUE}ملخص نتائج الاختبار:${NC}"
echo -e "${GREEN}✅ اختبارات نجحت: $TESTS_PASSED${NC}"
echo -e "${RED}❌ اختبارات فشلت: $TESTS_FAILED${NC}"

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
SUCCESS_RATE=$((TESTS_PASSED * 100 / TOTAL_TESTS))

echo -e "${BLUE}معدل النجاح: $SUCCESS_RATE%${NC}"

if [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "${GREEN}🎉 GitHub Integration جاهز للاستخدام!${NC}"
    exit 0
else
    echo -e "${RED}⚠️ يحتاج GitHub Integration لإصلاحات إضافية${NC}"
    exit 1
fi