# Git Policies - بصير MVP

## Branch Policy

### Main Branches

| Branch    | Purpose               | Protection             |
| --------- | --------------------- | ---------------------- |
| `main`    | Production-ready code | Protected, requires PR |
| `develop` | Integration branch    | Protected              |

### Feature Branches

- **Naming**: `feature/<name>` or `feat/<name>`
- **Lifespan**: Delete after merge
- **Base**: From `develop` or `main`

### Fix Branches

- **Naming**: `fix/<issue>` or `hotfix/<issue>`
- **Lifespan**: Delete after merge

### Release Branches

- **Naming**: `release/v<version>`
- **Purpose**: Prepare releases

---

## Tag Policy

### Semantic Versioning

- **Format**: `v<major>.<minor>.<patch>`
- **Example**: `v2.5.0`, `v2.5.1`

### Backup Tags

- **Format**: `backup-<purpose>-<date>`
- **Lifespan**: Archive after 30 days
- **Storage**: Export as patches before deletion

---

## File Size Limits

| Type             | Max Size         | Action if Exceeded   |
| ---------------- | ---------------- | -------------------- |
| Source files     | 100KB            | Review/refactor      |
| Assets           | 5MB              | Optimize/compress    |
| Bundles/Archives | **NEVER COMMIT** | Use external storage |

---

## Stash Policy

- **Purpose**: Temporary work-in-progress only
- **Lifespan**: Max 7 days
- **Alternative**: Use feature branches

---

## Code Review

1. All PRs require at least 1 approval
2. CI must pass before merge
3. No direct pushes to `main`

---

## Backup Procedures

### Before Major Changes

```bash
# Create bundle backup
git bundle create backup-$(date +%Y%m%d).bundle --all

# Export tags as patches
git format-patch -1 <tag> -o patches/
```

### Storage

- Store externally (NOT in git history)
- Keep checksums for verification

---

**Last Updated**: 2025-12-29
