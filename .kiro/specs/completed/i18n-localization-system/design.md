# Design Document - نظام الترجمة والتدويل

**المشروع:** بصير MVP  
**التاريخ:** 9 ديسمبر 2025  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**الإصدار:** 1.1  
**الحالة:** 🔄 قيد المراجعة

---

## Document Updates

### Version 1.1 (9 ديسمبر 2025)

- إضافة قسم Hardcoded Strings Migration Strategy
- إضافة قسم Text Overflow Handling Strategy
- إضافة قسم RTL/LTR Implementation Details
- إضافة Developer Tools (scripts)
- إضافة Documentation structure
- إضافة Monitoring and Maintenance
- تحسين Design Decisions and Rationale
- إضافة Security considerations details
- إضافة Automated Testing Scripts

---

## Overview

هذا المستند يصف التصميم التفصيلي لنظام الترجمة والتدويل (i18n/l10n) في تطبيق بصير MVP. النظام مصمم لدعم اللغتين العربية والإنجليزية مع إمكانية التوسع لدعم لغات إضافية في المستقبل.

### الأهداف الرئيسية

1. **استبدال جميع النصوص المشفرة** (191 نص) بنظام ترجمة مركزي
2. **دعم RTL/LTR كامل** مع إصلاح 7 alignments مشفرة
3. **معالجة طول النصوص** لـ 191 widget
4. **تنسيق التواريخ والأرقام** حسب اللغة
5. **واجهة سهلة لتبديل اللغة**

---

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Screens    │  │   Widgets    │  │  Providers   │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
│         │                 │                 │           │
│         └─────────────────┼─────────────────┘           │
│                           │                             │
└───────────────────────────┼─────────────────────────────┘
                            │
┌───────────────────────────┼─────────────────────────────┐
│                    Localization Layer                    │
│         ┌─────────────────▼─────────────────┐           │
│         │   AppLocalizations (Generated)    │           │
│         └─────────────────┬─────────────────┘           │
│                           │                             │
│         ┌─────────────────▼─────────────────┐           │
│         │    LocaleProvider (State Mgmt)    │           │
│         └─────────────────┬─────────────────┘           │
│                           │                             │
└───────────────────────────┼─────────────────────────────┘
                            │
┌───────────────────────────┼─────────────────────────────┐
│                      Data Layer                          │
│         ┌─────────────────▼─────────────────┐           │
│         │      ARB Files (ar, en)           │           │
│         └───────────────────────────────────┘           │
│         ┌───────────────────────────────────┐           │
│         │   LocaleRepository (Storage)      │           │
│         └───────────────────────────────────┘           │
└─────────────────────────────────────────────────────────┘
```

### Component Breakdown

#### 1. Presentation Layer

- **Screens**: تستخدم `AppLocalizations.of(context)` للوصول للترجمات
- **Widgets**: مكونات UI قابلة لإعادة الاستخدام مع دعم i18n
- **Providers**: إدارة حالة اللغة الحالية

#### 2. Localization Layer

- **AppLocalizations**: ملف مولد تلقائياً من Flutter
- **LocaleProvider**: Riverpod provider لإدارة اللغة
- **FormatHelpers**: دوال مساعدة للتنسيق

#### 3. Data Layer

- **ARB Files**: ملفات الترجمة بصيغة JSON
- **LocaleRepository**: حفظ واسترجاع اللغة المفضلة

---

## Components and Interfaces

## Hardcoded Strings Migration Strategy

### Current State Analysis

بناءً على نتائج الاختبار:

- **191 نص مشفر** تم اكتشافه في الكود
- **7 alignments مشفرة** (left/right)
- **191 widget** بدون overflow handling

### Migration Approach

#### Phase 1: Categorization

تصنيف النصوص المشفرة حسب:

1. **Navigation**: نصوص القوائم والتنقل
2. **Actions**: أزرار الإجراءات (إضافة، حذف، إلخ)
3. **Labels**: تسميات الحقول
4. **Messages**: رسائل النجاح والخطأ
5. **Content**: محتوى الشاشات

#### Phase 2: Key Naming Convention

```
{module}_{type}_{description}

