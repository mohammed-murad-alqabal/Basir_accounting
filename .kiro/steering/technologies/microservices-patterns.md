---
title: Microservices Architecture Patterns
inclusion: manual
---

# Microservices Architecture Patterns

**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025  
**الحالة:** ✅ نشط ومتقدم

---

## Overview

Comprehensive guide to microservices architecture patterns for scalable, maintainable, and resilient distributed systems. While Baseer MVP is currently a mobile-first application, these patterns provide foundation for future backend services and cloud integration.

## Core Microservices Patterns

### 1. Service Decomposition Patterns

#### Domain-Driven Design (DDD) Decomposition

```yaml
service_boundaries:
  customer_service:
    domain: Customer Management
    responsibilities:
      - Customer CRUD operations
      - Customer validation
      - Customer search and filtering
    data_ownership:
      - customers table
      - customer_preferences table

  invoice_service:
    domain: Invoice Management
    responsibilities:
      - Invoice creation and management
      - Invoice calculations (tax, discounts)
      - Invoice status tracking
    data_ownership:
      - invoices table
      - invoice_items table
      - invoice_templates table

  payment_service:
    domain: Payment Processing
    responsibilities:
      - Payment processing
      - Payment method management
      - Payment history tracking
    data_ownership:
      - payments table
      - payment_methods table
```

#### Business Capability Decomposition

```typescript
interface BusinessCapability {
  name: string;
  description: string;
  services: MicroService[];
  dataFlow: DataFlowPattern[];
}

const baseerCapabilities: BusinessCapability[] = [
  {
    name: "Customer Relationship Management",
    description: "Manage customer information and relationships",
    services: ["customer-service", "communication-service"],
    dataFlow: ["customer-events", "notification-events"],
  },
  {
    name: "Financial Management",
    description: "Handle invoicing, payments, and financial reporting",
    services: ["invoice-service", "payment-service", "reporting-service"],
    dataFlow: ["financial-events", "audit-events"],
  },
  {
    name: "Business Intelligence",
    description: "Analytics and insights for business decisions",
    services: ["analytics-service", "reporting-service"],
    dataFlow: ["analytics-events", "metrics-events"],
  },
];
```

### 2. Data Management Patterns

#### Database per Service

```yaml
service_data_architecture:
  customer_service:
    database: PostgreSQL
    schema: customer_db
    access_pattern: OLTP
    backup_strategy: daily_snapshots

  invoice_service:
    database: PostgreSQL
    schema: invoice_db
    access_pattern: OLTP
    backup_strategy: continuous_replication

  analytics_service:
    database: ClickHouse
    schema: analytics_db
    access_pattern: OLAP
    backup_strategy: weekly_full_backup
```

#### Saga Pattern for Distributed Transactions

```typescript
interface SagaStep {
  service: string;
  action: string;
  compensationAction: string;
  timeout: number;
}

class InvoiceCreationSaga {
  private steps: SagaStep[] = [
    {
      service: "customer-service",
      action: "validateCustomer",
      compensationAction: "releaseCustomerLock",
      timeout: 5000,
    },
    {
      service: "inventory-service",
      action: "reserveItems",
      compensationAction: "releaseItems",
      timeout: 10000,
    },
    {
      service: "invoice-service",
      action: "createInvoice",
      compensationAction: "deleteInvoice",
      timeout: 15000,
    },
    {
      service: "notification-service",
      action: "sendInvoiceNotification",
      compensationAction: "sendCancellationNotification",
      timeout: 5000,
    },
  ];

  async execute(invoiceData: InvoiceData): Promise<InvoiceResult> {
    const executedSteps: SagaStep[] = [];

    try {
      for (const step of this.steps) {
        await this.executeStep(step, invoiceData);
        executedSteps.push(step);
      }

      return { success: true, invoiceId: invoiceData.id };
    } catch (error) {
      // Compensate in reverse order
      await this.compensate(executedSteps.reverse());
      throw error;
    }
  }

  private async compensate(steps: SagaStep[]): Promise<void> {
    for (const step of steps) {
      try {
        await this.executeCompensation(step);
      } catch (compensationError) {
        // Log compensation failure but continue
        console.error(
          `Compensation failed for ${step.service}:${step.compensationAction}`
        );
      }
    }
  }
}
```

