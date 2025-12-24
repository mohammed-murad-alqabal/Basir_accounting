---
id: "performance-optimization"
description: "دليل شامل لتحسين الأداء في تطبيقات Flutter"
version: "1.0"
last_updated: "2025-12-17"
inclusion: manual
author: "فريق وكلاء تطوير مشروع بصير"
location: ".kiro/guides/"
metrics:
  location: ".kiro/guides/"
  size: "17KB"
  lines: 424
  context_usage: "8%"
---

# تحسين الأداء - بصير MVP

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**آخر تحديث:** 17 ديسمبر 2025  
**الحالة:** ✅ نشط ومكثف

---

## 🎯 مبادئ الأداء الأساسية

### **Flutter Performance Essentials**

- **const Constructors**: استخدم `const` دائماً للـ widgets الثابتة
- **ListView.builder**: للقوائم الطويلة فقط
- **RepaintBoundary**: للـ widgets المعقدة
- **Proper Disposal**: تنظيف الموارد في `dispose()`

---

## 🚀 تحسين الـ Widgets

### **الأساسيات اليومية**

```dart
// ✅ جيد: استخدام const
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('نص ثابت'),
        Icon(Icons.star),
        SizedBox(height: 16),
      ],
    );
  }
}

// ✅ جيد: ListView.builder للقوائم الطويلة
class InvoiceList extends StatelessWidget {
  final List<Invoice> invoices;

  const InvoiceList({super.key, required this.invoices});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return ListTile(
          key: ValueKey(invoice.id),
          title: Text(invoice.customerName),
          subtitle: Text('${invoice.totalAmount} ريال'),
        );
      },
    );
  }
}
```

### **إدارة الموارد**

```dart
class ResourceManagedWidget extends StatefulWidget {
  @override
  State<ResourceManagedWidget> createState() => _ResourceManagedWidgetState();
}

class _ResourceManagedWidgetState extends State<ResourceManagedWidget> {
  late AnimationController _controller;
  late StreamSubscription _subscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _subscription = someStream.listen(_handleData);
    _timer = Timer.periodic(Duration(seconds: 5), _periodicTask);
  }

  @override
  void dispose() {
    // ترتيب عكسي للتنظيف
    _timer?.cancel();
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * pi,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

---

## 💾 تحسين قاعدة البيانات (Isar)

### **الفهرسة الذكية**

```dart
@Collection()
class Invoice {
  Id id = Isar.autoIncrement;

  @Index() // فهرس للبحث السريع
  late int customerId;

  @Index() // فهرس للفلترة
  late InvoiceStatus status;

  @Index() // فهرس للترتيب
  late DateTime createdAt;

  // فهرس مركب للاستعلامات المعقدة
  @Index(composite: [CompositeIndex('customerId')])
  late DateTime dueDate;

  late double totalAmount;
  late String description;
}
```

### **الاستعلامات المحسنة**

```dart
class OptimizedInvoiceRepository {
  final Isar isar;

  OptimizedInvoiceRepository(this.isar);

  // استعلام بسيط مع فهرس
  Future<List<Invoice>> getInvoicesByStatus(InvoiceStatus status) async {
    return await isar.invoices
        .where()
        .statusEqualTo(status)
        .findAll();
  }

  // ترقيم الصفحات للأداء
  Future<List<Invoice>> getInvoicesPaginated({
    required int page,
    required int limit,
  }) async {
    return await isar.invoices
        .where()
        .sortByCreatedAtDesc()
        .offset(page * limit)
        .limit(limit)
        .findAll();
  }

  // العمليات المجمعة
  Future<void> createMultipleInvoices(List<Invoice> invoices) async {
    await isar.writeTxn(() async {
      await isar.invoices.putAll(invoices);
    });
  }
}
```

---

## 🔄 إدارة الحالة (Riverpod)

### **التحديثات الذكية**

```dart
// ✅ جيد: تحديثات محددة
final counterProvider = StateProvider<int>((ref) => 0);

class OptimizedCounter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // يعيد البناء فقط عند تغيير العداد
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('العدد: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: const Text('زيادة'),
        ),
      ],
    );
  }
}

