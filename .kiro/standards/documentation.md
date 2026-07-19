# Documentation Standards

**Project:** Basir MVP  
**Status:** ✅ Active

---

## Unified Identity

**Always use:**

```
Basir Project Agentic Development Team
```

**Refer to:** `.kiro/steering/core/team-identity.md`

---

## DartDoc

### Mandatory Requirements

- Document all public APIs (classes, methods, variables).
- Explain parameters and return values using brackets `[parameter]`.
- Include practical usage examples.

### Format Example

````dart
/// Adds a new customer to the database.
///
/// [customer] The customer entity to be added.
///
/// Throws [ValidationException] if the customer data violates business rules.
///
/// Example:
/// ```dart
/// await repository.addCustomer(customer);
/// ```
Future<void> addCustomer(Customer customer);
````

---

## Comments

### TODO Comments

Standardized format for tracking pending work:

```dart
// TODO(developer): Add phone number validation logic.
```

### Internal Implementation Comments

- Use `//` for short, single-line comments.
- Use `/* */` for multi-line block comments.
- Focus on explaining the **"Why"** (intent/rationale) rather than the "What" (the code itself).

---

## Documentation Structure

### Standard Markdown Template

```markdown
# [Title]

**Project:** Basir MVP  
**Date:** [Date]  
**Author:** Basir Project Agentic Development Team  
**Status:** [Status]

## Content

[...]

---

**Prepared by:** Basir Project Agentic Development Team
```

---

## Language Policy

### Unified Language

- **English**: Mandatory for all technical documentation, source code comments, and internal communication.
- **Arabic**: Exclusively for end-user facing content (localizations via `.arb` files).
- **Formal Tone**: Avoid slang and maintain high technical standards.

---

**For more details, refer to:** `.kiro/steering/reference/documentation-examples.md`