#### Event Sourcing Pattern

```typescript
interface DomainEvent {
  eventId: string;
  aggregateId: string;
  eventType: string;
  eventData: any;
  timestamp: Date;
  version: number;
}

class InvoiceAggregate {
  private events: DomainEvent[] = [];
  private version: number = 0;

  static fromHistory(events: DomainEvent[]): InvoiceAggregate {
    const aggregate = new InvoiceAggregate();
    events.forEach((event) => aggregate.apply(event));
    return aggregate;
  }

  createInvoice(customerId: string, items: InvoiceItem[]): void {
    const event: DomainEvent = {
      eventId: generateId(),
      aggregateId: this.id,
      eventType: "InvoiceCreated",
      eventData: { customerId, items },
      timestamp: new Date(),
      version: this.version + 1,
    };

    this.apply(event);
    this.events.push(event);
  }

  private apply(event: DomainEvent): void {
    switch (event.eventType) {
      case "InvoiceCreated":
        this.handleInvoiceCreated(event.eventData);
        break;
      case "InvoiceItemAdded":
        this.handleInvoiceItemAdded(event.eventData);
        break;
      // ... other event handlers
    }
    this.version = event.version;
  }

  getUncommittedEvents(): DomainEvent[] {
    return [...this.events];
  }

  markEventsAsCommitted(): void {
    this.events = [];
  }
}
```

### 3. Communication Patterns

#### API Gateway Pattern

```yaml
api_gateway_config:
  routes:
    - path: /api/v1/customers/*
      service: customer-service
      load_balancer: round_robin
      timeout: 30s
      retry_policy:
        max_retries: 3
        backoff: exponential

    - path: /api/v1/invoices/*
      service: invoice-service
      load_balancer: least_connections
      timeout: 45s
      cache_policy:
        ttl: 300s
        cache_key: "invoice:{invoice_id}"

    - path: /api/v1/payments/*
      service: payment-service
      load_balancer: weighted_round_robin
      timeout: 60s
      security:
        rate_limit: 100/minute
        authentication: <credential-fixture>

  middleware:
    - authentication
    - rate_limiting
    - request_logging
    - response_caching
    - circuit_breaker
```

#### Asynchronous Messaging

```typescript
interface MessageBroker {
  publish(topic: string, message: any): Promise<void>;
  subscribe(topic: string, handler: MessageHandler): Promise<void>;
  createTopic(topic: string, config: TopicConfig): Promise<void>;
}

class EventDrivenArchitecture {
  constructor(private broker: MessageBroker) {}

  async setupEventHandlers(): Promise<void> {
    // Customer events
    await this.broker.subscribe("customer.created", this.handleCustomerCreated);
    await this.broker.subscribe("customer.updated", this.handleCustomerUpdated);

    // Invoice events
    await this.broker.subscribe("invoice.created", this.handleInvoiceCreated);
    await this.broker.subscribe("invoice.paid", this.handleInvoicePaid);

    // Payment events
    await this.broker.subscribe(
      "payment.processed",
      this.handlePaymentProcessed
    );
    await this.broker.subscribe("payment.failed", this.handlePaymentFailed);
  }

  private async handleInvoiceCreated(
    message: InvoiceCreatedEvent
  ): Promise<void> {
    // Update customer statistics
    await this.broker.publish("customer.statistics.update", {
      customerId: message.customerId,
      action: "invoice_created",
      amount: message.totalAmount,
    });

    // Send notification
    await this.broker.publish("notification.send", {
      type: "invoice_created",
      recipient: message.customerEmail,
      data: message,
    });

    // Update analytics
    await this.broker.publish("analytics.event", {
      eventType: "invoice_created",
      timestamp: new Date(),
      data: message,
    });
  }
}
```

