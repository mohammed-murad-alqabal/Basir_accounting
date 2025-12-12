# دليل تكامل Figma مع Kiro

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 12 ديسمبر 2025

---

## 🎯 نظرة عامة

يوفر هذا الدليل خطوات تفصيلية لربط Figma مع Kiro باستخدام MCP (Model Context Protocol) للوصول إلى تصميمات المشروع مباشرة من بيئة التطوير.

---

## 🔑 الحصول على Figma Access Token

### الخطوة 1: إنشاء Personal Access Token

1. **اذهب إلى Figma Settings:**

   ```
   https://www.figma.com/settings
   ```

2. **إنشاء Token جديد:**

   - ابحث عن قسم "Personal access tokens"
   - اضغط على "Create new token"
   - أعطه اسم وصفي: `Kiro Integration - بصير MVP`
   - انسخ التوكن فوراً (لن تظهر مرة أخرى)

3. **حفظ التوكن بأمان:**
   ```bash
   # مثال على التوكن (استبدل بالتوكن الحقيقي)
   export FIGMA_ACCESS_TOKEN="your_figma_token_here"
   ```

### الخطوة 2: الحصول على معرفات المشروع

1. **Team ID:**

   - اذهب إلى فريقك في Figma
   - انسخ الرقم من URL: `https://www.figma.com/files/team/TEAM_ID/`

2. **Project ID:**

   - اذهب إلى مشروعك
   - انسخ الرقم من URL: `https://www.figma.com/files/project/PROJECT_ID/`

3. **File Key:**
   - افتح ملف التصميم
   - انسخ الرقم من URL: `https://www.figma.com/file/FILE_KEY/`

---

## ⚙️ إعداد Kiro MCP Configuration

### الخطوة 1: تحديث MCP Configuration

الملف موجود في: `.kiro/settings/mcp.json`

```json
{
  "mcpServers": {
    "figma": {
      "command": "uvx",
      "args": ["mcp-server-figma@latest"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR",
        "FIGMA_ACCESS_TOKEN": "YOUR_FIGMA_TOKEN_HERE"
      },
      "disabled": false,
      "autoApprove": [
        "get_file_info",
        "get_file_nodes",
        "get_comments",
        "get_team_projects"
      ],
      "priority": 82,
      "disabledTools": []
    }
  }
}
```

### الخطوة 2: إعداد Environment Variables

1. **إنشاء ملف .env:**

   ```bash
   cp .env.example .env
   ```

2. **إضافة Figma Tokens:**
   ```bash
   # في ملف .env
   FIGMA_ACCESS_TOKEN=figd_your_actual_token_here
   FIGMA_TEAM_ID=your_team_id_here
   FIGMA_PROJECT_ID=your_project_id_here
   ```

### الخطوة 3: تحديث MCP Configuration بالمتغيرات

```json
{
  "figma": {
    "command": "uvx",
    "args": ["mcp-server-figma@latest"],
    "env": {
      "FASTMCP_LOG_LEVEL": "ERROR",
      "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN}",
      "FIGMA_TEAM_ID": "${FIGMA_TEAM_ID}",
      "FIGMA_PROJECT_ID": "${FIGMA_PROJECT_ID}"
    },
    "disabled": false,
    "autoApprove": [
      "get_file_info",
      "get_file_nodes",
      "get_comments",
      "get_team_projects",
      "get_file_versions"
    ],
    "priority": 82
  }
}
```

---

## 🔧 تثبيت وتفعيل MCP Server

### الخطوة 1: تثبيت uvx (إذا لم يكن مثبت)

```bash
# تثبيت uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# أو باستخدام pip
pip install uv

# التحقق من التثبيت
uvx --version
```

### الخطوة 2: اختبار Figma MCP Server

```bash
# اختبار الاتصال
uvx mcp-server-figma@latest --help
```

### الخطوة 3: إعادة تشغيل Kiro

1. أعد تشغيل Kiro IDE
2. تحقق من MCP Server Panel
3. تأكد من ظهور "figma" في قائمة الخوادم النشطة

---

## 🧪 اختبار التكامل

### اختبار أساسي

```bash
# في Kiro، جرب هذه الأوامر:

# 1. الحصول على معلومات الفريق
@figma get_team_projects

# 2. الحصول على معلومات ملف معين
@figma get_file_info --file_key="YOUR_FILE_KEY"

# 3. الحصول على عقد الملف
@figma get_file_nodes --file_key="YOUR_FILE_KEY"
```

### اختبار متقدم

```bash
# الحصول على التعليقات
@figma get_comments --file_key="YOUR_FILE_KEY"

# الحصول على إصدارات الملف
@figma get_file_versions --file_key="YOUR_FILE_KEY"
```

---

## 🎨 استخدام Figma في التطوير

### 1. استخراج معلومات التصميم

```bash
# الحصول على تفاصيل الألوان والخطوط
@figma get_file_info --file_key="YOUR_FILE_KEY" --include_styles=true

# الحصول على مكونات التصميم
@figma get_file_nodes --file_key="YOUR_FILE_KEY" --node_ids="component_ids"
```

### 2. مراجعة التعليقات والملاحظات

```bash
# مراجعة تعليقات المصممين
@figma get_comments --file_key="YOUR_FILE_KEY"
```

### 3. تتبع التحديثات

```bash
# مراجعة آخر التحديثات
@figma get_file_versions --file_key="YOUR_FILE_KEY"
```

