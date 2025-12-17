---
title: Performance Optimization Guide
inclusion: fileMatch
fileMatchPattern: "*performance*|*optimization*|*benchmark*"
---

# Performance Optimization Guide

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025

---

## Flutter Performance Optimization

### Widget Performance Optimization

#### Efficient Widget Building

```dart
// Good: Use const constructors
class OptimizedWidget extends StatelessWidget {
  const OptimizedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        // Const widgets are cached and reused
        Text('Static Text'),
        Icon(Icons.star),
        SizedBox(height: 16),
      ],
    );
  }
}

// Good: Minimize rebuilds with RepaintBoundary
class ExpensiveWidget extends StatelessWidget {
  const ExpensiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: ComplexCustomPainter(),
        child: const SizedBox(
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

// Good: Use ListView.builder for large lists
class OptimizedListView extends StatelessWidget {
  final List<Item> items;

  const OptimizedListView({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          key: <credential-fixture>(item.id), // Stable keys for better performance
          title: Text(item.title),
          subtitle: Text(item.description),
        );
      },
    );
  }
}
```

#### State Management Performance

```dart
// Good: Granular state updates with Riverpod
final counterProvider = StateProvider<int>((ref) => 0);

class OptimizedCounter extends ConsumerWidget {
  const OptimizedCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when counter changes
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}

// Good: Selective listening with select
class SelectiveListener extends ConsumerWidget {
  const SelectiveListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when user name changes, not entire user object
    final userName = ref.watch(
      userProvider.select((user) => user?.name),
    );

    return Text('Hello, ${userName ?? 'Guest'}');
  }
}
```

### Memory Management

#### Efficient Resource Management

```dart
// Good: Proper disposal of resources
class ResourceManagedWidget extends StatefulWidget {
  const ResourceManagedWidget({super.key});

  @override
  State<ResourceManagedWidget> createState() => _ResourceManagedWidgetState();
}

class _ResourceManagedWidgetState extends State<ResourceManagedWidget> {
  late AnimationController _animationController;
  late StreamSubscription _subscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _subscription = someStream.listen((data) {
      // Handle data
    });

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) => _performPeriodicTask(),
    );
  }

  @override
  void dispose() {
    // Always dispose resources in reverse order of creation
    _timer?.cancel();
    _subscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _performPeriodicTask() {
    // Periodic task implementation
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animationController.value * 2 * pi,
          child: child,
        );
      },
      child: const Icon(Icons.refresh),
    );
  }
}
```

#### Image Optimization

```dart
// Good: Optimized image loading
class OptimizedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const OptimizedImageWidget({
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
      // Optimize memory usage
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      // Efficient loading
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      // Handle errors gracefully
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

## Database Performance (Isar)

### Query Optimization

```dart
// Good: Efficient Isar queries
class OptimizedInvoiceRepository {
  final Isar isar;

  OptimizedInvoiceRepository(this.isar);

  // Use indexes for better performance
  Future<List<Invoice>> getInvoicesByStatus(InvoiceStatus status) async {
    return await isar.invoices
        .where()
        .statusEqualTo(status) // This should have an @Index() on status field
        .findAll();
  }

  // Efficient pagination
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

  // Use composite indexes for complex queries
  Future<List<Invoice>> getCustomerInvoicesByDateRange({
    required int customerId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await isar.invoices
        .where()
        .customerIdEqualTo(customerId)
        .and()
        .createdAtBetween(startDate, endDate)
        .sortByCreatedAtDesc()
        .findAll();
  }

  // Efficient aggregation
  Future<double> getTotalAmountByCustomer(int customerId) async {
    final invoices = await isar.invoices
        .where()
        .customerIdEqualTo(customerId)
        .findAll();

    return invoices.fold<double>(
      0.0,
      (sum, invoice) => sum + invoice.totalAmount,
    );
  }

  // Batch operations for better performance
  Future<void> createMultipleInvoices(List<Invoice> invoices) async {
    await isar.writeTxn(() async {
      await isar.invoices.putAll(invoices);
    });
  }
}

// Optimized Invoice model with proper indexing
@Collection()
class Invoice {
  Id id = Isar.autoIncrement;

  @Index()
  late int customerId;

  @Index()
  late InvoiceStatus status;

  @Index()
  late DateTime createdAt;

  // Composite index for common query patterns
  @Index(composite: [CompositeIndex('customerId')])
  late DateTime dueDate;

  late double totalAmount;
  late String description;