### 4. Resilience Patterns

#### Circuit Breaker Pattern

```typescript
enum CircuitState {
  CLOSED = "closed",
  OPEN = "open",
  HALF_OPEN = "half_open",
}

class CircuitBreaker {
  private state: CircuitState = CircuitState.CLOSED;
  private failureCount: number = 0;
  private lastFailureTime: Date | null = null;
  private successCount: number = 0;

  constructor(
    private failureThreshold: number = 5,
    private recoveryTimeout: number = 60000, // 1 minute
    private successThreshold: number = 3
  ) {}

  async execute<T>(operation: () => Promise<T>): Promise<T> {
    if (this.state === CircuitState.OPEN) {
      if (this.shouldAttemptReset()) {
        this.state = CircuitState.HALF_OPEN;
        this.successCount = 0;
      } else {
        throw new Error("Circuit breaker is OPEN");
      }
    }

    try {
      const result = await operation();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }

  private onSuccess(): void {
    this.failureCount = 0;

    if (this.state === CircuitState.HALF_OPEN) {
      this.successCount++;
      if (this.successCount >= this.successThreshold) {
        this.state = CircuitState.CLOSED;
      }
    }
  }

  private onFailure(): void {
    this.failureCount++;
    this.lastFailureTime = new Date();

    if (this.failureCount >= this.failureThreshold) {
      this.state = CircuitState.OPEN;
    }
  }

  private shouldAttemptReset(): boolean {
    return (
      this.lastFailureTime &&
      Date.now() - this.lastFailureTime.getTime() >= this.recoveryTimeout
    );
  }
}
```

#### Retry Pattern with Exponential Backoff

```typescript
interface RetryConfig {
  maxRetries: number;
  baseDelay: number;
  maxDelay: number;
  backoffMultiplier: number;
  jitter: boolean;
}

class RetryHandler {
  constructor(private config: RetryConfig) {}

  async executeWithRetry<T>(
    operation: () => Promise<T>,
    isRetryable: (error: any) => boolean = () => true
  ): Promise<T> {
    let lastError: any;

    for (let attempt = 0; attempt <= this.config.maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error;

        if (attempt === this.config.maxRetries || !isRetryable(error)) {
          throw error;
        }

        const delay = this.calculateDelay(attempt);
        await this.sleep(delay);
      }
    }

    throw lastError;
  }

  private calculateDelay(attempt: number): number {
    let delay =
      this.config.baseDelay * Math.pow(this.config.backoffMultiplier, attempt);
    delay = Math.min(delay, this.config.maxDelay);

    if (this.config.jitter) {
      delay = delay * (0.5 + Math.random() * 0.5); // Add jitter
    }

    return delay;
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
```

### 5. Monitoring and Observability

#### Distributed Tracing

