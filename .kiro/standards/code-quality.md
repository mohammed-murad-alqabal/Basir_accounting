# Code Quality Standards

**Project:** Basir MVP  
**Status:** ✅ Active

---

## Base Standards

| Standard        | Value | Mandatory |
| :-------------- | :---: | :-------: |
| Test Coverage   | 70%+  |    ✅     |
| Max Line Length |  80   |    ✅     |
| Max Complexity  |  10   |    ✅     |
| DRY Principle   |   -   |    ✅     |

---

## SOLID Principles

### 1. Single Responsibility (SRP)

Every class must have only one responsibility.

### 2. Open/Closed (OCP)

Open for extension, closed for modification.

### 3. Liskov Substitution (LSP)

Subtypes must be substitutable for their base types.

### 4. Interface Segregation (ISP)

Do not force dependencies on unused interfaces.

### 5. Dependency Inversion (DIP)

Depend on abstractions, not concretions.

---

## Clean Code

### Meaningful Names

- Clear names that reflect purpose.
- Avoid ambiguous abbreviations.
- Use pronounceable names.

### Small Functions

- One function = one responsibility.
- Maximum length: 20-30 lines.
- Single level of abstraction.

### DRY (Don't Repeat Yourself)

- Avoid code duplication.
- Use functions for repetitive logic.
- Use constants for shared values.

---

## Error Handling

### Use of Exceptions

- Utilize custom exceptions.
- Handle errors at the appropriate level.
- Do not swallow exceptions (no empty catch blocks).

### Async Operations

- Always use try-catch blocks.
- Handle all potential states (loading, error, data).
- Log errors appropriately.

---

## Performance

### Const Constructors

- Use `const` wherever possible.
- Minimize unnecessary widget rebuilds.

### Lazy Loading

- Load data only when required.
- Implement pagination for large datasets.

---

**For full details and examples, refer to:** `.kiro/steering/reference/quality-examples.md`