  // Links for relationships
  final customer = IsarLink<Customer>();
  final items = IsarLinks<InvoiceItem>();
}
```

### Transaction Optimization

```dart
// Good: Efficient transaction usage
class TransactionOptimizedService {
  final Isar isar;

  TransactionOptimizedService(this.isar);

  // Batch related operations in single transaction
  Future<void> createInvoiceWithItems({
    required Invoice invoice,
    required List<InvoiceItem> items,
  }) async {
    await isar.writeTxn(() async {
      // Insert invoice first to get ID
      await isar.invoices.put(invoice);

      // Set invoice ID for all items
      for (final item in items) {
        item.invoiceId = invoice.id;
      }

      // Insert all items in batch
      await isar.invoiceItems.putAll(items);
    });
  }

  // Read operations don't need transactions but can benefit from batching
  Future<Map<String, dynamic>> getInvoiceSummary(int invoiceId) async {
    final invoice = await isar.invoices.get(invoiceId);
    if (invoice == null) throw Exception('Invoice not found');

    final items = await isar.invoiceItems
        .where()
        .invoiceIdEqualTo(invoiceId)
        .findAll();

    final customer = await isar.customers.get(invoice.customerId);

    return {
      'invoice': invoice,
      'items': items,
      'customer': customer,
      'itemCount': items.length,
      'totalAmount': items.fold<double>(
        0.0,
        (sum, item) => sum + (item.quantity * item.unitPrice),
      ),
    };
  }
}
```

## Network Performance

### Efficient HTTP Requests

```dart
// Good: Optimized HTTP client
class OptimizedApiClient {
  late final Dio _dio;
  final String baseUrl;

  OptimizedApiClient({required this.baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    // Add performance interceptors
    _dio.interceptors.addAll([
      _createCacheInterceptor(),
      _createCompressionInterceptor(),
      _createRetryInterceptor(),
      _createLoggingInterceptor(),
    ]);
  }

  // Implement request caching
  Interceptor _createCacheInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add cache headers for GET requests
        if (options.method == 'GET') {
          options.headers['Cache-Control'] = 'max-age=300'; // 5 minutes
        }
        handler.next(options);
      },
    );
  }

  // Enable compression
  Interceptor _createCompressionInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Accept-Encoding'] = 'gzip, deflate';
        handler.next(options);
      },
    );
  }

  // Implement retry logic
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetry(error) && error.requestOptions.extra['retryCount'] < 3) {
          error.requestOptions.extra['retryCount'] =
              (error.requestOptions.extra['retryCount'] ?? 0) + 1;

          // Exponential backoff
          final delay = Duration(
            milliseconds: 1000 * pow(2, error.requestOptions.extra['retryCount']),
          );

          await Future.delayed(delay);

          try {
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
          } catch (e) {
            handler.next(error);
          }
        } else {
          handler.next(error);
        }
      },
    );
  }

  bool _shouldRetry(DioError error) {
    return error.type == DioErrorType.connectionTimeout ||
           error.type == DioErrorType.receiveTimeout ||
           (error.response?.statusCode ?? 0) >= 500;
  }

  // Batch requests for efficiency
  Future<List<T>> batchRequests<T>(
    List<String> endpoints,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final futures = endpoints.map((endpoint) => _dio.get(endpoint));
    final responses = await Future.wait(futures);

    return responses
        .map((response) => fromJson(response.data))
        .toList();
  }
}
```

## Profiling and Monitoring

### Performance Monitoring

```dart
// Performance monitoring service
class PerformanceMonitor {
  static final _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final List<PerformanceMetric> _metrics = [];

  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  void stopTimer(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      _recordMetric(PerformanceMetric(
        name: name,
        duration: timer.elapsed,
        timestamp: DateTime.now(),
      ));
      _timers.remove(name);
    }
  }

  Future<T> measureAsync<T>(
    String name,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      _recordMetric(PerformanceMetric(
        name: name,
        duration: stopwatch.elapsed,
        timestamp: DateTime.now(),
      ));
      return result;
    } catch (error) {
      stopwatch.stop();
      _recordMetric(PerformanceMetric(
        name: name,
        duration: stopwatch.elapsed,
        timestamp: DateTime.now(),
        error: error.toString(),
      ));
      rethrow;
    }
  }

  void _recordMetric(PerformanceMetric metric) {
    _metrics.add(metric);

    // Keep only last 1000 metrics to prevent memory leaks
    if (_metrics.length > 1000) {
      _metrics.removeAt(0);
    }

    // Log slow operations
    if (metric.duration.inMilliseconds > 1000) {
      print('Slow operation detected: ${metric.name} took ${metric.duration.inMilliseconds}ms');
    }
  }

  List<PerformanceMetric> getMetrics({String? name}) {
    if (name != null) {
      return _metrics.where((m) => m.name == name).toList();
    }
    return List.from(_metrics);
  }

  Map<String, double> getAverageTimings() {
    final grouped = <String, List<Duration>>{};

    for (final metric in _metrics) {
      grouped.putIfAbsent(metric.name, () => []).add(metric.duration);
    }

    return grouped.map((name, durations) {
      final average = durations
          .map((d) => d.inMicroseconds)
          .reduce((a, b) => a + b) / durations.length;
      return MapEntry(name, average / 1000); // Convert to milliseconds
    });
  }
}

