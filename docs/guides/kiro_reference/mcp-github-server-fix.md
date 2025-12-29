---
id: "mcp-github-server-fix"
description: "دليل إصلاح خادم GitHub MCP - حل جذري"
version: "1.0"
last_updated: "2025-12-17"
inclusion: manual
metrics:
  location: ".kiro/guides/"
  size: "9KB"
  lines: 316
  context_usage: "4%"
---

# دليل إصلاح خادم GitHub MCP - حل جذري

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 12 ديسمبر 2025  
**الحالة:** ✅ تم الحل والاختبار  
**النوع:** دليل استكشاف الأخطاء وإصلاحها

---

## 📋 ملخص المشكلة

### الأعراض المُلاحظة

```
[2025-12-12T18:21:57.029Z] [info] [github] Adding new MCP server from updated configuration
[2025-12-12T18:21:57.029Z] [info] [github] Registering MCP server and starting connection
[2025-12-12T18:22:57.455Z] [info] [github] MCP connection closed successfully
[2025-12-12T18:22:57.455Z] [error] [github] Error connecting to MCP server: MCP error -32001: Request timed out
[2025-12-12T18:26:57.030Z] [error] [github] MCP server connection and syncing tools and resources timed out after 5 minutes
```

### المشاكل الجذرية المُحددة

1. **حزمة غير مستقرة**: استخدام `mcp-server-github` بدلاً من الحزمة الرسمية
2. **تكوين خاطئ للتوكن**: عدم استخدام متغيرات البيئة بشكل صحيح
3. **إدخالات مكررة**: تكوين مشوش مع إدخالات مكررة
4. **أذونات غير محددة**: عدم تحديد الأذونات المطلوبة

---

## 🔧 الحل الجذري المُطبق

### الخطوة 1: استبدال الحزمة

```bash
# من الحزمة غير المستقرة
"command": "uvx",
"args": ["mcp-server-github"]

# إلى الحزمة الرسمية
"command": "npx",
"args": ["-y", "@modelcontextprotocol/server-github"]
```

### الخطوة 2: إصلاح تكوين التوكن

```json
{
  "env": {
    "GITHUB_TOKEN": "${GITHUB_TOKEN}",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```

### الخطوة 3: تنظيف الإدخالات المكررة

```python
# تنظيف git autoApprove
git_auto_approve = [
    'git_status', 'git_diff', 'git_log', 'git_add',
    'git_commit', 'git_diff_unstaged', 'git_checkout',
    'git_diff_staged', 'git_branch'
]

# تنظيف filesystem autoApprove
filesystem_auto_approve = [
    'read_file', 'list_directory', 'read_text_file',
    'read_multiple_files', 'create_directory', 'directory_tree'
]
```

### الخطوة 4: تحديد الأذونات الآمنة

```json
"autoApprove": [
  "search_repositories",
  "get_file_contents",
  "list_issues",
  "get_issue"
]
```

---

## 🛠️ سكريبت الإصلاح الكامل

### سكريبت Python للإصلاح التلقائي

```python
#!/usr/bin/env python3
"""
سكريبت إصلاح خادم GitHub MCP
يقوم بإصلاح جميع المشاكل المُحددة تلقائياً
"""

import json
import os

def fix_github_mcp_server():
    config_path = os.path.expanduser('~/.kiro/settings/mcp.json')

    with open(config_path, 'r') as f:
        config = json.load(f)

    # إصلاح تكوين GitHub
    github_config = {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-github'],
        'env': {
            'GITHUB_TOKEN': '${GITHUB_TOKEN}',
            'FASTMCP_LOG_LEVEL': 'ERROR'
        },
        'disabled': False,
        'autoApprove': [
            'search_repositories',
            'get_file_contents',
            'list_issues',
            'get_issue'
        ]
    }

    # تنظيف git autoApprove
    git_auto_approve = [
        'git_status', 'git_diff', 'git_log', 'git_add',
        'git_commit', 'git_diff_unstaged', 'git_checkout',
        'git_diff_staged', 'git_branch'
    ]

    # تنظيف filesystem autoApprove
    filesystem_auto_approve = [
        'read_file', 'list_directory', 'read_text_file',
        'read_multiple_files', 'create_directory', 'directory_tree'
    ]

    # تطبيق الإصلاحات
    config['mcpServers']['github'] = github_config
    config['mcpServers']['git']['autoApprove'] = git_auto_approve
    config['mcpServers']['filesystem']['autoApprove'] = filesystem_auto_approve

    # حفظ التكوين
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)

    print('✅ تم إصلاح خادم GitHub MCP بنجاح')

if __name__ == '__main__':
    fix_github_mcp_server()
```

