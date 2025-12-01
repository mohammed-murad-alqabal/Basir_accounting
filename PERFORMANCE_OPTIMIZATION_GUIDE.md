# دليل تحسين الأداء والسرعة

**المشروع:** بصير MVP  
**التاريخ:** 1 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ نشط

---

## 🎯 المشاكل المحددة

### 1. بطء في تنفيذ الأوامر

### 2. بطء في محرر الأكواد

### 3. بطء في سطر الأوامر

### 4. بطء في التعامل مع المستودع البعيد (GitHub)

---

## 📊 التحليل الحالي

### حالة المستودع

- **حجم .git:** 4.7 MB (ممتاز ✅)
- **عدد الكائنات:** 1,890 (طبيعي ✅)
- **المساحة المتاحة:** 241 GB (ممتاز ✅)
- **Flutter:** 3.35.5 (محدث ✅)

### المشاكل المحتملة

1. ⚠️ عدم وجود تكوين HTTP/HTTPS لـ Git
2. ⚠️ عدم تفعيل Git cache
3. ⚠️ عدم تحسين إعدادات Flutter
4. ⚠️ عدم تحسين إعدادات المحرر

---

## 🔧 الحلول السريعة (Quick Fixes)

### 1. تحسين Git Performance

```bash
# تفعيل Git cache للمصادقة
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

# تحسين أداء Git
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
git config --global pack.threads 0

# تحسين HTTP/HTTPS
git config --global http.postBuffer 524288000
git config --global http.maxRequestBuffer 100M
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 999999

# تفعيل الضغط
git config --global core.compression 9
git config --global core.looseCompression 9
```

### 2. تحسين Flutter Performance

```bash
# تنظيف Flutter cache
flutter clean

# تحديث Flutter
flutter upgrade

# تفعيل Dart VM optimizations
export DART_VM_OPTIONS="--old_gen_heap_size=4096"

# تحسين pub cache
flutter pub cache repair
```

### 3. تحسين VS Code / IDE

إضافة إلى `.vscode/settings.json`:

```json
{
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/**": true,
    "**/.dart_tool/**": true,
    "**/build/**": true,
    "**/.pub-cache/**": true
  },
  "search.exclude": {
    "**/.dart_tool": true,
    "**/build": true,
    "**/.pub-cache": true
  },
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.previewLsp": true,
  "dart.analysisServerFolding": false,
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  }
}
```

### 4. تحسين Bash/Shell Performance

إضافة إلى `~/.bashrc` أو `~/.zshrc`:

```bash
# Git aliases للسرعة
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# Flutter aliases
alias fl='flutter'
alias flr='flutter run'
alias flt='flutter test'
alias fla='flutter analyze'
alias flc='flutter clean'

# تحسين history
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups

# تفعيل completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
```

---

## 🚀 الحلول المتقدمة

### 1. تحسين GitHub Connection

#### أ. استخدام SSH بدلاً من HTTPS

```bash
# توليد SSH key
ssh-keygen -t ed25519 -C "team@basser.local"

# إضافة المفتاح إلى ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# عرض المفتاح العام لإضافته إلى GitHub
cat ~/.ssh/id_ed25519.pub
```

**الخطوات:**

1. انسخ المفتاح العام
2. اذهب إلى GitHub → Settings → SSH Keys
3. أضف المفتاح الجديد
4. غيّر remote URL:

```bash
git remote set-url origin git@github.com:mohammed-murad-alqabal/Basser_MVP.git
```

#### ب. تحسين SSH Config

أنشئ `~/.ssh/config`:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    Compression yes
    TCPKeepAlive yes
    ServerAliveInterval 60
    ServerAliveCountMax 10