```typescript
interface TraceContext {
  traceId: string;
  spanId: string;
  parentSpanId?: string;
  baggage: Record<string, string>;
}

class DistributedTracing {
  private static instance: DistributedTracing;
  private currentContext: TraceContext | null = null;

  static getInstance(): DistributedTracing {
    if (!DistributedTracing.instance) {
      DistributedTracing.instance = new DistributedTracing();
    }
    return DistributedTracing.instance;
  }

  startSpan(operationName: string, parentContext?: TraceContext): TraceContext {
    const context: TraceContext = {
      traceId: parentContext?.traceId || this.generateTraceId(),
      spanId: this.generateSpanId(),
      parentSpanId: parentContext?.spanId,
      baggage: { ...parentContext?.baggage },
    };

    this.currentContext = context;

    // Send span start event to tracing system
    this.sendSpanEvent("start", operationName, context);

    return context;
  }

  finishSpan(
    context: TraceContext,
    operationName: string,
    error?: Error
  ): void {
    // Send span finish event to tracing system
    this.sendSpanEvent("finish", operationName, context, error);

    if (this.currentContext?.spanId === context.spanId) {
      this.currentContext = null;
    }
  }

  addBaggage(key: string, value: string): void {
    if (this.currentContext) {
      this.currentContext.baggage[key] = value;
    }
  }

  private sendSpanEvent(
    eventType: "start" | "finish",
    operationName: string,
    context: TraceContext,
    error?: Error
  ): void {
    const spanEvent = {
      eventType,
      operationName,
      traceId: context.traceId,
      spanId: context.spanId,
      parentSpanId: context.parentSpanId,
      timestamp: new Date().toISOString(),
      baggage: context.baggage,
      error: error
        ? {
            message: error.message,
            stack: error.stack,
          }
        : undefined,
    };

    // Send to tracing backend (Jaeger, Zipkin, etc.)
    console.log("Trace Event:", spanEvent);
  }

  private generateTraceId(): string {
    return (
      Math.random().toString(36).substring(2, 15) +
      Math.random().toString(36).substring(2, 15)
    );
  }

  private generateSpanId(): string {
    return Math.random().toString(36).substring(2, 10);
  }
}
```

#### Health Check Pattern

```typescript
interface HealthCheck {
  name: string;
  check(): Promise<HealthStatus>;
}

interface HealthStatus {
  status: "healthy" | "unhealthy" | "degraded";
  message?: string;
  details?: Record<string, any>;
  timestamp: Date;
}

class HealthCheckService {
  private checks: Map<string, HealthCheck> = new Map();

  registerCheck(check: HealthCheck): void {
    this.checks.set(check.name, check);
  }

  async getOverallHealth(): Promise<{
    status: "healthy" | "unhealthy" | "degraded";
    checks: Record<string, HealthStatus>;
  }> {
    const results: Record<string, HealthStatus> = {};
    let overallStatus: "healthy" | "unhealthy" | "degraded" = "healthy";

    for (const [name, check] of this.checks) {
      try {
        const status = await Promise.race([
          check.check(),
          this.timeout(5000), // 5 second timeout
        ]);

        results[name] = status;

        if (status.status === "unhealthy") {
          overallStatus = "unhealthy";
        } else if (
          status.status === "degraded" &&
          overallStatus === "healthy"
        ) {
          overallStatus = "degraded";
        }
      } catch (error) {
        results[name] = {
          status: "unhealthy",
          message: error.message,
          timestamp: new Date(),
        };
        overallStatus = "unhealthy";
      }
    }

    return { status: overallStatus, checks: results };
  }

  private timeout(ms: number): Promise<never> {
    return new Promise((_, reject) =>
      setTimeout(() => reject(new Error("Health check timeout")), ms)
    );
  }
}

// Example health checks
class DatabaseHealthCheck implements HealthCheck {
  name = "database";

  async check(): Promise<HealthStatus> {
    try {
      // Perform a simple query to check database connectivity
      await this.performHealthQuery();

      return {
        status: "healthy",
        message: "Database connection is healthy",
        timestamp: new Date(),
      };
    } catch (error) {
      return {
        status: "unhealthy",
        message: `Database connection failed: ${error.message}`,
        timestamp: new Date(),
      };
    }
  }

  private async performHealthQuery(): Promise<void> {
    // Implementation would perform actual database query
    // For example: SELECT 1
  }
}
```

## Deployment and Infrastructure Patterns

### Container Orchestration

```yaml
# Kubernetes deployment example
apiVersion: apps/v1
kind: Deployment
metadata:
  name: invoice-service
  labels:
    app: invoice-service
    version: v1
spec:
  replicas: 3
  selector:
    matchLabels:
      app: invoice-service
  template:
    metadata:
      labels:
        app: invoice-service
        version: v1
    spec:
      containers:
        - name: invoice-service
          image: baseer/invoice-service:v1.2.0
          ports:
            - containerPort: 8080
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: database-secret
                  key: url
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: invoice-service
spec:
  selector:
    app: invoice-service
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP
```

