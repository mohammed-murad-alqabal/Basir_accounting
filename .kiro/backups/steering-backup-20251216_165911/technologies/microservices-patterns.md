---
title: Microservices Architecture Patterns
inclusion: fileMatch
fileMatchPattern: "*service*|*api*|*microservice*"
---

# Microservices Architecture Patterns

**المشروع:** بصير MVP  
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**التاريخ:** 15 ديسمبر 2025

---

## Service Decomposition Strategies

### Domain-Driven Design (DDD) Approach

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
      - Invoice lifecycle management
      - PDF generation
      - Invoice calculations
    data_ownership:
      - invoices table
      - invoice_items table
      - invoice_templates table

  notification_service:
    domain: Communication
    responsibilities:
      - Email notifications
      - SMS notifications
      - Push notifications
    data_ownership:
      - notification_logs table
      - notification_templates table
```

### Service Size Guidelines

- **Single Responsibility**: Each service should have one clear business purpose
- **Team Ownership**: One team should own 2-8 services maximum
- **Database per Service**: Each service owns its data
- **Independent Deployment**: Services deploy independently

## Inter-Service Communication Patterns

### Synchronous Communication

#### REST API Design

```dart
// Customer Service API Client
class CustomerServiceClient {
  final String baseUrl;
  final http.Client httpClient;

  CustomerServiceClient({
    required this.baseUrl,
    required this.httpClient,
  });

  Future<Customer> getCustomer(String customerId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/customers/$customerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getToken()}',
      },
    );

    if (response.statusCode == 200) {
      return Customer.fromJson(jsonDecode(response.body));
    } else {
      throw CustomerServiceException(
        'Failed to get customer: ${response.statusCode}',
      );
    }
  }

  Future<List<Customer>> searchCustomers({
    String? name,
    String? email,
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    };

    final uri = Uri.parse('$baseUrl/customers').replace(
      queryParameters: queryParams,
    );

    final response = await httpClient.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final customers = (data['customers'] as List)
          .map((json) => Customer.fromJson(json))
          .toList();
      return customers;
    } else {
      throw CustomerServiceException(
        'Failed to search customers: ${response.statusCode}',
      );
    }
  }
}
```

#### GraphQL Federation

```graphql
# Customer Service Schema
type Customer {
  id: ID!
  name: String!
  email: String!
  phone: String
  address: Address
  createdAt: DateTime!
  updatedAt: DateTime!
}

type Address {
  street: String!
  city: String!
  country: String!
  postalCode: String
}

extend type Query {
  customer(id: ID!): Customer
  customers(filter: CustomerFilter, pagination: Pagination): CustomerConnection
}

extend type Mutation {
  createCustomer(input: CreateCustomerInput!): Customer!
  updateCustomer(id: ID!, input: UpdateCustomerInput!): Customer!
  deleteCustomer(id: ID!): Boolean!
}

# Invoice Service Schema (extends Customer)
extend type Customer @key(fields: "id") {
  id: ID! @external
  invoices: [Invoice!]!
  totalInvoiceAmount: Float!
}

type Invoice {
  id: ID!
  customerId: ID!
  customer: Customer!
  items: [InvoiceItem!]!
  total: Float!
  status: InvoiceStatus!
  createdAt: DateTime!
}
```

### Asynchronous Communication

#### Event-Driven Architecture

```dart
// Event Bus Implementation
abstract class DomainEvent {
  final String eventId;
  final DateTime occurredAt;
  final String eventType;

  DomainEvent({
    required this.eventId,
    required this.occurredAt,
    required this.eventType,
  });

  Map<String, dynamic> toJson();
}

class CustomerCreatedEvent extends DomainEvent {
  final String customerId;
  final String customerName;
  final String customerEmail;

  CustomerCreatedEvent({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
  }) : super(
          eventId: Uuid().v4(),
          occurredAt: DateTime.now(),
          eventType: 'customer.created',
        );

  @override
  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'occurredAt': occurredAt.toIso8601String(),
        'eventType': eventType,
        'customerId': customerId,
        'customerName': customerName,
        'customerEmail': customerEmail,
      };
}

