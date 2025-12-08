# Example 5: Commit Message Generation (commit)

**Scenario:** Product Review System  
**Prompt Used:** `commit.prompt.md` v2.0  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team

---

## 🎯 Scenario Context

**Previous Steps:**

1. Requirements completed
2. Design completed
3. Tasks breakdown completed
4. TASK-001 executed (Database Schema)

**Current Step:** Create commit message for TASK-001

**Goal:** Generate professional, informative commit message

---

## 📋 Agent Workflow (commit.prompt.md v2.0)

### Phase 1: Smart Change Analysis ⭐ MANDATORY

**Agent analyzes git changes:**

```bash
git status
git diff --cached
```

**Output:**

```
On branch feature/product-reviews
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   lib/features/reviews/data/models/review_model.dart
        new file:   test/unit/review_model_test.dart
```

**Agent categorizes changes:**

```
📊 Change Analysis

Source Code Changes:
✅ lib/features/reviews/data/models/review_model.dart (NEW)
   - ReviewModel class with @collection
   - Fields: id, productId, customerId, rating, text, createdAt, updatedAt
   - Indexes: productId, customerId, rating
   - Composite index for uniqueness
   - 85 lines

Test Changes:
✅ test/unit/review_model_test.dart (NEW)
   - 4 test cases
   - Tests model creation
   - Tests index queries
   - Tests uniqueness constraint
   - 120 lines

Configuration Changes:
❌ None

Documentation Changes:
❌ None

Artifacts to Filter:
❌ None (no generated files, build outputs, or IDE configs)
```

---

### Phase 2: Automatic Artifact Filtering ⭐

**Agent filters out:**

```
🔍 Artifact Filtering

Checking for common artifacts:
❌ *.g.dart files - None found
❌ *.freezed.dart files - None found
❌ build/ directory - Not in commit
❌ .dart_tool/ - Not in commit
❌ *.iml files - Not in commit
❌ .idea/ - Not in commit

✅ All changes are meaningful source code
✅ No artifacts to filter
```

---

### Phase 3: Commit Type Determination

**Agent determines:**

```
📝 Commit Type Analysis

Change Type: NEW FEATURE
Scope: reviews (data layer)
Breaking Change: No

Reasoning:
- New functionality added (review model)
- Part of reviews feature
- No existing code modified
- No breaking changes

Conventional Commit Type: feat
```

---

### Phase 4: Message Generation

**Agent generates:**

```markdown
# Commit Message (Draft)

feat(reviews): add review model with Isar schema

Implement ReviewModel Isar collection for storing product reviews locally.

Features:

- Auto-incrementing ID
- Indexed fields (productId, customerId, rating)
- Composite index for uniqueness (one review per customer per product)
- Timestamps (createdAt, updatedAt)

Technical Details:

- Uses Isar ORM for local storage
- Enforces data integrity via composite index
- Supports fast queries by product, customer, and rating

Testing:

- Unit tests for model creation
- Index query tests
- Uniqueness constraint tests
- 4/4 tests passing

Related:

- Task: TASK-001
- Requirements: FR-1, FR-2, FR-3, NFR-7, NFR-8
- Design: Database Schema section

Files:

- lib/features/reviews/data/models/review_model.dart (NEW)
- test/unit/review_model_test.dart (NEW)
```

---

### Phase 5: Final Checklist ⭐ MANDATORY

**Agent verifies:**

```
✅ Final Commit Checklist

Format:
✅ Follows Conventional Commits format
✅ Type is correct (feat)
✅ Scope is clear (reviews)
✅ Description is concise and clear
✅ Body provides context
✅ No breaking changes marker needed

Content:
✅ Explains WHAT was done
✅ Explains WHY it was done
✅ Includes technical details
✅ Lists test results
✅ References task/requirements
✅ Lists affected files

Quality:
✅ No artifacts included
✅ All changes are meaningful
✅ Message is professional
✅ Grammar is correct
✅ Length is appropriate (< 500 lines)

Standards:
✅ Follows philosophy.md (KISS, Quality First)
✅ Follows git-guide.md conventions
✅ English for commit message
✅ Clear and maintainable
```

---

## 📄 Final Commit Message

```
feat(reviews): add review model with Isar schema

Implement ReviewModel Isar collection for storing product reviews locally.

Features:
- Auto-incrementing ID
- Indexed fields (productId, customerId, rating)
- Composite index for uniqueness (one review per customer per product)
- Timestamps (createdAt, updatedAt)

Technical Details:
- Uses Isar ORM for local storage
- Enforces data integrity via composite index
- Supports fast queries by product, customer, and rating

Testing:
- Unit tests for model creation
- Index query tests
- Uniqueness constraint tests
- 4/4 tests passing

Related:
- Task: TASK-001
- Requirements: FR-1, FR-2, FR-3, NFR-7, NFR-8
- Design: Database Schema section

Files:
- lib/features/reviews/data/models/review_model.dart (NEW)
- test/unit/review_model_test.dart (NEW)
```

---

## 🚀 Commit Execution

