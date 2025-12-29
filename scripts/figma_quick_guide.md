# دليل Figma السريع

**المؤلف:** فريق وكلاء تطوير مشروع بصير

---

## 🚀 البدء السريع

### الإعداد

```bash
./scripts/setup_figma.sh
./scripts/test_figma_integration.sh
```

### الأوامر الأساسية

```bash
# معلومات المستخدم
python3 scripts/figma_api.py me

# معلومات ملف تصميم
python3 scripts/figma_api.py file FILE_KEY

# تعليقات ملف
python3 scripts/figma_api.py comments FILE_KEY
```

---

## 🔍 الحصول على FILE_KEY

من URL الملف في Figma:

```
https://www.figma.com/file/ABC123DEF456/Design-Name
                        ↑
                    FILE_KEY
```

---

## 📝 أمثلة عملية

```bash
# حفظ معلومات التصميم
python3 scripts/figma_api.py file ABC123 > design.json

# استخراج الألوان (يتطلب jq)
cat design.json | jq '.document.children[].children[].fills[]?.color'

# مراجعة التعليقات
python3 scripts/figma_api.py comments ABC123 | jq '.comments[]'
```

---

## 🔧 استكشاف الأخطاء

| الخطأ              | الحل                               |
| ------------------ | ---------------------------------- |
| Invalid token      | تحقق من FIGMA_ACCESS_TOKEN في .env |
| Access denied      | تحقق من صلاحيات الوصول             |
| Resource not found | تحقق من صحة FILE_KEY               |

---

**للمزيد:** [دليل التكامل الكامل](../docs/FIGMA_INTEGRATION_GUIDE.md)