// Event Publisher
class EventPublisher {
  final MessageBroker _messageBroker;

  EventPublisher(this._messageBroker);

  Future<void> publish(DomainEvent event) async {
    await _messageBroker.publish(
      topic: event.eventType,
      message: jsonEncode(event.toJson()),
      headers: {
        'event-id': event.eventId,
        'event-type': event.eventType,
        'timestamp': event.occurredAt.toIso8601String(),
      },
    );
  }
}

// Event Handler
class InvoiceServiceEventHandler {
  final InvoiceService _invoiceService;

  InvoiceServiceEventHandler(this._invoiceService);

  @EventHandler('customer.created')
  Future<void> handleCustomerCreated(CustomerCreatedEvent event) async {
    // Create default invoice template for new customer
    await _invoiceService.createDefaultTemplate(
      customerId: event.customerId,
      customerName: event.customerName,
    );
  }

  @EventHandler('customer.updated')
  Future<void> handleCustomerUpdated(CustomerUpdatedEvent event) async {
    // Update customer information in invoice service
    await _invoiceService.updateCustomerInfo(
      customerId: event.customerId,
      updates: event.changes,
    );
  }
}
```

## Service Discovery and Load Balancing

### Service Registry Pattern

```dart
// Service Registry Interface
abstract class ServiceRegistry {
  Future<void> register(ServiceInstance instance);
  Future<void> deregister(String serviceId);
  Future<List<ServiceInstance>> discover(String serviceName);
  Future<ServiceInstance?> findHealthyInstance(String serviceName);
}

class ServiceInstance {
  final String serviceId;
  final String serviceName;
  final String host;
  final int port;
  final Map<String, String> metadata;
  final HealthStatus health;

  ServiceInstance({
    required this.serviceId,
    required this.serviceName,
    required this.host,
    required this.port,
    this.metadata = const {},
    this.health = HealthStatus.unknown,
  });

  String get baseUrl => 'http://$host:$port';
}

// Load Balancer
class LoadBalancer {
  final ServiceRegistry _registry;
  final LoadBalancingStrategy _strategy;

  LoadBalancer(this._registry, this._strategy);

  Future<ServiceInstance?> selectInstance(String serviceName) async {
    final instances = await _registry.discover(serviceName);
    final healthyInstances = instances
        .where((instance) => instance.health == HealthStatus.healthy)
        .toList();

    if (healthyInstances.isEmpty) {
      return null;
    }

    return _strategy.select(healthyInstances);
  }
}

// Load Balancing Strategies
abstract class LoadBalancingStrategy {
  ServiceInstance select(List<ServiceInstance> instances);
}

class RoundRobinStrategy implements LoadBalancingStrategy {
  int _currentIndex = 0;

  @override
  ServiceInstance select(List<ServiceInstance> instances) {
    final instance = instances[_currentIndex % instances.length];
    _currentIndex++;
    return instance;
  }
}

class RandomStrategy implements LoadBalancingStrategy {
  final Random _random = Random();

  @override
  ServiceInstance select(List<ServiceInstance> instances) {
    return instances[_random.nextInt(instances.length)];
  }
}
```

## Data Management Patterns

### Database per Service

```yaml
service_data_ownership:
  customer_service:
    database: customer_db
    tables:
      - customers
      - customer_addresses
      - customer_preferences
    access_pattern: "Direct database access only by customer service"

  invoice_service:
    database: invoice_db
    tables:
      - invoices
      - invoice_items
      - invoice_templates
    access_pattern: "Direct database access only by invoice service"

  shared_data_access:
    pattern: "API calls between services"
    example: "Invoice service calls Customer service API to get customer details"
```

### Saga Pattern for Distributed Transactions

```dart
// Saga Orchestrator
class CreateInvoiceSaga {
  final CustomerServiceClient _customerService;
  final InvoiceServiceClient _invoiceService;
  final NotificationServiceClient _notificationService;
  final SagaStateRepository _stateRepository;

