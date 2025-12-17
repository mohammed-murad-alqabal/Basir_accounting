**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 15 ديسمبر 2025

---

---

title: Project Standards - Baseer MVP Specific
inclusion: always

---

# Project Standards - Baseer MVP Specific

## Local-First Application Standards

### Offline Functionality as Primary Requirement

- **Always Local First**: All core functionality must work offline
- **Network Optional**: Internet connectivity is enhancement, not requirement
- **Data Persistence**: All user data must persist locally using Isar
- **Sync When Available**: Background synchronization when network is available
- **Graceful Degradation**: Features degrade gracefully when offline

### Local Data Synchronization Patterns

```dart
// Good: Local-first data pattern
class DataService {
  Future<List<Invoice>> getInvoices() async {
    // 1. Always return local data first
    final localData = await _localRepository.getAll();

    // 2. Sync in background if connected
    if (await _connectivity.isConnected()) {
      _backgroundSync();
    }

    return localData;
  }

  Future<void> saveInvoice(Invoice invoice) async {
    // 1. Save locally immediately
    await _localRepository.save(invoice);

    // 2. Queue for sync when online
    await _syncQueue.add(invoice);
  }
}
```

### Background Processing Guidelines

- Use `WorkManager` for reliable background tasks
- Implement exponential backoff for failed sync attempts
- Handle app lifecycle changes gracefully
- Preserve battery life with efficient scheduling

## Baseer-Specific Standards

### Invoice Management Patterns

```dart
// Invoice lifecycle management
class InvoiceService {
  // Invoice states: draft -> sent -> paid -> archived
  Future<void> updateInvoiceStatus(String id, InvoiceStatus status) async {
    final invoice = await _repository.getById(id);

    // Validate state transitions
    if (!_isValidTransition(invoice.status, status)) {
      throw InvalidStateTransitionException();
    }

    // Update with timestamp
    final updatedInvoice = invoice.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    await _repository.update(updatedInvoice);
  }
}
```

### Customer Data Handling

```dart
// Customer data management with Arabic support
class CustomerService {
  Future<void> addCustomer(Customer customer) async {
    // Validate Arabic names
    _validateArabicName(customer.name);

    // Validate Saudi phone numbers
    _validateSaudiPhone(customer.phone);

    // Store with proper RTL support
    await _repository.save(customer);
  }

  void _validateArabicName(String name) {
    if (!RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(name)) {
      throw ValidationException('الاسم يجب أن يكون باللغة العربية');
    }
  }

  void _validateSaudiPhone(String phone) {
    if (!RegExp(r'^05\d{8}$').hasMatch(phone)) {
      throw ValidationException('رقم الهاتف يجب أن يبدأ بـ 05 ويتكون من 10 أرقام');
    }
  }
}
```

### Arabic Language Support Requirements

- **RTL Layout**: All UI components must support right-to-left layout
- **Arabic Fonts**: Use system fonts that support Arabic properly
- **Number Formatting**: Support both Arabic-Indic (٠١٢٣) and Western (0123) numerals
- **Date Formatting**: Support Hijri and Gregorian calendars
- **Input Validation**: Validate Arabic text input correctly

## Code Quality Standards for Baseer

### Flutter-Specific Quality Standards

- Follow `effective_dart` guidelines strictly
- Use `const` constructors for all static widgets
- Implement proper `dispose()` methods for controllers
- Use `late` keyword appropriately for non-nullable fields
- Follow Clean Architecture with clear layer separation

### Naming Conventions for Arabic Context

```dart
// Good: Clear English names for code, Arabic for UI
class CustomerRepository {
  Future<List<Customer>> getAllCustomers() async { }
}

// UI Text in Arabic
const String addCustomerTitle = 'إضافة عميل جديد';
const String customerNameLabel = 'اسم العميل';
const String phoneNumberLabel = 'رقم الهاتف';
```

### Error Handling for Local Apps

```dart
// Comprehensive error handling
class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log locally (no network required)
    _localLogger.error(error, stackTrace);

    // Show user-friendly Arabic message
    final message = _getArabicErrorMessage(error);
    _showErrorDialog(message);

    // Queue for remote logging when online
    _errorQueue.add(ErrorReport(error, stackTrace));
  }

  static String _getArabicErrorMessage(Object error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'لا يوجد اتصال بالإنترنت';
      case ValidationException:
        return 'البيانات المدخلة غير صحيحة';
      case DatabaseException:
        return 'حدث خطأ في حفظ البيانات';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
```

