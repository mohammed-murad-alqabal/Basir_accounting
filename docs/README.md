# Basir Accounting System Documentation

## Quick Navigation

| Category | Description | Path |
|----------|-------------|------|
| **Steering** | Product vision, tech stack, philosophy | [guides/steering/](./guides/steering/) |
| **Standards** | Coding standards, naming, architecture | [standards/](./standards/) |
| **Specs** | Active and completed specifications | [specs/](./specs/) |
| **Templates** | Code and document templates | [templates/](./templates/) |

---

## Steering Documents (The Core Truth)

These documents define the project identity and must be followed:

| Document | Purpose |
|----------|---------|
| [product.md](./guides/steering/product.md) | Product vision and team identity |
| [tech.md](./guides/steering/tech.md) | Technology stack and coding standards |
| [philosophy.md](./guides/steering/philosophy.md) | PPP: Purity, Precision, Professionalism |
| [roadmap.md](./guides/steering/roadmap.md) | Strategic roadmap 2025-2030 |
| [AGENTS.md](./guides/steering/AGENTS.md) | Agent directives and persona |

---

## Standards (Mandatory Compliance)

All code must adhere to these standards:

| Standard | Enforcement |
|----------|-------------|
| [flutter.md](./standards/flutter.md) | Flutter/Dart best practices |
| [engineering.md](./standards/engineering.md) | Clean Architecture rules |
| [accounting.md](./standards/accounting.md) | IFRS/ZATCA compliance |
| [naming.md](./standards/naming.md) | Naming conventions |
| [code-quality.md](./standards/code-quality.md) | Quality gates |

---

## Git Hooks (Automated Quality)

The `.githooks/` directory contains automated checks:

```bash
# Activate git hooks
git config core.hooksPath .githooks

# Hooks run automatically:
# - pre-commit: Format, analyze, security check
# - pre-push: Run tests
# - commit-msg: Validate message format
```

---

## Team Identity

> **Author/Developer:** Basir Accounting System Development Agents Team

**Forbidden Terms:**
- Kiro AI Agent
- AI Assistant
- Generic AI terms
- "MVP" references (use "accounting system")

---

## Compliance Checklist

Before any commit, ensure:

- [ ] `flutter analyze` passes with 0 errors
- [ ] Code follows naming conventions in `standards/naming.md`
- [ ] Architecture follows `guides/steering/architecture-mapping.md`
- [ ] No hardcoded secrets (security check runs in pre-commit)
- [ ] Commit message follows Conventional Commits format
