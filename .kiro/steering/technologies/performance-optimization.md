---
title: Performance Optimization Guide
inclusion: manual
---

# Performance Optimization Guide - Advanced 2025

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025  
**الحالة:** ✅ نشط ومتقدم

---

## Overview

Comprehensive performance optimization strategies for modern applications, with specific focus on Flutter mobile apps, backend services, and distributed systems.

## Flutter Mobile Performance

### Widget Performance Optimization

#### Efficient Widget Building

```dart
// Good: Const constructors and widget separation
class OptimizedInvoiceCard extends StatelessWidget {
  const OptimizedInvoiceCard({
    super.key,
    required this.invoice,
  });

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InvoiceHeader(invoice: invoice),
          const Divider(), // Const widget
          InvoiceDetails(invoice: invoice),
          InvoiceActions(invoice: invoice),
        ],
      ),
    );
  }
}

// Separate widgets to minimize rebuilds
class InvoiceHeader extends StatelessWidget {
  const InvoiceHeader({super.key, required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary( // Isolate repaints
      child: ListTile(
        title: Text(invoice.number),
        subtitle: Text(invoice.customerName),
        trailing: Text(
          invoice.total.toStringAsFixed(2),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
```

#### List Performance Optimization

```dart
class OptimizedInvoiceList extends StatelessWidget {
  const OptimizedInvoiceList({super.key, required this.invoices});
  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: invoices.length,
      cacheExtent: 500, // Pre-cache items
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return OptimizedInvoiceCard(
          key: <credential-fixture>(invoice.id), // Stable keys
          invoice: invoice,
        );
      },
    );
  }
}

// For large datasets with complex items
class VirtualizedInvoiceList extends StatelessWidget {
  const VirtualizedInvoiceList({super.key, required this.invoices});
  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            return AutomaticKeepAliveClientMixin(
              child: OptimizedInvoiceCard(invoice: invoices[index]),
            );
          },
        ),
      ],
    );
  }
}
```

### Memory Management

#### Efficient Image Handling

```dart
class OptimizedImageWidget extends StatelessWidget {
  const OptimizedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  final String imageUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
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

// Memory-efficient image caching
class ImageCacheManager {
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const int maxCacheObjects = 1000;

  static void optimizeImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = maxCacheObjects;
    PaintingBinding.instance.imageCache.maximumSizeBytes = maxCacheSize;
  }

  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
```

### Database Performance (Isar)

#### Query Optimization

```dart
class OptimizedInvoiceRepository {
  final Isar isar;

  OptimizedInvoiceRepository(this.isar);

  // Efficient pagination
  Future<List<Invoice>> getInvoicesPaginated({
    required int page,
    required int pageSize,
    String? searchTerm,
  }) async {
    var query = isar.invoices.where();

    if (searchTerm != null && searchTerm.isNotEmpty) {
      query = query.filter().customerNameContains(
        searchTerm,
        caseSensitive: false,
      );
    }

    return await query
        .sortByCreatedAtDesc()
        .offset(page * pageSize)
        .limit(pageSize)
        .findAll();
  }

  // Efficient aggregation
  Future<InvoiceStats> getInvoiceStats() async {
    final results = await Future.wait([
      isar.invoices.count(),
      isar.invoices.where().totalSum(),
      isar.invoices.filter().statusEqualTo(InvoiceStatus.paid).count(),
      isar.invoices.filter().statusEqualTo(InvoiceStatus.pending).count(),
    ]);

    return InvoiceStats(
      totalCount: results[0] as int,
      totalAmount: results[1] as double,
      paidCount: results[2] as int,
      pendingCount: results[3] as int,
    );
  }

  // Batch operations for better performance
  Future<void> batchUpdateInvoices(List<Invoice> invoices) async {
    await isar.writeTxn(() async {
      await isar.invoices.putAll(invoices);
    });
  }
}
```

## Backend Performance Optimization

### API Performance

#### Response Optimization

```typescript
interface APIPerformanceConfig {
  caching: {
    enabled: boolean;
    ttl: number;
    strategy: "memory" | "redis" | "hybrid";
  };
  compression: {
    enabled: boolean;
    algorithm: "gzip" | "brotli";
    threshold: number;
  };
  pagination: {
    defaultLimit: number;
    maxLimit: number;
  };
}

class OptimizedAPIController {
  private cache: CacheManager;
  private config: APIPerformanceConfig;

  async getInvoices(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20, search } = req.query;
    const cacheKey = `invoices:${page}:${limit}:${search || "all"}`;

    // Check cache first
    const cached = await this.cache.get(cacheKey);
    if (cached) {
      res.json(cached);
      return;
    }

    // Optimize database query
    const invoices = await this.invoiceService.findMany({
      skip: (page - 1) * limit,
      take: Math.min(limit, this.config.pagination.maxLimit),
      where: search
        ? {
            OR: [
              { customerName: { contains: search, mode: "insensitive" } },
              { invoiceNumber: { contains: search, mode: "insensitive" } },
            ],
          }
        : undefined,
      select: {
        id: true,
        invoiceNumber: true,
        customerName: true,
        total: true,
        status: true,
        createdAt: true,
        // Exclude heavy fields like items for list view
      },
    });

    const result = {
      data: invoices,
      pagination: {
        page,
        limit,
        total: await this.invoiceService.count(),
      },
    };

    // Cache the result
    await this.cache.set(cacheKey, result, this.config.caching.ttl);

    res.json(result);
  }
}
```

