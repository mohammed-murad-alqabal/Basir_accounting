# Arabic Language Standards

**Project:** Basir MVP  
**Status:** ✅ Active

---

## Core Terminology

| English  | Arabic         | Notes                            |
| :------- | :------------- | :------------------------------- |
| Customer | عميل           | Avoid "زبون"                     |
| Invoice  | فاتورة         | Avoid "إيصال"                    |
| Item     | بند            | Within the context of an invoice |
| Total    | الإجمالي       | Avoid "المجموع"                  |
| Subtotal | المجموع الفرعي | Before tax                       |
| Tax      | الضريبة        | Avoid "الرسوم"                   |
| Discount | الخصم          | Avoid "التخفيض"                  |
| Payment  | الدفع          | Avoid "السداد"                   |

---

## Invoice Statuses

| English   | Arabic |
| :-------- | :----- |
| Draft     | مسودة  |
| Sent      | مرسلة  |
| Paid      | مدفوعة |
| Overdue   | متأخرة |
| Cancelled | ملغاة  |

---

## Actions

| English | Arabic |
| :------ | :----- |
| Add     | إضافة  |
| Edit    | تعديل  |
| Delete  | حذف    |
| Save    | حفظ    |
| Cancel  | إلغاء  |
| Search  | بحث    |
| Filter  | تصفية  |
| Export  | تصدير  |
| Print   | طباعة  |

---

## Punctuation

### Rules

- Arabic Comma: (،) not (,)
- Question Mark: (؟) not (?)
- Full Stop: (.) at the end of sentences

### Numerals

- **Recommended:** Hindu-Arabic numerals (123)
- Comma (،) as thousands separator
- Decimal point (.) for fractions

---

## User Messages

### Confirmation Messages

```
'Are you sure you want to delete this customer?' -> 'هل أنت متأكد من حذف هذا العميل؟'
'Do you want to save changes?' -> 'هل تريد حفظ التغييرات؟'
```

### Error Messages

```
'Phone number must start with 05' -> 'رقم الهاتف يجب أن يبدأ بـ 05'
'Invalid email address' -> 'البريد الإلكتروني غير صحيح'
```

### Success Messages

```
'Customer added successfully' -> 'تم إضافة العميل بنجاح'
'Invoice saved successfully' -> 'تم حفظ الفاتورة بنجاح'
```

---

## Common Errors

| ❌ Incorrect | ✅ Correct    |
| :----------- | :------------ |
| إضافه        | إضافة         |
| إستخدام      | استخدام       |
| هل تريد حذف? | هل تريد حذف؟  |
| المبلغ: 1500 | المبلغ: 1,500 |

---

**For the full dictionary, refer to:** `.kiro/steering/reference/arabic-dictionary.md`
