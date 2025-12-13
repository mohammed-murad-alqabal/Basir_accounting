# التحسينات الحرجة - نظام تتبع الأخطاء

**المشروع:** بصير MVP  
**التاريخ:** 5 ديسمبر 2025  
**الأولوية:** 🔴 حرجة  
**الحالة:** 📋 قيد الانتظار

---

## 🎯 الهدف

تطبيق التحسينات الحرجة على نظام تتبع الأخطاء لضمان الموثوقية والأداء الأمثل.

---

## 🔴 التحسينات الحرجة (يجب تطبيقها فوراً)

### 1. فحص مساحة القرص

**الملف:** `scripts/collect_logs.sh`  
**السطر:** قبل `create_directories()`  
**الجهد:** 30 دقيقة

```bash
# إضافة هذه الدالة
check_disk_space() {
    local available=$(df -BM "$LOGS_DIR" 2>/dev/null | tail -1 | awk '{print $4}' | sed 's/M//')

    if [ -z "$available" ]; then
        print_warning "تعذر التحقق من مساحة القرص"
        return 0
    fi

    if [ "$available" -lt 100 ]; then
        print_error "مساحة القرص منخفضة: ${available}MB (الحد الأدنى: 100MB)"
        print_info "يرجى تشغيل: ./scripts/archive_logs.sh"
        return 1
    fi

    print_success "مساحة القرص كافية: ${available}MB"
    return 0
}

# استدعاؤها في main()
main() {
    # ... معالجة المعاملات ...

    # التحقق من المتطلبات
    check_command flutter
    check_command git

    # التحقق من مساحة القرص
    if ! check_disk_space; then
        exit 1
    fi

    # إنشاء المجلدات
    create_directories

    # ... بقية الكود ...
}
```

**الفائدة:**

- ✅ منع فشل العمليات بسبب امتلاء القرص
- ✅ تنبيه مبكر للمستخدم
- ✅ توجيه واضح للحل

---

### 2. التحقق من سلامة الملفات المضغوطة

**الملف:** `scripts/archive_logs.sh`  
**الدالة:** `compress_archive()`  
**الجهد:** 20 دقيقة

```bash
compress_archive() {
    local archive_size=$(get_archive_size_mb)

    print_message "$YELLOW" "📊 حجم الأرشيف الحالي: ${archive_size} MB"

    if [ $archive_size -gt $MAX_ARCHIVE_SIZE_MB ]; then
        print_message "$YELLOW" "🗜️  جاري ضغط الأرشيف..."

        local timestamp=$(date +%Y-%m-%d_%H-%M-%S)
        local archive_file="logs/archive_${timestamp}.${COMPRESSION_FORMAT}"

        # ضغط جميع ملفات السجلات في الأرشيف
        if tar -czf "$archive_file" -C "$ARCHIVE_DIR" . 2>/dev/null; then
            # ✅ إضافة: التحقق من سلامة الملف المضغوط
            print_message "$YELLOW" "🔍 التحقق من سلامة الملف المضغوط..."

            if tar -tzf "$archive_file" > /dev/null 2>&1; then
                # حساب حجم الملف المضغوط
                local compressed_size=$(du -h "$archive_file" | cut -f1)
                local original_size="${archive_size}M"

                # حذف الملفات الأصلية بعد التحقق من سلامة الضغط
                rm -f "$ARCHIVE_DIR"/*.log 2>/dev/null

                print_message "$GREEN" "✅ تم ضغط الأرشيف بنجاح"
                print_message "$GREEN" "  📦 الملف المضغوط: $archive_file"
                print_message "$GREEN" "  📏 الحجم الأصلي: $original_size"
                print_message "$GREEN" "  📏 الحجم المضغوط: $compressed_size"
                print_message "$GREEN" "  ✓ تم التحقق من سلامة الملف"

                return 0
            else
                # ✅ إضافة: معالجة فشل التحقق
                print_message "$RED" "❌ الملف المضغوط تالف!"
                print_message "$YELLOW" "⚠️  سيتم حذف الملف التالف والاحتفاظ بالملفات الأصلية"
                rm -f "$archive_file"
                return 1
            fi
        else
            print_message "$RED" "❌ فشل ضغط الأرشيف"
            return 1
        fi
    else
        print_message "$GREEN" "✅ حجم الأرشيف ضمن الحد المسموح (${MAX_ARCHIVE_SIZE_MB} MB)"
        return 0
    fi
}
```

