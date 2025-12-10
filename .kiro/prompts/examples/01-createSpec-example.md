# Example 1: Requirements Generation (createSpec)

**Scenario:** Product Review System  
**Prompt Used:** `createSpec.prompt.md` v2.0  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team

---

## 🎯 Scenario Context

**User Request:**

> "I want to add a product review system to the app. Customers should be able to rate products from 1-5 stars and write text reviews. Other customers should be able to see all reviews for a product."

---

## 📋 Agent Workflow

### Step 1: Context Gathering ⭐ MANDATORY

**Agent reads:**

```bash
# Core philosophy
.kiro/steering/core/philosophy.md

# Standards
.kiro/steering/standards/naming.md
.kiro/steering/standards/code-quality.md
.kiro/steering/standards/flutter.md
.kiro/steering/standards/arabic.md

# Strategic docs (if needed)
.kiro/steering/reference/strategic-docs.md
```

### Step 2: Clarification Questions

**Agent asks:**

```
Before I create the requirements specification, I need to clarify a few points:

1. **Review Editing:** Can customers edit or delete their reviews after posting?
2. **Review Moderation:** Should reviews be moderated before appearing?
3. **Anonymous Reviews:** Can customers post reviews anonymously?
4. **Review Sorting:** How should reviews be sorted (newest, highest rated, etc.)?
5. **Review Validation:** Any minimum/maximum length for review text?
6. **Multiple Reviews:** Can a customer post multiple reviews for the same product?
```

**User Responses:**

```
1. Yes, customers can edit/delete their own reviews
2. No moderation needed for MVP
3. No, reviews must be linked to customer account
4. Sort by newest first, with option to filter by rating
5. Minimum 10 characters, maximum 500 characters
6. No, one review per customer per product
```

### Step 3: Requirements Generation

**Agent creates:** `specs/product-reviews/requirements.md`

---

## 📄 Generated Requirements Document

```markdown
# Product Review System - Requirements Specification

**Project:** Basser MVP  
**Feature:** Product Review System  
**Date:** December 8, 2025  
**Author:** Basser Project Development Agents Team  
**Status:** Draft → Approved  
**Version:** 1.0

---

## 1. Overview

### 1.1 Purpose

Enable customers to rate and review products, and view reviews from other customers.

### 1.2 Scope

**In Scope:**

- Star rating (1-5 stars)
- Text review submission
- Review listing and viewing
- Review editing and deletion
- Review filtering by rating

**Out of Scope:**

- Review moderation
- Anonymous reviews
- Review voting (helpful/not helpful)
- Review images/photos
- Review responses from sellers

### 1.3 Strategic Alignment

**Aligns with:**

- `.kiro/steering/strategic-vision.md` - Customer engagement
- `.kiro/steering/product.md` - Core features
- `.kiro/steering/roadmap.md` - Q1 2026 MVP

---

## 2. Functional Requirements

### 2.1 Review Submission

#### FR-1: Star Rating Selection

**EARS Format:**
```

WHEN a customer views a product
THEN the system SHALL display a star rating input (1-5 stars)

```

**Acceptance Criteria:**
- [ ] Star rating selector visible on product details screen
- [ ] Stars are interactive (tap to select)
- [ ] Selected rating is highlighted
- [ ] Rating is required before submission

#### FR-2: Review Text Input

**EARS Format:**
```

WHEN a customer selects a star rating
THEN the system SHALL provide a text input field for the review
WHERE the text length is between 10 and 500 characters

```

**Acceptance Criteria:**
- [ ] Text input field visible after rating selection
- [ ] Character counter displayed (X/500)
- [ ] Minimum 10 characters enforced
- [ ] Maximum 500 characters enforced
- [ ] Arabic text supported with RTL

#### FR-3: Review Submission

**EARS Format:**
```

WHEN a customer submits a review
AND the review meets validation criteria
THEN the system SHALL save the review to the database
AND link it to the customer and product

```

**Acceptance Criteria:**
- [ ] Submit button enabled only when valid
- [ ] Loading indicator during submission
- [ ] Success message displayed
- [ ] Review appears in product reviews list
- [ ] Customer cannot submit duplicate review

### 2.2 Review Viewing

#### FR-4: Reviews List Display

**EARS Format:**
```

WHEN a customer views a product
THEN the system SHALL display all reviews for that product
SORTED BY newest first

```

**Acceptance Criteria:**
- [ ] All reviews displayed in list
- [ ] Each review shows: rating, text, author name, date
- [ ] Reviews sorted by newest first
- [ ] Empty state shown if no reviews
- [ ] Pagination if > 20 reviews

#### FR-5: Review Filtering

**EARS Format:**
```

WHEN a customer taps the filter button
THEN the system SHALL allow filtering reviews by star rating
WHERE multiple ratings can be selected

```

**Acceptance Criteria:**
- [ ] Filter button visible
- [ ] Filter options: 5★, 4★, 3★, 2★, 1★
- [ ] Multiple selections allowed
- [ ] Filtered results update immediately
- [ ] Clear filter option available

#### FR-6: Average Rating Display

**EARS Format:**
```

