# Professional Developer Guide: Basir Accounting System MVP

**Project:** Basir Accounting System MVP  
**Author:** Basir Project Agentic Development Team  
**Date:** December 16, 2025  
**Version:** 2.0 - Fully Updated for Flutter/Dart  
**Status:** ✅ Comprehensive and Verified

---

## 🎯 Welcome to Basir MVP

This guide is the primary technical resource for developers integrating with or maintaining the Basir Accounting System MVP. It provides a standardized, Flutter-centric framework for development, ensuring that all implementations align with our high-fidelity standards.

### What is Basir MVP?

**Basir** is a high-integrity, Local-First accounting and invoicing application engineered specifically for the Saudi and MENA markets. It features native Arabic support and professional Right-to-Left (RTL) orchestration.

### Core Engineering Pillars

- 🏠 **Local-First**: Data persistence is hardware-anchored by default.
- 📱 **Mobile-First**: Optimized for touch-centric, responsive workflows.
- 🇸🇦 **Arabic-First**: Native RTL support and Arabic technical terminology.
- 🔒 **Security-First**: Hardware-backed encryption and strict auth guards.
- ✨ **Quality-First**: High test density and Zero-Lint tolerance.

---

## 🚀 Quick Start

### Prerequisites

1.  **Flutter SDK 3.35.5+**
2.  **Dart SDK 3.9.2+** (Embedded in Flutter)
3.  **Android Studio** or **VS Code** (with Flutter/Dart extensions)
4.  **Git 2.0+**

### Environment Initialization

#### 1. Repository Access

```bash
git clone [repository-url] basir-mvp
cd basir-mvp
```

#### 2. Dependency Resolution

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 3. Execution

```bash
# Debug Mode
flutter run

# Device-Specific Execution
flutter run -d chrome  # Web
flutter run -d android # Android Device/Emulator
```

---

## 🏗️ Architectural Blueprint

### Directory Hierarchy

```text
lib/
├── core/                     # Cross-cutting foundational logic.
│   ├── constants/            # Global immutables and message indices.
│   ├── errors/               # Standardized exception handling.
│   ├── network/              # Connectivity and API orchestration.
│   └── utils/                # General-purpose utility functions.
├── features/                 # Modular Feature-First components.
│   ├── invoices/             # Transactional logic.
│   ├── customers/            # CRM logic.
│   └── settings/             # Configuration logic.
├── shared/                   # Reusable system-wide components.
│   ├── widgets/              # Atomic UI elements.
│   ├── providers/            # Riverpod DI and State containers.
│   └── themes/               # Typographic and palette tokens.
└── main.dart                 # Application entry point.
```

---

## 🎨 UI/UX Orchestration

### Material Design 3 and RTL Support

#### Global Theme Configuration

We utilize Material 3 with a customized typography scale optimized for Arabic script.

```dart
// lib/shared/themes/app_theme.dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2196F3), // Basir Tech Blue
      brightness: Brightness.light,
    ),
    fontFamily: 'Tajawal', // High-fidelity Arabic typeface
    textTheme: _buildTextTheme(),
  );
}
```

---

## 💾 Local Data Persistence (Isar)

We utilize the **Isar Database** for high-performance, local-first persistence.

#### Schema Definition

```dart
@Collection()
class InvoiceModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String invoiceNumber;

  @Index()
  late String customerName;

  late double totalAmount;

  @Index()
  late DateTime createdAt;

  @Index()
  @Enumerated(EnumType.name)
  late InvoiceStatus status;
}
```

---

## 🔄 State Orchestration (Riverpod)

**Riverpod** is the exclusive engine for state management and dependency injection.

- Use `Provider` for immutable service discovery.
- Use `StateNotifierProvider` or `NotifierProvider` for mutable UI state.
- Use `FutureProvider` for asynchronous data streams.

---

## 🧪 Verification and Quality Assurance

### Automated Testing Suite

We maintain a strict testing hierarchy to ensure system integrity.

1.  **Unit Tests**: Logic and calculation verification.
2.  **Widget Tests**: Component-level interaction verification.
3.  **Integration Tests**: Full E2E workflow verification.

```bash
# Execute Full Suite
flutter test

# Execute with Coverage Report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🔒 Security and Privacy Protocols

### Secure Storage

Sensitive credentials (Master Password, API tokens) must be stored in the hardware-backed **Flutter Secure Storage**.

### Data Sanitization

All logs and diagnostics must pass through the `sanitize.sh` utility before persistence or transmission to ensure PII (Personally Identifiable Information) protection.

---

## 🚀 Deployment Orchestration

### Release Build (Production)

#### Android

```bash
flutter build appbundle --release --shrink --obfuscate --split-debug-info=build/debug-info/
```

#### iOS

```bash
flutter build ipa --release
```

---

## 🔧 Operational Utilities

- `scripts/install.sh`: Automated environment and hook setup.
- `scripts/collect_logs.sh`: Comprehensive diagnostic collection.
- `scripts/generate_report.sh`: Project health and status reporting.

---

## 🎉 Conclusion

By adhering to these standards, you ensure that the Basir Accounting System remains a high-integrity, professional, and scalable platform.

**Welcome to the Engineering Team!** 🚀

---

**Prepared by:** Basir Project Agentic Development Team  
**Last Updated:** December 16, 2025  
**Version:** 2.0  
**Status:** ✅ English-First Standardized