Examples:
- customer_label_name
- invoice_action_add
- common_message_success
- dashboard_title_main
```

#### Phase 3: Automated Extraction

```bash
# Extract and categorize hardcoded strings
grep -r "Text(" lib/ --include="*.dart" | \
  grep -v "AppLocalizations" | \
  awk '{print $0}' > hardcoded_strings.txt
```

#### Phase 4: Gradual Replacement

1. Start with high-visibility screens (Dashboard, Settings)
2. Move to feature modules (Customers, Invoices)
3. Finish with utility screens and dialogs

### Design Decisions and Rationale

#### Decision 1: Flutter's Built-in Localization System

**Rationale:** استخدام نظام Flutter المدمج (`flutter_localizations` و `intl`) بدلاً من حلول خارجية لأنه:

- مدعوم رسمياً ومستقر
- يتكامل بسلاسة مع Flutter framework
- يوفر أداء ممتاز (< 100ms loading time)
- يولد كود type-safe تلقائياً

#### Decision 2: ARB Format for Translations

**Rationale:** اختيار صيغة ARB (Application Resource Bundle) لأنها:

- الصيغة القياسية في Flutter
- تدعم metadata للمفاتيح
- سهلة القراءة والتحرير (JSON-based)
- تدعم أدوات الترجمة الاحترافية

#### Decision 3: Riverpod for State Management

**Rationale:** استخدام Riverpod لإدارة حالة اللغة لأنه:

- يوفر reactive state management
- يسهل testing مع dependency injection
- يمنع rebuilds غير ضرورية
- متوافق مع معايير المشروع

#### Decision 4: SharedPreferences for Locale Storage

**Rationale:** استخدام SharedPreferences لحفظ اللغة المفضلة لأنه:

- بسيط وسريع للبيانات الصغيرة
- لا يحتاج تشفير (اللغة ليست بيانات حساسة)
- متوفر على جميع المنصات
- يوفر persistence تلقائي

### 1. ARB Files Structure

```json
// lib/l10n/app_ar.arb
{
  "@@locale": "ar",

  // App General
  "appTitle": "بصير",
  "@appTitle": {
    "description": "عنوان التطبيق"
  },

  // Navigation
  "dashboard": "لوحة التحكم",
  "customers": "العملاء",
  "invoices": "الفواتير",
  "settings": "الإعدادات",

  // Actions
  "add": "إضافة",
  "edit": "تعديل",
  "delete": "حذف",
  "save": "حفظ",
  "cancel": "إلغاء",
  "search": "بحث",

  // Customer Module
  "addCustomer": "إضافة عميل",
  "editCustomer": "تعديل عميل",
  "deleteCustomer": "حذف عميل",
  "customerName": "اسم العميل",
  "customerPhone": "رقم الهاتف",
  "customerEmail": "البريد الإلكتروني",
  "customerAddress": "العنوان",

  // Invoice Module
  "addInvoice": "إنشاء فاتورة",
  "invoiceNumber": "رقم الفاتورة",
  "invoiceDate": "تاريخ الفاتورة",
  "invoiceTotal": "الإجمالي",
  "invoiceStatus": "حالة الفاتورة",

  // Validation Messages
  "fieldRequired": "هذا الحقل مطلوب",
  "invalidPhone": "رقم الهاتف غير صحيح",
  "invalidEmail": "البريد الإلكتروني غير صحيح",

  // Success Messages
  "customerAdded": "تم إضافة العميل بنجاح",
  "customerUpdated": "تم تحديث العميل بنجاح",
  "customerDeleted": "تم حذف العميل بنجاح",

  // Error Messages
  "errorOccurred": "حدث خطأ غير متوقع",
  "networkError": "خطأ في الاتصال بالشبكة",

  // Confirmation Messages
  "confirmDelete": "هل أنت متأكد من الحذف؟",
  "confirmCancel": "هل تريد إلغاء التغييرات؟",

  // Settings
  "language": "اللغة",
  "arabic": "العربية",
  "english": "English",
  "changeLanguage": "تغيير اللغة"
}
```

### 2. l10n.yaml Configuration

```yaml
arb-dir: lib/l10n
template-arb-file: app_ar.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
preferred-supported-locales: [ar]
nullable-getter: false
synthetic-package: false
```

### 3. LocaleProvider (Riverpod)

```dart
// lib/core/providers/locale_provider.dart

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Load saved locale or use system locale
    _loadSavedLocale();
    return const Locale('ar'); // Default
  }

  Future<void> _loadSavedLocale() async {
    final repository = ref.read(localeRepositoryProvider);
    final savedLocale = await repository.getSavedLocale();
    if (savedLocale != null) {
      state = savedLocale;
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final repository = ref.read(localeRepositoryProvider);
    await repository.saveLocale(locale);
  }

  bool get isArabic => state.languageCode == 'ar';
  bool get isEnglish => state.languageCode == 'en';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
}
```

### 4. LocaleRepository

```dart
// lib/core/repositories/locale_repository.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  static const String _localeKey = 'app_locale';
  final SharedPreferences _prefs;

  LocaleRepository(this._prefs);

  Future<Locale?> getSavedLocale() async {
    final localeCode = _prefs.getString(_localeKey);
    if (localeCode == null) return null;
    return Locale(localeCode);
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> clearLocale() async {
    await _prefs.remove(_localeKey);
  }
}
```

### 5. Developer Tools

#### Translation Extraction Script

```bash
#!/bin/bash
# scripts/i18n/extract_strings.sh

