# Basir Engineering Standards (System Architecture)

## 🏗️ Architectural Excellence

1.  **Multi-Agent Orchestration**: Design the system as a collection of specialized agents (Orchestrator, Standards, Engine, Audit, Structure, Reporting).
2.  **Clean Architecture + DDD**: Maintain strict separation between layers. Business logic sits in the Domain layer via Entities and Value Objects.
3.  **Event-Sourcing (Immunity)**: Financial state should be derived from an immutable stream of events (the Ledger).

## 🧪 Quality & Verification

1.  **TDD (Test-Driven Development)**: Write tests for 100% of the Domain and Use Case logic.
2.  **Audit-First Design**: Code should not only work but create a "defensible" trail of _why_ it worked (Logic explaining reasoning).
3.  **Performance Zero-Waste**: Use selective rebuilds and 128-bit decimal arithmetic for financial precision.

## 🔒 Security & Trust

1.  **Immutable Ledger (Hash-Chained)**: Implement SHA-256 hash chaining of ledger entries to ensure data integrity.
2.  **Zero-Trust Identity**: Every accounting transaction must be digitally signed/authed.

## 🤖 Cognitive Agent Directives

1.  **Standards-First**: Always consult the `.kiro/specs/global-accounting-system/` before implementing accounting logic.
2.  **Verification Loop**: Run `flutter analyze` and `flutter test` after every significant logic change.
