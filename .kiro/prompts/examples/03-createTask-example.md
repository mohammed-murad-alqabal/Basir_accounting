# Example 3: Task Breakdown (createTask)

**Scenario:** Product Review System  
**Prompt Used:** `createTask.prompt.md` v2.0  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team

---

## 🎯 Scenario Context

**Previous Steps:**

1. Requirements completed (see `01-createSpec-example.md`)
2. Design completed (see `02-design-example.md`)

**Input:**

- `specs/product-reviews/requirements.md`
- `specs/product-reviews/design.md`

**Goal:** Break down design into actionable, hierarchical tasks

---

## 📋 Agent Workflow

### Step 1: Context Gathering ⭐ MANDATORY

**Agent reads:**

```bash
# Requirements and Design
specs/product-reviews/requirements.md
specs/product-reviews/design.md

# Core philosophy
.kiro/steering/core/philosophy.md

# Standards
.kiro/steering/standards/naming.md
.kiro/steering/standards/code-quality.md
.kiro/steering/standards/testing.md
```

### Step 2: Task Analysis

**Agent analyzes:**

- Architecture layers (Data, Domain, Presentation)
- Dependencies between components
- Logical implementation order
- Testing requirements

### Step 3: Task Generation

**Agent creates:** `specs/product-reviews/tasks.md`

**Key Features:**

- ✅ Hierarchical structure (Parent → Child tasks)
- ✅ Clear dependencies
- ✅ Logical ordering
- ✅ Traceability to requirements
- ✅ No approval gate (direct execution)

---

## 📄 Generated Tasks Document

```markdown
# Product Review System - Implementation Tasks

**Project:** Basser MVP  
**Feature:** Product Review System  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team  
**Status:** Ready for Implementation  
**Version:** 1.0

---

## Task Hierarchy
```

Product Review System
├── 1. Data Layer
│ ├── 1.1 Database Schema
│ ├── 1.2 Models
│ └── 1.3 Repository Implementation
├── 2. Domain Layer
│ ├── 2.1 Entities
│ ├── 2.2 Repository Interface
│ └── 2.3 Validators
├── 3. Presentation Layer
│ ├── 3.1 State Management
│ ├── 3.2 UI Components
│ └── 3.3 Screens
└── 4. Testing
├── 4.1 Unit Tests
├── 4.2 Widget Tests
└── 4.3 Integration Tests

````

---

## 1. Data Layer

### 1.1 Database Schema

**Task ID:** TASK-001
**Parent:** None
**Priority:** High
**Estimated Time:** 30 minutes
**Dependencies:** None

**Requirements Traceability:**
- FR-1, FR-2, FR-3 (Review submission)
- NFR-7, NFR-8 (Data integrity)

**Description:**
Create Isar collection for reviews with proper indexes.

**Acceptance Criteria:**
- [ ] ReviewModel class created with @collection annotation
- [ ] All fields defined (id, productId, customerId, rating, text, createdAt, updatedAt)
- [ ] Indexes created for productId, customerId, rating
- [ ] Composite index for uniqueness (productId + customerId)
- [ ] Schema generated successfully

