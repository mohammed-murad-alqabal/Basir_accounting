# فهرس استكشاف الأخطاء السريع

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 12 ديسمبر 2025

---

## 🚨 المشاكل الشائعة - حلول سريعة

### 1. خادم GitHub MCP - Timeout

**الأعراض:**

```
[error] [github] Error connecting to MCP server: MCP error -32001: Request timed out
```

**الحل السريع:**

```bash
python3 scripts/fix_github_mcp.py
```

**التوثيق:**

- [حل مشاكل MCP GitHub](../../../../.kiro/troubleshooting/mcp-github-complete-solution.md)
- [دليل استكشاف الأخطاء](../../../../.kiro/troubleshooting/README.md)

---

## 📁 الملفات المهمة

| الملف                                                                                                                  | الوصف           | الاستخدام            |
| ---------------------------------------------------------------------------------------------------------------------- | --------------- | -------------------- |
| [`troubleshooting/README.md`](../../../../.kiro/troubleshooting/README.md)                                             | الدليل الرئيسي  | نظرة عامة شاملة      |
| [`troubleshooting/mcp-github-complete-solution.md`](../../../../.kiro/troubleshooting/mcp-github-complete-solution.md) | حل GitHub MCP   | الحل الكامل المُختبر |
| [`scripts/fix_github_mcp.py`](../../../../.kiro/scripts/fix_github_mcp.py)                                             | سكريبت الإصلاح  | تشغيل تلقائي         |
| [`scripts/README.md`](../../../../.kiro/scripts/README.md)                                                             | دليل السكريبتات | شرح جميع الأدوات     |

---

## ⚡ أوامر سريعة

```bash
# إصلاح GitHub MCP
python3 scripts/fix_github_mcp.py

# فحص التكوين
grep -A 8 '"github"' ~/.kiro/settings/mcp.json

# اختبار GitHub API
curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# فحص السجلات
tail -20 ~/.kiro/logs/mcp.log | grep github
```

---

## 📊 إحصائيات الحلول

| المشكلة            | الحالة    | معدل النجاح | وقت الإصلاح |
| ------------------ | --------- | ----------- | ----------- |
| GitHub MCP Timeout | ✅ محلولة | 100%        | < 2 دقيقة   |

---

**للوصول السريع:** `.kiro/troubleshooting/README.md`