**الفائدة:**

- ✅ منع فقدان البيانات
- ✅ اكتشاف الملفات التالفة مبكراً
- ✅ الاحتفاظ بالملفات الأصلية في حالة الفشل

---

### 3. إضافة Timeout للعمليات

**الملف:** `scripts/hooks/pre-commit`  
**الموقع:** في جميع عمليات flutter  
**الجهد:** 15 دقيقة

```bash
# في بداية الملف، إضافة دالة timeout
run_with_timeout() {
    local timeout_seconds=$1
    shift
    local command="$@"

    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" $command
        local exit_code=$?

        if [ $exit_code -eq 124 ]; then
            print_error "تجاوزت العملية الوقت المحدد (${timeout_seconds} ثانية)"
            return 124
        fi

        return $exit_code
    else
        # fallback إذا لم يكن timeout متوفراً
        $command
        return $?
    fi
}

# استخدامها في فحص التنسيق
if [ -n "$DART_FILES" ]; then
    # فحص التنسيق مع timeout
    if ! run_with_timeout 30 flutter format --set-exit-if-changed $DART_FILES > /dev/null 2>&1; then
        if [ $? -eq 124 ]; then
            print_error "تجاوز flutter format الوقت المحدد"
            exit 1
        fi

        if [ "$AUTO_FORMAT" = "true" ]; then
            print_warning "⚠️  الكود غير منسق. جاري التنسيق التلقائي..."

            if ! run_with_timeout 30 flutter format $DART_FILES; then
                print_error "فشل التنسيق التلقائي"
                exit 1
            fi

            git add $DART_FILES
            print_success "✅ تم تنسيق الكود تلقائياً"
        else
            print_error "❌ الكود غير منسق. يرجى تشغيل: flutter format ."
            exit 1
        fi
    else
        print_success "✅ التنسيق صحيح"
    fi
fi

# استخدامها في التحليل الثابت
print_info "🔬 تشغيل التحليل الثابت..."

ANALYZE_OUTPUT=$(run_with_timeout 60 flutter analyze --no-pub 2>&1)
ANALYZE_EXIT_CODE=$?

if [ $ANALYZE_EXIT_CODE -eq 124 ]; then
    print_error "تجاوز flutter analyze الوقت المحدد (60 ثانية)"
    exit 1
fi
```

**الفائدة:**

- ✅ منع تعليق العمليات
- ✅ تجربة مستخدم أفضل
- ✅ اكتشاف المشاكل مبكراً

---

### 4. منع Issues المكررة

**الملف:** `.github/workflows/create-issue.yml`  
**الموقع:** قبل `github.rest.issues.create`  
**الجهد:** 1 ساعة

```yaml
- name: Create Issue for Critical Errors
  if: steps.parse.outputs.errors > 0
  uses: actions/github-script@v7
  with:
    script: |
      const fs = require('fs');
      const errors = '${{ steps.parse.outputs.errors }}';
      const warnings = '${{ steps.parse.outputs.warnings }}';

      let errorDetails = '';
      try {
        errorDetails = fs.readFileSync('errors.txt', 'utf8');
      } catch (e) {
        errorDetails = 'لم يتم العثور على تفاصيل الأخطاء';
      }

      // ✅ إضافة: التحقق من Issues المكررة
      console.log('🔍 البحث عن Issues مشابهة...');

      const { data: existingIssues } = await github.rest.issues.listForRepo({
        owner: context.repo.owner,
        repo: context.repo.repo,
        state: 'open',
        labels: 'automated,critical',
        per_page: 100
      });

      // البحث عن issue مشابه (نفس اليوم)
      const today = new Date().toISOString().split('T')[0];
      const similarIssue = existingIssues.find(issue => {
        const issueDate = issue.created_at.split('T')[0];
        return issue.title.includes('أخطاء حرجة') && issueDate === today;
      });

      const issueBody = `## 🔴 أخطاء حرجة في التحليل

