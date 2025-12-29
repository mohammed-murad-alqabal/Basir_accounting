# Baseer MVP - Project Structure

## 📂 Root Directory

- `lib/`: Application source code (Feature-first).
- `test/`: Unit, Widget, and Integration tests.
- `docs/`: Public and developer documentation (includes `guides/kiro_reference`).
- `scripts/`: Automation and utility scripts.
- `tools/`: External tools, data, libraries, and `kiro_optimizers`.
- `logs/`: Application and system logs (Archived in `logs/archive`).

## 🧠 .kiro Directory (AI Context)

The `.kiro` directory manages AI steering and context:

- `steering/`: **Core Truth**. Contains `product.md`, `tech.md`, `AGENTS.md`, `roadmap.md`.
- `hooks/`: Critical automated triggers (on-save, on-commit).
- `specs/`: Active and completed work specifications.
- `templates/`: Code and document templates.
- `config.json`: Agent configuration.

## 🚫 Deprecated / Archive

- `dev_support/` (or moved folders): Contains old logs/reports to keep context clean.
