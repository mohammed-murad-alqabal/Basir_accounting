---
id: "microservices-patterns"
description: "أنماط ومعايير تصميم الخدمات المصغرة (Microservices Patterns)"
version: "1.0"
last_updated: "2025-12-25"
inclusion: when_architecture_design
author: "فريق وكلاء تطوير مشروع بصير"
metrics:
  complexity: "High"
  impact: "System Architecture"
---

# Microservices Patterns & Best Practices

## 1. Service Decomposition Strategies

### 1.1 Decompose by Business Capability

- **مبدأ العمل**: تقسيم الخدمات بناءً على الوظائف التجارية (مثل: الفواتير، العملاء، المدفوعات).
- **الفائدة**: استقلالية الفرق، توافق مع الهيكل التنظيمي.
- **التطبيق**:
  - خدمة إدارة العملاء (`CustomerService`)
  - خدمة المعاملات والفواتير (`InvoiceService`)
  - خدمة المصادقة (`AuthService`)

### 1.2 Decompose by Subdomain (DDD)

- **مبدأ العمل**: استخدام حدود السياق (Bounded Contexts) من التصميم الموجه للمجال (DDD).
- **Core Domain**: الوظائف الأساسية التي تميز العمل.
- **Supporting Domain**: وظائف داعمة (مثل التسويق).
- **Generic Domain**: وظائف عامة (مثل المصادقة).

## 2. Inter-Service Communication

### 2.1 Synchronous (REST/gRPC)

- **متى يستخدم**: عندما تكون الاستجابة الفورية مطلوبة.
- **REST**: سهل الاستخدام، مدعوم عالمياً (للتكامل الخارجي).
- **gRPC**: عالي الأداء، ثنائي الاتجاه، typed (للاتصالات الداخلية).

### 2.2 Asynchronous (Messaging)

- **متى يستخدم**: لفك الارتباط (Decoupling)، التعامل مع الأحمال العالية.
- **التقنيات**: RabbitMQ, Kafka, Dart Streams (داخل التطبيق الواحد كنمط مصغر).
- **النمط**: Event-Driven Architecture.

## 3. Data Management

### 3.1 Database per Service

- **القاعدة**: كل خدمة تملك قاعدة بياناتها الخاصة. لا تشارك الجداول.
- **الهدف**: منع التواكل (Coupling) غير المرغوب فيه.
- **التحدي**: ضمان تناسق البيانات (Data Consistency).
- **الحل**: Sagas Pattern.

### 3.2 API Composition

- تجميع البيانات من خدمات متعددة في طبقة الـ API Gateway قبل إرسالها للعميل.

## 4. Resilience & Fault Tolerance

### 4.1 Circuit Breaker

- منع الفشل المتلالی (Cascading Failures) عندما تكون خدمة تابعة غير متاحة.
- استخدام مكتبات مثل `dio_smart_retry` أو تنفيذ نمط مخصص.

### 4.2 Retry Pattern

- إعادة المحاولة في حالة الفشل المؤقت (Transient Failures) مع Exponential Backoff.

## 5. Deployment & Containerization

### 5.1 Docker Standards

- كل خدمة في حاوية منفصلة (Container).
- استخدام `Dockerfile` موحد المعايير (Multistage builds).

### 5.2 Health Checks

- تنفيذ نقاط نهاية `/health` و `/readiness` لكل خدمة.

## 6. Observability

- **Centralized Logging**: تجميع السجلات في مكان واحد.
- **Distributed Tracing**: تتبع الطلبات عبر الخدمات (OpenTelemetry).
- **Metrics**: مراقبة الأداء (Prometheus/Grafana).
