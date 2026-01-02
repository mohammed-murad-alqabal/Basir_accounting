# دليل Git و GitHub الشامل

**المشروع:** بصير MVP  
**التاريخ:** 5 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط

---

## نظرة عامة

هذا الدليل الشامل يغطي جميع عمليات Git و GitHub المستخدمة في مشروع بصير MVP، من الأساسيات إلى العمليات المتقدمة.

---

## 1. الإعداد الأولي (Initial Setup)

### 1.1 تثبيت Git

#### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install git
```

#### macOS

```bash
# باستخدام Homebrew
brew install git

# أو تحميل من الموقع الرسمي
# https://git-scm.com/download/mac
```

#### Windows

```bash
# تحميل من الموقع الرسمي
# https://git-scm.com/download/win
```

#### التحقق من التثبيت

```bash
git --version
# Output: git version 2.x.x
```

### 1.2 التكوين الأساسي

```bash
# تعيين الاسم
git config --global user.name "اسمك الكامل"

# تعيين البريد الإلكتروني
git config --global user.email "your.email@example.com"

# تعيين المحرر الافتراضي
git config --global core.editor "code --wait"  # VS Code
# أو
git config --global core.editor "nano"  # Nano

# عرض جميع الإعدادات
git config --list
```

### 1.3 إعداد SSH Key

```bash
# إنشاء SSH key جديد
ssh-keygen -t ed25519 -C "your.email@example.com"

# بدء ssh-agent
eval "$(ssh-agent -s)"

# إضافة المفتاح إلى ssh-agent
ssh-add ~/.ssh/id_ed25519

# نسخ المفتاح العام
cat ~/.ssh/id_ed25519.pub
# انسخ الإخراج وأضفه إلى GitHub
# Settings → SSH and GPG keys → New SSH key
```

### 1.4 استنساخ المشروع

```bash
# استنساخ عبر HTTPS
git clone https://github.com/username/Basir_MVP.git

# استنساخ عبر SSH (موصى به)
git clone git@github.com:username/Basir_MVP.git

# الدخول إلى المجلد
cd Basir_MVP
```

---

## 2. العمليات اليومية (Daily Operations)

### 2.1 التحقق من الحالة

```bash
# عرض حالة المشروع
git status

# عرض الفروع
git branch

# عرض الفرع الحالي
git branch --show-current
```

### 2.2 إنشاء فرع جديد

```bash
# إنشاء فرع جديد
git branch feature/customer-search

# التبديل إلى الفرع الجديد
git checkout feature/customer-search

# إنشاء والتبديل في أمر واحد (موصى به)
git checkout -b feature/customer-search

# إنشاء فرع من فرع محدد
git checkout -b feature/new-feature develop
```

### 2.3 إضافة التغييرات

```bash
# إضافة ملف محدد
git add lib/features/customers/customer_repository.dart

# إضافة جميع الملفات في مجلد
git add lib/features/customers/

# إضافة جميع التغييرات
git add .

# إضافة تفاعلية (اختيار أجزاء محددة)
git add -p

# عرض ما سيتم إضافته
git diff --staged
```

### 2.4 إنشاء Commit

```bash
# commit بسيط
git commit -m "feat(customers): add customer search feature"

# commit مع وصف مفصل
git commit -m "feat(customers): add customer search feature" \
           -m "- Add search by name" \
           -m "- Add search by phone" \
           -m "- Add search filters"

# تعديل آخر commit
git commit --amend

# تعديل رسالة آخر commit
git commit --amend -m "feat(customers): add advanced customer search"
```

#### صيغة Conventional Commits

```bash
# الصيغة: type(scope): description

# أنواع الـ commits
feat(customers): add new feature          # ميزة جديدة
fix(invoices): fix calculation bug        # إصلاح خطأ
docs(readme): update installation guide   # توثيق
style(ui): format code                    # تنسيق
refactor(auth): restructure login logic   # إعادة هيكلة
test(customers): add unit tests           # اختبارات
chore(deps): update dependencies          # مهام صيانة
perf(db): improve query performance       # تحسين أداء
```

### 2.5 دفع التغييرات

```bash
# دفع إلى الفرع الحالي
git push

# دفع فرع جديد لأول مرة
git push -u origin feature/customer-search

# دفع جميع الفروع
git push --all

# دفع مع force (حذر!)
git push --force-with-lease  # أكثر أماناً
git push -f                  # خطر!
```

### 2.6 سحب التحديثات

```bash
# سحب من الفرع الحالي
git pull

# سحب من فرع محدد
git pull origin main

# سحب مع rebase
git pull --rebase

# سحب جميع الفروع
git fetch --all
```

---

## 3. إدارة الفروع (Branch Management)

### 3.1 استراتيجية الفروع

```
main (الإنتاج)
  ↓