class PerformanceMetric {
  final String name;
  final Duration duration;
  final DateTime timestamp;
  final String? error;

  PerformanceMetric({
    required this.name,
    required this.duration,
    required this.timestamp,
    this.error,
  });
}

// Usage example
class OptimizedInvoiceService {
  final PerformanceMonitor _monitor = PerformanceMonitor();
  final InvoiceRepository _repository;

  OptimizedInvoiceService(this._repository);

  Future<List<Invoice>> getInvoices() async {
    return await _monitor.measureAsync(
      'get_invoices',
      () => _repository.getAllInvoices(),
    );
  }

  Future<Invoice> createInvoice(InvoiceData data) async {
    return await _monitor.measureAsync(
      'create_invoice',
      () => _repository.createInvoice(data),
    );
  }
}
```

### Memory Profiling

```dart
// Memory usage monitoring
class MemoryMonitor {
  static void logMemoryUsage(String context) {
    final info = ProcessInfo.currentRss;
    print('Memory usage at $context: ${info ~/ (1024 * 1024)} MB');
  }

  static Future<void> profileMemoryUsage(
    String name,
    Future<void> Function() operation,
  ) async {
    final beforeMemory = ProcessInfo.currentRss;
    logMemoryUsage('$name - before');

    await operation();

    final afterMemory = ProcessInfo.currentRss;
    logMemoryUsage('$name - after');

    final difference = afterMemory - beforeMemory;
    print('Memory difference for $name: ${difference ~/ (1024 * 1024)} MB');
  }
}
```

## Performance Testing

### Benchmark Testing

```dart
// Performance benchmark tests
void main() {
  group('Performance Benchmarks', () {
    test('Database query performance', () async {
      final isar = await setupTestIsar();
      final repository = InvoiceRepository(isar);

      // Create test data
      final invoices = List.generate(1000, (i) => createTestInvoice(i));
      await repository.createMultiple(invoices);

      // Benchmark query performance
      final stopwatch = Stopwatch()..start();
      final results = await repository.getInvoicesByStatus(InvoiceStatus.paid);
      stopwatch.stop();

      print('Query took: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be under 100ms

      await isar.close();
    });

    test('Widget build performance', () async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 1000,
              itemBuilder: (context, index) => ListTile(
                title: Text('Item $index'),
              ),
            ),
          ),
        ),
      );

      // Measure frame rendering time
      final binding = WidgetsBinding.instance;
      final renderTime = binding.renderTimeMillis;

      expect(renderTime, lessThan(16)); // Should render in under 16ms (60fps)
    });
  });
}
```

## Best Practices Summary

### Performance Optimization Checklist

- [ ] Use `const` constructors for static widgets
- [ ] Implement proper `dispose()` methods
- [ ] Use `ListView.builder` for large lists
- [ ] Add `RepaintBoundary` for expensive widgets
- [ ] Optimize images with proper sizing
- [ ] Use indexes in database queries
- [ ] Batch database operations in transactions
- [ ] Implement request caching and compression
- [ ] Monitor performance with profiling tools
- [ ] Set performance budgets and test regularly

### Common Performance Anti-Patterns

- Building widgets in `build()` method
- Not disposing controllers and streams
- Using `ListView` instead of `ListView.builder` for large lists
- Missing database indexes
- Making individual database calls instead of batching
- Not implementing proper error handling and retries
- Ignoring memory leaks
- Not measuring and monitoring performance

---

**للمراجع التفصيلية:** راجع Flutter DevTools وأدوات الأداء المتقدمة