# Extract hardcoded strings from Dart files
echo "Extracting hardcoded strings..."

# Find all Text widgets with hardcoded strings
grep -r "Text(" lib/ --include="*.dart" | \
  grep -v "AppLocalizations" | \
  grep -v "// ignore" > extracted_strings.txt

echo "Found $(wc -l < extracted_strings.txt) potential hardcoded strings"
echo "Results saved to extracted_strings.txt"
```

#### Translation Completeness Checker

```bash
#!/bin/bash
# scripts/i18n/check_completeness.sh

# Compare ARB files for missing keys
echo "Checking translation completeness..."

# Extract keys from Arabic ARB
ar_keys=$(jq -r 'keys[]' lib/l10n/app_ar.arb | grep -v "^@")

# Extract keys from English ARB
en_keys=$(jq -r 'keys[]' lib/l10n/app_en.arb | grep -v "^@")

# Find missing keys
missing_in_en=$(comm -23 <(echo "$ar_keys" | sort) <(echo "$en_keys" | sort))
missing_in_ar=$(comm -13 <(echo "$ar_keys" | sort) <(echo "$en_keys" | sort))

if [ -n "$missing_in_en" ]; then
  echo "❌ Missing in English:"
  echo "$missing_in_en"
fi

if [ -n "$missing_in_ar" ]; then
  echo "❌ Missing in Arabic:"
  echo "$missing_in_ar"
fi

if [ -z "$missing_in_en" ] && [ -z "$missing_in_ar" ]; then
  echo "✅ All translations complete!"
fi
```

#### Translation Statistics Generator

```bash
#!/bin/bash
# scripts/i18n/stats.sh

echo "Translation Statistics"
echo "====================="

ar_count=$(jq -r 'keys[]' lib/l10n/app_ar.arb | grep -v "^@" | wc -l)
en_count=$(jq -r 'keys[]' lib/l10n/app_en.arb | grep -v "^@" | wc -l)

echo "Arabic keys: $ar_count"
echo "English keys: $en_count"

if [ $ar_count -eq $en_count ]; then
  echo "✅ Completeness: 100%"
else
  percentage=$((en_count * 100 / ar_count))
  echo "⚠️  Completeness: $percentage%"