WHEN a product has reviews
THEN the system SHALL display the average rating
AND the total number of reviews

```

**Acceptance Criteria:**
- [ ] Average rating calculated correctly
- [ ] Displayed as stars (e.g., 4.5★)
- [ ] Total review count shown (e.g., "4.5★ (23 تقييم)")
- [ ] Updates when new review added

### 2.3 Review Management

#### FR-7: Edit Own Review

**EARS Format:**
```

WHEN a customer views their own review
THEN the system SHALL provide an edit option
WHERE the customer can modify rating and text

```

**Acceptance Criteria:**
- [ ] Edit button visible on own reviews only
- [ ] Pre-fills current rating and text
- [ ] Same validation rules apply
- [ ] Updated timestamp shown
- [ ] Success message displayed

#### FR-8: Delete Own Review

**EARS Format:**
```

WHEN a customer taps delete on their own review
THEN the system SHALL show a confirmation dialog
AND delete the review upon confirmation

```

**Acceptance Criteria:**
- [ ] Delete button visible on own reviews only
- [ ] Confirmation dialog shown
- [ ] Review removed from database
- [ ] Review removed from UI
- [ ] Success message displayed

---

## 3. Non-Functional Requirements

### 3.1 Performance

**NFR-1: Review Loading**
```

The system SHALL load reviews within 2 seconds
UNDER normal network conditions

```

**NFR-2: Submission Response**
```

The system SHALL provide feedback within 1 second
AFTER review submission

```

### 3.2 Usability

**NFR-3: Arabic Support**
```

The system SHALL support Arabic text in reviews
WITH proper RTL layout

```

**NFR-4: Accessibility**
```

The system SHALL be accessible
WITH screen reader support for ratings

```

### 3.3 Security

**NFR-5: Authentication**
```

The system SHALL require authentication
BEFORE allowing review submission

```

**NFR-6: Authorization**
```

The system SHALL allow editing/deleting
ONLY the customer's own reviews

```

### 3.4 Data Integrity

**NFR-7: Validation**
```

The system SHALL validate all inputs
BEFORE saving to database

```

**NFR-8: Uniqueness**
```

The system SHALL enforce one review per customer per product

```

---

## 4. User Stories

### Epic: Product Review System

#### Story 1: Submit Review
```

As a customer
I want to rate and review a product
So that I can share my experience with others

Acceptance Criteria:

- Can select 1-5 star rating
- Can write 10-500 character review
- Review appears immediately after submission
- Cannot submit duplicate review

```

#### Story 2: View Reviews
```

As a customer
I want to see all reviews for a product
So that I can make informed purchase decisions

Acceptance Criteria:

- See all reviews sorted by newest
- See average rating and count
- See reviewer name and date
- Can filter by star rating

```

#### Story 3: Edit My Review
```

As a customer
I want to edit my review
So that I can update my opinion

Acceptance Criteria:

- Can edit rating and text
- Changes save successfully
- Updated timestamp shown
- Same validation applies

```

#### Story 4: Delete My Review
```

As a customer
I want to delete my review
So that I can remove it if needed

Acceptance Criteria:

- Can delete own review only
- Confirmation dialog shown
- Review removed completely
- Success message displayed

````

---

## 5. Data Model

### 5.1 Review Entity