### Database Performance

#### Connection Pool Optimization

```typescript
interface DatabaseConfig {
  pool: {
    min: number;
    max: number;
    acquireTimeoutMillis: number;
    idleTimeoutMillis: number;
  };
  query: {
    timeout: number;
    retries: number;
  };
}

class OptimizedDatabaseManager {
  private config: DatabaseConfig = {
    pool: {
      min: 2,
      max: 10,
      acquireTimeoutMillis: 60000,
      idleTimeoutMillis: 600000,
    },
    query: {
      timeout: 30000,
      retries: 3,
    },
  };

  async executeOptimizedQuery<T>(
    query: string,
    params: any[] = []
  ): Promise<T[]> {
    const startTime = Date.now();

    try {
      // Use prepared statements for better performance
      const result = await this.db.query(query, params);

      // Log slow queries
      const duration = Date.now() - startTime;
      if (duration > 1000) {
        console.warn(`Slow query detected: ${duration}ms`, { query, params });
      }

      return result;
    } catch (error) {
      console.error("Query execution failed:", { query, params, error });
      throw error;
    }
  }

  // Batch operations for better throughput
  async batchInsert<T>(table: string, records: T[]): Promise<void> {
    const batchSize = 1000;
    const batches = this.chunkArray(records, batchSize);

    for (const batch of batches) {
      await this.db.transaction(async (trx) => {
        await trx.batchInsert(table, batch);
      });
    }
  }

  private chunkArray<T>(array: T[], size: number): T[][] {
    const chunks: T[][] = [];
    for (let i = 0; i < array.length; i += size) {
      chunks.push(array.slice(i, i + size));
    }
    return chunks;
  }
}
```

## Monitoring and Profiling

### Performance Monitoring

```typescript
interface PerformanceMetrics {
  responseTime: number;
  throughput: number;
  errorRate: number;
  cpuUsage: number;
  memoryUsage: number;
  dbConnectionPool: number;
}

class PerformanceMonitor {
  private metrics: Map<string, PerformanceMetrics> = new Map();

  startRequest(requestId: string): void {
    this.metrics.set(requestId, {
      responseTime: Date.now(),
      throughput: 0,
      errorRate: 0,
      cpuUsage: process.cpuUsage().user,
      memoryUsage: process.memoryUsage().heapUsed,
      dbConnectionPool: this.getDbPoolSize(),
    });
  }

  endRequest(requestId: string, success: boolean): void {
    const metrics = this.metrics.get(requestId);
    if (!metrics) return;

    metrics.responseTime = Date.now() - metrics.responseTime;

    // Update global metrics
    this.updateGlobalMetrics(metrics, success);

    // Alert on performance issues
    if (metrics.responseTime > 5000) {
      this.alertSlowResponse(requestId, metrics);
    }

    this.metrics.delete(requestId);
  }

  private updateGlobalMetrics(
    metrics: PerformanceMetrics,
    success: boolean
  ): void {
    // Update throughput counter
    this.incrementThroughput();

    // Update error rate
    if (!success) {
      this.incrementErrorRate();
    }

    // Update resource usage
    this.updateResourceMetrics(metrics);
  }
}
```

### Profiling Tools Integration

```dart
// Flutter performance profiling
class FlutterPerformanceProfiler {
  static void enableProfiling() {
    if (kDebugMode) {
      // Enable performance overlay
      WidgetsApp.debugShowWidgetInspectorOverride = true;

      // Enable repaint rainbow
      debugRepaintRainbowEnabled = true;

      // Enable performance logging
      Timeline.startSync('app_startup');
    }
  }

  static void profileWidgetBuild(String widgetName, VoidCallback buildFunction) {
    if (kDebugMode) {
      Timeline.startSync('widget_build_$widgetName');
      buildFunction();
      Timeline.finishSync();
    } else {
      buildFunction();
    }
  }

  static void measureFrameTime() {
    if (kDebugMode) {
      SchedulerBinding.instance.addTimingsCallback((timings) {
        for (final timing in timings) {
          final frameTime = timing.totalSpan.inMilliseconds;
          if (frameTime > 16) { // 60fps = 16.67ms per frame
            print('Slow frame detected: ${frameTime}ms');
          }
        }
      });
    }
  }
}
```

## Caching Strategies

### Multi-Level Caching