fi
```

### 6. FormatHelpers

```dart
// lib/core/utils/format_helpers.dart

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class FormatHelpers {
  /// Format date according to locale
  static String formatDate(DateTime date, Locale locale) {
    final formatter = DateFormat.yMMMd(locale.languageCode);
    return formatter.format(date);
  }

  /// Format date and time
  static String formatDateTime(DateTime dateTime, Locale locale) {
    final formatter = DateFormat.yMMMd(locale.languageCode).add_jm();
    return formatter.format(dateTime);
  }

  /// Format number with thousands separator
  static String formatNumber(num number, Locale locale) {
    final formatter = NumberFormat('#,##0.##', locale.languageCode);
    return formatter.format(number);
  }

  /// Format currency
  static String formatCurrency(num amount, Locale locale) {
    final formatter = NumberFormat.currency(
      locale: locale.languageCode,
      symbol: locale.languageCode == 'ar' ? 'ر.س' : 'SAR',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format relative time (e.g., "منذ ساعة", "2 days ago")
  static String formatRelativeTime(DateTime dateTime, Locale locale) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (locale.languageCode == 'ar') {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'منذ $years ${years == 1 ? 'سنة' : 'سنوات'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'منذ $months ${months == 1 ? 'شهر' : 'أشهر'}';
      } else if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
      } else {
        return 'الآن';
      }
    } else {
      // English
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'just now';
      }
    }
  }
}
```

---

## Text Overflow Handling Strategy

### Current Issues

- 191 widgets بدون overflow handling
- قد تتسبب النصوص الطويلة في مشاكل عرض

### Solution Approach

#### 1. Default Text Widget Wrapper

```dart
// lib/core/widgets/localized_text.dart

class LocalizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign? textAlign;

  const LocalizedText(
    this.text, {
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
```

#### 2. Context-Specific Handling

```dart
// For titles (1 line)
LocalizedText(
  AppLocalizations.of(context)!.title,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)

// For descriptions (2-3 lines)
LocalizedText(
  AppLocalizations.of(context)!.description,
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
)

// For buttons (must fit)
FittedBox(
  fit: BoxFit.scaleDown,
  child: LocalizedText(
    AppLocalizations.of(context)!.buttonText,
    maxLines: 1,
  ),
)
```

#### 3. Flexible Layouts

```dart
// Use Flexible/Expanded for dynamic content
Row(
  children: [
    Icon(Icons.person),
    SizedBox(width: 8),
    Expanded(
      child: LocalizedText(
        customer.name,
        maxLines: 1,
      ),
    ),
  ],
)
```

### Testing Strategy for Overflow

```dart
testWidgets('long text does not overflow', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 100, // Constrained width
          child: LocalizedText(
            'Very long text that should be truncated',
            maxLines: 1,
          ),
        ),
      ),
    ),
  );

  // Verify no overflow
  expect(tester.takeException(), isNull);
});
```

## RTL/LTR Implementation Details

### Alignment Migration

#### Current Issues

- 7 hardcoded alignments using `left/right`
- Need to replace with `start/end`

#### Migration Pattern

```dart
// ❌ Before (Hardcoded)
Align(
  alignment: Alignment.centerLeft,
  child: Text('نص'),
)

Padding(
  padding: EdgeInsets.only(left: 16),
  child: Text('نص'),
)

// ✅ After (RTL-aware)
Align(
  alignment: AlignmentDirectional.centerStart,
  child: Text('نص'),
)

Padding(
  padding: EdgeInsetsDirectional.only(start: 16),
  child: Text('نص'),
)
```

### Directionality Widget

```dart
// In MaterialApp
MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) {
    return Directionality(
      textDirection: locale.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr,
      child: child!,
    );
  },
)
```

### Icon Mirroring

```dart
// Icons that should mirror in RTL
class DirectionalIcon extends StatelessWidget {
  final IconData icon;
  final bool shouldMirror;

  const DirectionalIcon({
    required this.icon,
    this.shouldMirror = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Transform(
      alignment: Alignment.center,
      transform: (isRTL && shouldMirror)
        ? Matrix4.rotationY(math.pi)
        : Matrix4.identity(),
      child: Icon(icon),
    );
  }
}

// Usage
DirectionalIcon(
  icon: Icons.arrow_forward,
  shouldMirror: true, // Will flip in RTL
)
```

## Data Models

### Locale Model

```dart
// Using Flutter's built-in Locale class
// No custom model needed

// Supported locales
const List<Locale> supportedLocales = [
  Locale('ar'), // Arabic
  Locale('en'), // English
];

// Locale extensions
extension LocaleExtensions on Locale {
  String get displayName {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }

