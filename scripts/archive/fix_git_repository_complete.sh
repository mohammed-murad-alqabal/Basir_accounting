#!/bin/bash
# fix_git_repository_complete.sh
# سكريبت إصلاح شامل للمستودع

set -e

echo "🔧 بدء إصلاح المستودع..."
echo ""

# 1. حفظ التغييرات الحالية
echo "📦 الخطوة 1: حفظ التغييرات الحالية..."
git add .
if git diff --cached --quiet; then
    echo "   ℹ️  لا توجد تغييرات للحفظ"
else
    git commit -m "chore: save all changes before repository cleanup"
    echo "   ✅ تم حفظ التغييرات"
fi
echo ""

# 2. دفع master
echo "⬆️  الخطوة 2: دفع master إلى origin..."
git push origin master
echo "   ✅ تم دفع master بنجاح"
echo ""

# 3. حذف origin/main
echo "🗑️  الخطوة 3: حذف origin/main..."
if git ls-remote --heads origin main | grep -q main; then
    git push origin --delete main
    echo "   ✅ تم حذف origin/main"
else
    echo "   ℹ️  origin/main غير موجود أو تم حذفه مسبقاً"
fi
echo ""

# 4. تنظيف المراجع المحلية
echo "🧹 الخطوة 4: تنظيف المراجع المحلية..."
git remote prune origin
git fetch --all --prune
echo "   ✅ تم تنظيف المراجع"
echo ""

# 5. التحقق من النتيجة
echo "✅ الخطوة 5: التحقق من النتيجة..."
echo ""
echo "الفروع الحالية:"
git branch -a
echo ""

# 6. إنشاء Git Hooks
echo "🔧 الخطوة 6: إنشاء Git Hooks..."

# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "🔍 Running flutter analyze..."
flutter analyze --no-pub
if [ $? -ne 0 ]; then
  echo "❌ Flutter analyze failed. Please fix the issues before committing."
  exit 1
fi
echo "✅ Flutter analyze passed!"
exit 0
EOF

chmod +x .git/hooks/pre-commit
echo "   ✅ تم إنشاء pre-commit hook"

# Pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
echo "🧪 Running tests..."
flutter test --no-pub
if [ $? -ne 0 ]; then
  echo "❌ Tests failed. Please fix the tests before pushing."
  exit 1
fi
echo "✅ All tests passed!"
exit 0
EOF

chmod +x .git/hooks/pre-push
echo "   ✅ تم إنشاء pre-push hook"
echo ""

# 7. إنشاء نسخة احتياطية
echo "💾 الخطوة 7: إنشاء نسخة احتياطية..."
git bundle create git-backup-$(date +%Y%m%d-%H%M%S).bundle --all
echo "   ✅ تم إنشاء نسخة احتياطية"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 تم إصلاح المستودع بنجاح!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 الخطوات التالية (يدوياً):"
echo ""
echo "1. تحديث الفرع الافتراضي على GitHub:"
echo "   https://github.com/mohammed-murad-alqabal/Basir_MVP/settings/branches"
echo "   غير الفرع الافتراضي من 'main' إلى 'master'"
echo ""
echo "2. إضافة Branch Protection Rules:"
echo "   ☑ Require pull request reviews"
echo "   ☑ Require status checks (flutter-analyze, flutter-test)"
echo ""
echo "3. راجع الملفات التالية:"
echo "   - CONTRIBUTING.md (دليل المساهمة)"
echo "   - GIT_REPOSITORY_FULL_ANALYSIS.md (التحليل الكامل)"
echo ""
echo "✅ المستودع الآن نظيف ومنظم!"