```typescript
interface CacheLevel {
  name: string;
  ttl: number;
  maxSize: number;
  evictionPolicy: "lru" | "lfu" | "ttl";
}

class MultiLevelCache {
  private levels: Map<string, CacheLevel> = new Map([
    [
      "memory",
      { name: "memory", ttl: 300, maxSize: 1000, evictionPolicy: "lru" },
    ],
    [
      "redis",
      { name: "redis", ttl: 3600, maxSize: 10000, evictionPolicy: "ttl" },
    ],
    [
      "database",
      { name: "database", ttl: 86400, maxSize: 100000, evictionPolicy: "lfu" },
    ],
  ]);

  async get<T>(key: string): Promise<T | null> {
    // Try each cache level in order
    for (const [levelName, level] of this.levels) {
      const value = await this.getFromLevel<T>(levelName, key);
      if (value !== null) {
        // Promote to higher cache levels
        await this.promoteToHigherLevels(key, value, levelName);
        return value;
      }
    }

    return null;
  }

  async set<T>(key: string, value: T, customTtl?: number): Promise<void> {
    // Set in all cache levels
    const promises = Array.from(this.levels.entries()).map(
      ([levelName, level]) =>
        this.setInLevel(levelName, key, value, customTtl || level.ttl)
    );

    await Promise.all(promises);
  }

  private async promoteToHigherLevels<T>(
    key: string,
    value: T,
    currentLevel: string
  ): Promise<void> {
    const levelNames = Array.from(this.levels.keys());
    const currentIndex = levelNames.indexOf(currentLevel);

    // Promote to all higher levels
    for (let i = 0; i < currentIndex; i++) {
      const levelName = levelNames[i];
      const level = this.levels.get(levelName)!;
      await this.setInLevel(levelName, key, value, level.ttl);
    }
  }
}
```

## Load Testing and Benchmarking

### Automated Performance Testing

```typescript
interface LoadTestConfig {
  concurrent_users: number;
  duration: string;
  ramp_up_time: string;
  endpoints: EndpointConfig[];
}

interface EndpointConfig {
  path: string;
  method: "GET" | "POST" | "PUT" | "DELETE";
  weight: number; // Percentage of requests
  expected_response_time: number; // milliseconds
}

class LoadTester {
  async runLoadTest(config: LoadTestConfig): Promise<LoadTestResults> {
    const results: LoadTestResults = {
      total_requests: 0,
      successful_requests: 0,
      failed_requests: 0,
      average_response_time: 0,
      p95_response_time: 0,
      p99_response_time: 0,
      throughput: 0,
      error_rate: 0,
    };

    const startTime = Date.now();
    const endTime = startTime + this.parseDuration(config.duration);

    // Simulate concurrent users
    const userPromises = Array.from({ length: config.concurrent_users }, () =>
      this.simulateUser(config, endTime)
    );

    const userResults = await Promise.all(userPromises);

    // Aggregate results
    return this.aggregateResults(userResults);
  }

  private async simulateUser(
    config: LoadTestConfig,
    endTime: number
  ): Promise<UserTestResult> {
    const requests: RequestResult[] = [];

    while (Date.now() < endTime) {
      const endpoint = this.selectEndpoint(config.endpoints);
      const startTime = Date.now();

      try {
        const response = await this.makeRequest(endpoint);
        const responseTime = Date.now() - startTime;

        requests.push({
          endpoint: endpoint.path,
          response_time: responseTime,
          success: response.status < 400,
          status_code: response.status,
        });

        // Check if response time meets expectations
        if (responseTime > endpoint.expected_response_time) {
          console.warn(
            `Slow response: ${endpoint.path} took ${responseTime}ms`
          );
        }
      } catch (error) {
        requests.push({
          endpoint: endpoint.path,
          response_time: Date.now() - startTime,
          success: false,
          error: error.message,
        });
      }

      // Wait before next request (simulate user think time)
      await this.sleep(Math.random() * 1000 + 500);
    }

    return { requests };
  }
}
```

---

## Performance Optimization Checklist

### Flutter Mobile App

- [ ] Use const constructors where possible
- [ ] Implement RepaintBoundary for expensive widgets
- [ ] Optimize ListView with builder pattern
- [ ] Implement efficient image caching
- [ ] Use proper key management for widgets
- [ ] Profile widget rebuilds and eliminate unnecessary ones
- [ ] Optimize database queries with proper indexing
- [ ] Implement pagination for large datasets

### Backend Services

- [ ] Implement multi-level caching strategy
- [ ] Optimize database connection pooling
- [ ] Use prepared statements for database queries
- [ ] Implement proper API pagination
- [ ] Add response compression (gzip/brotli)
- [ ] Set up database query monitoring
- [ ] Implement batch operations for bulk data
- [ ] Add performance monitoring and alerting

### Infrastructure

- [ ] Set up load balancing for high availability
- [ ] Implement CDN for static assets
- [ ] Configure auto-scaling based on metrics
- [ ] Set up database read replicas
- [ ] Implement circuit breakers for external services
- [ ] Add comprehensive monitoring and logging
- [ ] Set up automated performance testing
- [ ] Configure resource limits and quotas

---

**Performance Targets:**

- Mobile app startup time: < 3 seconds
- API response time (95th percentile): < 500ms
- Database query time (95th percentile): < 100ms
- Mobile app frame rate: 60fps consistently
- Memory usage: < 100MB for mobile app
- CPU usage: < 70% under normal load