  String get flagEmoji {
    switch (languageCode) {
      case 'ar':
        return '🇸🇦';
      case 'en':
        return '🇬🇧';
      default:
        return '🌐';
    }
  }
}
```

---

## Correctness Properties

_A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees._

### Property 1: Translation Key Completeness

_For any_ translation key in the Arabic ARB file, the same key must exist in all other language ARB files (English).
**Validates: Requirements 1.5, 7.1**

### Property 2: No Hardcoded Strings

_For any_ Text widget in the codebase, it must use `AppLocalizations.of(context)` instead of hardcoded strings.
**Validates: Requirements 2.1, 2.2**

### Property 3: RTL/LTR Alignment Consistency

_For any_ alignment property in the codebase, it must use `start/end` instead of `left/right`.
**Validates: Requirements 3.3**

### Property 4: Text Overflow Handling

_For any_ Text widget that displays user-generated or dynamic content, it must have `overflow` property set to `TextOverflow.ellipsis` or similar.
**Validates: Requirements 4.1, 4.2, 4.3**

### Property 5: Date Format Localization

_For any_ date displayed to the user, it must be formatted using `DateFormat` with the current locale.
**Validates: Requirements 5.1**

### Property 6: Number Format Localization

_For any_ number or currency displayed to the user, it must be formatted using `NumberFormat` with the current locale.
**Validates: Requirements 5.2, 5.3**

### Property 7: Locale Persistence

_For any_ locale change by the user, the new locale must be saved to local storage and restored on app restart.
**Validates: Requirements 6.2, 6.4**

### Property 8: Locale Change Propagation

_For any_ locale change, all visible UI elements must update to reflect the new language without requiring app restart.
**Validates: Requirements 6.3**

---

## Error Handling

### Translation Key Not Found

```dart
// Fallback mechanism in AppLocalizations
String getTranslation(String key) {
  try {
    return _localizedValues[key] ?? key;
  } catch (e) {
    debugPrint('Translation key not found: $key');
    return key; // Return key as fallback
  }
}
```

### Locale Loading Failure

```dart
// In LocaleProvider
Future<void> _loadSavedLocale() async {
  try {
    final repository = ref.read(localeRepositoryProvider);
    final savedLocale = await repository.getSavedLocale();
    if (savedLocale != null && _isSupported(savedLocale)) {
      state = savedLocale;
    } else {
      state = const Locale('ar'); // Default fallback
    }
  } catch (e) {
    debugPrint('Failed to load saved locale: $e');
    state = const Locale('ar'); // Default fallback
  }
}

bool _isSupported(Locale locale) {
  return supportedLocales.any((l) => l.languageCode == locale.languageCode);
}
```

### Format Failure

```dart
// In FormatHelpers
static String formatDate(DateTime date, Locale locale) {
  try {
    final formatter = DateFormat.yMMMd(locale.languageCode);
    return formatter.format(date);
  } catch (e) {
    debugPrint('Date formatting failed: $e');
    // Fallback to ISO format
    return date.toIso8601String().split('T')[0];
  }
}
```

---

## Testing Strategy

### Testing Approach

النظام يتطلب ثلاثة أنواع من الاختبارات:

1. **Unit Tests**: للتحقق من منطق الترجمة والتنسيق
2. **Widget Tests**: للتحقق من عرض الترجمات في UI
3. **Integration Tests**: للتحقق من تبديل اللغة end-to-end

**Coverage Goal**: > 80% لكود الترجمة

### Unit Tests

#### Translation Key Tests

```dart
test('all translation keys exist in all languages', () {
  final arKeys = loadArKeys();
  final enKeys = loadEnKeys();

  expect(arKeys.length, equals(enKeys.length));
  for (final key in arKeys) {
    expect(enKeys, contains(key));
  }
});
```

#### Format Helper Tests

```dart
test('formatCurrency returns correct format for Arabic', () {
  final result = FormatHelpers.formatCurrency(1234.56, Locale('ar'));
  expect(result, contains('ر.س'));
  expect(result, contains('1,234.56'));
});

test('formatDate returns correct format for English', () {
  final date = DateTime(2025, 12, 9);
  final result = FormatHelpers.formatDate(date, Locale('en'));
  expect(result, contains('Dec'));
  expect(result, contains('9'));
  expect(result, contains('2025'));
});
```

### Widget Tests

#### Localization Widget Tests

```dart
testWidgets('Text displays translated string', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('ar'),
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context)!.appTitle);
          },
        ),
      ),
    ),
  );

  expect(find.text('بصير'), findsOneWidget);
});
```

#### RTL/LTR Tests

```dart
testWidgets('UI direction changes with locale', (tester) async {
  // Test Arabic (RTL)
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale('ar'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(),
      ),
    ),
  );

  final directionality = tester.widget<Directionality>(
    find.byType(Directionality),
  );
  expect(directionality.textDirection, TextDirection.rtl);

  // Test English (LTR)
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale('en'),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(),
      ),
    ),
  );

  final directionality2 = tester.widget<Directionality>(
    find.byType(Directionality),
  );
  expect(directionality2.textDirection, TextDirection.ltr);
});
```

### Integration Tests

#### Language Switching Test

```dart
testWidgets('switching language updates entire UI', (tester) async {
  await tester.pumpWidget(MyApp());

  // Verify initial language (Arabic)
  expect(find.text('بصير'), findsOneWidget);

  // Navigate to settings
  await tester.tap(find.byIcon(Icons.settings));
  await tester.pumpAndSettle();

  // Change language to English
  await tester.tap(find.text('English'));
  await tester.pumpAndSettle();

  // Verify language changed
  expect(find.text('Basir'), findsOneWidget);
  expect(find.text('بصير'), findsNothing);
});
```

### Automated Testing Scripts

#### I18n Test Runner

```bash
#!/bin/bash
# test/i18n/run_i18n_tests.sh

