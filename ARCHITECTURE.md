# 🏗️ Basir System Architecture

**Status:** 💎 Diamond Purity Achieved  
**Last Updated:** 2026-01-14  
**Framework:** Clean Architecture + Cognitive Multi-Agent Layer

---

## 📋 Architectural Overview

Basir is a high-performance, institutional-grade accounting system designed for the Saudi Arabian market (ZATCA compliance) and international standards (IFRS 18). It utilizes a hybrid architecture combining **Flutter** for cross-platform visual excellence and **Rust** for mission-critical financial calculations and cryptographic security.

### Core Philosophy

- **Precision First**: Every financial operation uses high-precision decimal math.
- **Cognitive Integrity**: Transactions are validated by a multi-agent consensus system (The Cognitive Hexagon).
- **ZATCA Readiness**: Native support for ZATCA Phase 2 (Clearance & Reporting) embedded in the core.

---

## 🛠️ Technology Stack

| Layer                 | Technology              | Role                                          |
| :-------------------- | :---------------------- | :-------------------------------------------- |
| **Presentation**      | Flutter (Dart)          | High-fidelity UI, State Management (Riverpod) |
| **Business Logic**    | Dart + Rust (FFI)       | Multi-agent orchestration, Financial rules    |
| **Core Calculations** | Rust (accounting_core)  | Decimal math, Forensic scanning               |
| **Compliance**        | Rust (accounting_zatca) | XML signing, QR TLV, Cryptographic hashing    |
| **Persistence**       | Isar (NoSQL)            | High-performance offline-first storage        |
| **Security**          | Flutter Secure Storage  | Encrypted credential and key management       |

---

## 🧬 The Cognitive Hexagon

The heart of Basir's validation logic is the multi-agent orchestration service. Every posted transaction must pass through six specialized "Cognitive Agents":

1.  **Standards Engine (IFRS 18)**: Ensures compliance with the latest international reporting standards.
2.  **Tax Engine (ZATCA)**: Validates VAT rates, categories, and regulatory data integrity.
3.  **Forensic Audit**: Detects anomalies, sequence gaps, and irregular posting patterns.
4.  **Operational Intel**: Analyzes business impact (e.g., inventory velocity, credit risks).
5.  **Financial Strategy**: Provides KPI oversight and cash flow forecasting advice.
6.  **Sustainability Expert (ISSB)**: Monitors environmental (S2) and social (S1) disclosure metrics.

---

## 🇸🇦 ZATCA Phase 2 Implementation

Basir implements the "Reporting" and "Clearance" models required by the Zakat, Tax and Customs Authority:

- **Cryptographic Bridge**: Rust-based engine for generating UUIDs, Hashing (SHA-256), and ECDSA signatures.
- **XML Integration**: automated generation of UBL 2.1 compliant invoice XMLs.
- **QR Code (TLV)**: high-performance QR generation including the required cryptographic hash and signature components.

---

## 📊 Data Layer & Clean Architecture

### 1. Domain Layer (The Brain)

- **Entities**: Immutable Dart and Rust structures (Invoice, JournalEntry).
- **Repositories**: Abstract contracts for data access.
- **Agents**: Scientific logic for consensus.

### 2. Data Layer (The Muscle)

- **Isar implementation**: Optimized for massive datasets with native speed.
- **Rust FFI**: Direct bridge to the high-performance calculation engine.

### 3. Presentation Layer (The Face)

- **Feature-First**: Modular directories (invoices, accounting, inventory).
- **Riverpod v2+**: Reactive state management with code generation.

---

## 🛡️ Security & Reliability

- **Self-Healing**: Automated audit trail verification using the Rust Forensic engine.
- **Offline-First**: All data is local; synchronization is an optional secondary layer.
- **Hardware Acceleration**: Computationally heavy tasks (PDF generation, Forensic scans) run on background threads via Rust.

---

💎 **Diamond Purity Protocol** | _Precision. Integrity. Basir._
