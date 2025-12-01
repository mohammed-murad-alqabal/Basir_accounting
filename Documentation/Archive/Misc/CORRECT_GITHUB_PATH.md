# المسار الصحيح لتغيير الفرع الافتراضي

**المشكلة:** أنت في صفحة "Branch protection rules" ❌  
**المطلوب:** الذهاب إلى صفحة "Branches" الرئيسية ✅

---

## 🎯 الطريقة الصحيحة

### الخطوة 1: في القائمة اليسرى

**أنت الآن في:**

```
Code and automation
  ├─ Branches ← أنت هنا (Branch protection rules)
```

**يجب أن تكون في:**

```
Code and automation
  ├─ Branches ← اضغط هنا مباشرة (ليس على Rules)
```

### الخطوة 2: ابحث عن "Default branch"

**في الصفحة الرئيسية للـ Branches، ستجد في الأعلى:**

```
┌─────────────────────────────────────────┐
│ Default branch                          │
├─────────────────────────────────────────┤
│ The default branch is main              │
│                                         │
│ main [⇄] ← اضغط هنا                    │
└─────────────────────────────────────────┘
```

---

## 🔧 الحل السريع

### الطريقة 1: استخدم هذا الرابط المباشر

**انسخ والصق هذا الرابط:**

```
https://github.com/mohammed-murad-alqabal/Basser_MVP/settings
```

**ثم:**

1. في القائمة اليسرى، اضغط على **"Branches"** (تحت Code and automation)
2. ستجد في أعلى الصفحة قسم **"Default branch"**
3. اضغط على أيقونة **⇄** بجانب `main`
4. اختر `master`
5. اضغط Update

### الطريقة 2: من الصفحة الحالية

**أنت الآن في:**

```
Settings > Branches > Branch protection rules
```

**اضغط على "Branches" في القائمة اليسرى مرة أخرى**

**ستنتقل إلى:**

```
Settings > Branches (الصفحة الرئيسية)
```

**هناك ستجد "Default branch" في الأعلى**

---

## 📸 ما يجب أن تراه

### الصفحة الصحيحة تبدو هكذا:

```
┌──────────────────────────────────────────────────┐
│ Branches                                         │
├──────────────────────────────────────────────────┤
│                                                  │
│ Default branch                                   │
│ ─────────────────────────────────────────────    │
│ The default branch is main                       │
│                                                  │
│ [main] [⇄] ← هذا ما تبحث عنه!                   │
│                                                  │
│ ─────────────────────────────────────────────    │
│                                                  │
│ Branch protection rules                          │
│ ─────────────────────────────────────────────    │
│ Classic branch protections have not been...     │
│                                                  │
└──────────────────────────────────────────────────┘
```

**الفرق:**

- ❌ أنت الآن في قسم "Branch protection rules" (في الأسفل)
- ✅ يجب أن تكون في قسم "Default branch" (في الأعلى)

---

## 🚀 الخطوات بالتفصيل

### 1. اذهب إلى الصفحة الرئيسية للـ Branches

**من الصفحة الحالية:**

- انظر إلى القائمة اليسرى
- ابحث عن "Branches" تحت "Code and automation"
- اضغط عليها مرة أخرى

**أو استخدم هذا الرابط:**

```
https://github.com/mohammed-murad-alqabal/Basser_MVP/settings
```

### 2. ابحث عن "Default branch" في أعلى الصفحة

**يجب أن ترى:**

```
Default branch
The default branch is main
[main] [⇄]
```

### 3. اضغط على ⇄

**ستظهر قائمة منسدلة:**

```
┌──────────────┐
│ main         │ ← الحالي
│ master       │ ← اختر هذا
│ backup-...   │
└──────────────┘
```

### 4. اختر master

### 5. اضغط Update

### 6. أكد التغيير

**ستظهر رسالة تحذير:**

```
Are you sure you want to change the default branch?
```

**اضغط:** "I understand, update the default branch"

---

## ✅ التحقق من النجاح

**بعد التغيير، يجب أن ترى:**

```
Default branch
The default branch is master ✅
[master] [⇄]
```

---

## 🎯 بعد التغيير

**ارجع إلى Terminal ونفذ:**

```bash
./fix_git_repository_complete.sh
```

---

## 💡 نصيحة

**إذا لم تجد "Default branch" في الصفحة:**

1. تأكد من أنك في الصفحة الرئيسية للـ Branches
2. scroll للأعلى - قد يكون في أعلى الصفحة
3. حدّث الصفحة (F5)

---

## 📞 المساعدة

**إذا ما زلت لا تجدها:**

1. أغلق التبويب
2. افتح هذا الرابط في تبويب جديد:
   ```
   https://github.com/mohammed-murad-alqabal/Basser_MVP/settings
   ```
3. اضغط "Branches" في القائمة اليسرى
4. ابحث عن "Default branch" في أعلى الصفحة

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 1 ديسمبر 2025