  CreateInvoiceSaga({
    required CustomerServiceClient customerService,
    required InvoiceServiceClient invoiceService,
    required NotificationServiceClient notificationService,
    required SagaStateRepository stateRepository,
  })  : _customerService = customerService,
        _invoiceService = invoiceService,
        _notificationService = notificationService,
        _stateRepository = stateRepository;

  Future<void> execute(CreateInvoiceCommand command) async {
    final sagaId = Uuid().v4();
    var state = SagaState(
      sagaId: sagaId,
      status: SagaStatus.started,
      steps: [],
    );

    try {
      // Step 1: Validate customer
      state = await _executeStep(
        state,
        'validate_customer',
        () => _customerService.validateCustomer(command.customerId),
        () => Future.value(), // No compensation needed for validation
      );

      // Step 2: Create invoice
      state = await _executeStep(
        state,
        'create_invoice',
        () => _invoiceService.createInvoice(command.invoiceData),
        () => _invoiceService.deleteInvoice(state.invoiceId!),
      );

      // Step 3: Send notification
      state = await _executeStep(
        state,
        'send_notification',
        () => _notificationService.sendInvoiceCreatedNotification(
          customerId: command.customerId,
          invoiceId: state.invoiceId!,
        ),
        () => Future.value(), // Notification failure doesn't need compensation
      );

      state = state.copyWith(status: SagaStatus.completed);
    } catch (error) {
      // Execute compensation actions in reverse order
      await _compensate(state);
      state = state.copyWith(
        status: SagaStatus.failed,
        error: error.toString(),
      );
    } finally {
      await _stateRepository.save(state);
    }
  }

  Future<SagaState> _executeStep(
    SagaState state,
    String stepName,
    Future<dynamic> Function() action,
    Future<void> Function() compensation,
  ) async {
    try {
      final result = await action();
      final step = SagaStep(
        name: stepName,
        status: StepStatus.completed,
        compensation: compensation,
        result: result,
      );

      return state.copyWith(
        steps: [...state.steps, step],
      );
    } catch (error) {
      final step = SagaStep(
        name: stepName,
        status: StepStatus.failed,
        compensation: compensation,
        error: error.toString(),
      );

      throw SagaExecutionException(
        state.copyWith(steps: [...state.steps, step]),
        error,
      );
    }
  }

  Future<void> _compensate(SagaState state) async {
    final completedSteps = state.steps
        .where((step) => step.status == StepStatus.completed)
        .toList()
        .reversed;

    for (final step in completedSteps) {
      try {
        await step.compensation();
      } catch (error) {
        // Log compensation failure but continue with other compensations
        print('Compensation failed for step ${step.name}: $error');
      }
    }
  }
}
```

## Monitoring and Observability

### Distributed Tracing

```dart
// Tracing Implementation
class TracingInterceptor extends Interceptor {
  final Tracer _tracer;

  TracingInterceptor(this._tracer);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final span = _tracer.startSpan(
      'http_request',
      tags: {
        'http.method': options.method,
        'http.url': options.uri.toString(),
        'service.name': 'flutter_client',
      },
    );

    // Add trace headers
    options.headers['X-Trace-Id'] = span.traceId;
    options.headers['X-Span-Id'] = span.spanId;
    options.extra['span'] = span;

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final span = response.requestOptions.extra['span'] as Span?;
    if (span != null) {
      span.setTag('http.status_code', response.statusCode.toString());
      span.finish();
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final span = err.requestOptions.extra['span'] as Span?;
    if (span != null) {
      span.setTag('error', true);
      span.setTag('error.message', err.message);
      span.finish();
    }
    handler.next(err);
  }
}
```

### Health Checks

```dart
// Health Check Implementation
class HealthCheckService {
  final List<HealthCheck> _healthChecks;

  HealthCheckService(this._healthChecks);

  Future<HealthStatus> checkHealth() async {
    final results = <String, HealthCheckResult>{};
    var overallStatus = HealthStatus.healthy;

    for (final check in _healthChecks) {
      try {
        final result = await check.check().timeout(
          Duration(seconds: 5),
          onTimeout: () => HealthCheckResult.unhealthy('Timeout'),
        );

        results[check.name] = result;

        if (result.status != HealthStatus.healthy) {
          overallStatus = HealthStatus.unhealthy;
        }
      } catch (error) {
        results[check.name] = HealthCheckResult.unhealthy(error.toString());
        overallStatus = HealthStatus.unhealthy;
      }
    }

    return HealthStatus(
      status: overallStatus,
      checks: results,
      timestamp: DateTime.now(),
    );
  }
}

