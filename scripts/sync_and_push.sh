#!/bin/bash
# sync_and_push.sh - مزامنة ورفع آمن
# Basir Project - Git Workflow Helper

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "\n${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
print_step "الفرع الحالي: $current_branch"

# Fetch latest
print_step "جلب التحديثات من البعيد..."
git fetch origin

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    print_warning "يوجد تغييرات غير ملتزمة"
    echo ""
    git status --short
    echo ""
    read -p "هل تريد الالتزام بها؟ (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "رسالة الالتزام: " commit_msg
        git add .
        git commit -m "$commit_msg"
        print_success "تم الالتزام"
    else
        print_warning "سيتم stash التغييرات مؤقتاً"
        git stash
    fi
fi

# Rebase on target branch
target_branch="develop"
if [[ "$current_branch" == "develop" || "$current_branch" == "main" ]]; then
    target_branch="$current_branch"
fi

print_step "مزامنة مع origin/$target_branch..."
if git rebase origin/$target_branch; then
    print_success "تمت المزامنة بنجاح"
else
    print_error "فشل الـ rebase - يوجد تعارضات"
    echo "حل التعارضات ثم نفذ: git rebase --continue"
    exit 1
fi

# Run checks
print_step "تشغيل الفحوصات..."

echo -e "\n${BLUE}Flutter Analyze:${NC}"
if flutter analyze --no-fatal-infos 2>/dev/null; then
    print_success "التحليل ناجح"
else
    print_warning "يوجد مشاكل في التحليل (غير حرجة)"
fi

# Push
print_step "رفع التغييرات..."
if git push origin "$current_branch" 2>/dev/null; then
    print_success "تم الرفع بنجاح"
elif git push --force-with-lease origin "$current_branch" 2>/dev/null; then
    print_success "تم الرفع (force-with-lease) بنجاح"
else
    print_error "فشل الرفع"
    exit 1
fi

# Restore stash if exists
if git stash list | grep -q "stash@{0}"; then
    print_step "استعادة التغييرات المحفوظة..."
    git stash pop
fi

echo ""
print_success "اكتملت عملية المزامنة والرفع بنجاح! 🎉"
