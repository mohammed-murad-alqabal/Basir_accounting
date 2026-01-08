# استراتيجية الفروع - مشروع بصير

## النموذج المعتمد: Simplified GitFlow

```
main ─────●─────────●─────────●───────→ (إنتاج مستقر)
           ↑         ↑         ↑
develop ──●──●──●──●──●──●──●──●──●───→ (تطوير متكامل)
          ↑  ↑     ↑     ↑     ↑
          │  feature/   fix/   release/
          │  accounting sales   v1.1.0
          │
          hotfix/emergency
```

## هيكل الفروع

| الفرع       | الغرض       | يُدمج إلى        | محمي |
| ----------- | ----------- | ---------------- | ---- |
| `main`      | الإنتاج     | -                | ✅   |
| `develop`   | التطوير     | `main`           | ✅   |
| `feature/*` | ميزات       | `develop`        | ❌   |
| `fix/*`     | إصلاحات     | `develop`        | ❌   |
| `hotfix/*`  | طوارئ       | `main`+`develop` | ❌   |
| `release/*` | إعداد إصدار | `main`+`develop` | ❌   |

## قواعد التسمية

```
<type>/<ticket>-<description>

أمثلة:
  feature/ACC-101-accounts-payable
  fix/INV-205-tax-calc
  hotfix/PROD-001-crash
  release/v1.2.0
```

## سير العمل السريع

```bash
# 1. تحديث develop
git checkout develop && git pull origin develop

# 2. إنشاء فرع عمل
git checkout -b feature/ACC-101-new-feature

# 3. العمل والالتزام
git commit -m "feat(AP): add payment screen"

# 4. رفع وفتح PR
git push -u origin feature/ACC-101-new-feature
# ثم افتح PR على GitHub

# 5. بعد الدمج، احذف الفرع محلياً
git checkout develop && git pull
git branch -d feature/ACC-101-new-feature
```

## قواعد الحماية

### main

- ✅ Require PR with 2 approvals
- ✅ Require status checks (CI)
- ✅ No direct push
- ✅ No force push

### develop

- ✅ Require PR with 1 approval
- ✅ Require status checks (CI)
- ✅ No force push

---

**آخر تحديث:** 2026-01-08  
**الإصدار:** 1.0
