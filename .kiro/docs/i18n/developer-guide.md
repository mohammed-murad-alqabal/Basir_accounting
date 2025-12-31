# دليل المطور لنظام الترجمة والتدويل (i18n Developer Guide)

هذا الدليل يشرح كيفية استخدام وصيانة نظام الترجمة في مشروع بصير.

## البنية الأساسية

يعتمد المشروع على الحزمة الرسمية `flutter_localizations` وملفات ARB (Application Resource Bundle) لتخزين الترجمات.

### المجلدات والملفات

- `lib/l10n/`: يحتوي على ملفات الترجمة `.arb`.
  - `app_ar.arb`: اللغة العربية (الأساسية/Template).
  - `app_en.arb`: اللغة الإنجليزية.
- `lib/core/providers/locale_provider.dart`: `StateNotifier` لإدارة لغة التطبيق الحالية.
- `lib/core/repositories/locale_repository.dart`: مسؤول عن حفظ واسترجاع اللغة المفضلة للمستخدم باستخدام `shared_preferences`.
- `l10n.yaml`: ملف تكوين عملية توليد الكود.
- `scripts/i18n/`: أدوات مساعدة للمطورين.

## كيفية إضافة نصوص جديدة

لإضافة نص جديد للتطبيق:

1.  **افتح `lib/l10n/app_ar.arb`:**
    أضف المفتاح الجديد مع القيمة العربية والوصف (اختياري لكن مفضل).

    ```json
    "welcomeMessage": "مرحباً بك في بصير",
    "@welcomeMessage": {
      "description": "رسالة الترحيب في الشاشة الرئيسية"
    }
    ```

2.  **شغل سكريبت التوليد (تلقائي):**
    عند حفظ الملف، سيقوم Flutter تلقائياً بتحديث `AppLocalizations` (إذا كان التطبيق يعمل) أو يمكنك تشغيل:

    ```bash
    flutter gen-l10n
    ```

3.  **تحديث اللغة الإنجليزية:**
    افتح `lib/l10n/app_en.arb` وأضف المفتاح نفسه مع الترجمة الإنجليزية.

    ```json
    "welcomeMessage": "Welcome to Basser"
    ```

    > **نصيحة:** استخدم سكريبت المزامنة `scripts/i18n/sync_keys.sh` لإضافة المفاتيح المفقودة في الملفات الأخرى تلقائياً.

4.  **الاستخدام في الكود:**
    استخدم `context.l10n` للوصول للنص.
    ```dart
    Text(context.l10n.welcomeMessage)
    ```

## كيفية إضافة لغة جديدة

1.  أنشئ ملف جديد في `lib/l10n/`، مثل `app_es.arb` (للغة الإسبانية).
2.  أضف النصوص المترجمة (يمكنك نسخ هيكل `app_en.arb` والبدء بالترجمة).
3.  أضف كود اللغة إلى قائمة `supportedLocales` في `main.dart` أو حيث يتم تعريفها (عادة يتم جلبها تلقائياً من `AppLocalizations.supportedLocales`، ولكن تأكد من أن `l10n.yaml` ليس لديه قيود).

## الأدوات المساعدة (Scripts)

توجد أدوات في `scripts/i18n/` لمساعدتك:

- **`extract_strings.sh`**: لاستخراج النصوص التي لم تتم ترجمتها بعد (hardcoded strings) من الكود.
- **`check_completeness.sh`**: للتحقق من أن جميع ملفات اللغة تحتوي على جميع المفاتيح الموجودة في الملف الأساسي (Template).
- **`sync_keys.sh`**: لنسخ المفاتيح المفقودة من الملف الأساسي إلى باقي الملفات (يسهل عملية بدء الترجمة).
- **`stats.sh`**: لعرض إحصائيات تغطية الترجمة.

## أفضل الممارسات

- **أسماء المفاتيح:** استخدم `camelCase` (مثال: `homePageTitle`).
- **المعاملات (Parameters):** استخدم placeholders للنصوص المتغيرة.
  ```json
  "greeting": "مرحباً {name}",
  "@greeting": {
    "placeholders": {
      "name": { "type": "String" }
    }
  }
  ```
- **التعدد (Plurals):** استخدم صيغ الجمع المدمجة.
  ```json
  "itemCount": "{count, plural, =0{لا يوجد عناصر} other{{count} عناصر}}",
  ```
- **RTL/LTR:** لا تستخدم `left` و `right` في الـ padding أو alignment. استخدم `start` و `end` بدلاً منها (مثال: `EdgeInsetsDirectional.only(start: 16)`).

## استكشاف الأخطاء وإصلاحها (Troubleshooting)

### النص لا يظهر بعد التحديث؟

- تأكد من تشغيل `flutter gen-l10n`.
- تأكد من حفظ ملفات `.arb`.
- أعد تشغيل التطبيق (Hot Restart).

### خطأ في الـ ARB Syntax؟

- تأكد من عدم وجود فاصلة (`,`) زائدة في نهاية آخر عنصر في JSON.
- تأكد من أن جميع الأقواس مغلقة بشكل صحيح.

### اللغة لا تتغير؟

- تأكد من أن `LocaleProvider` يتم تحديثه وأن `MaterialApp` يستمع للتغييرات.

## التنسيق (Formatting)

لضمان عرض التواريخ والأرقام بشكل صحيح حسب اللغة، استخدم `FormatHelpers` في `lib/core/utils/format_helpers.dart`.

### التواريخ (Dates)

```dart
// عرض: ٩ ديسمبر ٢٠٢٥ (AR) أو Dec 9, 2025 (EN)
FormatHelpers.formatDate(DateTime.now(), locale: context.l10n.localeName);

// التقويم الهجري
FormatHelpers.formatDate(
  DateTime.now(),
  locale: context.l10n.localeName,
  calendarType: CalendarType.hijri,
);
```

### الأرقام والعملات (Numbers & Currencies)

```dart
// عرض: ١٬٢٣٤٫٥٦ (AR) أو 1,234.56 (EN)
FormatHelpers.formatNumber(1234.56, locale: context.l10n.localeName);

// عرض: ١٬٢٣٤٫٥٦ ر.س (AR) أو SAR 1,234.56 (EN)
FormatHelpers.formatCurrency(1234.56, locale: context.l10n.localeName);
```

### الوقت النسبي (Relative Time)

```dart
// عرض: منذ 5 دقائق (AR) أو 5m ago (EN)
FormatHelpers.formatRelativeTime(notificationTime, locale: context.l10n.localeName);
```
