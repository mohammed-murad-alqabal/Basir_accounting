#!/bin/bash

# إعداد Git بشكل احترافي
# يقوم بتكوين Git مع أفضل الممارسات

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   إعداد Git - Basser MVP Project     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# 1. تكوين المستخدم
echo -e "${YELLOW}[1/8]${NC} تكوين معلومات المستخدم..."

if [ -z "$(git config user.name)" ]; then
    echo -e "${YELLOW}[INPUT]${NC} أدخل اسمك:"
    read -r user_name
    git config user.name "$user_name"
fi

if [ -z "$(git config user.email)" ]; then
    echo -e "${YELLOW}[INPUT]${NC} أدخل بريدك الإلكتروني:"
    read -r user_email
    git config user.email "$user_email"
fi

echo -e "${GREEN}[SUCCESS]${NC} المستخدم: $(git config user.name) <$(git config user.email)>"

# 2. تفعيل Git Hooks
echo -e "${YELLOW}[2/8]${NC} تفعيل Git Hooks..."
git config core.hooksPath .githooks
echo -e "${GREEN}[SUCCESS]${NC} تم تفعيل Git Hooks"

# 3. تكوين الفروع
echo -e "${YELLOW}[3/8]${NC} تكوين الفروع..."
git config init.defaultBranch main
git config pull.rebase false
git config push.default current
git config push.followTags true
echo -e "${GREEN}[SUCCESS]${NC} تم تكوين الفروع"

# 4. تكوين الدمج
echo -e "${YELLOW}[4/8]${NC} تكوين الدمج..."
git config merge.ff false
git config merge.conflictstyle diff3
echo -e "${GREEN}[SUCCESS]${NC} تم تكوين الدمج"

# 5. تكوين الألوان
echo -e "${YELLOW}[5/8]${NC} تكوين الألوان..."
git config color.ui auto
git config color.branch auto
git config color.diff auto
git config color.status auto
echo -e "${GREEN}[SUCCESS]${NC} تم تكوين الألوان"

# 6. تكوين الأدوات
echo -e "${YELLOW}[6/8]${NC} تكوين الأدوات..."
git config core.editor "nano"
git config core.autocrlf input
git config core.whitespace trailing-space,space-before-tab
echo -e "${GREEN}[SUCCESS]${NC} تم تكوين الأدوات"

# 7. تكوين الأمان
echo -e "${YELLOW}[7/8]${NC} تكوين الأمان..."
git config transfer.fsckObjects true
git config fetch.fsckObjects true
git config receive.fsckObjects true
echo -e "${GREEN}[SUCCESS]${NC} تم تكوين الأمان"

# 8. تكوين الأداء
echo -e "${YELLOW}[8/8]${NC} تكوين الأداء..."
git config core.preloadindex true
git config core.fscache true
git config gc.auto 256
echo -e "${GREEN}[SUCCESS]${NC} تم تكوين الأداء"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✅ تم إعداد Git بنجاح!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# عرض التكوين
echo -e "${BLUE}[INFO]${NC} التكوين الحالي:"
echo ""
echo -e "${YELLOW}المستخدم:${NC}"
echo "  الاسم: $(git config user.name)"
echo "  البريد: $(git config user.email)"
echo ""
echo -e "${YELLOW}الفروع:${NC}"
echo "  الفرع الافتراضي: $(git config init.defaultBranch)"
echo "  استراتيجية Push: $(git config push.default)"
echo ""
echo -e "${YELLOW}Git Hooks:${NC}"
echo "  المسار: $(git config core.hooksPath)"
echo ""

# نصائح
echo -e "${BLUE}[TIPS]${NC} نصائح مفيدة:"
echo ""
echo "  1. استخدم Conventional Commits:"
echo "     ${GREEN}feat:${NC} للميزات الجديدة"
echo "     ${GREEN}fix:${NC} لإصلاح الأخطاء"
echo "     ${GREEN}docs:${NC} للتوثيق"
echo ""
echo "  2. أنشئ فرع جديد لكل ميزة:"
echo "     ${GREEN}git checkout -b feature/my-feature${NC}"
echo ""
echo "  3. قبل الـ push، تأكد من:"
echo "     ${GREEN}flutter format lib/ test/${NC}"
echo "     ${GREEN}flutter analyze${NC}"
echo "     ${GREEN}flutter test${NC}"
echo ""
echo "  4. للمساعدة:"
echo "     ${GREEN}git help <command>${NC}"
echo ""

exit 0
