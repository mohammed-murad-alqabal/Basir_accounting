# Performance & Optimization: Baseer Intelligent Financial System

**Document ID:** BASEER-P4-007  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Technical Architecture

---

## 1. Performance Targets

### Mobile App

| Metric         | Target    | Measurement               |
| -------------- | --------- | ------------------------- |
| App Launch     | < 2s      | Cold start to interactive |
| Screen Load    | < 1.5s    | TTI (Time to Interactive) |
| Animation      | 60 FPS    | No jank                   |
| Memory Usage   | < 200MB   | Typical usage             |
| Battery Impact | < 3%/hour | Active usage              |
| App Size       | < 50MB    | Download size             |

### Backend API

| Metric        | Target   | Percentile   |
| ------------- | -------- | ------------ |
| Response Time | < 100ms  | p50          |
| Response Time | < 200ms  | p95          |
| Response Time | < 500ms  | p99          |
| Throughput    | 1000 RPS | Per pod      |
| Error Rate    | < 0.1%   | All requests |

---

## 2. Mobile Optimization

### Flutter Performance

#### Widget Optimization

```dart
// ❌ Bad: Rebuilds entire list
ListView.builder(
  itemBuilder: (context, index) {
    return _buildComplexItem(items[index]);
  },
)

// ✅ Good: Const constructors, minimal rebuilds
ListView.builder(
  itemBuilder: (context, index) {
    return InvoiceListItem(
      key: ValueKey(items[index].id),
      invoice: items[index],
    );
  },
)

// Widget with const constructor
class InvoiceListItem extends StatelessWidget {
  const InvoiceListItem({
    super.key,
    required this.invoice,
  });

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

#### Image Optimization

```dart
// Use cached network images
CachedNetworkImage(
  imageUrl: receipt.imageUrl,
  memCacheWidth: 200, // Resize in memory
  placeholder: (context, url) => const Shimmer(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

#### List Performance

```dart
// For large lists, use SliverList with caching
CustomScrollView(
  slivers: [
    SliverList.separated(
      itemCount: invoices.length,
      itemBuilder: (context, index) => InvoiceCard(invoices[index]),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    ),
  ],
)
```

### Local Database (Isar)

```dart
// Use indexes for frequently queried fields
@collection
class Invoice {
  Id id = Isar.autoIncrement;

  @Index()
  late String status;

  @Index(composite: [CompositeIndex('customerId')])
  late DateTime issueDate;

  // ...
}

// Use lazy loading for large collections
final invoices = await isar.invoices
  .where()
  .statusEqualTo('pending')
  .limit(20)
  .findAll();
```

---

## 3. Backend Optimization

### Database Queries

```sql
-- Use appropriate indexes
CREATE INDEX idx_invoices_org_status_date
ON invoices(org_id, status, issue_date DESC);

-- Use partial indexes for common filters
CREATE INDEX idx_active_invoices
ON invoices(org_id)
WHERE deleted_at IS NULL AND status != 'draft';

-- Avoid N+1 queries - use JOINs
SELECT i.*, c.name as customer_name
FROM invoices i
JOIN customers c ON i.customer_id = c.id
WHERE i.org_id = $1;
```

### Connection Pooling

```go
// Configure connection pool
db, err := sql.Open("postgres", connStr)
db.SetMaxOpenConns(25)
db.SetMaxIdleConns(10)
db.SetConnMaxLifetime(5 * time.Minute)
```

### Caching Strategy

| Data Type             | TTL      | Cache Layer    |
| --------------------- | -------- | -------------- |
| User session          | 15 min   | Redis          |
| Organization settings | 1 hour   | Redis          |
| Exchange rates        | 24 hours | Redis          |
| Static content        | 1 week   | CDN            |
| Invoice PDF           | 1 hour   | Object storage |

```go
// Cache-aside pattern
func (s *Service) GetInvoice(ctx context.Context, id string) (*Invoice, error) {
    // Try cache first
    cached, err := s.cache.Get(ctx, "invoice:"+id)
    if err == nil {
        return cached, nil
    }

    // Fetch from database
    invoice, err := s.repo.FindByID(ctx, id)
    if err != nil {
        return nil, err
    }

    // Store in cache
    s.cache.Set(ctx, "invoice:"+id, invoice, time.Hour)

    return invoice, nil
}
```

---

## 4. API Optimization

### Response Compression

```go
// Enable gzip compression
r.Use(gzip.Gzip(gzip.DefaultCompression))
```

### Pagination

```go
// Always paginate list endpoints
type ListParams struct {
    Page    int `form:"page" binding:"min=1"`
    PerPage int `form:"per_page" binding:"min=1,max=100"`
}

// Return pagination metadata
type ListResponse struct {
    Data []Invoice `json:"data"`
    Meta struct {
        Page      int `json:"page"`
        PerPage   int `json:"per_page"`
        Total     int `json:"total"`
        TotalPages int `json:"total_pages"`
    } `json:"meta"`
}
```

### Field Selection

```go
// Allow clients to request specific fields
// GET /invoices?fields=id,number,total,status
```

---

## 5. Load Testing

### Test Scenarios

| Scenario | Users  | Duration | Target         |
| -------- | ------ | -------- | -------------- |
| Smoke    | 10     | 1 min    | < 100ms        |
| Load     | 100    | 10 min   | < 200ms p95    |
| Stress   | 500    | 5 min    | No errors      |
| Spike    | 0→1000 | 2 min    | Recovery < 30s |

### k6 Script Example

```javascript
import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  stages: [
    { duration: "2m", target: 100 },
    { duration: "5m", target: 100 },
    { duration: "2m", target: 0 },
  ],
  thresholds: {
    http_req_duration: ["p(95)<200"],
    http_req_failed: ["rate<0.01"],
  },
};

export default function () {
  const res = http.get("https://api.baseer.app/v1/invoices", {
    headers: { Authorization: `Bearer ${__ENV.TOKEN}` },
  });

  check(res, {
    "status is 200": (r) => r.status === 200,
    "response time < 200ms": (r) => r.timings.duration < 200,
  });

  sleep(1);
}
```

---

## 6. Monitoring & Profiling

### Key Metrics to Watch

| Category   | Metrics                     |
| ---------- | --------------------------- |
| Latency    | p50, p95, p99 response time |
| Traffic    | RPS, bytes in/out           |
| Errors     | 4xx, 5xx rates              |
| Saturation | CPU, memory, connections    |

### Profiling Tools

| Tool             | Use Case                |
| ---------------- | ----------------------- |
| Flutter DevTools | Widget rebuild analysis |
| Dart Observatory | Memory profiling        |
| Go pprof         | CPU/memory profiling    |
| Jaeger           | Distributed tracing     |

---

## 7. Optimization Checklist

### Pre-Launch

- [ ] All screens load < 1.5s
- [ ] No jank in animations
- [ ] Database indexes created
- [ ] N+1 queries eliminated
- [ ] Caching implemented
- [ ] Load test passed

### Ongoing

- [ ] Weekly performance review
- [ ] Slow query monitoring
- [ ] Memory leak checks
- [ ] Bundle size tracking

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