**Implementation Details:**
```dart
// File: lib/features/reviews/data/models/review_model.dart

@collection
class ReviewModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String productId;

  @Index()
  late String customerId;

  @Index()
  late int rating;

  late String text;
  late DateTime createdAt;
  DateTime? updatedAt;

  @Index(composite: [CompositeIndex('productId'), CompositeIndex('customerId')])
  String get uniqueKey => '$productId-$customerId';
}
````

**Testing:**

- Unit test for model creation
- Test index queries

---

### 1.2 Models

**Task ID:** TASK-002  
**Parent:** TASK-001  
**Priority:** High  
**Estimated Time:** 45 minutes  
**Dependencies:** TASK-001

**Requirements Traceability:**

- All functional requirements

**Description:**
Implement ReviewModel with conversion methods.

**Acceptance Criteria:**

- [ ] toEntity() method implemented
- [ ] fromEntity() method implemented
- [ ] toJson() method implemented
- [ ] fromJson() method implemented
- [ ] All conversions tested

**Implementation Details:**

```dart
extension ReviewModelExtensions on ReviewModel {
  Review toEntity() {
    return Review(
      id: id.toString(),
      productId: productId,
      customerId: customerId,
      customerName: '', // Will be populated from customer data
      rating: rating,
      text: text,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static ReviewModel fromEntity(Review review) {
    return ReviewModel()
      ..id = int.tryParse(review.id) ?? Isar.autoIncrement
      ..productId = review.productId
      ..customerId = review.customerId
      ..rating = review.rating
      ..text = review.text
      ..createdAt = review.createdAt
      ..updatedAt = review.updatedAt;
  }
}
```

**Testing:**

- Test toEntity conversion
- Test fromEntity conversion
- Test round-trip conversion

---

### 1.3 Repository Implementation

**Task ID:** TASK-003  
**Parent:** TASK-002  
**Priority:** High  
**Estimated Time:** 2 hours  
**Dependencies:** TASK-002, TASK-006 (Repository Interface)

**Requirements Traceability:**

- FR-3 (Review submission)
- FR-4 (Reviews list)
- FR-7 (Edit review)
- FR-8 (Delete review)
- NFR-5, NFR-6 (Security)

**Description:**
Implement ReviewRepository with all CRUD operations and security checks.

**Acceptance Criteria:**

- [ ] All repository methods implemented
- [ ] Duplicate check implemented
- [ ] Authorization checks implemented
- [ ] Error handling implemented
- [ ] Transactions used for writes
- [ ] All methods tested

**Implementation Details:**

```dart
// File: lib/features/reviews/data/repositories/review_repository_impl.dart

class ReviewRepositoryImpl implements ReviewRepository {
  final Isar isar;
  final AuthService authService;

  ReviewRepositoryImpl(this.isar, this.authService);

  @override
  Future<List<Review>> getReviewsByProduct(String productId) async {
    try {
      final models = await isar.reviewModels
          .filter()
          .productIdEqualTo(productId)
          .sortByCreatedAtDesc()
          .findAll();

      return models.map((m) => m.toEntity()).toList();
    } catch (e, stackTrace) {
      debugPrint('Error getting reviews: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> addReview(Review review) async {
    // Check authentication
    final currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      throw UnauthorizedException('يجب تسجيل الدخول');
    }

    // Verify customer ID
    if (review.customerId != currentUser.id) {
      throw UnauthorizedException('غير مصرح');
    }

    // Check duplicate
    final existing = await getCustomerReview(
      review.productId,
      review.customerId,
    );
    if (existing != null) {
      throw DuplicateReviewException('لقد قمت بتقييم هذا المنتج مسبقاً');
    }

    // Save
    await isar.writeTxn(() async {
      await isar.reviewModels.put(ReviewModel.fromEntity(review));
    });
  }

  // ... other methods
}
```

**Testing:**

- Test all CRUD operations
- Test duplicate detection
- Test authorization checks
- Test error handling

---

## 2. Domain Layer

### 2.1 Entities

**Task ID:** TASK-004  
**Parent:** None  
**Priority:** High  
**Estimated Time:** 30 minutes  
**Dependencies:** None

**Requirements Traceability:**

- All functional requirements

**Description:**
Create Review entity with business logic.

**Acceptance Criteria:**

- [ ] Review class created
- [ ] All fields defined
- [ ] copyWith method implemented
- [ ] isEdited getter implemented
- [ ] getRelativeTime method implemented
- [ ] All methods tested

**Implementation Details:**

```dart
// File: lib/features/reviews/domain/entities/review.dart

class Review {
  final String id;
  final String productId;
  final String customerId;
  final String customerName;
  final int rating;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Review({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.customerName,
    required this.rating,
    required this.text,
    required this.createdAt,
    this.updatedAt,
  });

  Review copyWith({
    String? id,
    String? productId,
    String? customerId,
    String? customerName,
    int? rating,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Review(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      rating: rating ?? this.rating,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isEdited => updatedAt != null;

  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else {
      return 'منذ دقائق';
    }
  }
}
```

**Testing:**

- Test copyWith
- Test isEdited
- Test getRelativeTime

---

### 2.2 Repository Interface

**Task ID:** TASK-006  
**Parent:** None  
**Priority:** High  
**Estimated Time:** 20 minutes  
**Dependencies:** TASK-004

**Requirements Traceability:**

- All functional requirements

**Description:**
Define ReviewRepository interface.

**Acceptance Criteria:**

- [ ] All methods defined
- [ ] Documentation complete
- [ ] Return types specified
- [ ] Exceptions documented

**Implementation Details:**

```dart
// File: lib/features/reviews/domain/repositories/review_repository.dart

abstract class ReviewRepository {
  /// Gets all reviews for a product
  Future<List<Review>> getReviewsByProduct(String productId);

  /// Gets a customer's review for a product
  Future<Review?> getCustomerReview(String productId, String customerId);

  /// Adds a new review
  /// Throws [DuplicateReviewException] if review already exists
  /// Throws [UnauthorizedException] if not authenticated
  Future<void> addReview(Review review);

  /// Updates an existing review
  /// Throws [UnauthorizedException] if not owner
  Future<void> updateReview(Review review);

  /// Deletes a review
  /// Throws [UnauthorizedException] if not owner
  Future<void> deleteReview(String reviewId);

  /// Gets average rating for a product
  Future<double> getAverageRating(String productId);

  /// Gets total review count
  Future<int> getReviewCount(String productId);
}
```

---

### 2.3 Validators

**Task ID:** TASK-007  
**Parent:** None  
**Priority:** High  
**Estimated Time:** 45 minutes  
**Dependencies:** None

**Requirements Traceability:**

- FR-1, FR-2 (Input validation)
- BR-4, BR-5 (Validation rules)

**Description:**
Implement ReviewValidator with all validation rules.

**Acceptance Criteria:**

- [ ] validateRating implemented
- [ ] validateText implemented
- [ ] validateReview implemented
- [ ] All edge cases tested
- [ ] Error messages in Arabic

**Implementation Details:**

```dart
// File: lib/features/reviews/domain/validators/review_validator.dart

class ReviewValidator {
  static String? validateRating(int? rating) {
    if (rating == null) {
      return 'يرجى اختيار التقييم';
    }
    if (rating < 1 || rating > 5) {
      return 'التقييم يجب أن يكون بين 1 و 5';
    }
    return null;
  }

  static String? validateText(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'يرجى كتابة تقييمك';
    }

    final trimmed = text.trim();

    if (trimmed.length < 10) {
      return 'التقييم يجب أن يحتوي على 10 أحرف على الأقل';
    }

    if (trimmed.length > 500) {
      return 'التقييم طويل جداً (الحد الأقصى 500 حرف)';
    }

    return null;
  }

  static Map<String, String> validateReview({
    required int? rating,
    required String? text,
  }) {
    final errors = <String, String>{};

    final ratingError = validateRating(rating);
    if (ratingError != null) {
      errors['rating'] = ratingError;
    }

    final textError = validateText(text);
    if (textError != null) {
      errors['text'] = textError;
    }

    return errors;
  }
}
```

**Testing:**

- Test all validation rules
- Test edge cases
- Test error messages

---

## 3. Presentation Layer

### 3.1 State Management

**Task ID:** TASK-008  
**Parent:** None  
**Priority:** High  
**Estimated Time:** 1.5 hours  
**Dependencies:** TASK-003, TASK-006

**Requirements Traceability:**

- All functional requirements

**Description:**
Implement ReviewsNotifier with Riverpod.

**Acceptance Criteria:**

- [ ] ReviewsNotifier implemented
- [ ] submitReview method implemented
- [ ] updateReview method implemented
- [ ] deleteReview method implemented
- [ ] filterByRating method implemented
- [ ] Error handling implemented
- [ ] All methods tested

**Implementation Details:**

```dart
// File: lib/features/reviews/presentation/providers/reviews_provider.dart

@riverpod
class ReviewsNotifier extends _$ReviewsNotifier {
  @override
  Future<List<Review>> build(String productId) async {
    final repository = ref.watch(reviewRepositoryProvider);
    return repository.getReviewsByProduct(productId);
  }

  Future<void> submitReview(Review review) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reviewRepositoryProvider);
      await repository.addReview(review);
      return repository.getReviewsByProduct(review.productId);
    });
  }