// Database Health Check
class DatabaseHealthCheck implements HealthCheck {
  final Database _database;

  DatabaseHealthCheck(this._database);

  @override
  String get name => 'database';

  @override
  Future<HealthCheckResult> check() async {
    try {
      await _database.query('SELECT 1');
      return HealthCheckResult.healthy();
    } catch (error) {
      return HealthCheckResult.unhealthy('Database connection failed: $error');
    }
  }
}

// External Service Health Check
class ExternalServiceHealthCheck implements HealthCheck {
  final String serviceName;
  final String healthEndpoint;
  final http.Client httpClient;

  ExternalServiceHealthCheck({
    required this.serviceName,
    required this.healthEndpoint,
    required this.httpClient,
  });

  @override
  String get name => serviceName;

  @override
  Future<HealthCheckResult> check() async {
    try {
      final response = await httpClient.get(Uri.parse(healthEndpoint));

      if (response.statusCode == 200) {
        return HealthCheckResult.healthy();
      } else {
        return HealthCheckResult.unhealthy(
          'Service returned status ${response.statusCode}',
        );
      }
    } catch (error) {
      return HealthCheckResult.unhealthy('Service unreachable: $error');
    }
  }
}
```

## Security Patterns

### API Gateway Security

```dart
// JWT Token Validation
class JwtAuthenticationMiddleware {
  final JwtDecoder _jwtDecoder;
  final String _secretKey;

  JwtAuthenticationMiddleware(this._jwtDecoder, this._secretKey);

  Future<bool> authenticate(String token) async {
    try {
      final payload = _jwtDecoder.decode(token, _secretKey);

      // Check expiration
      final exp = payload['exp'] as int;
      if (DateTime.now().millisecondsSinceEpoch / 1000 > exp) {
        return false;
      }

      // Check issuer
      final iss = payload['iss'] as String?;
      if (iss != 'baseer-auth-service') {
        return false;
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  Map<String, dynamic>? extractClaims(String token) {
    try {
      return _jwtDecoder.decode(token, _secretKey);
    } catch (error) {
      return null;
    }
  }
}

// Rate Limiting
class RateLimitingMiddleware {
  final Map<String, List<DateTime>> _requestHistory = {};
  final int _maxRequests;
  final Duration _timeWindow;

  RateLimitingMiddleware({
    required int maxRequests,
    required Duration timeWindow,
  })  : _maxRequests = maxRequests,
        _timeWindow = timeWindow;

  bool isAllowed(String clientId) {
    final now = DateTime.now();
    final history = _requestHistory[clientId] ?? [];

    // Remove old requests outside the time window
    history.removeWhere((time) => now.difference(time) > _timeWindow);

    if (history.length >= _maxRequests) {
      return false;
    }

    history.add(now);
    _requestHistory[clientId] = history;

    return true;
  }
}
```

## Best Practices

### Service Design Principles

1. **Single Responsibility**: Each service should have one business capability
2. **Autonomous**: Services should be independently deployable and scalable
3. **Business-Focused**: Services should be organized around business capabilities
4. **Decentralized**: Avoid shared databases and centralized governance
5. **Failure Isolation**: Design for failure and implement circuit breakers
6. **Observable**: Implement comprehensive logging, metrics, and tracing

### Common Anti-Patterns to Avoid

- **Distributed Monolith**: Services that are too tightly coupled
- **Chatty Interfaces**: Too many fine-grained service calls
- **Shared Database**: Multiple services accessing the same database
- **Synchronous Communication Everywhere**: Not using async patterns when appropriate
- **Lack of Monitoring**: Insufficient observability in distributed systems

---

**للمراجع التفصيلية:** راجع `.kiro/steering/technologies/` للمزيد من الأنماط المتقدمة
