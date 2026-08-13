# سكريبتات الإصلاح والصيانة - مشروع بصير

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 12 ديسمبر 2025

---

## 📜 السكريبتات المتاحة

### 🔧 إصلاح خوادم MCP

#### [`fix_github_mcp.py`](./fix_github_mcp.py)

**الوصف:** إصلاح شامل لخادم GitHub MCP  
**المشكلة:** timeout وفشل الاتصال  
**الحل:** استبدال حزمة PyPI بحزمة GitHub MCP الرسمية  
**الاستخدام:**

```bash
python3 scripts/fix_github_mcp.py
```

**المتطلبات:**

- Python 3.6+
- uv package manager للـ MCP servers
- GITHUB_TOKEN في متغيرات البيئة
- صلاحيات كتابة على `~/.kiro/settings/mcp.json`

**الميزات:**

- ✅ إنشاء نسخة احتياطية تلقائية
- ✅ اختبار الاتصال بـ GitHub API
- ✅ تكوين آمن ومحسن
- ✅ رسائل واضحة ومفصلة
- ✅ معالجة الأخطاء الشاملة

---

## 🚀 الاستخدام

### تشغيل سكريبت إصلاح GitHub MCP

```bash
# الطريقة المباشرة
python3 scripts/fix_github_mcp.py

# أو جعله قابل للتنفيذ
chmod +x scripts/fix_github_mcp.py
./scripts/fix_github_mcp.py
```

### مثال على الإخراج المتوقع

```
============================================================
🛠️  سكريبت إصلاح خادم GitHub MCP
   فريق وكلاء تطوير مشروع بصير
============================================================

🧪 اختبار الاتصال بـ GitHub...
✅ GITHUB_TOKEN موجود (الطول: 40)
✅ GitHub API يعمل بشكل صحيح

🔧 بدء إصلاح خادم GitHub MCP...
✅ تم إنشاء نسخة احتياطية: ~/.kiro/settings/mcp.json.backup.20251212_190530
🔑 استخدام متغير البيئة: ${GITHUB_TOKEN}
✅ تم إصلاح خادم GitHub MCP بنجاح
🔄 يرجى إعادة تشغيل Kiro لتطبيق التغييرات

🎉 تم الإصلاح بنجاح!
📖 للمزيد من التفاصيل، راجع: .kiro/troubleshooting/mcp-github-complete-solution.md
```

---

## 🛡️ الأمان والموثوقية

### إجراءات الأمان

- ✅ **نسخ احتياطية تلقائية** قبل أي تعديل
- ✅ **التحقق من صحة الملفات** قبل المعالجة
- ✅ **عدم تخزين أسرار** في السكريبتات
- ✅ **معالجة الأخطاء الشاملة** مع رسائل واضحة

### اختبار الموثوقية

- ✅ مُختبر على أنظمة Linux متعددة
- ✅ يعمل مع إصدارات Python 3.6+
- ✅ متوافق مع تكوينات MCP مختلفة
- ✅ يتعامل مع حالات الخطأ بأمان

---

## 📋 متطلبات النظام

### البرامج المطلوبة

```bash
# Python 3.6 أو أحدث
python3 --version

# Node.js و npm
node --version
npm --version

# curl (للاختبارات)
curl --version

# jq (اختياري، للتنسيق)
jq --version
```

### متغيرات البيئة

```bash
# GitHub Personal Access Token
export GITHUB_TOKEN="<YOUR_GITHUB_TOKEN>"

# التحقق من وجوده
echo "Token length: ${#GITHUB_TOKEN}"
```

### الملفات المطلوبة

- `~/.kiro/settings/mcp.json` (يجب أن يكون موجود وقابل للكتابة)

---

## 🔍 استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### 1. خطأ "ملف التكوين غير موجود"

```bash
# إنشاء ملف التكوين الأساسي
mkdir -p ~/.kiro/settings
echo '{"mcpServers":{}}' > ~/.kiro/settings/mcp.json
```

#### 2. خطأ "GITHUB_TOKEN غير موجود"

```bash
# تعيين التوكن
export GITHUB_TOKEN="your_token_here"

# أو إضافته للملف الشخصي
echo 'export GITHUB_TOKEN="your_token_here"' >> ~/.bashrc
source ~/.bashrc
```

#### 3. خطأ "فشل في الاتصال بـ GitHub API"

```bash
# اختبار الاتصال يدوياً
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user

# فحص صلاحيات التوكن
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos
```

#### 4. خطأ "npx غير موجود"

```bash
# تثبيت Node.js و npm
# Ubuntu/Debian:
sudo apt update && sudo apt install nodejs npm

# CentOS/RHEL:
sudo yum install nodejs npm

# أو استخدام nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install node
```

---

## 📈 خطة التطوير المستقبلية

### سكريبتات مخطط لها

- [ ] `fix_all_mcp_servers.py` - إصلاح شامل لجميع خوادم MCP
- [ ] `health_check_mcp.py` - فحص صحة جميع الخوادم
- [ ] `backup_restore_config.py` - نسخ احتياطي واستعادة التكوينات
- [ ] `optimize_mcp_performance.py` - تحسين أداء خوادم MCP
- [ ] `generate_mcp_report.py` - تقرير شامل عن حالة النظام

### تحسينات مخطط لها

- [ ] واجهة سطر أوامر تفاعلية
- [ ] تكامل مع نظام السجلات
- [ ] إشعارات تلقائية عند اكتشاف مشاكل
- [ ] تحديثات تلقائية للسكريبتات
- [ ] دعم أنظمة تشغيل إضافية

---

## 📞 الدعم والمساعدة

### للحصول على المساعدة

1. **راجع الوثائق** في `.kiro/troubleshooting/`
2. **شغّل السكريبت مع verbose mode** (إذا متوفر)
3. **فحص السجلات** في `~/.kiro/logs/`
4. **اختبر المكونات منفردة** باستخدام الأوامر اليدوية

### الإبلاغ عن مشاكل

عند الإبلاغ عن مشكلة، يرجى تضمين:

- إصدار نظام التشغيل
- إصدار Python و Node.js
- رسالة الخطأ الكاملة
- محتوى ملف التكوين (بدون أسرار)
- خطوات إعادة إنتاج المشكلة

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 12 ديسمبر 2025  
**الحالة:** ✅ مُختبر وجاهز للاستخدام
