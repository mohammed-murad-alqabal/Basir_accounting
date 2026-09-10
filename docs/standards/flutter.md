# Flutter Standards

**Project:** Basir MVP  
**Status:** ✅ Active

---

## Architectural Architecture

### Clean Architecture

- **Presentation Layer**: Screens, Widgets, Providers
- **Domain Layer**: Business Logic, Entities, Use Cases
- **Data Layer**: Models, Repositories, Services, Data Sources

### Feature-First Organization

```
lib/
├── core/          # Shared code (theme, utils, etc.)
├── features/      # Business logic grouped by feature
└── data/          # Global data handling (if any)
```

---

## State Management

### Riverpod 2.0+ (Official Standard)

- `Provider`: For constant/immutable values.
- `StateProvider`: For simple, atomic state changes.
- `FutureProvider`: For asynchronous data fetching and state handling.
- `AsyncNotifier`: For complex, asynchronous state logic (the Riverpod 2.0+ standard).

---

## Database

### Isar (Approved Local Storage)

- Use **Isar in-memory** for unit/integration testing.
- Proper connection management (ensure Isar instances are closed or shared correctly).
- Utilize **Transactions** for bulk operations.
- Implement **Indexes** to optimize query performance.

---

## Security

### Secure Storage

- Utilize `flutter_secure_storage` for credentials and tokens.
- Never store passwords or sensitive data in plain text.
- Use strong **Hashing** algorithms (SHA-256 or better) for sensitive comparisons.

---

## Testing

### Testing Types

- **Unit Tests**: For isolated functions and classes.
- **Widget Tests**: For UI components and basic interaction.
- **Integration Tests**: For end-to-end user flows and service orchestration.

### General Rules

- Target Coverage: **70%+**.
- Utilize **Mocks** (via Mocktail or similar) for dependency isolation.
- Target execution time: Fast suite (**< 30 seconds** for core tests).

---

## Performance

### Optimizations

- Prefer `const` constructors whenever applicable.
- Design widgets to minimize unnecessary rebuilds (use `select` or scoped providers).
- Utilize `ListView.builder` for efficient list rendering.
- Implement **Lazy Loading** for remote and local heavy assets (e.g., images).

---

## RTL (Right-to-Left) Support

### Guidelines

- Use `Directionality` for explicit mirror testing.
- Verify UI in both LTR (English) and RTL (Arabic) orientations.
- Utilize high-quality Arabic typography (e.g., Inter/Roboto with proper Arabic variants).
- Prefer logical alignment: `TextAlign.start` instead of `left`.

---

**For the full development guide, refer to:** `.kiro/steering/guides/flutter-guide.md`