```

### 2. تحسين Flutter Build Performance

```bash
# استخدام Gradle daemon
echo "org.gradle.daemon=true" >> android/gradle.properties
echo "org.gradle.parallel=true" >> android/gradle.properties
echo "org.gradle.configureondemand=true" >> android/gradle.properties
echo "org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8" >> android/gradle.properties
```

### 3. تحسين Dart Analysis

أنشئ/عدّل `analysis_options.yaml`:

```yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  errors:
    missing_required_param: error
    missing_return: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/generated/**"
    - "build/**"
    - ".dart_tool/**"
```

### 4. تنظيف المستودع

```bash
# تنظيف الملفات غير المتتبعة
git clean -fd

# تحسين المستودع
git gc --aggressive --prune=now

# إعادة بناء الفهرس
git update-index --refresh

# فحص وإصلاح المستودع
git fsck --full
```

---

## 📝 سكريبت تحسين شامل

أنشئ ملف `optimize_environment.sh`:

```bash
#!/bin/bash

echo "🚀 بدء تحسين بيئة التطوير..."

# 1. تحسين Git
echo "📦 تحسين Git..."
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
git config --global pack.threads 0
git config --global http.postBuffer 524288000
git config --global core.compression 9
git config --global credential.helper 'cache --timeout=3600'

# 2. تنظيف Flutter
echo "🧹 تنظيف Flutter..."
flutter clean
flutter pub cache repair

# 3. تنظيف Git
echo "🗑️ تنظيف Git..."
git gc --aggressive --prune=now
git update-index --refresh

# 4. تحديث Flutter
echo "⬆️ تحديث Flutter..."
flutter upgrade

echo "✅ تم التحسين بنجاح!"
echo ""
echo "📊 الإحصائيات:"
echo "- حجم .git: $(du -sh .git | cut -f1)"
echo "- Flutter: $(flutter --version | head -1)"
echo "- Git: $(git --version)"
```

تشغيل السكريبت:

```bash
chmod +x optimize_environment.sh
./optimize_environment.sh
```

---

## 🔍 تشخيص المشاكل

### اختبار سرعة Git

```bash
# قياس وقت git status
time git status

# قياس وقت git fetch
time git fetch --dry-run

# قياس وقت git pull
time git pull --dry-run
```

### اختبار سرعة Flutter

```bash
# قياس وقت flutter analyze
time flutter analyze

# قياس وقت flutter test
time flutter test --no-pub

# قياس وقت flutter build
time flutter build apk --debug
```

### اختبار سرعة الشبكة

```bash
# اختبار الاتصال بـ GitHub
ping -c 5 github.com

# اختبار سرعة التحميل
curl -o /dev/null -s -w "Time: %{time_total}s\n" https://github.com
```

---

## 📈 مقاييس الأداء المستهدفة

| العملية           | الوقت الحالي | الهدف  | الحالة |
| :---------------- | :----------- | :----- | :----- |
| `git status`      | ؟            | < 0.5s | 🔄     |
| `git pull`        | ؟            | < 2s   | 🔄     |
| `flutter analyze` | ؟            | < 10s  | 🔄     |
| `flutter test`    | ؟            | < 30s  | 🔄     |
| IDE startup       | ؟            | < 5s   | 🔄     |

---

## 🛠️ أدوات المراقبة

### 1. مراقبة Git Performance

```bash
# تفعيل Git tracing
export GIT_TRACE=1
export GIT_TRACE_PERFORMANCE=1
export GIT_TRACE_SETUP=1

# تشغيل أمر Git
git status

# إيقاف tracing
unset GIT_TRACE GIT_TRACE_PERFORMANCE GIT_TRACE_SETUP
```

### 2. مراقبة Flutter Performance

```bash
# تفعيل verbose mode
flutter analyze --verbose

# مراقبة pub cache
flutter pub cache list
```

### 3. مراقبة النظام

```bash
# استخدام CPU
top -bn1 | grep "Cpu(s)"

# استخدام الذاكرة
free -h

# استخدام القرص
df -h

# العمليات النشطة
ps aux | grep -E "(flutter|dart|git)"
```

---

## 🎯 خطة التنفيذ

### المرحلة 1: التحسينات الفورية (5 دقائق)

```bash
# تشغيل سكريبت التحسين
./optimize_environment.sh
```

### المرحلة 2: التحسينات المتوسطة (15 دقيقة)

1. إعداد SSH لـ GitHub
2. تحديث إعدادات VS Code
3. إضافة aliases إلى shell

### المرحلة 3: التحسينات المتقدمة (30 دقيقة)

1. تحسين Gradle
2. تحسين Dart Analysis
3. إعداد monitoring tools

---

## 📞 الدعم والمساعدة

### إذا استمرت المشاكل

1. **فحص الشبكة:**

   ```bash
   ping -c 10 github.com
   traceroute github.com
   ```

2. **فحص DNS:**

   ```bash
   nslookup github.com
   dig github.com
   ```

3. **فحص Firewall:**

   ```bash
   sudo iptables -L
   ```

4. **فحص Proxy:**
   ```bash
   echo $http_proxy
   echo $https_proxy
   ```

---

## ✅ قائمة التحقق

### قبل البدء

- [ ] نسخ احتياطي للمشروع
- [ ] إغلاق جميع التطبيقات غير الضرورية
- [ ] التأكد من الاتصال بالإنترنت

### بعد التحسين

- [ ] اختبار git status
- [ ] اختبار git pull
- [ ] اختبار flutter analyze
- [ ] اختبار flutter test
- [ ] اختبار IDE performance

---

## 📚 موارد إضافية

- [Git Performance Tips](https://git-scm.com/docs/git-config#_performance)
- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [VS Code Performance](https://code.visualstudio.com/docs/setup/setup-overview#_performance)

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 1 ديسمبر 2025  
**الحالة:** ✅ جاهز للتطبيق