// ✅ جيد: الاستماع الانتقائي
class SelectiveListener extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // يعيد البناء فقط عند تغيير الاسم
    final userName = ref.watch(
      userProvider.select((user) => user?.name),
    );

    return Text('مرحباً، ${userName ?? 'ضيف'}');
  }
}
```

---

## 📊 مراقبة الأداء

### **أدوات القياس الأساسية**

```bash
# فحص الأداء
flutter run --profile

# قياس حجم التطبيق
flutter build apk --analyze-size

# فحص الذاكرة
flutter run --profile --enable-software-rendering
```

### **مراقبة بسيطة**

```dart
class SimplePerformanceMonitor {
  static Future<T> measure<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();

      if (stopwatch.elapsedMilliseconds > 1000) {
        print('عملية بطيئة: $name استغرقت ${stopwatch.elapsedMilliseconds}ms');
      }

      return result;
    } catch (error) {
      stopwatch.stop();
      print('خطأ في $name بعد ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }
}

// الاستخدام
Future<List<Invoice>> getInvoices() async {
  return await SimplePerformanceMonitor.measure(
    'get_invoices',
    () => repository.getAllInvoices(),
  );
}
```

---

## 🖼️ تحسين الصور

### **تحميل ذكي للصور**

```dart
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      // تحسين الذاكرة
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      // معالجة الأخطاء
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
    );
  }
}
```

---

## 📋 قائمة التحقق اليومية

### **للمطورين**

- [ ] استخدام `const` للـ widgets الثابتة
- [ ] تنفيذ `dispose()` للموارد
- [ ] استخدام `ListView.builder` للقوائم الطويلة
- [ ] إضافة فهارس لقاعدة البيانات
- [ ] مراقبة استهلاك الذاكرة
- [ ] اختبار الأداء على أجهزة حقيقية

### **قبل النشر**

- [ ] فحص الأداء مع `flutter run --profile`
- [ ] قياس حجم التطبيق
- [ ] اختبار على أجهزة متوسطة المواصفات
- [ ] فحص تسريبات الذاكرة
- [ ] تحسين الصور والموارد

---

## 🚫 الأخطاء الشائعة

### **تجنب هذه الممارسات:**

```dart
// ❌ خطأ: بناء widgets في build()
Widget build(BuildContext context) {
  return Column(
    children: [
      Container(), // إنشاء جديد في كل مرة
      Text('نص'), // إنشاء جديد في كل مرة
    ],
  );
}

// ❌ خطأ: عدم تنظيف الموارد
class BadWidget extends StatefulWidget {
  @override
  State<BadWidget> createState() => _BadWidgetState();
}

class _BadWidgetState extends State<BadWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (t) {});
    // لا يوجد dispose() - تسريب ذاكرة!
  }
}

// ❌ خطأ: استخدام ListView للقوائم الطويلة
ListView(
  children: List.generate(1000, (index) => ListTile()), // بطيء جداً
)
```

---

## 🔗 المراجع المتقدمة

### **للتفاصيل الشاملة:**

- [دليل تحسين الأداء المتقدم](../../reference/advanced-performance-optimization.md)

### **أدوات مفيدة:**

- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Performance Profiling](https://flutter.dev/docs/perf/rendering/ui-performance)
- [Memory Profiling](https://flutter.dev/docs/development/tools/devtools/memory)

---

## 🎯 التوصيات العملية

### **للبدء:**

1. استخدم `const` في كل مكان ممكن
2. نفذ `dispose()` لجميع الموارد
3. استخدم `ListView.builder` للقوائم
4. أضف فهارس لقاعدة البيانات

### **للتطوير المستمر:**

1. راقب الأداء بانتظام
2. اختبر على أجهزة متوسطة
3. قس واحسن باستمرار
4. تعلم من Flutter DevTools

---

**تم بواسطة:** فريق وكلاء تطوير مشروع بصير  
**الحالة:** ✅ ملف توجيه مكثف ومحسن  
**المراجعة القادمة:** 23 ديسمبر 2025**للمراجع التفصيلية:** راجع Flutter DevTools وأدوات الأداء المتقدمة
