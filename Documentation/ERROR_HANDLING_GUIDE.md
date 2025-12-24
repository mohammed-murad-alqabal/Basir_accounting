# دليل معالجة الأخطاء الشاملة

**المشروع:** بصير MVP  
**التاريخ:** 6 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.0  
**الحالة:** ✅ نشط ومعتمد

---

## نظرة عامة

هذا الدليل يشرح كيفية استخدام مكتبة معالجة الأخطاء الشاملة (`error_handler.sh`) في جميع سكريبتات نظام تتبع الأخطاء والسجلات.

---

## المحتويات

1. [التحميل والإعداد](#التحميل-والإعداد)
2. [دوال الطباعة الملونة](#دوال-الطباعة-الملونة)
3. [دوال التسجيل](#دوال-التسجيل)
4. [معالجة الأخطاء](#معالجة-الأخطاء)
5. [الاسترداد التلقائي](#الاسترداد-التلقائي)
6. [التحقق والتحقيق](#التحقق-والتحقيق)
7. [التنظيف](#التنظيف)
8. [أمثلة عملية](#أمثلة-عملية)

---

## التحميل والإعداد

### الطريقة الأساسية

```bash
#!/bin/bash

# تحديد مسار السكريبت
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# تحميل مكتبة معالجة الأخطاء
if [ -f "$SCRIPT_DIR/utils/error_handler.sh" ]; then
    source "$SCRIPT_DIR/utils/error_handler.sh"
else
    echo "خطأ: لم يتم العثور على مكتبة معالجة الأخطاء" >&2
    exit 1
fi
```

### مع إعدادات إضافية

```bash
#!/bin/bash

set -o errexit   # الخروج عند أي خطأ
set -o nounset   # الخروج عند استخدام متغير غير معرف
set -o pipefail  # فشل pipeline إذا فشل أي أمر

# تحميل المكتبة
source "$(dirname "$0")/utils/error_handler.sh"
```

---

## دوال الطباعة الملونة

### الدوال المتاحة

| الدالة           | اللون   | الاستخدام     |
| :--------------- | :------ | :------------ |
| `print_debug`    | سماوي   | رسائل التصحيح |
| `print_info`     | أزرق    | معلومات عامة  |
| `print_success`  | أخضر    | عمليات ناجحة  |
| `print_warning`  | أصفر    | تحذيرات       |
| `print_error`    | أحمر    | أخطاء         |
| `print_critical` | أرجواني | أخطاء حرجة    |

### أمثلة

```bash
# رسائل معلوماتية
print_info "بدء تنفيذ السكريبت..."
print_debug "قيمة المتغير: $variable"

# رسائل النجاح
print_success "تم إكمال العملية بنجاح!"

# رسائل التحذير والأخطاء
print_warning "هذا تحذير - قد تحتاج للانتباه"
print_error "حدث خطأ أثناء التنفيذ"
print_critical "خطأ حرج - يجب التدخل الفوري!"
```

---

## دوال التسجيل

### الدوال المتاحة

| الدالة         | المستوى  | الوصف                 |
| :------------- | :------- | :-------------------- |
| `log_debug`    | DEBUG    | تسجيل معلومات التصحيح |
| `log_info`     | INFO     | تسجيل معلومات عامة    |
| `log_warning`  | WARNING  | تسجيل تحذيرات         |
| `log_error`    | ERROR    | تسجيل أخطاء           |
| `log_critical` | CRITICAL | تسجيل أخطاء حرجة      |

### تنسيق السجل

```
[2025-12-06 10:30:45] [INFO] [script_name.sh] رسالة السجل
```

### أمثلة

```bash
# تسجيل معلومات
log_info "بدء معالجة الملفات..."
log_debug "عدد الملفات: $file_count"

# تسجيل تحذيرات وأخطاء
log_warning "الملف غير موجود: $file_path"
log_error "فشل تنفيذ الأمر: $command"
log_critical "فشل حرج في النظام!"
```

### موقع ملف السجل

الموقع الافتراضي: `logs/errors/error_YYYY-MM-DD.log`

يمكن تغييره:

```bash
export ERROR_LOG_FILE="custom/path/error.log"
```

---

## معالجة الأخطاء

### 1. معالج الأخطاء العام

```bash
handle_error exit_code "رسالة الخطأ" [line_number] [function_name]
```

**مثال:**

```bash
if ! some_command; then
    handle_error 1 "فشل تنفيذ some_command" "$LINENO" "${FUNCNAME[0]}"
fi
```

### 2. معالج أخطاء الأوامر

```bash
handle_command_error "command" exit_code "error_output"
```

**مثال:**

```bash
output=$(flutter analyze 2>&1)
exit_code=$?

if [ $exit_code -ne 0 ]; then
    handle_command_error "flutter analyze" $exit_code "$output"
fi
```

**الاقتراحات التلقائية:**

- كود 1: تحقق من صحة المعاملات
- كود 2: تحقق من الصلاحيات
- كود 126: تحقق من صلاحيات التنفيذ
- كود 127: الأمر غير موجود

### 3. معالج أخطاء الملفات

```bash
handle_file_error "operation" "file_path" "error_message"
```

**العمليات المدعومة:**

- `read` - قراءة ملف
- `write` - كتابة ملف
- `delete` - حذف ملف
- `create` - إنشاء ملف

**مثال:**

```bash
if [ ! -f "$config_file" ]; then
    handle_file_error "read" "$config_file" "الملف غير موجود"
fi
```

### 4. معالج أخطاء الشبكة

```bash
handle_network_error "operation" "url" "error_code"
```

**مثال:**

```bash
if ! curl -f "$url" > /dev/null 2>&1; then
    handle_network_error "download" "$url" "timeout"
fi
```

---

## الاسترداد التلقائي

### 1. إعادة المحاولة التلقائية

```bash
retry_command max_attempts delay "command"
```

**المعاملات:**

- `max_attempts`: عدد المحاولات (افتراضي: 3)
- `delay`: التأخير بين المحاولات بالثواني (افتراضي: 2)
- `command`: الأمر المراد تنفيذه

**مثال:**

```bash
# محاولة 3 مرات مع تأخير 2 ثانية
if retry_command 3 2 "curl -f https://example.com"; then
    print_success "نجح الاتصال"
else
    log_error "فشل الاتصال بعد 3 محاولات"
fi
```

### 2. النسخ الاحتياطي

```bash
backup_file "file_path" ["backup_dir"]
```

**مثال:**

```bash
# إنشاء نسخة احتياطية قبل التعديل
if backup_file "config.yml" "backups"; then
    # تعديل الملف بأمان
    echo "new_config" > config.yml
fi
```

### 3. الاستعادة من النسخة الاحتياطية

```bash
restore_backup "backup_path" "target_path"
```

**مثال:**

```bash
# استعادة من نسخة احتياطية
if restore_backup "backups/config.yml.backup.20251206" "config.yml"; then
    print_success "تم استعادة الملف"
fi
```

---

## التحقق والتحقيق

### 1. التحقق من الأوامر

```bash
check_command "command_name"
```

**مثال:**

```bash
# التحقق من المتطلبات
if ! check_command "flutter"; then
    log_error "Flutter غير مثبت"
    exit 1
fi

if ! check_command "git"; then
    log_warning "Git غير مثبت - بعض الميزات قد لا تعمل"
fi
```

### 2. التحقق من الملفات والمجلدات

```bash
check_file "file_path"
check_directory "dir_path"
```

**مثال:**

```bash
# التحقق من البنية
if ! check_directory "logs"; then
    log_info "إنشاء مجلد logs..."
    mkdir -p logs
fi

if check_file "config.yml"; then
    log_info "تحميل التكوين..."
    source config.yml
fi
```

### 3. التحقق من المساحة المتوفرة

```bash
check_disk_space required_mb [path]
```

**مثال:**

```bash
# التحقق من توفر 500MB
if ! check_disk_space 500 "."; then
    log_error "المساحة غير كافية"
    # تنظيف أو أرشفة
    cleanup_old_files
fi
```

### 4. التحقق من صلاحيات الكتابة

```bash
check_write_permission "path"
```

**مثال:**

```bash
if ! check_write_permission "logs"; then
    log_error "لا توجد صلاحيات كتابة في logs"
    exit 1
fi
```

---

## التنظيف

### تنظيف الملفات المؤقتة

```bash
cleanup_temp_files [temp_dir] [pattern]
```

**المعاملات:**

- `temp_dir`: المجلد المؤقت (افتراضي: /tmp)
- `pattern`: نمط الملفات (افتراضي: basser\_\*)

**مثال:**

```bash
# تنظيف في نهاية السكريبت
cleanup_temp_files "/tmp" "my_script_*"
```

---

## أمثلة عملية

### مثال 1: سكريبت بسيط مع معالجة أخطاء

```bash
#!/bin/bash

# تحميل المكتبة
source "$(dirname "$0")/utils/error_handler.sh"

# بدء التنفيذ
print_info "بدء معالجة البيانات..."

# التحقق من المتطلبات
check_command "flutter" || exit 1
check_directory "data" || mkdir -p data

# تنفيذ العملية
if flutter analyze > /dev/null 2>&1; then
    print_success "التحليل نجح!"
else
    log_error "فشل التحليل"
    exit 1
fi

print_info "انتهى السكريبت بنجاح"
```

### مثال 2: سكريبت مع إعادة المحاولة

```bash
#!/bin/bash

source "$(dirname "$0")/utils/error_handler.sh"

print_info "تحميل البيانات من الخادم..."

# محاولة التحميل مع إعادة المحاولة
if retry_command 5 3 "curl -f https://api.example.com/data"; then
    print_success "تم التحميل بنجاح"
else
    log_error "فشل التحميل بعد 5 محاولات"
    exit 1
fi
```

### مثال 3: سكريبت مع نسخ احتياطي

```bash
#!/bin/bash

source "$(dirname "$0")/utils/error_handler.sh"

CONFIG_FILE="config.yml"

print_info "تحديث ملف التكوين..."

# إنشاء نسخة احتياطية
if ! backup_file "$CONFIG_FILE" "backups"; then
    log_error "فشل إنشاء النسخة الاحتياطية"
    exit 1
fi

# تحديث الملف
if ! update_config "$CONFIG_FILE"; then
    log_error "فشل التحديث - استعادة النسخة الاحتياطية"

    # استعادة من النسخة الاحتياطية
    BACKUP=$(ls -t backups/config.yml.backup.* | head -1)
    restore_backup "$BACKUP" "$CONFIG_FILE"
    exit 1
fi

print_success "تم التحديث بنجاح"
```

### مثال 4: سكريبت شامل

```bash
#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# تحميل المكتبة
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/error_handler.sh"

# دالة رئيسية
main() {
    print_info "═══ بدء السكريبت ═══"

    # 1. التحقق من المتطلبات
    print_info "التحقق من المتطلبات..."
    check_command "flutter" || exit 1
    check_command "git" || exit 1
    check_disk_space 100 "." || exit 1

    # 2. إنشاء البنية
    print_info "إنشاء البنية..."
    mkdir -p logs/{archive,errors,reports}

    # 3. تنفيذ العمليات
    print_info "تنفيذ العمليات..."

    if retry_command 3 2 "flutter pub get"; then
        print_success "تم تحميل التبعيات"
    else
        log_error "فشل تحميل التبعيات"
        return 1
    fi

    if flutter analyze > /dev/null 2>&1; then
        print_success "التحليل نجح"
    else
        log_warning "التحليل وجد مشاكل"
    fi

    # 4. التنظيف
    print_info "التنظيف..."
    cleanup_temp_files

    print_success "═══ انتهى السكريبت بنجاح ═══"
    return 0
}

# تنفيذ
main "$@"
exit_code=$?

# طباعة الملخص
print_error_summary

exit $exit_code
```

---

## أفضل الممارسات

### 1. استخدم المستوى المناسب

```bash
# ✅ جيد
log_debug "قيمة المتغير: $var"
log_info "بدء العملية..."
log_warning "الملف غير موجود"
log_error "فشل الأمر"
log_critical "خطأ حرج في النظام"

# ❌ سيء
log_error "بدء العملية..."  # استخدم log_info
log_info "خطأ حرج!"  # استخدم log_critical
```

### 2. أضف سياق للأخطاء

```bash
# ✅ جيد
log_error "فشل تنفيذ flutter analyze في السطر $LINENO"
log_error "الملف غير موجود: $file_path"

# ❌ سيء
log_error "خطأ"
log_error "فشل"
```

### 3. استخدم إعادة المحاولة للعمليات غير المستقرة

```bash
# ✅ جيد - عمليات الشبكة
retry_command 3 2 "curl -f $url"

# ✅ جيد - عمليات قد تفشل مؤقتاً
retry_command 2 1 "git push"

# ❌ سيء - عمليات محلية مستقرة
retry_command 3 2 "ls -la"  # غير ضروري
```

### 4. أنشئ نسخ احتياطية قبل التعديلات الحرجة

```bash
# ✅ جيد
backup_file "$important_file" "backups"
modify_file "$important_file"

# ❌ سيء
modify_file "$important_file"  # بدون نسخة احتياطية
```

### 5. نظف الموارد دائماً

```bash
# ✅ جيد
trap cleanup_temp_files EXIT

# أو في نهاية السكريبت
cleanup_temp_files
```

---

## استكشاف الأخطاء

### المشكلة: المكتبة لا تُحمل

**الحل:**

```bash
# تحقق من المسار
ls -la scripts/utils/error_handler.sh

# تحقق من الصلاحيات
chmod +x scripts/utils/error_handler.sh
```

### المشكلة: لا يتم الكتابة إلى ملف السجل

**الحل:**

```bash
# تحقق من وجود المجلد
mkdir -p logs/errors

# تحقق من الصلاحيات
chmod 755 logs/errors
```

### المشكلة: الألوان لا تظهر

**الحل:**

```bash
# تحقق من دعم الألوان
echo -e "\033[0;31mTest\033[0m"

# أو عطل الألوان
export NO_COLOR=1
```

---

## المرجع السريع

### دوال الطباعة

- `print_debug` - رسائل التصحيح
- `print_info` - معلومات
- `print_success` - نجاح
- `print_warning` - تحذير
- `print_error` - خطأ
- `print_critical` - خطأ حرج

### دوال التسجيل

- `log_debug` - تسجيل debug
- `log_info` - تسجيل info
- `log_warning` - تسجيل warning
- `log_error` - تسجيل error
- `log_critical` - تسجيل critical

### معالجة الأخطاء

- `handle_error` - معالج عام
- `handle_command_error` - أخطاء الأوامر
- `handle_file_error` - أخطاء الملفات
- `handle_network_error` - أخطاء الشبكة

### الاسترداد

- `retry_command` - إعادة المحاولة
- `backup_file` - نسخ احتياطي
- `restore_backup` - استعادة

### التحقق

- `check_command` - التحقق من أمر
- `check_file` - التحقق من ملف
- `check_directory` - التحقق من مجلد
- `check_disk_space` - التحقق من المساحة
- `check_write_permission` - التحقق من الصلاحيات

### التنظيف

- `cleanup_temp_files` - تنظيف الملفات المؤقتة
- `print_error_summary` - طباعة ملخص الأخطاء

---

**تم إعداد هذا الدليل بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 6 ديسمبر 2025  
**الحالة:** ✅ معتمد ونشط