  // ... other methods
}
```

**Testing:**

- Test all state transitions
- Test error handling
- Test filtering

---

### 3.2 UI Components

**Task ID:** TASK-009  
**Parent:** None  
**Priority:** Medium  
**Estimated Time:** 2 hours  
**Dependencies:** TASK-004, TASK-007

**Description:**
Create reusable UI components.

**Sub-tasks:**

#### 3.2.1 StarRating Widget

**Acceptance Criteria:**

- [ ] Interactive and read-only modes
- [ ] Proper sizing
- [ ] Accessibility support
- [ ] RTL support

#### 3.2.2 ReviewCard Widget

**Acceptance Criteria:**

- [ ] Displays all review info
- [ ] Edit/Delete buttons for own reviews
- [ ] Proper Arabic layout
- [ ] Relative time display

#### 3.2.3 ReviewFilter Widget

**Acceptance Criteria:**

- [ ] Multiple selection
- [ ] Clear filter option
- [ ] Visual feedback

**Testing:**

- Widget tests for all components
- Test interactions
- Test RTL layout

---

### 3.3 Screens

**Task ID:** TASK-010  
**Parent:** TASK-009  
**Priority:** Medium  
**Estimated Time:** 3 hours  
**Dependencies:** TASK-008, TASK-009

**Description:**
Implement review screens.

**Sub-tasks:**

#### 3.3.1 ReviewSubmissionScreen

**Acceptance Criteria:**

- [ ] Star rating input
- [ ] Text input with counter
- [ ] Validation
- [ ] Submit/Cancel buttons
- [ ] Loading states
- [ ] Error display

#### 3.3.2 ReviewsListScreen

**Acceptance Criteria:**

- [ ] Reviews list
- [ ] Average rating display
- [ ] Filter functionality
- [ ] Empty state
- [ ] Loading state
- [ ] Error state

**Testing:**

- Widget tests for all screens
- Test user flows
- Test error states

---

## 4. Testing

### 4.1 Unit Tests

**Task ID:** TASK-011  
**Parent:** None  
**Priority:** High  
**Estimated Time:** 2 hours  
**Dependencies:** All implementation tasks

**Requirements Traceability:**

- NFR (Testing requirements)

**Description:**
Write comprehensive unit tests.

**Acceptance Criteria:**

- [ ] Repository tests (70%+ coverage)
- [ ] Validator tests (95%+ coverage)
- [ ] Entity tests (90%+ coverage)
- [ ] Provider tests (70%+ coverage)
- [ ] All tests passing

**Test Files:**

```
test/unit/
├── review_repository_test.dart
├── review_validator_test.dart
├── review_entity_test.dart
└── reviews_provider_test.dart
```

---

### 4.2 Widget Tests

**Task ID:** TASK-012  
**Parent:** None  
**Priority:** Medium  
**Estimated Time:** 2 hours  
**Dependencies:** TASK-009, TASK-010

**Description:**
Write widget tests for all components.

**Acceptance Criteria:**

- [ ] StarRating tests
- [ ] ReviewCard tests
- [ ] ReviewFilter tests
- [ ] Screen tests
- [ ] All tests passing

---

### 4.3 Integration Tests

**Task ID:** TASK-013  
**Parent:** None  
**Priority:** Medium  
**Estimated Time:** 1.5 hours  
**Dependencies:** All tasks

**Description:**
Write integration tests for complete flows.

**Acceptance Criteria:**

- [ ] Submit review flow
- [ ] Edit review flow
- [ ] Delete review flow
- [ ] Filter reviews flow
- [ ] All tests passing

---

## Task Summary

### Statistics

| Category     | Tasks  | Estimated Time |
| :----------- | :----- | :------------- |
| Data Layer   | 3      | 3.25 hours     |
| Domain Layer | 3      | 1.75 hours     |
| Presentation | 3      | 6.5 hours      |
| Testing      | 3      | 5.5 hours      |
| **Total**    | **12** | **17 hours**   |

### Priority Breakdown

- **High Priority:** 8 tasks
- **Medium Priority:** 4 tasks

### Dependencies Graph

```
TASK-001 (Schema)
    ↓
