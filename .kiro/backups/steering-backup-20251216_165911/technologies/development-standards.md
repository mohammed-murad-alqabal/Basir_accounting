**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 15 ديسمبر 2025

---

---

title: Development Standards - Enhanced for Baseer MVP
inclusion: always

---

# Development Standards - Enhanced for Baseer MVP

## Flutter/Dart Specific Standards

### Code Quality Standards

- Follow `effective_dart` guidelines and Flutter best practices
- Use `dart format` for consistent code formatting
- Implement `const` constructors wherever possible
- Use `final` for immutable variables
- Follow Clean Architecture (3 layers: Presentation, Domain, Data)

### Project Structure Standards

```
lib/
├── core/                    # Core utilities and constants
├── features/               # Feature-first organization
│   ├── invoices/          # Invoice management feature
│   │   ├── data/          # Data layer (repositories, models)
│   │   ├── domain/        # Domain layer (entities, use cases)
│   │   └── presentation/  # Presentation layer (pages, widgets)
│   └── customers/         # Customer management feature
└── shared/                # Shared widgets and utilities
```

## State Management Standards (Riverpod)

### Provider Patterns

- Use `StateNotifier` for complex state management
- Implement `AsyncValue` for handling loading/error states
- Use `family` modifiers for parameterized providers
- Follow dependency injection patterns with providers

### Example Implementation

```dart
// Good: StateNotifier for complex state
class InvoiceNotifier extends StateNotifier<AsyncValue<List<Invoice>>> {
  InvoiceNotifier(this._repository) : super(const AsyncValue.loading());

  final InvoiceRepository _repository;

  Future<void> loadInvoices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllInvoices());
  }
}

// Provider definition
final invoiceProvider = StateNotifierProvider<InvoiceNotifier, AsyncValue<List<Invoice>>>(
  (ref) => InvoiceNotifier(ref.watch(invoiceRepositoryProvider)),
);
```

## Local Database Standards (Isar)

### Schema Design

- Use proper indexing for frequently queried fields
- Implement composite indexes for complex queries
- Follow naming conventions: `@Collection()` for entities
- Use `@Id()` for primary keys, prefer `int` over `String`

### Query Optimization

```dart
// Good: Efficient query with proper indexing
@Collection()
class Invoice {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  @Index()
  late int customerId;

  @Index(composite: [CompositeIndex('customerId')])
  late String status;
}

// Efficient query usage
Future<List<Invoice>> getCustomerInvoices(int customerId) async {
  return await isar.invoices
    .where()
    .customerIdEqualTo(customerId)
    .sortByCreatedAtDesc()
    .findAll();
}
```

### Transaction Management

- Use transactions for related operations
- Implement proper error handling in transactions
- Keep transactions as short as possible

```dart
// Good: Transaction usage
Future<void> createInvoiceWithItems(Invoice invoice, List<InvoiceItem> items) async {
  await isar.writeTxn(() async {
    await isar.invoices.put(invoice);
    await isar.invoiceItems.putAll(items);
  });
}
```

## Offline-First Application Standards

### Data Synchronization

- Implement conflict resolution strategies
- Use optimistic updates for better UX
- Handle network connectivity changes gracefully
- Implement background sync when connectivity returns

### Local Storage Patterns

```dart
// Good: Offline-first repository pattern
class InvoiceRepository {
  final IsarDatabase _localDb;
  final ApiService _apiService;
  final ConnectivityService _connectivity;

  Future<List<Invoice>> getInvoices() async {
    // Always return local data first
    final localInvoices = await _localDb.getAllInvoices();

    // Sync in background if connected
    if (await _connectivity.isConnected()) {
      _syncInBackground();
    }

    return localInvoices;
  }

  Future<void> _syncInBackground() async {
    // Background sync implementation
  }
}
```

## Arabic Language & RTL Support

### Localization Standards

- Use `flutter_localizations` for proper RTL support
- Implement `Directionality` widgets correctly
- Test all UI components in both LTR and RTL modes
- Use Arabic-specific date/number formatting

### Text Input Standards

```dart
// Good: Arabic text input handling
TextField(
  textDirection: TextDirection.rtl,
  textAlign: TextAlign.right,
  inputFormatters: [
    ArabicTextInputFormatter(), // Custom formatter for Arabic
  ],
  decoration: InputDecoration(
    hintText: 'أدخل اسم العميل',
    hintTextDirection: TextDirection.rtl,
  ),
)
```

## Testing Standards for Local Apps

### Unit Testing

- Test all business logic in isolation
- Mock external dependencies (API, database)
- Test offline scenarios specifically
- Achieve 70%+ test coverage

### Widget Testing

- Test UI components in both Arabic and English
- Test RTL layout correctness
- Test offline state handling in UI
- Use golden tests for visual regression

### Integration Testing

- Test complete user journeys offline
- Test data persistence across app restarts
- Test background sync functionality
- Test Arabic input and display

## Performance Standards

### Flutter Performance

- Use `const` constructors to reduce rebuilds
- Implement proper `ListView.builder` for large lists
- Use `RepaintBoundary` for expensive widgets
- Monitor memory usage with DevTools

### Database Performance

- Implement proper indexing strategies
- Use lazy loading for large datasets
- Implement pagination for list views
- Monitor query performance

## Security Standards for Local Apps

### Local Data Protection

- Use `flutter_secure_storage` for sensitive data
- Implement proper encryption for local database
- Validate all user inputs
- Implement secure backup/restore mechanisms

### Example Implementation

```dart
// Good: Secure local storage
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> storeUserPin(String pin) async {
    final hashedPin = await _hashPin(pin);
    await _storage.write(key: 'user_pin', value: hashedPin);
  }
}
```

## Dependency Management

### Flutter Dependencies

- Use latest stable versions of Flutter packages
- Prefer packages with active maintenance
- Document version constraints in pubspec.yaml
- Regular security audits of dependencies

### Recommended Packages for Baseer MVP

```yaml
dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.4.9 # State management
  isar: ^3.1.0 # Local database
  isar_flutter_libs: ^3.1.0
  flutter_secure_storage: ^9.0.0 # Secure storage
  connectivity_plus: ^5.0.2 # Network connectivity
  intl: ^0.18.1 # Internationalization

dev_dependencies:
  flutter_test:
    sdk: flutter
  isar_generator: ^3.1.0
  build_runner: ^2.4.7
  mockito: ^5.4.4 # Mocking for tests
```

## Code Review Standards

### Flutter-Specific Checklist

- [ ] Proper use of `const` constructors
- [ ] Correct state management patterns
- [ ] Efficient database queries
- [ ] Proper error handling for offline scenarios
- [ ] Arabic/RTL layout correctness
- [ ] Performance considerations (rebuilds, memory)
- [ ] Security best practices applied
- [ ] Tests written and passing

## Documentation Standards

### Code Documentation

- Use DartDoc for all public APIs
- Include usage examples in documentation
- Document offline behavior specifically
- Explain Arabic/RTL considerations

### Project Documentation

- Maintain comprehensive README with setup instructions
- Document database schema and migrations
- Include troubleshooting guide for common issues
- Document Arabic language setup requirements

---

**للمراجع التفصيلية:** راجع ملفات التوجيه الأخرى في `.kiro/steering/`