develop (التطوير)
  ↓
feature/* (الميزات)
  ↓
hotfix/* (الإصلاحات العاجلة)
```

### 3.2 عمليات الفروع

```bash
# عرض جميع الفروع
git branch -a

# عرض الفروع مع آخر commit
git branch -v

# حذف فرع محلي
git branch -d feature/customer-search

# حذف فرع بالقوة
git branch -D feature/customer-search

# حذف فرع بعيد
git push origin --delete feature/customer-search

# إعادة تسمية فرع
git branch -m old-name new-name
```

### 3.3 دمج الفروع (Merging)

```bash
# التبديل إلى الفرع المستهدف
git checkout develop

# دمج فرع آخر
git merge feature/customer-search

# دمج بدون fast-forward
git merge --no-ff feature/customer-search

# إلغاء الدمج
git merge --abort
```

### 3.4 Rebase

```bash
# rebase على فرع آخر
git checkout feature/customer-search
git rebase develop

# rebase تفاعلي (لتنظيف التاريخ)
git rebase -i HEAD~5

# متابعة بعد حل التعارضات
git rebase --continue

# إلغاء rebase
git rebase --abort
```

---

## 4. حل التعارضات (Conflict Resolution)

### 4.1 اكتشاف التعارضات

```bash
# عند الدمج أو rebase
git merge feature/customer-search
# CONFLICT (content): Merge conflict in lib/features/customers/customer_repository.dart

# عرض الملفات المتعارضة
git status
```

### 4.2 حل التعارضات

```dart
// الملف المتعارض يحتوي على:
<<<<<<< HEAD
// الكود الحالي
final customers = await getAllCustomers();
=======
// الكود الوارد
final customers = await fetchAllCustomers();
>>>>>>> feature/customer-search

// بعد الحل:
final customers = await getAllCustomers();
```

```bash
# بعد حل التعارضات
git add lib/features/customers/customer_repository.dart
git commit -m "merge: resolve conflicts in customer_repository"
```

### 4.3 أدوات حل التعارضات

```bash
# استخدام mergetool
git mergetool

# استخدام VS Code
code --wait --merge <file>

# قبول النسخة الحالية
git checkout --ours <file>

# قبول النسخة الواردة
git checkout --theirs <file>
```

---

## 5. التاريخ والسجلات (History & Logs)

### 5.1 عرض التاريخ

```bash
# عرض التاريخ الأساسي
git log

# عرض مختصر
git log --oneline

# عرض مع الرسم البياني
git log --graph --oneline --all

# عرض آخر 10 commits
git log -10

# عرض commits لمطور محدد
git log --author="اسم المطور"

# عرض commits في فترة زمنية
git log --since="2 weeks ago"
git log --after="2025-11-01" --before="2025-12-01"
```

### 5.2 عرض التغييرات

```bash
# عرض التغييرات غير المضافة
git diff

# عرض التغييرات المضافة
git diff --staged

# عرض التغييرات بين فرعين
git diff main..develop

# عرض التغييرات في ملف محدد
git diff lib/features/customers/customer_repository.dart

# عرض إحصائيات التغييرات
git diff --stat
```

### 5.3 البحث في التاريخ

```bash
# البحث عن كلمة في التاريخ
git log -S "searchTerm"

# البحث عن رسالة commit
git log --grep="customer"

# عرض من غيّر سطر محدد
git blame lib/features/customers/customer_repository.dart

# عرض تاريخ ملف
git log --follow lib/features/customers/customer_repository.dart
```

---

## 6. التراجع والإصلاح (Undo & Fix)

### 6.1 التراجع عن التغييرات

```bash
# التراجع عن تغييرات غير مضافة
git checkout -- <file>
# أو
git restore <file>

# التراجع عن جميع التغييرات غير المضافة
git checkout -- .
# أو
git restore .

# إزالة ملف من staging
git reset HEAD <file>
# أو
git restore --staged <file>
```

### 6.2 التراجع عن Commits

```bash
# التراجع عن آخر commit (مع الاحتفاظ بالتغييرات)
git reset --soft HEAD~1

# التراجع عن آخر commit (بدون الاحتفاظ بالتغييرات)
git reset --hard HEAD~1

# التراجع عن عدة commits
git reset --soft HEAD~3

# إنشاء commit عكسي
git revert HEAD

# التراجع عن commit محدد
git revert <commit-hash>
```

### 6.3 تنظيف المشروع

```bash
# عرض الملفات التي سيتم حذفها
git clean -n

# حذف الملفات غير المتتبعة
git clean -f

# حذف المجلدات أيضاً
git clean -fd

# حذف الملفات المتجاهلة أيضاً
git clean -fdx
```

---

## 7. GitHub Operations

### 7.1 إنشاء Pull Request

#### من سطر الأوامر

```bash
# دفع الفرع
git push -u origin feature/customer-search

# ثم افتح GitHub وأنشئ PR
# أو استخدم GitHub CLI
gh pr create --title "Add customer search feature" \
             --body "Description of changes"
```

#### من واجهة GitHub

1. اذهب إلى المستودع على GitHub
2. اضغط "Pull requests"
3. اضغط "New pull request"
4. اختر الفروع (base ← compare)
5. اضغط "Create pull request"
6. املأ العنوان والوصف
7. اضغط "Create pull request"

### 7.2 مراجعة Pull Request

```bash
# سحب PR محلياً
gh pr checkout 123

# أو يدوياً
git fetch origin pull/123/head:pr-123
git checkout pr-123

# اختبار التغييرات
flutter test

# إضافة تعليق
gh pr comment 123 --body "Looks good!"

# الموافقة
gh pr review 123 --approve

# طلب تعديلات
gh pr review 123 --request-changes --body "Please fix..."
```

### 7.3 دمج Pull Request

```bash
# دمج عبر GitHub CLI
gh pr merge 123

# خيارات الدمج
gh pr merge 123 --merge      # merge commit
gh pr merge 123 --squash     # squash commits
gh pr merge 123 --rebase     # rebase

# حذف الفرع بعد الدمج
gh pr merge 123 --delete-branch
```

### 7.4 Issues

```bash
# إنشاء issue
gh issue create --title "Bug: Customer search not working" \
                --body "Description of the bug"

# عرض جميع issues
gh issue list

# عرض issue محدد
gh issue view 456

# إغلاق issue
gh issue close 456

# إعادة فتح issue
gh issue reopen 456
```

---

## 8. GitHub Actions

### 8.1 عرض Workflows

```bash
# عرض جميع workflows
gh workflow list

# عرض runs لـ workflow محدد
gh run list --workflow=analysis.yml

# عرض تفاصيل run
gh run view 789
```

### 8.2 تشغيل Workflows

```bash
# تشغيل workflow يدوياً
gh workflow run analysis.yml

# تشغيل مع inputs
gh workflow run analysis.yml -f environment=production
```

### 8.3 عرض Logs

```bash
# عرض logs لـ run
gh run view 789 --log

# تحميل logs
gh run download 789
```

---

## 9. العمليات المتقدمة

### 9.1 Stash (الحفظ المؤقت)

```bash
# حفظ التغييرات مؤقتاً
git stash

# حفظ مع رسالة
git stash save "WIP: customer search feature"

# عرض جميع stashes
git stash list

# تطبيق آخر stash
git stash apply

# تطبيق stash محدد
git stash apply stash@{2}

# تطبيق وحذف
git stash pop

# حذف stash
git stash drop stash@{0}

# حذف جميع stashes
git stash clear
```

### 9.2 Cherry-pick

```bash
# تطبيق commit محدد على الفرع الحالي
git cherry-pick <commit-hash>

# تطبيق عدة commits
git cherry-pick <commit1> <commit2>

# تطبيق مع تعديل الرسالة
git cherry-pick <commit-hash> --edit
```

### 9.3 Submodules

```bash
# إضافة submodule
git submodule add https://github.com/user/repo.git path/to/submodule

# تحديث submodules
git submodule update --init --recursive

# سحب تحديثات submodules
git submodule update --remote

# حذف submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
```

### 9.4 Tags

```bash
# إنشاء tag
git tag v1.0.0

# إنشاء annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# عرض جميع tags
git tag

# دفع tag
git push origin v1.0.0

# دفع جميع tags
git push --tags

# حذف tag محلي
git tag -d v1.0.0

# حذف tag بعيد
git push origin --delete v1.0.0
```

---

## 10. استكشاف الأخطاء وإصلاحها

### 10.1 مشاكل الاتصال

#### المشكلة: Permission denied (publickey)

```bash
# الحل: التحقق من SSH key
ssh -T git@github.com

# إذا فشل، أضف SSH key
ssh-add ~/.ssh/id_ed25519

# أو أنشئ key جديد
ssh-keygen -t ed25519 -C "your.email@example.com"
```

#### المشكلة: Could not resolve host

```bash
# الحل: التحقق من الاتصال بالإنترنت
ping github.com

# التحقق من DNS
nslookup github.com

# استخدام HTTPS بدلاً من SSH
git remote set-url origin https://github.com/user/repo.git
```

### 10.2 مشاكل الدمج

#### المشكلة: Merge conflict

```bash
# الحل: حل التعارضات يدوياً
# راجع قسم "حل التعارضات" أعلاه

# أو إلغاء الدمج
git merge --abort
```

#### المشكلة: Diverged branches

```bash
# الحل: rebase أو merge
git pull --rebase origin main

# أو
git pull origin main
```

### 10.3 مشاكل الأداء

#### المشكلة: Git operations are slow

```bash
# الحل: تنظيف المستودع
git gc --aggressive --prune=now

# ضغط قاعدة البيانات
git repack -a -d --depth=250 --window=250

# تحديث index
git update-index --refresh
```

#### المشكلة: Large repository

```bash
# الحل: استنساخ جزئي
git clone --depth 1 https://github.com/user/repo.git

# أو استنساخ فرع واحد
git clone --single-branch --branch main https://github.com/user/repo.git
```

### 10.4 استعادة البيانات

#### المشكلة: Deleted commit by mistake

```bash
# الحل: استخدام reflog
git reflog

# استعادة commit
git reset --hard <commit-hash>
```

#### المشكلة: Deleted branch by mistake

```bash
# الحل: استخدام reflog
git reflog

# إنشاء الفرع مرة أخرى
git branch recovered-branch <commit-hash>
```

---

## 11. أفضل الممارسات

### 11.1 Commit Messages

#### ✅ جيد

```bash
feat(customers): add customer search with filters

- Add search by name
- Add search by phone
- Add date range filter
- Add status filter

Closes #123
```

#### ❌ سيء

```bash
update code
fix bug
changes
```

### 11.2 Branch Naming

#### ✅ جيد

```bash
feature/customer-search
fix/invoice-calculation-bug
hotfix/security-vulnerability
refactor/auth-service
```

#### ❌ سيء

```bash
new-feature
fix
my-branch
test
```

### 11.3 Pull Requests

#### ✅ جيد

- عنوان واضح ومحدد
- وصف مفصل للتغييرات
- ربط بـ issues ذات صلة
- screenshots للتغييرات في UI
- checklist للمراجعة

#### ❌ سيء

- عنوان غامض
- بدون وصف
- تغييرات كثيرة جداً
- بدون اختبارات

### 11.4 Code Review

#### ✅ افعل

- راجع الكود بعناية
- اختبر التغييرات محلياً
- قدم ملاحظات بناءة
- اقترح تحسينات
- وافق فقط إذا كنت متأكداً

#### ❌ لا تفعل

- لا توافق بدون مراجعة
- لا تكن قاسياً في التعليقات
- لا تتجاهل المعايير
- لا تؤخر المراجعة

---

## 12. الأوامر السريعة

### 12.1 الإعداد

```bash
# إعداد سريع
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor "code --wait"
```

### 12.2 العمليات اليومية

```bash
# سير عمل يومي
git checkout -b feature/new-feature
# ... عمل على الكود ...
git add .
git commit -m "feat: add new feature"
git push -u origin feature/new-feature
```

### 12.3 التنظيف

```bash
# تنظيف شامل
git fetch --prune
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
git gc --aggressive --prune=now
```

### 12.4 الطوارئ

```bash
# التراجع السريع
git reset --hard HEAD~1
git push --force-with-lease

# استعادة سريعة
git reflog
git reset --hard <commit-hash>
```

---

## 13. الموارد والمراجع

### الوثائق الرسمية

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Docs](https://docs.github.com/)
- [GitHub CLI](https://cli.github.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)

### الأدوات المفيدة

- [GitKraken](https://www.gitkraken.com/) - Git GUI
- [SourceTree](https://www.sourcetreeapp.com/) - Git GUI
- [GitHub Desktop](https://desktop.github.com/) - GitHub GUI
- [Git Extensions](https://gitextensions.github.io/) - Git GUI

### الدورات والتعليم

- [Git Handbook](https://guides.github.com/introduction/git-handbook/)
- [GitHub Learning Lab](https://lab.github.com/)
- [Pro Git Book](https://git-scm.com/book/en/v2)

---

## 14. سجل التحديثات

### الإصدار 1.0 (5 ديسمبر 2025)

- ✅ الدليل الشامل الأول
- ✅ جميع العمليات الأساسية
- ✅ العمليات المتقدمة
- ✅ استكشاف الأخطاء وإصلاحها
- ✅ أفضل الممارسات
- ✅ أمثلة عملية

### التحديثات المخططة

- 📋 إضافة أمثلة فيديو
- 📋 إضافة سيناريوهات متقدمة
- 📋 إضافة تكامل مع أدوات CI/CD
- 📋 إضافة أمثلة لـ Git workflows

---

**تم إعداد هذا الدليل بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 5 ديسمبر 2025  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد

**للأسئلة والاستفسارات:** راجع قسم استكشاف الأخطاء وإصلاحها أو اسأل الفريق