```dart
class Review {
  final String id;              // Unique identifier
  final String productId;       // Product reference
  final String customerId;      // Customer reference
  final int rating;             // 1-5 stars
  final String text;            // Review text
  final DateTime createdAt;     // Creation timestamp
  final DateTime? updatedAt;    // Last update timestamp
}
````

### 5.2 Validation Rules

| Field      | Type     | Required | Constraints       |
| :--------- | :------- | :------- | :---------------- |
| id         | String   | Yes      | UUID              |
| productId  | String   | Yes      | Valid product ID  |
| customerId | String   | Yes      | Valid customer ID |
| rating     | int      | Yes      | 1-5               |
| text       | String   | Yes      | 10-500 characters |
| createdAt  | DateTime | Yes      | Auto-generated    |
| updatedAt  | DateTime | No       | Auto on update    |

---

## 6. Business Rules

### BR-1: One Review Per Product

```
A customer can submit only ONE review per product.
If attempting to submit another, show error message.
```

### BR-2: Own Reviews Only

```
A customer can edit/delete ONLY their own reviews.
Other customers' reviews are read-only.
```

### BR-3: Authentication Required

```
Review submission requires authenticated customer.
Anonymous reviews are not allowed.
```

### BR-4: Text Validation

```
Review text must be:
- Minimum 10 characters
- Maximum 500 characters
- Can contain Arabic and English
- No HTML tags allowed
```

### BR-5: Rating Validation

```
Rating must be:
- Integer value
- Between 1 and 5 (inclusive)
- Required (cannot be null)
```

---

## 7. UI/UX Requirements

### 7.1 Review Submission UI

**Components:**

- Star rating selector (5 stars)
- Text input field (multiline)
- Character counter
- Submit button
- Cancel button

**Arabic Labels:**

- "تقييمك" (Your Rating)
- "اكتب تقييمك" (Write Your Review)
- "إرسال" (Submit)
- "إلغاء" (Cancel)

### 7.2 Reviews List UI

**Components:**

- Average rating display
- Total reviews count
- Filter button
- Review cards (list)
- Empty state

**Review Card:**

- Customer name
- Star rating (visual)
- Review text
- Date (relative, e.g., "منذ يومين")
- Edit/Delete buttons (own reviews only)

---

## 8. Error Handling

### 8.1 Validation Errors

| Error            | Message (Arabic)                             |
| :--------------- | :------------------------------------------- |
| Rating missing   | "يرجى اختيار التقييم"                        |
| Text too short   | "التقييم يجب أن يحتوي على 10 أحرف على الأقل" |
| Text too long    | "التقييم طويل جداً (الحد الأقصى 500 حرف)"    |
| Duplicate review | "لقد قمت بتقييم هذا المنتج مسبقاً"           |

### 8.2 System Errors

| Error         | Message (Arabic)                          |
| :------------ | :---------------------------------------- |
| Network error | "خطأ في الاتصال. يرجى المحاولة مرة أخرى"  |
| Save failed   | "فشل حفظ التقييم. يرجى المحاولة مرة أخرى" |
| Load failed   | "فشل تحميل التقييمات"                     |

---

## 9. Testing Requirements

### 9.1 Unit Tests

- [ ] Review validation logic
- [ ] Average rating calculation
- [ ] Duplicate review detection
- [ ] Text length validation

### 9.2 Widget Tests

- [ ] Star rating selector
- [ ] Review submission form
- [ ] Reviews list display
- [ ] Filter functionality

### 9.3 Integration Tests

- [ ] Complete review submission flow
- [ ] Edit review flow
- [ ] Delete review flow
- [ ] Filter and sort flow

**Target Coverage:** 70%+

---

## 10. Dependencies

### 10.1 Internal

- Customer authentication system
- Product catalog
- Local database (Isar)

### 10.2 External

- None (fully offline-capable)

---

## 11. Constraints

### 11.1 Technical

- Must work offline (local database)
- Must support Arabic RTL
- Must follow Clean Architecture

### 11.2 Business

- MVP scope only (no moderation)
- One review per customer per product
- No anonymous reviews

---

## 12. Success Metrics

### 12.1 Functional

- [ ] All functional requirements implemented
- [ ] All user stories completed
- [ ] 70%+ test coverage

### 12.2 Quality

- [ ] 0 critical bugs
- [ ] < 2 second load time
- [ ] Passes all acceptance criteria

---

## 13. Approval

### 13.1 Stakeholders

- [ ] Product Owner
- [ ] Technical Lead
- [ ] UX Designer

### 13.2 Sign-off

**Approved by:** [Name]  
**Date:** [Date]  
**Version:** 1.0

---

**Prepared by:** Basser Project Development Agents Team  
**Date:** December 8, 2025  
**Status:** ✅ Ready for Design Phase

```

---

## ✅ Quality Checklist

**Agent verifies:**

- [x] All EARS requirements follow correct syntax
- [x] User stories have clear acceptance criteria
- [x] Data model is complete
- [x] Business rules are explicit
- [x] Error messages in Arabic
- [x] Testing requirements specified
- [x] Success metrics defined
- [x] Follows philosophy.md principles
- [x] Follows standards (naming, quality, etc.)
- [x] Full English for technical content
- [x] Arabic for user-facing text

---

## 📊 Outcome

**Result:** ✅ Complete requirements specification

**Next Step:** Design Phase (use `design.prompt.md`)

**Files Created:**
- `specs/product-reviews/requirements.md`

**Time Taken:** ~15 minutes

**Quality Rating:** 9.5/10 ⭐⭐⭐⭐⭐

---

## 💡 Key Takeaways

### What Worked Well

1. ✅ EARS syntax made requirements clear and testable
2. ✅ Clarification questions prevented ambiguity
3. ✅ User stories provided context
4. ✅ Data model helped visualize structure
5. ✅ Business rules were explicit

### Best Practices Applied

1. ✅ Context gathering before starting
2. ✅ Asked clarifying questions
3. ✅ Used EARS format consistently
4. ✅ Included acceptance criteria
5. ✅ Specified error messages in Arabic
6. ✅ Defined success metrics
7. ✅ Full English for technical content

### Lessons Learned

1. 💡 Clarification questions save time later
2. 💡 EARS format forces precision
3. 💡 Business rules prevent misunderstandings
4. 💡 Data model helps identify missing requirements

---

**Prepared by:** Basser Project Development Agents Team
**Date:** December 8, 2025
**Example:** 1 of 6
```
