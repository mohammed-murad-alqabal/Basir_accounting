---
id: "frontend-standards"
description: "معايير Flutter Frontend الشاملة"
version: "1.0"
last_updated: "2025-12-17"
inclusion: manual
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  location: ".kiro/guides/"
  size: "11KB"
  lines: 320
  context_usage: "5.5%"
---

# معايير Flutter Frontend - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 17 ديسمبر 2025  
**الحالة:** ✅ نشط ومكثف

---

## 🏗️ معمارية Flutter Widgets

### **اختيار نوع Widget**

- **StatelessWidget**: للمحتوى الثابت
- **StatefulWidget**: للحالة الداخلية (نماذج، رسوم متحركة)
- **ConsumerWidget**: لـ Riverpod providers
- **HookWidget**: للحالات المتقدمة

### **أنماط تركيب Widgets**

```dart
// ✅ جيد: التركيب بدلاً من الوراثة
class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InvoiceHeader(invoice: invoice),
          InvoiceBody(invoice: invoice),
          InvoiceActions(invoice: invoice),
        ],
      ),
    );
  }
}

// ❌ خطأ: widget واحد كبير
class InvoiceCard extends StatelessWidget {
  // 200+ سطر في build method
}
```

### **تصميم محسن للأداء**

- استخدام `const` constructors دائماً
- `RepaintBoundary` للـ widgets المعقدة
- `ListView.builder` للقوائم الطويلة
- تنفيذ `dispose()` بشكل صحيح

---

## 🎨 Material Design 3

### **نظام التصميم**

```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3), // بصير الأزرق
      brightness: Brightness.light,
    ),
    typography: Typography.material2021(),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3),
      brightness: Brightness.dark,
    ),
  );
}
```

### **معايير المكونات**

- **Cards**: استخدام `Card` للمحتوى المجمع
- **Lists**: استخدام `ListTile` لعناصر القائمة المتسقة
- **Forms**: استخدام `TextFormField` مع التحقق المناسب
- **Navigation**: استخدام `NavigationBar` للتنقل السفلي
- **Dialogs**: استخدام `AlertDialog` للتأكيدات

---

## 🔤 دعم العربية و RTL

### **تنفيذ RTL Layout**

```dart
class ArabicAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الفواتير'),
          automaticallyImplyLeading: true, // يتعامل مع زر الرجوع RTL
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start, // محاذاة لليمين في RTL
          children: [
            Text('مرحباً بك في بصير'),
          ],
        ),
      ),
    );
  }
}
```

### **معايير الطباعة العربية**

```dart
class ArabicTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Cairo', // خط مناسب للعربية
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.5, // ارتفاع سطر أفضل للعربية
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    height: 1.6,
  );
}
```

### **معالجة النص ثنائي الاتجاه**

```dart
class BidirectionalText extends StatelessWidget {
  final String text;
  const BidirectionalText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: _detectTextDirection(text),
      textAlign: _getTextAlign(text),
    );
  }

  TextDirection _detectTextDirection(String text) {
    final arabicChars = RegExp(r'[\u0600-\u06FF]').allMatches(text).length;
    final totalChars = text.replaceAll(RegExp(r'\s'), '').length;

    return arabicChars > totalChars * 0.5
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
```

---

## 📱 التصميم المحمول أولاً

### **التصميم المتجاوب**

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileLayout(child: child);
        } else {
          return TabletLayout(child: child);
        }
      },
    );
  }
}
```

### **معايير التفاعل باللمس**

- **الحد الأدنى للهدف**: 44x44 بكسل منطقي
- **ردود الفعل البصرية**: لجميع العناصر التفاعلية
- **دعم الإيماءات**: الإيماءات الشائعة (السحب، القرص)
- **إمكانية الوصول**: دعم TalkBack و VoiceOver

---

## 🔄 إدارة الحالة مع Riverpod

### **تنظيم Providers**

```dart
// Domain providers
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(ref.watch(isarProvider));
});

// State providers
final customersProvider = StateNotifierProvider<CustomersNotifier, AsyncValue<List<Customer>>>((ref) {
  return CustomersNotifier(ref.watch(customerRepositoryProvider));
});

// UI state providers
final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);
```

### **أنماط إدارة الحالة**

- **حالات التحميل**: التعامل دائماً مع حالات التحميل والخطأ والنجاح
- **معالجة الأخطاء**: رسائل خطأ واضحة بالعربية
- **التحديثات المتفائلة**: تحديث الواجهة فوراً، مزامنة في الخلفية
- **استمرارية الحالة**: الحفاظ على الحالة المهمة عبر إعادة تشغيل التطبيق

---

## 🧪 استراتيجية الاختبارات

### **معايير اختبار Widgets**

```dart
void main() {
  group('CustomerCard Widget', () {
    testWidgets('displays customer information correctly', (tester) async {
      final customer = Customer(name: 'أحمد محمد', phone: '0501234567');

      await tester.pumpWidget(
        MaterialApp(home: CustomerCard(customer: customer)),
      );

      expect(find.text('أحمد محمد'), findsOneWidget);
      expect(find.text('0501234567'), findsOneWidget);
    });

    testWidgets('handles RTL layout correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          home: CustomerCard(customer: testCustomer),
        ),
      );

      final cardWidget = tester.widget<Card>(find.byType(Card));
      expect(cardWidget.child, isA<Directionality>());
    });
  });
}
```

### **اختبار Golden Files**

```dart
void main() {
  testWidgets('invoice card golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: InvoiceCard(invoice: mockInvoice)),
    );

    await expectLater(
      find.byType(InvoiceCard),
      matchesGoldenFile('invoice_card.png'),
    );
  });
}
```

---

## ⚡ تحسين الأداء

### **تحسينات Flutter المحددة**

- **تحسين Build Method**: الحفاظ على build methods سريعة ونقية
- **تخزين Widgets مؤقتاً**: تخزين widgets المكلفة مع `const`
- **تحسين الصور**: استخدام تنسيقات وأحجام مناسبة
- **أداء الرسوم المتحركة**: استخدام `AnimationController` بكفاءة
- **إدارة الذاكرة**: التخلص من الموارد بشكل صحيح

### **أداء قاعدة البيانات للمحمول**

```dart
class OptimizedRepository {
  Future<List<Invoice>> getRecentInvoices() async {
    return await isar.invoices
      .where()
      .sortByCreatedAtDesc()
      .limit(50) // تحديد النتائج لأداء المحمول
      .findAll();
  }

  Future<List<Invoice>> searchInvoices(String query) async {
    return await isar.invoices
      .filter()
      .customerNameContains(query, caseSensitive: false)
      .limit(20) // تحديد نتائج البحث
      .findAll();
  }
}
```

---

## 🔗 المراجع المتقدمة

### **للتفاصيل الشاملة:**

- **Advanced Frontend Standards**

### **المعايير التقنية:**

- [معايير المشروع](./project-standards.md)
- [معايير التطوير](./development-standards.md)
- [أفضل ممارسات الأداء](./performance-optimization.md)

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ ملف توجيه مكثف ومحسن  
**المراجعة القادمة:** 23 ديسمبر 2025
