**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 15 ديسمبر 2025

---

---

inclusion: fileMatch
fileMatchPattern: '\*.dart'

---

# Flutter Frontend Development Standards

## Flutter Widget Architecture

### Widget Selection Guidelines

- **StatelessWidget**: For widgets that don't change (static content, pure functions)
- **StatefulWidget**: For widgets with internal state (forms, animations)
- **ConsumerWidget**: For widgets that need Riverpod providers
- **HookWidget**: For widgets using Flutter Hooks (advanced cases)

### Widget Composition Patterns

```dart
// Good: Composition over inheritance
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

// Bad: Monolithic widget
class InvoiceCard extends StatelessWidget {
  // 200+ lines of build method
}
```

### Performance-First Widget Design

- Use `const` constructors wherever possible
- Implement `RepaintBoundary` for expensive widgets
- Use `ListView.builder` for large lists
- Implement proper `dispose()` methods

## Material Design 3 Implementation

### Design System Standards

```dart
// Good: Consistent design system usage
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3), // Baseer blue
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

### Component Standards

- **Cards**: Use `Card` widget for grouped content
- **Lists**: Use `ListTile` for consistent list items
- **Forms**: Use `TextFormField` with proper validation
- **Navigation**: Use `NavigationBar` for bottom navigation
- **Dialogs**: Use `AlertDialog` for confirmations

## Arabic/RTL Layout Standards

### RTL Layout Implementation

```dart
// Good: Proper RTL support
class ArabicAwareWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الفواتير'),
          automaticallyImplyLeading: true, // Handles RTL back button
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns to right in RTL
          children: [
            Text('مرحباً بك في بصير'),
            // More widgets...
          ],
        ),
      ),
    );
  }
}
```

### Arabic Typography Standards

```dart
// Arabic text styling
class ArabicTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Cairo', // Arabic-friendly font
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.5, // Better line height for Arabic
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    height: 1.6,
  );
}
```

### Bidirectional Text Handling

```dart
// Handle mixed Arabic/English text
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
    // Detect if text is primarily Arabic or English
    final arabicChars = RegExp(r'[\u0600-\u06FF]').allMatches(text).length;
    final totalChars = text.replaceAll(RegExp(r'\s'), '').length;

    return arabicChars > totalChars * 0.5
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
```

## Mobile-First Design Standards

### Responsive Design for Mobile

```dart
// Good: Responsive design patterns
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

### Touch Interaction Standards

- **Minimum Touch Target**: 44x44 logical pixels
- **Touch Feedback**: Visual feedback for all interactive elements
- **Gesture Support**: Support common mobile gestures (swipe, pinch)
- **Accessibility**: Support TalkBack and VoiceOver

## State Management with Riverpod

### Provider Organization

```dart
// Good: Organized provider structure
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

### State Management Patterns

- **Loading States**: Always handle loading, error, and success states
- **Error Handling**: Provide meaningful error messages in Arabic
- **Optimistic Updates**: Update UI immediately, sync in background
- **State Persistence**: Persist important state across app restarts

## Testing Strategy for Flutter

### Widget Testing Standards

```dart
void main() {
  group('CustomerCard Widget', () {
    testWidgets('displays customer information correctly', (tester) async {
      final customer = Customer(name: 'أحمد محمد', phone: '0501234567');

      await tester.pumpWidget(
        MaterialApp(
          home: CustomerCard(customer: customer),
        ),
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

      // Verify RTL layout
      final cardWidget = tester.widget<Card>(find.byType(Card));
      expect(cardWidget.child, isA<Directionality>());
    });
  });
}
```

### Golden File Testing

```dart
void main() {
  testWidgets('invoice card golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: InvoiceCard(invoice: mockInvoice),
      ),
    );

    await expectLater(
      find.byType(InvoiceCard),
      matchesGoldenFile('invoice_card.png'),
    );
  });
}
```

## Performance Optimization

### Flutter-Specific Optimizations

- **Build Method Optimization**: Keep build methods pure and fast
- **Widget Caching**: Cache expensive widgets with `const`
- **Image Optimization**: Use appropriate image formats and sizes
- **Animation Performance**: Use `AnimationController` efficiently
- **Memory Management**: Dispose resources properly

### Database Performance for Mobile

```dart
// Good: Efficient database operations
class OptimizedRepository {
  Future<List<Invoice>> getRecentInvoices() async {
    return await isar.invoices
      .where()
      .sortByCreatedAtDesc()
      .limit(50) // Limit results for mobile performance
      .findAll();
  }

  Future<List<Invoice>> searchInvoices(String query) async {
    return await isar.invoices
      .filter()
      .customerNameContains(query, caseSensitive: false)
      .limit(20) // Limit search results
      .findAll();
  }
}
```

---

**للمراجع التفصيلية:** راجع ملفات التوجيه الأخرى في `.kiro/steering/`