TASK-002 (Models)
    ↓
TASK-003 (Repository Impl) ← TASK-006 (Repository Interface) ← TASK-004 (Entity)
    ↓
TASK-008 (State Management)
    ↓
TASK-009 (UI Components) ← TASK-007 (Validators)
    ↓
TASK-010 (Screens)
    ↓
TASK-011, TASK-012, TASK-013 (Testing)
```

---

## Execution Order

**Recommended sequence:**

1. TASK-001: Database Schema
2. TASK-004: Entities
3. TASK-007: Validators
4. TASK-002: Models
5. TASK-006: Repository Interface
6. TASK-003: Repository Implementation
7. TASK-008: State Management
8. TASK-009: UI Components
9. TASK-010: Screens
10. TASK-011: Unit Tests
11. TASK-012: Widget Tests
12. TASK-013: Integration Tests

---

## Notes

### Development Guidelines

- Follow KISS principle
- Write tests alongside implementation
- Use const constructors
- Support RTL layout
- Handle all error cases

### Quality Gates

- [ ] All tests passing
- [ ] 70%+ coverage
- [ ] 0 flutter analyze errors
- [ ] Code formatted
- [ ] DartDoc complete

---

**Prepared by:** Basser Project Development Agents Team  
**Date:** December 8, 2025  
**Status:** ✅ Ready for Implementation

```