---

## 🔒 الأمان وأفضل الممارسات

### حماية التوكن

1. **لا تشارك التوكن:**

   - لا تضع التوكن في الكود
   - لا ترفعه إلى Git
   - استخدم متغيرات البيئة فقط

2. **تدوير التوكن:**

   - غيّر التوكن كل 90 يوم
   - أنشئ توكن جديد عند الشك في تسريبه

3. **صلاحيات محدودة:**
   - استخدم التوكن للقراءة فقط
   - لا تعطي صلاحيات كتابة غير ضرورية

### مراقبة الاستخدام

```bash
# مراجعة سجلات MCP
tail -f .kiro/audit/mcp-audit.log | grep figma

# مراقبة استخدام API
@figma get_api_usage_stats
```

---

## 🛠️ استكشاف الأخطاء

### مشاكل شائعة

1. **خطأ في التوكن:**

   ```
   Error: Invalid access token
   ```

   **الحل:** تحقق من صحة التوكن في `.env`

2. **خطأ في File Key:**

   ```
   Error: File not found
   ```

   **الحل:** تأكد من صحة File Key من URL

3. **خطأ في الصلاحيات:**
   ```
   Error: Insufficient permissions
   ```
   **الحل:** تحقق من صلاحيات التوكن في Figma

### تشخيص المشاكل

```bash
# تفعيل التسجيل المفصل
export FASTMCP_LOG_LEVEL=DEBUG

# اختبار الاتصال
curl -H "X-Figma-Token: YOUR_TOKEN" \
     "https://api.figma.com/v1/me"

# مراجعة سجلات MCP
cat .kiro/audit/mcp-audit.log | grep figma | tail -10
```

---

## 📚 الأوامر المتاحة

### معلومات الملفات

| الأمر               | الوصف         | المعاملات                              |
| ------------------- | ------------- | -------------------------------------- |
| `get_file_info`     | معلومات الملف | `file_key`, `version`, `ids`, `depth`  |
| `get_file_nodes`    | عقد الملف     | `file_key`, `ids`, `depth`, `geometry` |
| `get_file_versions` | إصدارات الملف | `file_key`                             |

### إدارة المشاريع

| الأمر               | الوصف         | المعاملات    |
| ------------------- | ------------- | ------------ |
| `get_team_projects` | مشاريع الفريق | `team_id`    |
| `get_project_files` | ملفات المشروع | `project_id` |

### التعليقات والمراجعة

| الأمر          | الوصف         | المعاملات                            |
| -------------- | ------------- | ------------------------------------ |
| `get_comments` | تعليقات الملف | `file_key`                           |
| `post_comment` | إضافة تعليق   | `file_key`, `message`, `client_meta` |

---

## 🎯 أمثلة عملية

### مثال 1: استخراج نظام الألوان

```bash
# الحصول على معلومات الملف مع الأنماط
@figma get_file_info --file_key="ABC123" --include_styles=true

# استخراج الألوان من النتيجة
# يمكن استخدامها في ملفات CSS أو Dart
```

### مثال 2: مراجعة تعليقات المصمم

```bash
# الحصول على جميع التعليقات
@figma get_comments --file_key="ABC123"

# مراجعة التعليقات الجديدة فقط
@figma get_comments --file_key="ABC123" --since="2025-12-01"
```

### مثال 3: تتبع تحديثات التصميم

```bash
# مراجعة آخر الإصدارات
@figma get_file_versions --file_key="ABC123"

# مقارنة إصدارين
@figma get_file_info --file_key="ABC123" --version="1234567890"
```

---

## 📋 قائمة مراجعة الإعداد

### قبل البدء

- [ ] حساب Figma نشط
- [ ] صلاحيات الوصول للملفات المطلوبة
- [ ] Kiro IDE مثبت ومحدث

### خطوات الإعداد

- [ ] إنشاء Personal Access Token
- [ ] نسخ Team ID و Project ID
- [ ] تحديث `.env` بالتوكن
- [ ] تحديث `mcp.json` configuration
- [ ] إعادة تشغيل Kiro

### اختبار التكامل

- [ ] اختبار `get_team_projects`
- [ ] اختبار `get_file_info`
- [ ] اختبار `get_comments`
- [ ] مراجعة سجلات MCP

### الأمان

- [ ] التوكن في `.env` فقط
- [ ] `.env` في `.gitignore`
- [ ] صلاحيات محدودة للتوكن
- [ ] جدولة تدوير التوكن

---

## 🆘 الدعم والمساعدة

### الموارد

- [Figma API Documentation](https://www.figma.com/developers/api)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [Kiro MCP Guide](.kiro/steering/mcp-best-practices.md)

### الحصول على المساعدة

1. **مراجعة السجلات:**

   ```bash
   tail -f .kiro/audit/mcp-audit.log
   ```

2. **اختبار الاتصال:**

   ```bash
   curl -H "X-Figma-Token: $FIGMA_ACCESS_TOKEN" \
        "https://api.figma.com/v1/me"
   ```

3. **فتح Issue في المشروع:**
   - وصف المشكلة بالتفصيل
   - إرفاق سجلات الأخطاء (بدون التوكن)
   - ذكر خطوات إعادة الإنتاج

---

**آخر تحديث:** 12 ديسمبر 2025  
**الحالة:** ✅ جاهز للاستخدام  
**المؤلف:** فريق وكلاء تطوير مشروع بصير