## Testing Requirements for Baseer

### Local App Testing Standards

- **Offline Testing**: Test all functionality without network
- **Data Persistence Testing**: Verify data survives app restarts
- **Arabic Input Testing**: Test Arabic text input and display
- **RTL Layout Testing**: Test UI in right-to-left mode
- **Performance Testing**: Test with large local datasets

### Test Coverage Requirements

- **Unit Tests**: 70%+ coverage for business logic
- **Widget Tests**: All custom widgets must have tests
- **Integration Tests**: Critical user flows (create invoice, add customer)
- **Golden Tests**: UI consistency across different screen sizes

### Example Test Structure

```dart
void main() {
  group('Invoice Management', () {
    testWidgets('should create invoice offline', (tester) async {
      // Setup offline environment
      await tester.pumpWidget(MyApp(isOffline: true));

      // Test invoice creation
      await tester.tap(find.byKey(Key('add_invoice_button')));
      await tester.pumpAndSettle();

      // Verify invoice saved locally
      expect(find.text('تم حفظ الفاتورة'), findsOneWidget);
    });

    testWidgets('should display Arabic text correctly', (tester) async {
      await tester.pumpWidget(MyApp(locale: Locale('ar')));

      // Test RTL layout
      expect(find.text('إضافة فاتورة جديدة'), findsOneWidget);

      // Verify text direction
      final textWidget = tester.widget<Text>(find.text('إضافة فاتورة جديدة'));
      expect(textWidget.textDirection, TextDirection.rtl);
    });
  });
}
```

## Documentation Standards for Baseer

### Arabic Documentation Requirements

- **User-facing text**: All UI text must be in Arabic
- **Error messages**: All error messages in Arabic
- **Help documentation**: User guides in Arabic
- **Code comments**: Technical comments in English, user stories in Arabic

### API Documentation

```dart
/// إدارة الفواتير في التطبيق
///
/// يوفر هذا الكلاس جميع العمليات المطلوبة لإدارة الفواتير
/// بما في ذلك الإنشاء والتعديل والحذف والبحث
class InvoiceManager {
  /// ينشئ فاتورة جديدة
  ///
  /// [customer] العميل المرتبط بالفاتورة
  /// [items] قائمة البنود في الفاتورة
  ///
  /// Returns معرف الفاتورة الجديدة
  /// Throws [ValidationException] إذا كانت البيانات غير صحيحة
  Future<String> createInvoice(Customer customer, List<InvoiceItem> items) async {
    // Implementation
  }
}
```

## Security Practices for Local Apps

### Local Data Security

- **Encryption at Rest**: Encrypt sensitive data in local database
- **Secure Storage**: Use `flutter_secure_storage` for credentials
- **Input Sanitization**: Sanitize all user inputs before storage
- **Access Control**: Implement app-level access controls

### Privacy Considerations

```dart
// Privacy-first data handling
class PrivacyManager {
  // No personal data leaves the device without explicit consent
  Future<void> exportData() async {
    final consent = await _getUserConsent();
    if (!consent) return;

    // Anonymize data before export
    final anonymizedData = await _anonymizeData();
    await _exportToFile(anonymizedData);
  }

  // Clear all data when requested
  Future<void> clearAllData() async {
    await _localDatabase.clear();
    await _secureStorage.deleteAll();
    await _preferences.clear();
  }
}
```

## Performance Guidelines for Mobile Apps

### Flutter Performance Optimization

- **Widget Rebuilds**: Minimize unnecessary widget rebuilds
- **Memory Management**: Dispose controllers and streams properly
- **Image Optimization**: Optimize images for mobile screens
- **List Performance**: Use `ListView.builder` for large lists
- **Database Queries**: Optimize Isar queries with proper indexing

### Battery Life Considerations

- **Background Tasks**: Minimize background processing
- **Network Usage**: Batch network requests when online
- **Screen Updates**: Reduce unnecessary screen updates
- **Location Services**: Use location services sparingly

## Deployment Standards

### Mobile App Deployment

- **App Store Optimization**: Optimize for Arabic app stores
- **Localization**: Support Arabic and English languages
- **Testing**: Test on various Android devices and screen sizes
- **Performance**: Ensure smooth performance on mid-range devices

### Version Management

```yaml
# pubspec.yaml version management
version: 1.0.0+1
# Format: major.minor.patch+build
# Increment build number for each release
# Increment version for feature releases
```

---

**للمراجع التفصيلية:** راجع ملفات التوجيه الأخرى في `.kiro/steering/`