```bash
git add lib/features/reviews/data/models/review_model.dart
git add test/unit/review_model_test.dart
git commit -m "feat(reviews): add review model with Isar schema

Implement ReviewModel Isar collection for storing product reviews locally.

Features:
- Auto-incrementing ID
- Indexed fields (productId, customerId, rating)
- Composite index for uniqueness (one review per customer per product)
- Timestamps (createdAt, updatedAt)

Technical Details:
- Uses Isar ORM for local storage
- Enforces data integrity via composite index
- Supports fast queries by product, customer, and rating

Testing:
- Unit tests for model creation
- Index query tests
- Uniqueness constraint tests
- 4/4 tests passing

Related:
- Task: TASK-001
- Requirements: FR-1, FR-2, FR-3, NFR-7, NFR-8
- Design: Database Schema section

Files:
- lib/features/reviews/data/models/review_model.dart (NEW)
- test/unit/review_model_test.dart (NEW)"
```

**Output:**

```
[feature/product-reviews 3a7f9c2] feat(reviews): add review model with Isar schema
 2 files changed, 205 insertions(+)
 create mode 100644 lib/features/reviews/data/models/review_model.dart
 create mode 100644 test/unit/review_model_test.dart
```

---

## 📊 Commit Analysis

### Message Structure

| Section   | Content                     | Lines  |
| :-------- | :-------------------------- | :----- |
| Header    | Type, scope, description    | 1      |
| Body      | Features, technical details | 8      |
| Testing   | Test results                | 4      |
| Related   | Task, requirements, design  | 3      |
| Files     | Changed files               | 2      |
| **Total** |                             | **18** |

### Quality Metrics

| Metric               | Target | Actual | Status |
| :------------------- | :----- | :----- | :----- |
| Conventional Commits | Yes    | Yes    | ✅     |
| Clear description    | Yes    | Yes    | ✅     |
| Context provided     | Yes    | Yes    | ✅     |
| Tests mentioned      | Yes    | Yes    | ✅     |
| Traceability         | Yes    | Yes    | ✅     |
| No artifacts         | Yes    | Yes    | ✅     |

---

## 🔍 Comparison: Before vs After

### Before (Without commit.prompt.md v2.0)

```
git commit -m "add review model"
```

**Problems:**

- ❌ No conventional commits format
- ❌ No context
- ❌ No technical details
- ❌ No test information
- ❌ No traceability
- ❌ Unclear what was done

### After (With commit.prompt.md v2.0)

```
feat(reviews): add review model with Isar schema

[Full message as shown above]
```

**Benefits:**

- ✅ Conventional commits format
- ✅ Clear context
- ✅ Technical details included
- ✅ Test results shown
- ✅ Full traceability
- ✅ Professional and informative

---

## 💡 Key Takeaways

### What Worked Well

1. ✅ **Smart analysis** identified all meaningful changes
2. ✅ **Artifact filtering** prevented noise
3. ✅ **Conventional commits** ensured consistency
4. ✅ **Context** made message informative
5. ✅ **Traceability** linked to requirements

### Best Practices Applied

1. ✅ Analyze changes before writing
2. ✅ Filter out artifacts automatically
3. ✅ Use conventional commits format
4. ✅ Provide context and technical details
5. ✅ Include test results
6. ✅ Link to task and requirements
7. ✅ List affected files
8. ✅ Verify with final checklist

### Lessons Learned

1. 💡 Smart analysis saves time
2. 💡 Artifact filtering prevents mistakes
3. 💡 Context makes commits valuable
4. 💡 Traceability helps future developers
5. 💡 Professional messages build trust

---

## 📚 Additional Examples

### Example: Bug Fix Commit

```
fix(reviews): resolve duplicate review detection

Fix issue where composite index wasn't preventing duplicate reviews.

Problem:
- Customers could submit multiple reviews for same product
- Composite index wasn't being checked properly

Solution:
- Add explicit duplicate check in repository
- Query by composite key before insert
- Throw DuplicateReviewException if exists

Testing:
- Added test for duplicate detection
- All tests passing (5/5)

Related:
- Bug: BUG-042
- Requirement: BR-1 (One review per product)

Files:
- lib/features/reviews/data/repositories/review_repository_impl.dart (MODIFIED)
- test/unit/review_repository_test.dart (MODIFIED)
```

### Example: Refactor Commit

```
refactor(reviews): extract validation to separate class

Extract review validation logic from repository to dedicated validator class.

Changes:
- Create ReviewValidator class
- Move validation methods from repository
- Update repository to use validator
- Improve error messages

Benefits:
- Single Responsibility Principle
- Reusable validation logic
- Easier to test
- Cleaner repository code

Testing:
- All existing tests passing
- New validator tests added (95% coverage)

Related:
- Task: TASK-007
- Design: Validators section

Files:
- lib/features/reviews/domain/validators/review_validator.dart (NEW)
- lib/features/reviews/data/repositories/review_repository_impl.dart (MODIFIED)
- test/unit/review_validator_test.dart (NEW)
```

---

## 🎯 Git History Quality

**With commit.prompt.md v2.0:**

```
git log --oneline

3a7f9c2 feat(reviews): add review model with Isar schema
2b8e1d3 feat(reviews): implement review repository
1c9f0a4 feat(reviews): add review validators
0d8a2b5 feat(reviews): create review submission screen
```

**Benefits:**

- ✅ Clear feature progression
- ✅ Easy to understand history
- ✅ Professional appearance
- ✅ Searchable by type/scope
- ✅ Valuable for code review

---

**Prepared by:** Basser Project Development Agents Team  
**Date:** December 8, 2025  
**Example:** 5 of 6
