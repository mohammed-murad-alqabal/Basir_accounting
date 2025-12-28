# System Architecture: Baseer Intelligent Financial System

**Document ID:** BASEER-P4-001  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Technical Architecture

---

## 1. Architecture Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────────┐  │
│  │   iOS App    │  │ Android App  │  │        Web App           │  │
│  │  (Flutter)   │  │  (Flutter)   │  │       (Flutter)          │  │
│  └──────────────┘  └──────────────┘  └──────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────────┘
                             │ HTTPS/TLS 1.3
                             ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           API GATEWAY                               │
│        Load Balancer + Rate Limiting + Authentication               │
└────────────────────────────┬────────────────────────────────────────┘
                             │
┌────────────────────────────┼────────────────────────────────────────┐
│                      SERVICE LAYER (Go)                             │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────────────┐   │
│  │ Auth Svc  │ │Invoice Svc│ │Expense Svc│ │    Report Svc     │   │
│  └───────────┘ └───────────┘ └───────────┘ └───────────────────┘   │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────────────┐   │
│  │Customer   │ │ Tax Svc   │ │  AI Svc   │ │  Notification Svc │   │
│  │   Svc     │ │           │ │           │ │                   │   │
│  └───────────┘ └───────────┘ └───────────┘ └───────────────────┘   │
└────────────────────────────┬────────────────────────────────────────┘
                             │
┌────────────────────────────┼────────────────────────────────────────┐
│                        DATA LAYER                                   │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────────────┐   │
│  │  PostgreSQL   │  │    Redis      │  │    Object Storage     │   │
│  │  (Primary)    │  │   (Cache)     │  │    (Documents)        │   │
│  └───────────────┘  └───────────────┘  └───────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                             │
┌────────────────────────────┼────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                             │
│     Kubernetes │ Terraform │ CI/CD │ Monitoring │ Logging          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Technology Stack

### Frontend (Client)

| Layer            | Technology | Version | Rationale                          |
| ---------------- | ---------- | ------- | ---------------------------------- |
| Framework        | Flutter    | 3.24+   | Cross-platform, native performance |
| State Management | Riverpod   | 2.x     | Type-safe, testable                |
| Local Database   | Isar       | 3.x     | Fast, embedded, encrypted          |
| HTTP Client      | Dio        | 5.x     | Interceptors, retry logic          |
| Navigation       | GoRouter   | 14.x    | Declarative, deep linking          |

### Backend (Server)

| Layer      | Technology    | Version | Rationale                |
| ---------- | ------------- | ------- | ------------------------ |
| Language   | Go            | 1.22+   | Performance, simplicity  |
| Framework  | Gin           | 1.x     | Fast HTTP router         |
| ORM        | GORM          | 1.x     | Productivity, migrations |
| Validation | go-playground | 10.x    | Struct validation        |
| Auth       | JWT           | -       | Stateless authentication |

### Data

| Type       | Technology     | Use               |
| ---------- | -------------- | ----------------- |
| Primary DB | PostgreSQL 16  | Relational data   |
| Cache      | Redis 7        | Sessions, caching |
| Search     | PostgreSQL FTS | Full-text search  |
| Queue      | Redis Streams  | Async jobs        |
| Files      | S3/GCS         | Document storage  |

### AI/ML

| Component      | Technology      | Use              |
| -------------- | --------------- | ---------------- |
| Categorization | TensorFlow Lite | On-device ML     |
| OCR            | Google ML Kit   | Receipt scanning |
| Language       | OpenAI API      | NLP features     |

---

## 3. Component Architecture

### Frontend Architecture (Flutter)

