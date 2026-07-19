#!/bin/bash

# Setup Git Hooks for Basir ERP Development
# This script configures Git hooks for the project

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Setting up Git hooks for Basir ERP Development...${NC}"

# Check if we're in a Git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a Git repository${NC}"
    exit 1
fi

# Create .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Set up pre-push hook
if [ -f ".githooks/pre-push" ]; then
    echo -e "${YELLOW}📋 Installing pre-push hook...${NC}"
    cp .githooks/pre-push .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    echo -e "${GREEN}✅ Pre-push hook installed${NC}"
else
    echo -e "${RED}❌ Error: .githooks/pre-push not found${NC}"
    exit 1
fi

# Configure Git to use our hooks directory
echo -e "${YELLOW}📋 Configuring Git hooks path...${NC}"
git config core.hooksPath .githooks

# Test the hook installation
echo -e "${YELLOW}🧪 Testing hook installation...${NC}"
if [ -x ".git/hooks/pre-push" ]; then
    echo -e "${GREEN}✅ Hooks are executable and ready${NC}"
else
    echo -e "${RED}❌ Error: Hooks are not executable${NC}"
    exit 1
fi

# Display current branch and validate it
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}📍 Current branch: $current_branch${NC}"

# Test branch name validation
echo -e "${YELLOW}🧪 Testing branch name validation...${NC}"
if .githooks/pre-push; then
    echo -e "${GREEN}✅ Branch name validation passed${NC}"
else
    echo -e "${YELLOW}⚠️  Branch name validation failed - this is expected for non-standard branch names${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Git hooks setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 What's been configured:${NC}"
echo "  • Pre-push hook for branch name validation"
echo "  • Git hooks path set to .githooks/"
echo "  • Branch naming conventions enforced"
echo ""
echo -e "${YELLOW}📖 Branch naming conventions:${NC}"
echo "  • feature/<module>-<description> (e.g., feature/hr-employee-management)"
echo "  • bugfix/<description>"
echo "  • hotfix/<description>"
echo "  • release/v<version>"
echo "  • docs/<description>"
echo "  • chore/<description>"
echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "  • Use descriptive branch names"
echo "  • Include the ERP module in feature branches"
echo "  • Follow kebab-case naming (lowercase with hyphens)"
echo ""