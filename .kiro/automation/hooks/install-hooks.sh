#!/bin/bash

# تثبيت Git Hooks
# يقوم بنسخ الـ hooks إلى .git/hooks/

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${BLUE}🔧 تثبيت Git Hooks...${NC}"
echo ""

# التحقق من وجود .git
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}⚠️  ليس مستودع Git${NC}"
    exit 1
fi

# إنشاء مجلد hooks إذا لم يكن موجوداً
mkdir -p .git/hooks

# تثبيت pre-commit hook
echo "▶ تثبيت pre-commit hook..."
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit Hook - يتم تشغيله تلقائياً قبل كل كوميت

# تشغيل فحص الجودة
./.kiro/automation/hooks/pre-commit/quality-check.sh

exit $?
EOF

chmod +x .git/hooks/pre-commit
echo -e "${GREEN}✅ تم تثبيت pre-commit hook${NC}"

# تثبيت pre-push hook
echo "▶ تثبيت pre-push hook..."
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
# Pre-push Hook - يتم تشغيله تلقائياً قبل كل دفع

echo ""
echo "🚀 Pre-push: فحص نهائي..."
echo ""

# تشغيل الاختبارات
if command -v flutter &> /dev/null; then
    echo "▶ تشغيل الاختبارات..."
    if flutter test > /dev/null 2>&1; then
        echo "✅ الاختبارات نجحت"
    else
        echo "⚠️  بعض الاختبارات فشلت"
        echo ""
        read -p "هل تريد المتابعة؟ (y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi

echo ""
echo "✅ جاهز للدفع!"
echo ""

exit 0
EOF

chmod +x .git/hooks/pre-push
echo -e "${GREEN}✅ تم تثبيت pre-push hook${NC}"

# تثبيت commit-msg hook
echo "▶ تثبيت commit-msg hook..."
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash
# Commit-msg Hook - يتحقق من صيغة رسالة الكوميت

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# التحقق من صيغة Conventional Commits
if ! echo "$commit_msg" | grep -qE '^(feat|fix|docs|style|refactor|test|chore|perf|ci|build)(\(.+\))?: .+'; then
    echo ""
    echo "❌ رسالة الكوميت لا تتبع Conventional Commits"
    echo ""
    echo "الصيغة الصحيحة:"
    echo "  type(scope): description"
    echo ""
    echo "أمثلة:"
    echo "  feat(auth): إضافة تسجيل دخول"
    echo "  fix(ui): إصلاح overflow"
    echo "  docs(readme): تحديث التوثيق"
    echo ""
    exit 1
fi

exit 0
EOF

chmod +x .git/hooks/commit-msg
echo -e "${GREEN}✅ تم تثبيت commit-msg hook${NC}"

echo ""
echo -e "${GREEN}🎉 تم تثبيت جميع الـ hooks بنجاح!${NC}"
echo ""
echo "الـ hooks المثبتة:"
echo "  • pre-commit: فحص الجودة قبل الكوميت"
echo "  • pre-push: تشغيل الاختبارات قبل الدفع"
echo "  • commit-msg: التحقق من صيغة رسالة الكوميت"
echo ""
echo -e "${BLUE}ℹ️  لتعطيل الـ hooks مؤقتاً: git commit --no-verify${NC}"
echo ""

exit 0