echo "Running I18n Tests..."

# Run unit tests
echo "1. Running unit tests..."
flutter test test/unit/core/utils/format_helpers_test.dart
flutter test test/unit/core/repositories/locale_repository_test.dart

# Run widget tests
echo "2. Running widget tests..."
flutter test test/widget/core/widgets/localized_text_test.dart

# Run integration tests
echo "3. Running integration tests..."
flutter test integration_test/language_switching_test.dart

# Check translation completeness
echo "4. Checking translation completeness..."
bash scripts/i18n/check_completeness.sh

echo "✅ All I18n tests completed!"
```

---

## Performance Considerations

### Lazy Loading

- ARB files are loaded once at app startup
- Generated `AppLocalizations` class is efficient
- No runtime parsing of JSON

### Caching

- Locale preference cached in SharedPreferences
- No repeated disk reads
- In-memory locale state in Riverpod

### Build Optimization

- Use `const` constructors where possible
- Minimize rebuilds when locale changes
- Use `Consumer` widgets strategically

```dart
// ✅ Good - Only rebuilds Text widget
Consumer(
  builder: (context, ref, child) {
    final locale = ref.watch(localeProvider);
    return Text(AppLocalizations.of(context)!.appTitle);
  },
)

// ❌ Bad - Rebuilds entire screen
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider); // Unnecessary watch
    return Scaffold(
      // ... entire screen rebuilds
    );
  }
}
```

---

## Security Considerations

### Input Validation

```dart
// Sanitize user input before displaying
class InputSanitizer {
  static String sanitize(String input) {
    // Remove HTML tags
    String sanitized = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove script tags
    sanitized = sanitized.replaceAll(RegExp(r'<script[^>]*>.*?</script>',
      caseSensitive: false, multiLine: true), '');

    return sanitized;
  }
}

