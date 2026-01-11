# Technical Design Document (TDD) - Initial Version (MVP)

## 1. Objectives and Methodology

This document outlines the engineering architecture and technical design of the **Basir** MVP to ensure a solid foundation that is maintainable, testable, and highly scalable for future expansions.

**Primary Methodology**: Clean Architecture.

## 2. Clean Architecture

The project is divided into distinct, independent layers. Dependency flows from outer layers to inner layers, ensuring that core business logic (Domain) remains unaffected by implementation details such as the UI framework or database choice.

| Layer               | Description                                                                                                                                                  | Technologies                                    |
| :------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------- |
| **1. Presentation** | Contains UI components (Widgets) and state management logic. Responsible for data rendering and user interaction.                                            | Flutter Widgets, Riverpod                       |
| **2. Domain**       | The heart of the application. Contains Entities, Use Cases, and Repository Interfaces. This layer is pure Dart and contains no implementation-specific code. | Dart Entities, Use Cases, Repository Interfaces |
| **3. Data**         | Implements the Repository Interfaces defined in the Domain layer. Responsible for data persistence and retrieval (local database, and future APIs).          | Isar Database, Repository Implementations       |

## 3. Directory Structure

The `lib` directory is organized to reflect Clean Architecture principles:

```
lib/
├── core/             # Shared components (constants, helpers, shared models, error handling)
├── features/         # Application features (each feature has its own subdirectory)
│   ├── auth/         # Local authentication (login, initial setup)
│   ├── invoices/     # Invoice management feature
│   ├── customers/    # Customer management feature
│   └── dashboard/    # Dashboard and analytics feature
├── main.dart         # Main entry point of the application
└── services/         # Cross-cutting concerns and external services (e.g., local storage)
```

**Inside each feature (e.g., `invoices/`):**

```
invoices/
├── data/             # Data Layer (Isar Models, Repository Implementations)
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/           # Domain Layer (Entities, Use Cases, Repository Interfaces)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/     # Presentation Layer (UI, State Management)
    ├── pages/        # Full screen widgets
    ├── widgets/      # Feature-specific components
    └── providers/    # Riverpod State Notifiers and Controllers
```

## 4. State Management and Persistence

| Component            | Technology                 | Rationale                                                                                                                                              |
| :------------------- | :------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **State Management** | **Riverpod**               | A modern, compile-safe solution that provides fine-grained control over dependencies (Dependency Injection) and simplifies unit testing.               |
| **Local Storage**    | **Isar Database**          | An ultra-fast NoSQL database designed specifically for Flutter/Dart. Ideal for efficient local storage of structured data like invoices and customers. |
| **Secure Storage**   | **Flutter Secure Storage** | Used for storing sensitive credentials (username/password) securely using device-level encryption.                                                     |

## 5. Engineering Best Practices

1.  **Clean Code**: Strict adherence to **SOLID** and **DRY** principles.
2.  **Documentation**: Using Dart documentation (Triple-slash `///` Doc Comments) for all public classes and members.
3.  **Static Analysis (Linting)**: Enabling strict `flutter_lints` rules to guarantee code quality and consistency.
4.  **Extensibility**: Designing `Repository Interfaces` in the Domain layer to allow seamless switching between the current local storage (Isar) and future cloud synchronization (REST/GraphQL API) without disrupting business logic.