---

## 🧪 اختبار الحل

### اختبار الاتصال

```bash
# اختبار التوكن
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# اختبار الحزمة
timeout 15 npx -y @modelcontextprotocol/server-github --help
```

### اختبار الوظائف

```python
# اختبار البحث في المستودعات
mcp_github_search_repositories(query="flutter todo app", perPage=3)

# اختبار قراءة الملفات
mcp_github_get_file_contents(owner="user", repo="repo", path="README.md")
```

---

## 📊 مقارنة قبل وبعد الإصلاح

| المعيار       | قبل الإصلاح            | بعد الإصلاح                           |
| ------------- | ---------------------- | ------------------------------------- |
| **الاستقرار** | ❌ timeout بعد 5 دقائق | ✅ اتصال فوري                         |
| **الحزمة**    | `mcp-server-github`    | `@modelcontextprotocol/server-github` |
| **الأمان**    | ❌ توكن مكشوف          | ✅ متغير بيئة                         |
| **التكوين**   | ❌ إدخالات مكررة       | ✅ تكوين نظيف                         |
| **الأذونات**  | ❌ غير محددة           | ✅ أذونات آمنة                        |

---

## 🚨 علامات التحذير المستقبلية

### أعراض تستدعي تطبيق هذا الحل

- رسائل خطأ `MCP error -32001: Request timed out`
- فشل اتصال خادم GitHub MCP لأكثر من 5 دقائق
- رسائل `MCP server connection and syncing tools and resources timed out`

### فحص دوري موصى به

```bash
# فحص شهري للتكوين
grep -A 15 '"github"' ~/.kiro/settings/mcp.json

# اختبار الاتصال
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

---

## 🔄 خطوات الاستكشاف المنهجي

### 1. تحديد المشكلة

```bash
# فحص السجلات
tail -f ~/.kiro/logs/mcp.log

# فحص التكوين الحالي
cat ~/.kiro/settings/mcp.json | jq '.mcpServers.github'
```

### 2. اختبار المكونات

```bash
# اختبار التوكن
echo "Token length: ${#GITHUB_TOKEN}"

# اختبار الحزمة
uvx --from @modelcontextprotocol/server-github --help
```

### 3. تطبيق الإصلاح

```bash
# تشغيل سكريبت الإصلاح
python3 fix_github_mcp.py

# إعادة تشغيل Kiro
# (إعادة تشغيل يدوية مطلوبة)
```

### 4. التحقق من النجاح

```bash
# اختبار الوظائف
# استخدام أدوات MCP GitHub في Kiro
```

---

## 📚 مراجع إضافية

### الحزم المُختبرة والموصى بها

- ✅ `@modelcontextprotocol/server-github` - الحزمة الرسمية
- ⚠️ `mcp-server-github` - غير مستقرة
- ⚠️ `github-mcp-server` - بديل محتمل
- ⚠️ `mcp-github` - بديل محتمل

### متغيرات البيئة المطلوبة

```bash
export GITHUB_TOKEN="<github-token-fixture>"
```

### أذونات التوكن المطلوبة

- `repo` - للوصول للمستودعات
- `read:user` - لقراءة معلومات المستخدم
- `read:org` - لقراءة معلومات المنظمة (اختياري)

---

## ⚡ نصائح للأداء

### تحسين التكوين

```json
{
  "env": {
    "FASTMCP_LOG_LEVEL": "ERROR", // تقليل السجلات
    "GITHUB_TOKEN": "${GITHUB_TOKEN}"
  },
  "autoApprove": [
    // فقط الأذونات المطلوبة
  ]
}
```

### مراقبة الأداء

```bash
# مراقبة استخدام الذاكرة
ps aux | grep "server-github"

# مراقبة الشبكة
netstat -an | grep github
```

---

## 🎯 الخلاصة

هذا الحل يعالج المشكلة من جذورها عبر:

1. **استبدال الحزمة غير المستقرة** بالحزمة الرسمية
2. **إصلاح تكوين الأمان** باستخدام متغيرات البيئة
3. **تنظيف التكوين** من الإدخالات المكررة
4. **تحديد أذونات آمنة** للاستخدام

**النتيجة:** خادم GitHub MCP مستقر وآمن وسريع الاستجابة.

---

**تم التوثيق بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 12 ديسمبر 2025  
**حالة الاختبار:** ✅ مُختبر ومُؤكد العمل
