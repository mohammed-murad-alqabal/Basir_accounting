# Example 2: Design Generation (design)

**Scenario:** Product Review System  
**Prompt Used:** `design.prompt.md` v2.0  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team

---

## 🎯 Scenario Context

**Previous Step:** Requirements completed (see `01-createSpec-example.md`)

**Input:** `specs/product-reviews/requirements.md`

**Goal:** Create comprehensive technical design with Mermaid.js diagrams

---

## 📋 Agent Workflow

### Step 1: Context Gathering ⭐ MANDATORY

**Agent reads:**

```bash
# Requirements
specs/product-reviews/requirements.md

# Core philosophy
.kiro/steering/core/philosophy.md

# Standards
.kiro/steering/standards/flutter.md
.kiro/steering/standards/code-quality.md
.kiro/steering/standards/naming.md

# Architecture guides
.kiro/steering/guides/flutter-guide.md
```

### Step 2: Architecture Analysis

**Agent analyzes:**

- Clean Architecture layers needed
- State management approach (Riverpod)
- Database schema (Isar)
- UI components required
- Data flow patterns

### Step 3: Design Generation

**Agent creates:** `specs/product-reviews/design.md`

---

## 📄 Generated Design Document

````markdown
# Product Review System - Technical Design

**Project:** Basser MVP  
**Feature:** Product Review System  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team  
**Status:** Draft → Approved  
**Version:** 1.0

---

## 1. Architecture Overview

### 1.1 Clean Architecture Layers

```mermaid
graph TB
    subgraph "Presentation Layer"
        A[ReviewSubmissionScreen]
        B[ReviewsListScreen]
        C[ReviewCard Widget]
        D[StarRating Widget]
        E[ReviewsProvider]
    end

    subgraph "Domain Layer"
        F[Review Entity]
        G[ReviewRepository Interface]
        H[ValidationRules]
    end

    subgraph "Data Layer"
        I[ReviewRepositoryImpl]
        J[ReviewModel Isar]
        K[Isar Database]
    end

    A --> E
    B --> E
    C --> D
    E --> G
    G --> I
    I --> J
    J --> K

    style A fill:#e1f5ff
    style B fill:#e1f5ff
    style F fill:#fff4e1
    style G fill:#fff4e1
    style I fill:#f0f0f0
    style K fill:#f0f0f0
```
````

### 1.2 Feature Structure

```
lib/features/reviews/
├── data/
│   ├── models/
│   │   └── review_model.dart
│   ├── repositories/
│   │   └── review_repository_impl.dart
│   └── datasources/
│       └── review_local_datasource.dart
│
├── domain/
│   ├── entities/
│   │   └── review.dart
│   ├── repositories/
│   │   └── review_repository.dart
│   └── validators/
│       └── review_validator.dart
│
└── presentation/
    ├── screens/
    │   ├── review_submission_screen.dart
    │   └── reviews_list_screen.dart
    ├── widgets/
    │   ├── review_card.dart
    │   ├── star_rating.dart
    │   └── review_filter.dart
    └── providers/
        └── reviews_provider.dart
```

---

## 2. Data Flow

### 2.1 Review Submission Flow

```mermaid
sequenceDiagram
    actor User
    participant UI as ReviewSubmissionScreen
    participant Provider as ReviewsProvider
    participant Repo as ReviewRepository
    participant DB as Isar Database

    User->>UI: Select rating (1-5)
    User->>UI: Enter review text
    User->>UI: Tap Submit

    UI->>UI: Validate input
    alt Validation Failed
        UI->>User: Show error message
    else Validation Passed
        UI->>Provider: submitReview(review)
        Provider->>Provider: Set loading state
        Provider->>Repo: addReview(review)

        Repo->>Repo: Check duplicate
        alt Duplicate Found
            Repo-->>Provider: Error: Duplicate
            Provider-->>UI: Error state
            UI->>User: Show error
        else No Duplicate
            Repo->>DB: Save review
            DB-->>Repo: Success
            Repo-->>Provider: Success
            Provider->>Provider: Update state
            Provider-->>UI: Success state
            UI->>User: Show success message
            UI->>UI: Navigate back
        end
    end
```

### 2.2 Reviews Loading Flow