### Service Mesh Configuration

```yaml
# Istio service mesh configuration
apiVersion: <credential-fixture>
kind: VirtualService
metadata:
  name: invoice-service
spec:
  http:
    - match:
        - headers:
            version:
              exact: v2
      route:
        - destination:
            host: invoice-service
            subset: v2
          weight: 100
    - route:
        - destination:
            host: invoice-service
            subset: v1
          weight: 100
---
apiVersion: <credential-fixture>
kind: DestinationRule
metadata:
  name: invoice-service
spec:
  host: invoice-service
  trafficPolicy:
    circuitBreaker:
      consecutiveErrors: 3
      interval: 30s
      baseEjectionTime: 30s
    retryPolicy:
      attempts: 3
      perTryTimeout: 2s
  subsets:
    - name: v1
      labels:
        version: v1
    - name: v2
      labels:
        version: v2
```

## Best Practices for Baseer MVP Evolution

### 1. Gradual Migration Strategy

```yaml
migration_phases:
  phase_1_foundation:
    duration: "3 months"
    goals:
      - Extract customer service
      - Implement API gateway
      - Set up monitoring

  phase_2_core_services:
    duration: "4 months"
    goals:
      - Extract invoice service
      - Implement event-driven architecture
      - Add distributed tracing

  phase_3_advanced_features:
    duration: "3 months"
    goals:
      - Add analytics service
      - Implement CQRS pattern
      - Advanced monitoring and alerting
```

### 2. Data Consistency Strategy

```typescript
interface DataConsistencyStrategy {
  pattern: "eventual_consistency" | "strong_consistency";
  compensationStrategy: "saga" | "two_phase_commit";
  conflictResolution: "last_write_wins" | "merge" | "manual";
}

const baseerConsistencyRules: Record<string, DataConsistencyStrategy> = {
  customer_data: {
    pattern: "strong_consistency",
    compensationStrategy: "two_phase_commit",
    conflictResolution: "manual",
  },
  invoice_creation: {
    pattern: "eventual_consistency",
    compensationStrategy: "saga",
    conflictResolution: "last_write_wins",
  },
  analytics_data: {
    pattern: "eventual_consistency",
    compensationStrategy: "saga",
    conflictResolution: "merge",
  },
};
```

### 3. Security Patterns

```yaml
security_architecture:
  authentication:
    pattern: "OAuth 2.0 + JWT"
    provider: "AWS Cognito"
    token_expiry: "1 hour"
    refresh_token_expiry: "30 days"

  authorization:
    pattern: "RBAC (Role-Based Access Control)"
    roles:
      - admin
      - business_owner
      - employee
      - viewer

  inter_service_communication:
    pattern: "mTLS (Mutual TLS)"
    certificate_rotation: "automatic"
    certificate_validity: "90 days"

  data_encryption:
    at_rest: "AES-256"
    in_transit: "TLS 1.3"
    key_management: "AWS KMS"
```

---

## Implementation Roadmap

### Short Term (Next 6 months)

- Design service boundaries based on current Baseer features
- Implement API gateway pattern for mobile app backend
- Set up basic monitoring and health checks
- Create deployment pipeline for containerized services

### Medium Term (6-12 months)

- Extract first microservice (customer or invoice service)
- Implement event-driven architecture
- Add distributed tracing and advanced monitoring
- Implement circuit breaker and retry patterns

### Long Term (12+ months)

- Complete microservices migration
- Implement advanced patterns (CQRS, Event Sourcing)
- Add service mesh for advanced traffic management
- Implement comprehensive observability stack

---

**Usage Guidelines:**

- Start with monolith-first approach for Baseer MVP
- Apply microservices patterns gradually as the system grows
- Focus on business value over technical complexity
- Ensure proper monitoring and observability from day one
- Consider team size and expertise when choosing patterns