// Usage in widgets
Text(InputSanitizer.sanitize(userInput))
```

### Translation File Security

- ✅ No API keys or secrets in ARB files
- ✅ No user data in translation files
- ✅ Translation files are version controlled
- ✅ Validate translation keys at build time

### Data Privacy

- No sensitive data in translation files
- Translation files are public
- User locale preference is not sensitive
- Locale stored in SharedPreferences (non-encrypted)

---

## Migration Strategy

### Phase 1: Setup (Week 1)

1. Create ARB files structure
2. Configure l10n.yaml
3. Add flutter_localizations dependency
4. Generate AppLocalizations

### Phase 2: Core Translations (Week 2)

1. Extract and translate navigation strings
2. Extract and translate common actions
3. Extract and translate validation messages
4. Test core functionality

### Phase 3: Module Translations (Week 3-4)

1. Customer module translations
2. Invoice module translations
3. Settings module translations
4. Dashboard module translations

### Phase 4: Refinements (Week 5)

1. Fix RTL alignments
2. Add overflow handling
3. Implement date/number formatting
4. Add language switcher UI

### Phase 5: Testing & Documentation (Week 6)

1. Comprehensive testing
2. Documentation
3. Developer tools
4. Final review

---

## Documentation

### Developer Guide Structure

سيتم إنشاء دليل شامل في `.kiro/docs/i18n/` يتضمن:

#### 1. Getting Started Guide

- كيفية إضافة نص جديد
- كيفية استخدام AppLocalizations
- أمثلة عملية

#### 2. Translation Guide

- بنية ملفات ARB
- قواعد تسمية المفاتيح
- أفضل الممارسات

#### 3. RTL Support Guide

- استخدام start/end بدلاً من left/right
- EdgeInsetsDirectional
- اختبار RTL/LTR

#### 4. Troubleshooting Guide

- مشاكل شائعة وحلولها
- أخطاء البناء
- مشاكل الترجمة المفقودة

#### 5. API Reference

- FormatHelpers API
- LocaleProvider API
- LocaleRepository API

### Code Documentation Standards

````dart
/// يقوم بتنسيق التاريخ حسب اللغة الحالية.
///
/// [date] التاريخ المراد تنسيقه.
/// [locale] اللغة المستخدمة للتنسيق.
///
/// Returns سلسلة نصية تمثل التاريخ المنسق.
///
/// مثال:
/// ```dart
/// final formatted = FormatHelpers.formatDate(
///   DateTime.now(),
///   Locale('ar'),
/// );
/// print(formatted); // "٩ ديسمبر ٢٠٢٥"
/// ```
static String formatDate(DateTime date, Locale locale) {
  // Implementation
}
````

## Dependencies

### Required Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
  shared_preferences: ^2.2.0
  riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  mockito: ^5.4.0 # For testing
```

### Package Justification

- **flutter_localizations**: نظام الترجمة المدمج في Flutter
- **intl**: تنسيق التواريخ والأرقام
- **shared_preferences**: حفظ اللغة المفضلة
- **riverpod**: إدارة حالة اللغة
- **mockito**: اختبار المكونات مع mocking

---

## Monitoring and Maintenance

### Translation Coverage Metrics

```dart
// lib/core/utils/translation_metrics.dart

class TranslationMetrics {
  static int getTotalKeys() {
    // Count total translation keys
  }

  static int getMissingKeys(String languageCode) {
    // Count missing translations for a language
  }

  static double getCoveragePercentage(String languageCode) {
    final total = getTotalKeys();
    final missing = getMissingKeys(languageCode);
    return ((total - missing) / total) * 100;
  }
}
```

### Continuous Integration Checks

```yaml
# .github/workflows/i18n-check.yml
name: I18n Checks

on: [push, pull_request]

jobs:
  check-translations:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Check translation completeness
        run: bash scripts/i18n/check_completeness.sh

      - name: Check for hardcoded strings
        run: bash scripts/i18n/extract_strings.sh

      - name: Fail if issues found
        run: |
          if [ -s extracted_strings.txt ]; then
            echo "❌ Hardcoded strings found!"
            exit 1
          fi
```

### Maintenance Schedule

- **Weekly**: مراجعة الترجمات الجديدة
- **Monthly**: تحديث الإحصائيات والتقارير
- **Quarterly**: مراجعة شاملة للترجمات
- **Yearly**: تقييم إضافة لغات جديدة

## Future Enhancements

### Phase 2 (Post-MVP)

- Additional languages (French, German, etc.)
- Pluralization support (e.g., "1 item" vs "2 items")
- Gender-specific translations
- Context-aware translations
- Right-to-left language improvements

### Phase 3 (Advanced)

- Online translation management system (e.g., Lokalise, Crowdin)
- A/B testing for translations
- Translation analytics and usage tracking
- Professional translation service integration
- Machine translation suggestions
- Translation memory and glossary

### Scalability Considerations

- **Current**: 2 languages, ~200 keys per language
- **Phase 2**: 5 languages, ~500 keys per language
- **Phase 3**: 10+ languages, ~1000+ keys per language

**Performance Impact**: مع النمو، قد نحتاج:

- Lazy loading للغات
- Translation caching strategies
- CDN للترجمات في Web

---

**تم إعداده بواسطة:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 9 ديسمبر 2025  
**الإصدار:** 1.1  
**الحالة:** 🔄 قيد المراجعة