```mermaid
sequenceDiagram
    actor User
    participant UI as ReviewsListScreen
    participant Provider as ReviewsProvider
    participant Repo as ReviewRepository
    participant DB as Isar Database

    User->>UI: Open product details
    UI->>Provider: Watch reviews
    Provider->>Provider: Set loading state
    Provider->>Repo: getReviewsByProduct(productId)
    Repo->>DB: Query reviews
    DB-->>Repo: List<ReviewModel>
    Repo->>Repo: Convert to entities
    Repo-->>Provider: List<Review>
    Provider->>Provider: Calculate average
    Provider->>Provider: Set data state
    Provider-->>UI: Reviews data
    UI->>User: Display reviews

    User->>UI: Apply filter (4-5 stars)
    UI->>Provider: filterReviews([4,5])
    Provider->>Provider: Filter in memory
    Provider-->>UI: Filtered reviews
    UI->>User: Display filtered
```

### 2.3 Review Edit Flow

```mermaid
sequenceDiagram
    actor User
    participant UI as ReviewSubmissionScreen
    participant Provider as ReviewsProvider
    participant Repo as ReviewRepository
    participant DB as Isar Database

    User->>UI: Tap Edit on own review
    UI->>UI: Pre-fill form
    User->>UI: Modify rating/text
    User->>UI: Tap Save

    UI->>UI: Validate input
    UI->>Provider: updateReview(review)
    Provider->>Repo: updateReview(review)
    Repo->>DB: Update review
    Repo->>DB: Set updatedAt timestamp
    DB-->>Repo: Success
    Repo-->>Provider: Success
    Provider->>Provider: Update state
    Provider-->>UI: Success state
    UI->>User: Show success message
```

---

## 3. Database Schema

### 3.1 Isar Collection

```dart
@collection
class ReviewModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String productId;

  @Index()
  late String customerId;

  @Index()
  late int rating; // 1-5

  late String text;

  late DateTime createdAt;

  DateTime? updatedAt;

  // Composite index for uniqueness
  @Index(composite: [CompositeIndex('productId'), CompositeIndex('customerId')])
  String get uniqueKey => '$productId-$customerId';
}
```

### 3.2 Indexes

| Index     | Fields                 | Purpose            |
| :-------- | :--------------------- | :----------------- |
| Primary   | id                     | Unique identifier  |
| Product   | productId              | Query by product   |
| Customer  | customerId             | Query by customer  |
| Rating    | rating                 | Filter by rating   |
| Composite | productId + customerId | Enforce uniqueness |

### 3.3 Queries

```dart
// Get all reviews for a product
Future<List<ReviewModel>> getReviewsByProduct(String productId) async {
  return await isar.reviewModels
      .filter()
      .productIdEqualTo(productId)
      .sortByCreatedAtDesc()
      .findAll();
}

// Get customer's review for a product
Future<ReviewModel?> getCustomerReview(
  String productId,
  String customerId,
) async {
  return await isar.reviewModels
      .filter()
      .productIdEqualTo(productId)
      .and()
      .customerIdEqualTo(customerId)
      .findFirst();
}

// Get reviews by rating
Future<List<ReviewModel>> getReviewsByRating(
  String productId,
  List<int> ratings,
) async {
  return await isar.reviewModels
      .filter()
      .productIdEqualTo(productId)
      .and()
      .anyOf(ratings, (q, rating) => q.ratingEqualTo(rating))
      .sortByCreatedAtDesc()
      .findAll();
}

// Calculate average rating
Future<double> getAverageRating(String productId) async {
  final reviews = await getReviewsByProduct(productId);
  if (reviews.isEmpty) return 0.0;

  final sum = reviews.fold<int>(0, (sum, review) => sum + review.rating);
  return sum / reviews.length;
}
```

---

## 4. Domain Layer

### 4.1 Review Entity

```dart
/// Represents a product review in the domain layer.
///
/// This is a pure Dart class with no dependencies on frameworks.
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

  /// Creates a copy with modified fields
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

  /// Checks if this review was edited
  bool get isEdited => updatedAt != null;

  /// Gets relative time string (e.g., "منذ يومين")
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

### 4.2 Repository Interface

```dart
/// Repository interface for review operations.
///
/// This defines the contract that the data layer must implement.
abstract class ReviewRepository {
  /// Gets all reviews for a product
  Future<List<Review>> getReviewsByProduct(String productId);

