# Strategic Master Blueprint: Basir Project

## 1. Vision and Mission

### Vision

To become the leading Arabic-first, privacy-focused financial management ecosystem, empowering SMEs with intelligent, standards-compliant accounting tools that require zero specialized training.

### Mission

To bridge the gap between complex international accounting standards (IFRS/ZATCA) and the daily operational needs of small businesses through "Cognitive Accounting"—an AI-driven, proactive approach to financial health.

## 2. Core Strategic Pillars

| Pillar                     | Description                                                                                           |
| :------------------------- | :---------------------------------------------------------------------------------------------------- |
| **Privacy First**          | All core financial data remains on-device. Privacy is not a feature; it is the foundation.            |
| **Arabic-First Design**    | Native RTL support and Arabic-first user journeys, ensuring a premium experience for the MENA region. |
| **Standard Compliance**    | Built-in compliance with IFRS 18, ZATCA (Phase 2), and Saudi Arabian accounting regulations.          |
| **Intelligent Automation** | Reducing manual entry by 80% through automated categorization and OCR-driven invoice processing.      |

## 3. Development Roadmap

### Phase 1: Cognitive Foundation (Current)

- [x] Clean Architecture Setup
- [x] Local Storage Engine (Isar)
- [x] Core Accounting Entities (Decimal Precision)
- [x] Basic Invoicing & Customer Management
- [x] IFRS 18 Basic Reporting (Income Statement & Balance Sheet)

### Phase 2: Regulatory Excellence (Q2 2026)

- [ ] ZATCA Phase 2 Integration (XML/UBL 2.1)
- [ ] QR Code (Base64) Cryptographic Signing
- [ ] Multi-VAT Rate Support
- [ ] Advanced Forensic Audit Trails

### Phase 3: AI-Driven Insights (Q4 2026)

- [ ] Local LLM for Financial Advisory
- [ ] Cash Flow Forecasting (Prophet/ARIMA)
- [ ] Automated Expense Categorization
- [ ] Smart Budgeting Alerts

## 4. Engineering Standards (The "Diamond Purity" Protocol)

1. **Zero-Lint Tolerance**: `flutter analyze` must return 0 issues at all times.
2. **Immutable State**: State management must strictly use Riverpod with immutable data models (Freezed).
3. **Domain-Driven Design (DDD)**: Logic must reside in Domain/Application layers, keeping the UI purely declarative.
4. **Comprehensive Documentation**: Every feature must include a Concept Note, Technical Design, and Verification Plan.
5. **English Purity (Internal)**: All code, commits, and technical documentation must be in professional technical English.

## 5. Technology Stack

- **Framework**: Flutter (Cross-platform)
- **Language**: Dart
- **State Management**: Riverpod 2.0+
- **Database**: Isar (NoSQL for Flutter/Dart)
- **Precision**: `decimal` package for all monetary calculations
- **Code Generation**: Freezed, JsonSerializable, RiverpodGenerator