```
lib/
├── core/
│   ├── config/         # App configuration
│   ├── constants/      # App constants
│   ├── error/          # Error handling
│   ├── network/        # HTTP client, interceptors
│   ├── router/         # Navigation
│   ├── theme/          # Design system
│   ├── utils/          # Utilities
│   └── widgets/        # Shared widgets
│
├── features/
│   ├── auth/
│   │   ├── data/       # Repositories, data sources
│   │   ├── domain/     # Models, business logic
│   │   └── presentation/ # UI, controllers
│   │
│   ├── invoices/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── expenses/
│   ├── customers/
│   ├── dashboard/
│   └── settings/
│
└── main.dart
```

### Backend Architecture (Go)

```
backend/
├── cmd/
│   └── server/         # Application entry point
│
├── internal/
│   ├── config/         # Configuration
│   ├── handler/        # HTTP handlers
│   ├── middleware/     # Auth, logging, etc.
│   ├── model/          # Domain models
│   ├── repository/     # Data access
│   ├── service/        # Business logic
│   └── validator/      # Input validation
│
├── pkg/
│   ├── crypto/         # Encryption utilities
│   ├── zatca/          # ZATCA compliance
│   └── pdf/            # PDF generation
│
└── main.go
```

---

## 4. Data Flow

### Request Flow

```
Client → API Gateway → Auth Middleware → Handler → Service → Repository → DB
                                                        ↓
Client ← Response ← Handler ← Service ← Cache/DB Result
```

### Sync Architecture

```
┌─────────────┐          ┌─────────────┐          ┌─────────────┐
│   Mobile    │  ──────▶ │   Sync      │  ──────▶ │   Server    │
│   (Isar)    │  ◀────── │   Engine    │  ◀────── │   (PG)      │
└─────────────┘          └─────────────┘          └─────────────┘
                               │
                     Conflict Resolution
                     Last-Write-Wins + Merge
```

---

## 5. Security Architecture

### Authentication Flow

```
┌────────┐     ┌────────┐     ┌────────┐     ┌────────┐
│ Client │────▶│  Auth  │────▶│ Verify │────▶│ Issue  │
│        │     │Request │     │ Creds  │     │ JWT    │
└────────┘     └────────┘     └────────┘     └────────┘
                                                  │
┌────────┐     ┌────────┐     ┌────────┐          │
│ Client │◀────│ Access │◀────│Refresh │◀─────────┘
│        │     │ Token  │     │ Token  │
└────────┘     └────────┘     └────────┘
```

### Token Structure

| Token         | Duration  | Storage           | Use            |
| ------------- | --------- | ----------------- | -------------- |
| Access Token  | 15 min    | Memory            | API calls      |
| Refresh Token | 7 days    | Secure storage    | Token refresh  |
| Biometric Key | Permanent | Keychain/Keystore | Biometric auth |

### Encryption

| Layer            | Method                           |
| ---------------- | -------------------------------- |
| In Transit       | TLS 1.3                          |
| At Rest (Server) | AES-256-GCM                      |
| At Rest (Mobile) | Isar encryption + Secure Storage |
| Sensitive Fields | Field-level encryption           |

---

## 6. Scalability Design

### Horizontal Scaling

| Component   | Strategy                          |
| ----------- | --------------------------------- |
| API Servers | Kubernetes HPA, stateless         |
| Database    | Read replicas, connection pooling |
| Cache       | Redis Cluster                     |
| Files       | CDN + distributed storage         |

### Performance Targets

| Metric               | Target      |
| -------------------- | ----------- |
| API Response (p95)   | < 200ms     |
| Concurrent Users     | 100K+       |
| Database Connections | 100 per pod |
| Cache Hit Rate       | > 90%       |

---

## 7. Deployment Architecture

### Kubernetes Cluster

```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                        │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Namespace: baseer-prod                              │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐             │    │
│  │  │API Pod x3│ │Worker x2 │ │ Redis    │             │    │
│  │  └──────────┘ └──────────┘ └──────────┘             │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Managed Services                                    │    │
│  │  • Cloud SQL (PostgreSQL)                           │    │
│  │  • Cloud Storage                                    │    │
│  │  • Cloud CDN                                        │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