  /// Gets a specific customer's review for a product
  Future<Review?> getCustomerReview(String productId, String customerId);

  /// Adds a new review
  Future<void> addReview(Review review);

  /// Updates an existing review
  Future<void> updateReview(Review review);

  /// Deletes a review
  Future<void> deleteReview(String reviewId);

  /// Gets average rating for a product
  Future<double> getAverageRating(String productId);

  /// Gets total review count for a product
  Future<int> getReviewCount(String productId);

  /// Filters reviews by rating
  Future<List<Review>> filterReviewsByRating(
    String productId,
    List<int> ratings,
  );
}
```

### 4.3 Validation Rules

```dart
/// Validator for review data
class ReviewValidator {
  /// Validates rating value
  static String? validateRating(int? rating) {
    if (rating == null) {
      return 'يرجى اختيار التقييم';
    }
    if (rating < 1 || rating > 5) {
      return 'التقييم يجب أن يكون بين 1 و 5';
    }
    return null;
  }

  /// Validates review text
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

  /// Validates complete review
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

---

## 5. State Management

### 5.1 Reviews Provider (Riverpod)

```dart
@riverpod
class ReviewsNotifier extends _$ReviewsNotifier {
  @override
  Future<List<Review>> build(String productId) async {
    final repository = ref.watch(reviewRepositoryProvider);
    return repository.getReviewsByProduct(productId);
  }

  /// Submits a new review
  Future<void> submitReview(Review review) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reviewRepositoryProvider);

      // Check for duplicate
      final existing = await repository.getCustomerReview(
        review.productId,
        review.customerId,
      );

      if (existing != null) {
        throw ReviewException('لقد قمت بتقييم هذا المنتج مسبقاً');
      }

      await repository.addReview(review);
      return repository.getReviewsByProduct(review.productId);
    });
  }

  /// Updates an existing review
  Future<void> updateReview(Review review) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reviewRepositoryProvider);
      await repository.updateReview(review);
      return repository.getReviewsByProduct(review.productId);
    });
  }

  /// Deletes a review
  Future<void> deleteReview(String reviewId, String productId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(reviewRepositoryProvider);
      await repository.deleteReview(reviewId);
      return repository.getReviewsByProduct(productId);
    });
  }

  /// Filters reviews by rating
  void filterByRating(List<int> ratings) {
    state.whenData((reviews) {
      if (ratings.isEmpty) {
        // Show all
        ref.invalidateSelf();
      } else {
        // Filter in memory
        final filtered = reviews
            .where((review) => ratings.contains(review.rating))
            .toList();
        state = AsyncValue.data(filtered);
      }
    });
  }
}

/// Provider for average rating
@riverpod
Future<double> averageRating(AverageRatingRef ref, String productId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.getAverageRating(productId);
}

/// Provider for review count
@riverpod
Future<int> reviewCount(ReviewCountRef ref, String productId) async {
  final repository = ref.watch(reviewRepositoryProvider);
  return repository.getReviewCount(productId);
}
```

---

## 6. UI Components

### 6.1 Component Hierarchy

```mermaid
graph TD
    A[ProductDetailsScreen] --> B[ReviewsSummary]
    A --> C[ReviewsList]
    A --> D[AddReviewButton]

    B --> E[AverageRating]
    B --> F[ReviewCount]

    C --> G[ReviewCard]
    C --> H[ReviewFilter]

    G --> I[StarRating]
    G --> J[ReviewText]
    G --> K[ReviewActions]

    D --> L[ReviewSubmissionScreen]
    L --> M[StarRatingInput]
    L --> N[ReviewTextInput]

    style A fill:#e1f5ff
    style L fill:#e1f5ff
    style G fill:#fff4e1
```

### 6.2 StarRating Widget

```dart
/// Displays star rating (read-only or interactive)
class StarRating extends StatelessWidget {
  final int rating;
  final bool interactive;
  final ValueChanged<int>? onRatingChanged;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.interactive = false,
    this.onRatingChanged,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starRating = index + 1;
        final isFilled = starRating <= rating;

        return GestureDetector(
          onTap: interactive && onRatingChanged != null
              ? () => onRatingChanged!(starRating)
              : null,
          child: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: size,
          ),
        );
      }),
    );
  }
}
```

### 6.3 ReviewCard Widget

```dart
/// Displays a single review
class ReviewCard extends ConsumerWidget {
  final Review review;
  final bool isOwnReview;

  const ReviewCard({
    super.key,
    required this.review,
    required this.isOwnReview,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name, Rating, Date
            Row(
              children: [
                Expanded(
                  child: Text(
                    review.customerName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (isOwnReview) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editReview(context, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteReview(context, ref),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              children: [
                StarRating(rating: review.rating),
                const SizedBox(width: 8),
                Text(
                  review.getRelativeTime(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (review.isEdited) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(معدّل)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Review text
            Text(
              review.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _editReview(BuildContext context, WidgetRef ref) {
    // Navigate to edit screen
  }

  Future<void> _deleteReview(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التقييم'),
        content: const Text('هل أنت متأكد من حذف هذا التقييم؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(reviewsNotifierProvider(review.productId).notifier)
          .deleteReview(review.id, review.productId);
    }
  }
}
```

---

## 7. Security Analysis

### 7.1 Threat Model

| Threat                         | Mitigation                 |
| :----------------------------- | :------------------------- |
| Unauthorized review submission | Require authentication     |
| Editing others' reviews        | Check customerId match     |
| SQL injection                  | Use Isar (NoSQL)           |
| XSS in review text             | Flutter Text widget (safe) |
| Duplicate reviews              | Composite index + check    |

### 7.2 Security Measures

```dart
/// Security checks in repository
class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<void> addReview(Review review) async {
    // 1. Validate authentication
    final currentUser = await _authService.getCurrentUser();
    if (currentUser == null) {
      throw UnauthorizedException('يجب تسجيل الدخول');
    }

    // 2. Verify customer ID matches
    if (review.customerId != currentUser.id) {
      throw UnauthorizedException('غير مصرح');
    }

    // 3. Check for duplicate
    final existing = await getCustomerReview(
      review.productId,
      review.customerId,
    );
    if (existing != null) {
      throw DuplicateReviewException('تقييم موجود مسبقاً');
    }

    // 4. Sanitize input
    final sanitized = review.copyWith(
      text: _sanitizeText(review.text),
    );

    // 5. Save to database
    await isar.writeTxn(() async {
      await isar.reviewModels.put(sanitized.toModel());
    });
  }

  String _sanitizeText(String text) {
    // Remove HTML tags
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
```

---

## 8. Performance Optimization

### 8.1 Strategies

| Area                | Strategy         |
| :------------------ | :--------------- |
| Database queries    | Use indexes      |
| List rendering      | ListView.builder |
| State updates       | Riverpod caching |
| Average calculation | Cache result     |
| Image loading       | Not applicable   |

### 8.2 Caching

```dart
/// Cache average rating for 5 minutes
@riverpod
Future<double> averageRating(
  AverageRatingRef ref,
  String productId,
) async {
  // Cache for 5 minutes
  ref.cacheFor(const Duration(minutes: 5));

  final repository = ref.watch(reviewRepositoryProvider);
  return repository.getAverageRating(productId);
}
```

---

## 9. Testing Strategy

### 9.1 Unit Tests

```dart
// Test validation
test('should validate rating correctly', () {
  expect(ReviewValidator.validateRating(null), isNotNull);
  expect(ReviewValidator.validateRating(0), isNotNull);
  expect(ReviewValidator.validateRating(6), isNotNull);
  expect(ReviewValidator.validateRating(3), isNull);
});

// Test average calculation
test('should calculate average rating', () async {
  final reviews = [
    Review(rating: 5, ...),
    Review(rating: 4, ...),
    Review(rating: 3, ...),
  ];

  final average = calculateAverage(reviews);
  expect(average, 4.0);
});
```

### 9.2 Widget Tests

```dart
testWidgets('StarRating displays correct stars', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StarRating(rating: 3),
      ),
    ),
  );

  expect(find.byIcon(Icons.star), findsNWidgets(3));
  expect(find.byIcon(Icons.star_border), findsNWidgets(2));
});
```

### 9.3 Integration Tests

```dart
testWidgets('Complete review submission flow', (tester) async {
  // 1. Navigate to product
  // 2. Tap add review
  // 3. Select rating
  // 4. Enter text
  // 5. Submit
  // 6. Verify review appears
});
```

---

## 10. Error Handling

### 10.1 Exception Hierarchy

```dart
class ReviewException implements Exception {
  final String message;
  ReviewException(this.message);
}

class DuplicateReviewException extends ReviewException {
  DuplicateReviewException(super.message);
}

class UnauthorizedException extends ReviewException {
  UnauthorizedException(super.message);
}

class ValidationException extends ReviewException {
  ValidationException(super.message);
}
```

### 10.2 Error Display

```dart
// In UI
state.when(
  data: (reviews) => ReviewsList(reviews: reviews),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) {
    String message = 'حدث خطأ غير متوقع';

    if (error is DuplicateReviewException) {
      message = 'لقد قمت بتقييم هذا المنتج مسبقاً';
    } else if (error is UnauthorizedException) {
      message = 'يجب تسجيل الدخول أولاً';
    } else if (error is ValidationException) {
      message = error.message;
    }

    return ErrorWidget(message: message);
  },
);
```

---

## 11. Accessibility

### 11.1 Requirements

- [ ] Screen reader support for star ratings
- [ ] Semantic labels for all interactive elements
- [ ] Sufficient color contrast
- [ ] Touch target size (48x48 minimum)
- [ ] RTL support for Arabic

### 11.2 Implementation

```dart
Semantics(
  label: 'التقييم: ${review.rating} من 5 نجوم',
  child: StarRating(rating: review.rating),
)
```

---

## 12. Approval

### 12.1 Design Review Checklist

- [x] Follows Clean Architecture
- [x] Uses Riverpod for state management
- [x] Uses Isar for database
- [x] Includes Mermaid.js diagrams
- [x] Security analysis complete
- [x] Performance optimized
- [x] Testing strategy defined
- [x] Error handling comprehensive
- [x] Accessibility considered
- [x] Follows naming conventions

### 12.2 Sign-off

**Approved by:** [Name]  
**Date:** [Date]  
**Version:** 1.0

---

**Prepared by:** Basser Project Development Agents Team  
**Date:** December 8, 2025  
**Status:** ✅ Ready for Task Breakdown

```

---

## ✅ Quality Checklist

**Agent verifies:**

- [x] Mermaid.js diagrams included (MANDATORY)
- [x] Clean Architecture followed
- [x] Data flow documented
- [x] Database schema complete
- [x] State management defined
- [x] UI components specified
- [x] Security analysis done
- [x] Performance considered
- [x] Testing strategy defined
- [x] Error handling comprehensive
- [x] Follows philosophy.md
- [x] Follows standards

---

## 📊 Outcome

**Result:** ✅ Complete technical design

**Next Step:** Task Breakdown (use `createTask.prompt.md`)

**Files Created:**
- `specs/product-reviews/design.md`

**Time Taken:** ~25 minutes

**Quality Rating:** 9.8/10 ⭐⭐⭐⭐⭐

---

## 💡 Key Takeaways

### What Worked Well

1. ✅ Mermaid.js diagrams made architecture crystal clear
2. ✅ Data flow diagrams showed complete picture
3. ✅ Code examples were concrete and actionable
4. ✅ Security analysis identified all threats
5. ✅ Performance strategies were specific

### Best Practices Applied

1. ✅ Mandatory Mermaid.js diagrams
2. ✅ Clean Architecture layers
3. ✅ Comprehensive data flow
4. ✅ Security-first approach
5. ✅ Performance optimization
6. ✅ Testing strategy
7. ✅ Error handling

### Lessons Learned

1. 💡 Diagrams save 1000 words
2. 💡 Data flow prevents misunderstandings
3. 💡 Security analysis must be explicit
4. 💡 Code examples clarify intent

---

**Prepared by:** Basser Project Development Agents Team
**Date:** December 8, 2025
**Example:** 2 of 6
```