**التاريخ:** ${new Date().toLocaleString('ar-SA')}
**Workflow Run:** [#${{ github.event.workflow_run.id }}](${{ github.event.workflow_run.html_url }})
**Branch:** ${{ github.event.workflow_run.head_branch }}
**Commit:** ${{ github.event.workflow_run.head_sha }}

### 📊 الملخص

- **أخطاء:** ${errors}
- **تحذيرات:** ${warnings}

### 🔍 تفاصيل الأخطاء

\`\`\`
${errorDetails}
\`\`\`

### 📝 الإجراءات المطلوبة

- [ ] مراجعة الأخطاء المذكورة أعلاه
- [ ] إصلاح الأخطاء الحرجة
- [ ] تشغيل \`flutter analyze\` محلياً للتحقق
- [ ] إنشاء PR مع الإصلاحات

### 🔗 الموارد

- [تقرير التحليل الكامل](https://github.com/${{ github.repository }}/actions/runs/${{ github.event.workflow_run.id }})
- [دليل الجودة](../../../.kiro/steering/technologies/project-standards.md)

---

**تم إنشاؤه تلقائياً بواسطة:** GitHub Actions
**Label:** \`automated\`, \`bug\`, \`critical\`
`;

      if (similarIssue) {
        // ✅ تحديث Issue الموجود
        console.log(`✅ تم العثور على Issue مشابه: #${similarIssue.number}`);
        console.log('📝 سيتم إضافة تعليق بدلاً من إنشاء issue جديد');

        await github.rest.issues.createComment({
          owner: context.repo.owner,
          repo: context.repo.repo,
          issue_number: similarIssue.number,
          body: `## 🔄 تحديث: ${new Date().toLocaleString('ar-SA')}

تم اكتشاف أخطاء حرجة جديدة في [Workflow Run #${{ github.event.workflow_run.id }}](${{ github.event.workflow_run.html_url }})

### 📊 الملخص الجديد

- **أخطاء:** ${errors}
- **تحذيرات:** ${warnings}

### 🔍 التفاصيل

\`\`\`
${errorDetails}
\`\`\`

---

**Branch:** ${{ github.event.workflow_run.head_branch }}
**Commit:** ${{ github.event.workflow_run.head_sha }}
`
        });

        // إضافة label إذا لم يكن موجوداً
        await github.rest.issues.addLabels({
          owner: context.repo.owner,
          repo: context.repo.repo,
          issue_number: similarIssue.number,
          labels: ['needs-attention']
        });

      } else {
        // ✅ إنشاء Issue جديد
        console.log('📝 لم يتم العثور على Issues مشابهة، سيتم إنشاء issue جديد');

        await github.rest.issues.create({
          owner: context.repo.owner,
          repo: context.repo.repo,
          title: `🔴 أخطاء حرجة: ${errors} خطأ في التحليل`,
          body: issueBody,
          labels: ['automated', 'bug', 'critical', 'code-quality']
        });
      }
```

**الفائدة:**

- ✅ تقليل الضوضاء في Issues
- ✅ تجميع الأخطاء المتعلقة
- ✅ سهولة المتابعة

---

## 📋 قائمة التحقق السريعة

### قبل التطبيق

- [ ] قراءة التحسينات المقترحة بالكامل
- [ ] فهم الكود الحالي
- [ ] إنشاء backup للملفات الأصلية
- [ ] إنشاء فرع جديد للتحسينات

```bash
git checkout -b feature/critical-improvements
```

### أثناء التطبيق

- [ ] تطبيق التحسين 1: فحص مساحة القرص
- [ ] اختبار التحسين 1 محلياً
- [ ] تطبيق التحسين 2: التحقق من الضغط
- [ ] اختبار التحسين 2 محلياً
- [ ] تطبيق التحسين 3: Timeout
- [ ] اختبار التحسين 3 محلياً
- [ ] تطبيق التحسين 4: منع التكرار
- [ ] اختبار التحسين 4 (يحتاج GitHub)

### بعد التطبيق

- [ ] تشغيل جميع الاختبارات

```bash
./test/run_all_tests.sh
```

- [ ] تشغيل السكريبتات يدوياً

```bash
./scripts/collect_logs.sh
./scripts/archive_logs.sh
./scripts/generate_report.sh
```

- [ ] التحقق من Git Hooks

```bash
# اختبار pre-commit
git add .
git commit -m "test: verify pre-commit hook"

# اختبار pre-push (بدون push فعلي)
git push --dry-run
```

- [ ] إنشاء PR
- [ ] مراجعة الكود
- [ ] دمج التحسينات

---

## 🧪 سيناريوهات الاختبار

### 1. فحص مساحة القرص

```bash
# محاكاة مساحة منخفضة (للاختبار فقط)
# لا تنفذ هذا على نظام إنتاج!

# اختبار 1: مساحة كافية
./scripts/collect_logs.sh
# المتوقع: ✅ مساحة القرص كافية

# اختبار 2: مساحة منخفضة (محاكاة)
# عدّل الدالة مؤقتاً لإرجاع قيمة منخفضة
# المتوقع: ❌ مساحة القرص منخفضة
```

### 2. التحقق من الضغط

```bash
# اختبار 1: ضغط ناجح
./scripts/archive_logs.sh
# المتوقع: ✅ تم ضغط الأرشيف بنجاح + ✓ تم التحقق من سلامة الملف

# اختبار 2: ملف تالف (محاكاة)
# أنشئ ملف tar.gz تالف يدوياً
echo "corrupted" > logs/test_corrupted.tar.gz
# ثم حاول استخراجه
tar -tzf logs/test_corrupted.tar.gz
# المتوقع: خطأ
```

### 3. Timeout

```bash
# اختبار 1: عملية عادية
git add .
git commit -m "test: normal operation"
# المتوقع: نجاح خلال الوقت المحدد

# اختبار 2: عملية بطيئة (محاكاة)
# عدّل timeout مؤقتاً إلى 1 ثانية
# المتوقع: ❌ تجاوزت العملية الوقت المحدد
```

### 4. منع التكرار

```bash
# اختبار 1: Issue جديد
# قم بإنشاء أخطاء وادفع
# المتوقع: إنشاء Issue جديد

# اختبار 2: Issue موجود
# قم بإنشاء أخطاء مرة أخرى في نفس اليوم
# المتوقع: تعليق على Issue الموجود
```

---

## ⏱️ الجدول الزمني المقترح

### اليوم 1 (3 ساعات)

- **09:00 - 09:30**: إنشاء فرع وbackup
- **09:30 - 10:00**: تطبيق التحسين 1 (فحص مساحة القرص)
- **10:00 - 10:30**: اختبار التحسين 1
- **10:30 - 10:50**: تطبيق التحسين 2 (التحقق من الضغط)
- **10:50 - 11:20**: اختبار التحسين 2
- **11:20 - 11:35**: تطبيق التحسين 3 (Timeout)
- **11:35 - 12:00**: اختبار التحسين 3

### اليوم 2 (2 ساعة)

- **09:00 - 10:00**: تطبيق التحسين 4 (منع التكرار)
- **10:00 - 10:30**: اختبار شامل لجميع التحسينات
- **10:30 - 11:00**: إنشاء PR ومراجعة

---

## 📞 الدعم

إذا واجهت أي مشاكل أثناء التطبيق:

1. **راجع الكود الأصلي** - تأكد من فهم السياق
2. **راجع التقرير الشامل** - `ERROR_TRACKING_SYSTEM_REVIEW.md`
3. **اختبر بشكل تدريجي** - لا تطبق كل شيء مرة واحدة
4. **احتفظ بbackup** - يمكنك الرجوع دائماً

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 5 ديسمبر 2025  
**الأولوية:** 🔴 حرجة  
**الحالة:** 📋 جاهز للتطبيق

**ابدأ الآن:** اتبع قائمة التحقق السريعة أعلاه