---

## ✅ Quality Checklist

**Agent verifies:**

- [x] Hierarchical structure (Parent → Child)
- [x] Clear dependencies identified
- [x] Logical ordering
- [x] Traceability to requirements
- [x] Acceptance criteria for each task
- [x] Time estimates provided
- [x] Testing tasks included
- [x] No approval gate (direct execution)
- [x] Follows philosophy.md
- [x] Follows standards

---

## 📊 Outcome

**Result:** ✅ Complete task breakdown

**Next Step:** Task Execution (use `executeTask.prompt.md`)

**Files Created:**
- `specs/product-reviews/tasks.md`

**Time Taken:** ~20 minutes

**Quality Rating:** 9.7/10 ⭐⭐⭐⭐⭐

---

## 💡 Key Takeaways

### What Worked Well

1. ✅ Hierarchical structure made dependencies clear
2. ✅ Logical ordering prevented blockers
3. ✅ Traceability ensured completeness
4. ✅ Time estimates helped planning
5. ✅ No approval gate streamlined workflow

### Best Practices Applied

1. ✅ Bottom-up approach (Data → Domain → Presentation)
2. ✅ Testing tasks included
3. ✅ Clear acceptance criteria
4. ✅ Dependencies documented
5. ✅ Execution order suggested
6. ✅ Code examples provided

### Lessons Learned

1. 💡 Hierarchical tasks prevent confusion
2. 💡 Dependencies must be explicit
3. 💡 Time estimates help prioritization
4. 💡 Testing tasks ensure quality

---

**Prepared by:** Basser Project Development Agents Team
**Date:** December 8, 2025
**Example:** 3 of 6
```
